kvm-qemu可执行程序像普通Qemu一样：分配RAM,加载代码，不同于重新编译或者调用callingKQemu，它创建了一个线程（这个很重要）；这个线程调用KVM内核模块去切换到用户模式，并且去执行
VM代码。当遇到一个特权指令，它从新切换会KVM内核模块，该内核模块在需要的时候，像Qemu线程发信号去处理大部分的硬件仿真。

这个体系结构一个比较巧妙的一个地方就是客户代码被模拟在一个posix线程，这允许你使用通常Linux工具管理。如果你需要一个有2或者4核的虚拟机，kvm-qemu创建2或者4个线程，
每个线程调用KVM内核模块并开始执行。并发性（若果你有足够多的真实核）或者调度（如果你不管）是被通用的Linux调度器，这个使得KVM代码量十分的小。
当一起工作的时候，KVM管理CPU和MEM的访问，QEMU仿真硬件资源（硬盘，声卡，USB，等等）当QEMU单独运行时，QEMU同时模拟CPU和硬件。
