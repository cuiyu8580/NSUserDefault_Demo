# NSUserDefault_Demo


NSUserDefault 原理测试



### 本文在测试分析的基础上讨论一下NSUserDefaults的工作原理，如有错误之处，欢迎批评指正。

NSUserDefaults 的存储目录是在/Library/Preferences下的一个.plist文件，该路径可通过配置实现iTunes共享文件。可被iTunes备份。 

读取NSUserDefaults值的时候会默认在内存中缓存下来一份，所以NSUserDefaults的读取速度比较快。正常情况下，我们后面对NSUserDefaults的读取都是从内存中读取的，经测试删除.plist文件后，依然可以正常读取，基本可以证明这一点。

### 关于偶尔出现remove之后发现还有值的情况

NSUserDefaults 删除的时候，首先可以肯定的是内存中的值首先被删除了（此时读取的时候显示为空）.plist文件的数据处于等待被删除的状态。此时，系统会开启一个任务来处理删除.plist的值。但是这个任务并不总是及时的，它可能会处于拥堵排队状态，所以当我们删除之后（此时内存中已删除，所以打印相应的key值，显示已经删除的状态，任务开启正在等待删除本地.plist），再重启app(删除本地.plist文件。任务中断，并未实际删除)。所以发现有时候读取的时候还在，有时候已经删除了（app重启之后，再读取的时候会重新从.plist文件读取一份到内存中供我们访问）

### 关于synchronize

通常我们的印象是调用synchronize，系统会及时把值存储到本地.plist文件，不加的时候，好像就不会及时存储。我们先看看苹果的解释

![synchronize](/NSUserDefault_Demo/NSUserDefault_Demo/synchronize.png)

<img src=https://upload-images.jianshu.io/upload_images/1416772-dcb70bb799c71286.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000 img>

很明显，苹果并不希望你手动去调用它，并且说他会阻塞调用线程，并且再接下来的版本会被标记成NS_DEPRECATED，下面我们还用实际测试情况来说明

经测试，不管是否调用synchronize，首先内存中会首先写入要存储的值，此时系统会开辟一个任务来处理把此值存入.plist文件。同样地，这个任务也并不是总是及时的，可能处于等待排队的状态，只有当此任务执行完毕值才会被正确地存储到本地，所以当任务中断的时候，会出现写入之后下次读取为空的情况。但几乎和你是否调用synchronize，是没有必然关系的。

### 综上所述，手动调用synchronize是不必要的。它并不会给你带来任何特殊的帮助。

### 顺便再提醒一下，改变.plist文件的任意值，并不会导致内存中的所有的数据全部同步成最新状态。

提供一个demo，供大家测试各种情况[NSUserDefault_Demo](https://github.com/cuiyu8580/NSUserDefault_Demo.git)
