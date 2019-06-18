Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0A604ACFB
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 23:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730890AbfFRVHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 17:07:49 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:34508 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730789AbfFRVFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 17:05:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=6Olw/Jt6p3FQJK+KHgcRjPZvPg9dYcTB/APDCUh9Tjg=; b=k9plp4z7v/mRcIWOI7tr7k2Ue
        wQZODatAsooJm1Pt5c4Dru04DcvZYFDNuzKkB7eCRptExvmhWppt7RcBgo+4GR9wC3mAbSsjxX6xP
        Q9tv36G51X1Qxy449Ok2Pk2ZruuKjQfxA9jieTWC8NKgb90TSsp8U9oFHO6UrwBAy8uqY2m5FuhRP
        aFMBsWi1VKD2HEI6qoOwx2pfe6ACqwiNGjRIofDv9bUw8mGOAKMK9jrWOxDTZXp916sC5wTQfbZx6
        VsAH6DrIB5MHDQZMTwG+NzxDscBLO7JAyrD6qzHfM6WK6gI8cw+SzuPV+ZNM1erraXbJmNpXtw43v
        3HwwC66ag==;
Received: from 177.133.86.196.dynamic.adsl.gvt.net.br ([177.133.86.196] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hdLIb-0006yL-O2; Tue, 18 Jun 2019 21:05:50 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1hdLIZ-0002Bg-Jb; Tue, 18 Jun 2019 18:05:47 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH v1 00/22] Convert files to ReST - part 3
Date:   Tue, 18 Jun 2019 18:05:24 -0300
Message-Id: <cover.1560891322.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the third part of a series I wrote sometime ago where I manually
convert lots of files to be properly parsed by Sphinx as ReST files.

As it touches on lot of stuff, this series is based on today's linux-next, 
at tag next-20190617.

The first version of this series had 57 patches. The first part with 28 patches
were already merged.  The second part has 29 patches. This series with 22 
patches finishes the conversion part of my series. That's because I opted to
do ~1 patch per converted directory.

That sounds too much to be send on a single round. So, I'm opting to split
it on 3 parts for the conversion.

After having those three patch series merged, I should submit a final patch 
series adding orphaned books to existing ones (with ~50 patches), to be
applied on a convenient moment (probably late on a merge window).

Those patches should probably be good to be merged either by subsystem
maintainers or via the docs tree.

I opted to mark new files not included yet to the main index.rst (directly or
indirectly) with the :orphan: tag, in order to avoid adding warnings to the
build system. This should be removed after we find a "home" for all
the converted files within the new document tree arrangement, after I
submit the third part.

Both this series and  the other parts of this work are on my devel git tree,
at:

	https://git.linuxtv.org/mchehab/experimental.git/log/?h=convert_rst_renames_v5.1

The final output in html (after all patches I currently have, including 
the upcoming series) can be seen at:

	https://www.infradead.org/~mchehab/rst_conversion/

It contains all pending work from my side related to the conversion, plus
the patches I finished a first version today with contains the renaming 
patches and de-orphan changes.

Mauro Carvalho Chehab (22):
  docs: Documentation/*.txt: rename all ReST files to *.rst
  docs: ioctl-number.txt: convert it to ReST format
  docs: ioctl: convert to ReST
  docs: thermal: convert to ReST
  docs: rapidio: convert to ReST
  docs: blockdev: convert to ReST
  docs: perf: convert to ReST
  docs: sysctl: convert to ReST
  docs: block: convert to ReST
  docs: security: move some books to it and update
  docs: admin-guide: add .rst files from the main dir
  docs: driver-api: add .rst files from the main dir
  docs: x86: move two x86-specific files to x86 arch dir
  docs: usb: rename files to .rst and add them to drivers-api
  docs: driver-api: add a chapter for memory-related API
  docs: driver-api: add xilinx driver API documentation
  docs: add arch doc directories to the index
  docs: admin-guide: move sysctl directory to it
  docs: driver-api: add remaining converted dirs to it
  docs: extcon: move it to acpi dir and convert it to ReST
  docs: admin-guide: add laptops documentation
  admin-guide: add kdump documentation into it

 CREDITS                                       |   2 +-
 Documentation/ABI/removed/sysfs-class-rfkill  |   2 +-
 Documentation/ABI/stable/sysfs-class-rfkill   |   2 +-
 Documentation/ABI/stable/sysfs-devices-node   |   2 +-
 Documentation/ABI/testing/procfs-diskstats    |   2 +-
 Documentation/ABI/testing/sysfs-block         |   2 +-
 Documentation/ABI/testing/sysfs-block-device  |   2 +-
 .../ABI/testing/sysfs-class-switchtec         |   2 +-
 .../ABI/testing/sysfs-devices-system-cpu      |   4 +-
 .../ABI/testing/sysfs-platform-asus-laptop    |   2 +-
 Documentation/PCI/pci.rst                     |   8 +-
 Documentation/{ => admin-guide}/aoe/aoe.rst   |   4 +-
 .../{ => admin-guide}/aoe/autoload.sh         |   1 -
 .../{ => admin-guide}/aoe/examples.rst        |   0
 Documentation/{ => admin-guide}/aoe/index.rst |   2 -
 Documentation/{ => admin-guide}/aoe/status.sh |   0
 Documentation/{ => admin-guide}/aoe/todo.rst  |   0
 .../{ => admin-guide}/aoe/udev-install.sh     |   4 +-
 Documentation/{ => admin-guide}/aoe/udev.txt  |   8 +-
 .../{btmrvl.txt => admin-guide/btmrvl.rst}    |   0
 Documentation/admin-guide/bug-hunting.rst     |   4 +-
 .../cgroup-v1/blkio-controller.rst            |   0
 .../{ => admin-guide}/cgroup-v1/cgroups.rst   |   4 +-
 .../{ => admin-guide}/cgroup-v1/cpuacct.rst   |   0
 .../{ => admin-guide}/cgroup-v1/cpusets.rst   |   2 +-
 .../{ => admin-guide}/cgroup-v1/devices.rst   |   0
 .../cgroup-v1/freezer-subsystem.rst           |   0
 .../{ => admin-guide}/cgroup-v1/hugetlb.rst   |   0
 .../{ => admin-guide}/cgroup-v1/index.rst     |   2 -
 .../cgroup-v1/memcg_test.rst                  |   4 +-
 .../{ => admin-guide}/cgroup-v1/memory.rst    |   0
 .../{ => admin-guide}/cgroup-v1/net_cls.rst   |   0
 .../{ => admin-guide}/cgroup-v1/net_prio.rst  |   0
 .../{ => admin-guide}/cgroup-v1/pids.rst      |   0
 .../{ => admin-guide}/cgroup-v1/rdma.rst      |   0
 Documentation/admin-guide/cgroup-v2.rst       |   2 +-
 .../clearing-warn-once.rst}                   |   0
 .../cpu-load.rst}                             |   0
 .../cputopology.rst}                          |   0
 .../efi-stub.rst}                             |   0
 .../{highuid.txt => admin-guide/highuid.rst}  |   2 +-
 Documentation/admin-guide/hw-vuln/l1tf.rst    |   4 +-
 .../hw_random.rst}                            |   0
 Documentation/admin-guide/index.rst           |  26 +
 .../{iostats.txt => admin-guide/iostats.rst}  |   0
 .../{ => admin-guide}/kdump/gdbmacros.txt     |   0
 .../{ => admin-guide}/kdump/index.rst         |   1 -
 .../{ => admin-guide}/kdump/kdump.rst         |   0
 .../{ => admin-guide}/kdump/vmcoreinfo.rst    |   0
 .../admin-guide/kernel-parameters.txt         |  46 +-
 .../kernel-per-cpu-kthreads.rst}              |   4 +-
 .../{ => admin-guide}/laptops/asus-laptop.rst |   0
 .../laptops/disk-shock-protection.rst         |   0
 .../{ => admin-guide}/laptops/index.rst       |   1 -
 .../{ => admin-guide}/laptops/laptop-mode.rst |   0
 .../{ => admin-guide}/laptops/lg-laptop.rst   |   1 -
 .../{ => admin-guide}/laptops/sony-laptop.rst |   0
 .../{ => admin-guide}/laptops/sonypi.rst      |   0
 .../laptops/thinkpad-acpi.rst                 |   6 +-
 .../laptops/toshiba_haps.rst                  |   0
 .../lcd-panel-cgram.rst                       |   2 -
 .../{ldm.txt => admin-guide/ldm.rst}          |   3 +-
 .../lockup-watchdogs.rst}                     |   0
 .../mm/cma_debugfs.rst}                       |   2 -
 Documentation/admin-guide/mm/index.rst        |   2 +-
 Documentation/admin-guide/mm/ksm.rst          |   2 +-
 .../admin-guide/mm/numa_memory_policy.rst     |   2 +-
 .../numastat.rst}                             |   3 +-
 .../{pnp.txt => admin-guide/pnp.rst}          |  11 +-
 .../{rtc.txt => admin-guide/rtc.rst}          |   6 +-
 .../{svga.txt => admin-guide/svga.rst}        |   0
 .../abi.txt => admin-guide/sysctl/abi.rst}    |  71 +-
 .../fs.txt => admin-guide/sysctl/fs.rst}      | 142 +--
 .../README => admin-guide/sysctl/index.rst}   |  34 +-
 .../sysctl/kernel.rst}                        | 378 ++++----
 .../net.txt => admin-guide/sysctl/net.rst}    | 141 ++-
 .../sysctl/sunrpc.rst}                        |  13 +-
 .../user.txt => admin-guide/sysctl/user.rst}  |  32 +-
 .../vm.txt => admin-guide/sysctl/vm.rst}      | 264 ++---
 .../video-output.rst}                         |   1 -
 Documentation/arm/index.rst                   |   2 -
 Documentation/arm64/index.rst                 |   2 -
 .../{bfq-iosched.txt => bfq-iosched.rst}      |  68 +-
 .../block/{biodoc.txt => biodoc.rst}          | 366 ++++---
 .../block/{biovecs.txt => biovecs.rst}        |  20 +-
 .../block/{capability.txt => capability.rst}  |  17 +-
 ...ne-partition.txt => cmdline-partition.rst} |  13 +-
 ...{data-integrity.txt => data-integrity.rst} |  60 +-
 ...dline-iosched.txt => deadline-iosched.rst} |  21 +-
 Documentation/block/index.rst                 |  25 +
 .../block/{ioprio.txt => ioprio.rst}          |  95 +-
 .../{kyber-iosched.txt => kyber-iosched.rst}  |   3 +-
 .../block/{null_blk.txt => null_blk.rst}      |  65 +-
 Documentation/block/{pr.txt => pr.rst}        |  18 +-
 .../{queue-sysfs.txt => queue-sysfs.rst}      |   7 +-
 .../block/{request.txt => request.rst}        |  47 +-
 Documentation/block/{stat.txt => stat.rst}    |  13 +-
 ...witching-sched.txt => switching-sched.rst} |  28 +-
 ...ontrol.txt => writeback_cache_control.rst} |  12 +-
 ...structure-v9.txt => data-structure-v9.rst} |   6 +-
 Documentation/blockdev/drbd/figures.rst       |  28 +
 .../blockdev/drbd/{README.txt => index.rst}   |  15 +-
 .../blockdev/{floppy.txt => floppy.rst}       |  88 +-
 Documentation/blockdev/index.rst              |  16 +
 Documentation/blockdev/{nbd.txt => nbd.rst}   |   2 +-
 .../blockdev/{paride.txt => paride.rst}       | 194 ++--
 .../blockdev/{ramdisk.txt => ramdisk.rst}     |  55 +-
 Documentation/blockdev/{zram.txt => zram.rst} | 197 ++--
 Documentation/core-api/printk-formats.rst     |   2 +-
 Documentation/device-mapper/statistics.rst    |   4 +-
 .../devicetree/bindings/phy/phy-bindings.txt  |   2 +-
 .../atomic_bitops.rst}                        |   1 -
 .../bt8xxgpio.rst}                            |   1 -
 .../bus-virt-phys-mapping.rst}                |  52 +-
 .../{connector => driver-api}/connector.rst   |   2 -
 .../{console => driver-api}/console.rst       |   2 -
 .../{crc32.txt => driver-api/crc32.rst}       |   0
 .../{dcdbas.txt => driver-api/dcdbas.rst}     |   0
 .../debugging-modules.rst}                    |   0
 .../debugging-via-ohci1394.rst}               |   0
 .../{dell_rbu.txt => driver-api/dell_rbu.rst} |   1 -
 .../{digsig.txt => driver-api/digsig.rst}     |   0
 .../{EDID/howto.rst => driver-api/edid.rst}   |   2 -
 .../{eisa.txt => driver-api/eisa.rst}         |   0
 .../futex-requeue-pi.rst}                     |   0
 .../gcc-plugins.rst}                          |   0
 .../hwspinlock.rst}                           |   0
 Documentation/driver-api/index.rst            |  71 +-
 .../io-mapping.rst}                           |   0
 .../io_ordering.rst}                          |   0
 .../{IPMI.txt => driver-api/ipmi.rst}         |   0
 .../irq-affinity.rst}                         |   0
 .../irq-domain.rst}                           |   0
 Documentation/{IRQ.txt => driver-api/irq.rst} |   0
 .../irqflags-tracing.rst}                     |   1 -
 Documentation/{isa.txt => driver-api/isa.rst} |   0
 .../{isapnp.txt => driver-api/isapnp.rst}     |   0
 .../{kobject.txt => driver-api/kobject.rst}   |   4 +-
 .../{kprobes.txt => driver-api/kprobes.rst}   |   1 -
 .../{kref.txt => driver-api/kref.rst}         |   0
 .../pblk.txt => driver-api/lightnvm-pblk.rst} |   0
 Documentation/{lzo.txt => driver-api/lzo.rst} |   0
 .../{mailbox.txt => driver-api/mailbox.rst}   |   0
 .../men-chameleon-bus.rst}                    |   0
 .../mm/dma-api-howto.rst}                     |   0
 .../mm/dma-api.rst}                           |   6 +-
 .../mm/dma-attributes.rst}                    |   0
 .../mm/dma-isa-lpc.rst}                       |   2 +-
 Documentation/driver-api/mm/index.rst         |  11 +
 .../nommu-mmap.rst}                           |   0
 Documentation/{ntb.txt => driver-api/ntb.rst} |   0
 Documentation/{nvmem => driver-api}/nvmem.rst |   2 -
 .../{padata.txt => driver-api/padata.rst}     |   0
 .../parport-lowlevel.rst}                     |   0
 .../percpu-rw-semaphore.rst}                  |   0
 .../{pi-futex.txt => driver-api/pi-futex.rst} |   0
 Documentation/driver-api/pps.rst              |   2 -
 .../preempt-locking.rst}                      |   2 +-
 .../{pti => driver-api}/pti_intel_mid.rst     |   2 -
 Documentation/driver-api/ptp.rst              |   2 -
 Documentation/{pwm.txt => driver-api/pwm.rst} |   0
 .../{rbtree.txt => driver-api/rbtree.rst}     |  52 +-
 .../remoteproc.rst}                           |   2 +-
 .../{rfkill.txt => driver-api/rfkill.rst}     |   0
 .../robust-futex-ABI.rst}                     |   0
 .../robust-futexes.rst}                       |   0
 .../{rpmsg.txt => driver-api/rpmsg.rst}       |   0
 .../{sgi-ioc4.txt => driver-api/sgi-ioc4.rst} |   0
 .../{SM501.txt => driver-api/sm501.rst}       |   0
 .../smsc_ece1099.rst}                         |   0
 .../speculation.rst}                          |   8 +-
 .../static-keys.rst}                          |   0
 .../switchtec.rst}                            |   2 +-
 .../sync_file.rst}                            |   0
 Documentation/{tee.txt => driver-api/tee.rst} |   0
 .../this_cpu_ops.rst}                         |   0
 .../unaligned-memory-access.rst}              |   0
 Documentation/driver-api/usb/dma.rst          |   6 +-
 .../vfio-mediated-device.rst}                 |   2 +-
 .../{vfio.txt => driver-api/vfio.rst}         |   0
 .../{ => driver-api}/xilinx/eemi.rst          |   0
 .../{ => driver-api}/xilinx/index.rst         |   1 -
 .../{xillybus.txt => driver-api/xillybus.rst} |   0
 Documentation/{xz.txt => driver-api/xz.rst}   |   0
 .../{zorro.txt => driver-api/zorro.rst}       |   5 +-
 Documentation/driver-model/device.rst         |   2 +-
 Documentation/fb/fbcon.rst                    |   4 +-
 Documentation/fb/vesafb.rst                   |   2 +-
 Documentation/filesystems/proc.txt            |   2 +-
 Documentation/filesystems/sysfs.txt           |   2 +-
 Documentation/filesystems/tmpfs.txt           |   2 +-
 .../acpi/extcon-intel-int3496.rst}            |  14 +-
 Documentation/firmware-guide/acpi/index.rst   |   1 +
 Documentation/gpu/drm-mm.rst                  |   2 +-
 Documentation/ia64/index.rst                  |   2 -
 Documentation/ia64/irq-redir.rst              |   2 +-
 Documentation/index.rst                       |  14 +
 ...g-up-ioctls.txt => botching-up-ioctls.rst} |   1 +
 Documentation/ioctl/{cdrom.txt => cdrom.rst}  | 908 +++++++++++-------
 Documentation/ioctl/{hdio.txt => hdio.rst}    | 835 ++++++++++------
 Documentation/ioctl/index.rst                 |  16 +
 ...{ioctl-decoding.txt => ioctl-decoding.rst} |  13 +-
 .../{ioctl-number.txt => ioctl-number.rst}    | 588 ++++++------
 Documentation/locking/rt-mutex.rst            |   2 +-
 Documentation/m68k/index.rst                  |   2 -
 Documentation/memory-barriers.txt             |   6 +-
 Documentation/mic/index.rst                   |   2 -
 Documentation/networking/ip-sysctl.txt        |   2 +-
 Documentation/networking/scaling.rst          |   4 +-
 .../perf/{arm-ccn.txt => arm-ccn.rst}         |  18 +-
 .../perf/{arm_dsu_pmu.txt => arm_dsu_pmu.rst} |   5 +-
 .../perf/{hisi-pmu.txt => hisi-pmu.rst}       |  35 +-
 Documentation/perf/index.rst                  |  16 +
 .../perf/{qcom_l2_pmu.txt => qcom_l2_pmu.rst} |   3 +-
 .../perf/{qcom_l3_pmu.txt => qcom_l3_pmu.rst} |   3 +-
 .../{thunderx2-pmu.txt => thunderx2-pmu.rst}  |  25 +-
 .../perf/{xgene-pmu.txt => xgene-pmu.rst}     |   3 +-
 Documentation/{phy.txt => phy.rst}            |   2 +
 Documentation/phy/samsung-usb2.rst            |   2 -
 .../powerpc/firmware-assisted-dump.rst        |   2 +-
 Documentation/process/submit-checklist.rst    |   2 +-
 Documentation/rapidio/index.rst               |  15 +
 .../{mport_cdev.txt => mport_cdev.rst}        |  47 +-
 .../rapidio/{rapidio.txt => rapidio.rst}      |  39 +-
 .../rapidio/{rio_cm.txt => rio_cm.rst}        |  66 +-
 .../rapidio/{sysfs.txt => sysfs.rst}          |   4 +
 .../rapidio/{tsi721.txt => tsi721.rst}        |  45 +-
 Documentation/riscv/index.rst                 |   2 -
 Documentation/s390/index.rst                  |   2 -
 Documentation/s390/vfio-ccw.rst               |   6 +-
 Documentation/scheduler/index.rst             |   2 -
 Documentation/scheduler/sched-deadline.rst    |   2 +-
 Documentation/scheduler/sched-design-CFS.rst  |   2 +-
 Documentation/scheduler/sched-rt-group.rst    |   2 +-
 Documentation/security/index.rst              |   5 +-
 .../security/{LSM.rst => lsm-development.rst} |   0
 Documentation/{lsm.txt => security/lsm.rst}   |   0
 Documentation/{SAK.txt => security/sak.rst}   |   1 -
 .../{siphash.txt => security/siphash.rst}     |   0
 Documentation/security/tpm/index.rst          |   1 +
 Documentation/security/tpm/xen-tpmfront.rst   |   2 -
 Documentation/sparc/index.rst                 |   2 -
 ...pu-cooling-api.txt => cpu-cooling-api.rst} |  39 +-
 .../{exynos_thermal => exynos_thermal.rst}    |  47 +-
 ...emulation => exynos_thermal_emulation.rst} |  66 +-
 Documentation/thermal/index.rst               |  18 +
 ...el_powerclamp.txt => intel_powerclamp.rst} | 177 ++--
 .../{nouveau_thermal => nouveau_thermal.rst}  |  54 +-
 ...ower_allocator.txt => power_allocator.rst} | 140 +--
 .../thermal/{sysfs-api.txt => sysfs-api.rst}  | 490 ++++++----
 ...hermal => x86_pkg_temperature_thermal.rst} |  28 +-
 Documentation/trace/kprobetrace.rst           |   2 +-
 .../it_IT/process/submit-checklist.rst        |   2 +-
 .../translations/ko_KR/memory-barriers.txt    |   6 +-
 Documentation/translations/zh_CN/IRQ.txt      |   4 +-
 .../translations/zh_CN/filesystems/sysfs.txt  |   2 +-
 .../translations/zh_CN/io_ordering.txt        |   4 +-
 .../translations/zh_CN/oops-tracing.txt       |   4 +-
 .../zh_CN/process/submit-checklist.rst        |   2 +-
 Documentation/usb/{acm.txt => acm.rst}        |   0
 .../{authorization.txt => authorization.rst}  |   0
 .../usb/{chipidea.txt => chipidea.rst}        |   0
 Documentation/usb/{dwc3.txt => dwc3.rst}      |   0
 Documentation/usb/{ehci.txt => ehci.rst}      |   0
 .../usb/{functionfs.txt => functionfs.rst}    |   0
 ...{gadget-testing.txt => gadget-testing.rst} |   4 +-
 ...adget_configfs.txt => gadget_configfs.rst} |   0
 .../usb/{gadget_hid.txt => gadget_hid.rst}    |   0
 .../{gadget_multi.txt => gadget_multi.rst}    |   0
 ...{gadget_printer.txt => gadget_printer.rst} |   0
 .../{gadget_serial.txt => gadget_serial.rst}  |   0
 Documentation/usb/index.rst                   |  39 +
 .../usb/{iuu_phoenix.txt => iuu_phoenix.rst}  |   0
 .../{mass-storage.txt => mass-storage.rst}    |   0
 ...{misc_usbsevseg.txt => misc_usbsevseg.rst} |   0
 .../usb/{mtouchusb.txt => mtouchusb.rst}      |   0
 Documentation/usb/{ohci.txt => ohci.rst}      |   0
 Documentation/usb/{rio.txt => rio.rst}        |   0
 Documentation/usb/text_files.rst              |  29 +
 .../usb/{usb-help.txt => usb-help.rst}        |   0
 .../usb/{usb-serial.txt => usb-serial.rst}    |   0
 ...{usbip_protocol.txt => usbip_protocol.rst} |   0
 Documentation/usb/{usbmon.txt => usbmon.rst}  |   0
 ...-overview.txt => wusb-design-overview.rst} |   0
 Documentation/vm/numa.rst                     |   4 +-
 Documentation/vm/page_migration.rst           |   2 +-
 Documentation/vm/unevictable-lru.rst          |   4 +-
 Documentation/w1/w1.netlink                   |   2 +-
 Documentation/watchdog/hpwdt.rst              |   4 +-
 Documentation/x86/index.rst                   |   2 +
 .../{Intel-IOMMU.txt => x86/intel-iommu.rst}  |   1 +
 .../{intel_txt.txt => x86/intel_txt.rst}      |   1 +
 Documentation/x86/topology.rst                |   2 +-
 .../x86/x86_64/fake-numa-for-cpusets.rst      |   4 +-
 Documentation/xtensa/index.rst                |   2 -
 MAINTAINERS                                   | 106 +-
 arch/Kconfig                                  |   4 +-
 arch/arm/Kconfig                              |   4 +-
 arch/arm64/Kconfig                            |   2 +-
 arch/ia64/hp/common/sba_iommu.c               |  12 +-
 arch/ia64/sn/pci/pci_dma.c                    |   4 +-
 arch/parisc/Kconfig                           |   2 +-
 arch/parisc/kernel/pci-dma.c                  |   2 +-
 arch/sh/Kconfig                               |   4 +-
 arch/sparc/Kconfig                            |   2 +-
 arch/unicore32/include/asm/io.h               |   2 +-
 arch/x86/Kconfig                              |   8 +-
 arch/x86/include/asm/dma-mapping.h            |   4 +-
 arch/x86/kernel/amd_gart_64.c                 |   2 +-
 block/Kconfig                                 |   4 +-
 block/Kconfig.iosched                         |   2 +-
 block/bfq-iosched.c                           |   2 +-
 block/blk-integrity.c                         |   2 +-
 block/ioprio.c                                |   2 +-
 block/mq-deadline.c                           |   2 +-
 block/partitions/Kconfig                      |   2 +-
 block/partitions/cmdline.c                    |   2 +-
 drivers/base/core.c                           |   2 +-
 drivers/block/Kconfig                         |   8 +-
 drivers/block/floppy.c                        |   2 +-
 drivers/block/zram/Kconfig                    |   6 +-
 drivers/char/Kconfig                          |   6 +-
 drivers/char/hw_random/core.c                 |   2 +-
 drivers/char/ipmi/Kconfig                     |   2 +-
 drivers/char/ipmi/ipmi_si_hotmod.c            |   2 +-
 drivers/char/ipmi/ipmi_si_intf.c              |   2 +-
 drivers/dma-buf/Kconfig                       |   2 +-
 drivers/gpio/Kconfig                          |   2 +-
 drivers/gpu/drm/Kconfig                       |   2 +-
 drivers/gpu/drm/drm_ioctl.c                   |   2 +-
 drivers/parisc/sba_iommu.c                    |  16 +-
 drivers/pci/switch/Kconfig                    |   2 +-
 drivers/perf/qcom_l3_pmu.c                    |   2 +-
 drivers/platform/x86/Kconfig                  |   8 +-
 drivers/platform/x86/dcdbas.c                 |   2 +-
 drivers/platform/x86/dell_rbu.c               |   2 +-
 drivers/pnp/isapnp/Kconfig                    |   2 +-
 drivers/rapidio/Kconfig                       |   2 +-
 drivers/tty/Kconfig                           |   2 +-
 drivers/usb/Kconfig                           |   2 +-
 drivers/usb/class/Kconfig                     |   2 +-
 drivers/usb/gadget/Kconfig                    |   6 +-
 drivers/usb/gadget/function/f_mass_storage.c  |   2 +-
 drivers/usb/gadget/legacy/Kconfig             |   6 +-
 drivers/usb/host/Kconfig                      |   2 +-
 drivers/usb/misc/Kconfig                      |   2 +-
 drivers/usb/mon/Kconfig                       |   2 +-
 drivers/usb/serial/Kconfig                    |  10 +-
 drivers/usb/serial/belkin_sa.c                |   2 +-
 drivers/usb/serial/belkin_sa.h                |   2 +-
 drivers/usb/serial/cypress_m8.c               |   2 +-
 drivers/usb/serial/empeg.c                    |   2 +-
 drivers/usb/serial/ftdi_sio.c                 |   2 +-
 drivers/usb/serial/ir-usb.c                   |   2 +-
 drivers/usb/serial/keyspan_pda.c              |   2 +-
 drivers/usb/serial/omninet.c                  |   2 +-
 drivers/usb/serial/oti6858.c                  |   2 +-
 drivers/usb/serial/pl2303.c                   |   2 +-
 drivers/usb/serial/usb-serial.c               |   2 +-
 drivers/usb/serial/visor.c                    |   2 +-
 drivers/usb/serial/visor.h                    |   2 +-
 drivers/usb/serial/whiteheat.c                |   2 +-
 drivers/usb/serial/whiteheat.h                |   2 +-
 drivers/vfio/Kconfig                          |   2 +-
 drivers/vfio/mdev/Kconfig                     |   2 +-
 drivers/w1/Kconfig                            |   2 +-
 fs/proc/Kconfig                               |   2 +-
 include/asm-generic/bitops/atomic.h           |   2 +-
 include/linux/cgroup-defs.h                   |   2 +-
 include/linux/dma-mapping.h                   |   2 +-
 include/linux/hw_random.h                     |   2 +-
 include/linux/io-mapping.h                    |   2 +-
 include/linux/jump_label.h                    |   2 +-
 include/linux/kobject.h                       |   2 +-
 include/linux/kobject_ns.h                    |   2 +-
 include/linux/rbtree.h                        |   2 +-
 include/linux/rbtree_augmented.h              |   2 +-
 include/linux/thermal.h                       |   4 +-
 include/media/videobuf-dma-sg.h               |   2 +-
 include/uapi/linux/bpf.h                      |   2 +-
 include/uapi/rdma/rdma_user_ioctl_cmds.h      |   2 +-
 init/Kconfig                                  |   6 +-
 kernel/cgroup/cpuset.c                        |   2 +-
 kernel/dma/debug.c                            |   2 +-
 kernel/padata.c                               |   2 +-
 kernel/panic.c                                |   2 +-
 lib/Kconfig                                   |   2 +-
 lib/Kconfig.debug                             |   2 +-
 lib/crc32.c                                   |   2 +-
 lib/kobject.c                                 |   4 +-
 lib/lzo/lzo1x_decompress_safe.c               |   2 +-
 lib/xz/Kconfig                                |   2 +-
 mm/Kconfig                                    |   2 +-
 mm/nommu.c                                    |   2 +-
 mm/swap.c                                     |   2 +-
 samples/Kconfig                               |   2 +-
 samples/kprobes/kprobe_example.c              |   2 +-
 samples/kprobes/kretprobe_example.c           |   2 +-
 scripts/gcc-plugins/Kconfig                   |   2 +-
 security/Kconfig                              |   2 +-
 security/device_cgroup.c                      |   2 +-
 tools/include/linux/rbtree.h                  |   2 +-
 tools/include/linux/rbtree_augmented.h        |   2 +-
 tools/include/uapi/linux/bpf.h                |   2 +-
 tools/testing/selftests/zram/README           |   2 +-
 405 files changed, 4491 insertions(+), 2896 deletions(-)
 rename Documentation/{ => admin-guide}/aoe/aoe.rst (97%)
 rename Documentation/{ => admin-guide}/aoe/autoload.sh (99%)
 rename Documentation/{ => admin-guide}/aoe/examples.rst (100%)
 rename Documentation/{ => admin-guide}/aoe/index.rst (95%)
 rename Documentation/{ => admin-guide}/aoe/status.sh (100%)
 rename Documentation/{ => admin-guide}/aoe/todo.rst (100%)
 rename Documentation/{ => admin-guide}/aoe/udev-install.sh (92%)
 rename Documentation/{ => admin-guide}/aoe/udev.txt (91%)
 rename Documentation/{btmrvl.txt => admin-guide/btmrvl.rst} (100%)
 rename Documentation/{ => admin-guide}/cgroup-v1/blkio-controller.rst (100%)
 rename Documentation/{ => admin-guide}/cgroup-v1/cgroups.rst (99%)
 rename Documentation/{ => admin-guide}/cgroup-v1/cpuacct.rst (100%)
 rename Documentation/{ => admin-guide}/cgroup-v1/cpusets.rst (99%)
 rename Documentation/{ => admin-guide}/cgroup-v1/devices.rst (100%)
 rename Documentation/{ => admin-guide}/cgroup-v1/freezer-subsystem.rst (100%)
 rename Documentation/{ => admin-guide}/cgroup-v1/hugetlb.rst (100%)
 rename Documentation/{ => admin-guide}/cgroup-v1/index.rst (97%)
 rename Documentation/{ => admin-guide}/cgroup-v1/memcg_test.rst (98%)
 rename Documentation/{ => admin-guide}/cgroup-v1/memory.rst (100%)
 rename Documentation/{ => admin-guide}/cgroup-v1/net_cls.rst (100%)
 rename Documentation/{ => admin-guide}/cgroup-v1/net_prio.rst (100%)
 rename Documentation/{ => admin-guide}/cgroup-v1/pids.rst (100%)
 rename Documentation/{ => admin-guide}/cgroup-v1/rdma.rst (100%)
 rename Documentation/{clearing-warn-once.txt => admin-guide/clearing-warn-once.rst} (100%)
 rename Documentation/{cpu-load.txt => admin-guide/cpu-load.rst} (100%)
 rename Documentation/{cputopology.txt => admin-guide/cputopology.rst} (100%)
 rename Documentation/{efi-stub.txt => admin-guide/efi-stub.rst} (100%)
 rename Documentation/{highuid.txt => admin-guide/highuid.rst} (99%)
 rename Documentation/{hw_random.txt => admin-guide/hw_random.rst} (100%)
 rename Documentation/{iostats.txt => admin-guide/iostats.rst} (100%)
 rename Documentation/{ => admin-guide}/kdump/gdbmacros.txt (100%)
 rename Documentation/{ => admin-guide}/kdump/index.rst (97%)
 rename Documentation/{ => admin-guide}/kdump/kdump.rst (100%)
 rename Documentation/{ => admin-guide}/kdump/vmcoreinfo.rst (100%)
 rename Documentation/{kernel-per-CPU-kthreads.txt => admin-guide/kernel-per-cpu-kthreads.rst} (98%)
 rename Documentation/{ => admin-guide}/laptops/asus-laptop.rst (100%)
 rename Documentation/{ => admin-guide}/laptops/disk-shock-protection.rst (100%)
 rename Documentation/{ => admin-guide}/laptops/index.rst (95%)
 rename Documentation/{ => admin-guide}/laptops/laptop-mode.rst (100%)
 rename Documentation/{ => admin-guide}/laptops/lg-laptop.rst (99%)
 rename Documentation/{ => admin-guide}/laptops/sony-laptop.rst (100%)
 rename Documentation/{ => admin-guide}/laptops/sonypi.rst (100%)
 rename Documentation/{ => admin-guide}/laptops/thinkpad-acpi.rst (99%)
 rename Documentation/{ => admin-guide}/laptops/toshiba_haps.rst (100%)
 rename Documentation/{auxdisplay => admin-guide}/lcd-panel-cgram.rst (99%)
 rename Documentation/{ldm.txt => admin-guide/ldm.rst} (98%)
 rename Documentation/{lockup-watchdogs.txt => admin-guide/lockup-watchdogs.rst} (100%)
 rename Documentation/{cma/debugfs.rst => admin-guide/mm/cma_debugfs.rst} (98%)
 rename Documentation/{numastat.txt => admin-guide/numastat.rst} (93%)
 rename Documentation/{pnp.txt => admin-guide/pnp.rst} (98%)
 rename Documentation/{rtc.txt => admin-guide/rtc.rst} (99%)
 rename Documentation/{svga.txt => admin-guide/svga.rst} (100%)
 rename Documentation/{sysctl/abi.txt => admin-guide/sysctl/abi.rst} (30%)
 rename Documentation/{sysctl/fs.txt => admin-guide/sysctl/fs.rst} (77%)
 rename Documentation/{sysctl/README => admin-guide/sysctl/index.rst} (78%)
 rename Documentation/{sysctl/kernel.txt => admin-guide/sysctl/kernel.rst} (79%)
 rename Documentation/{sysctl/net.txt => admin-guide/sysctl/net.rst} (85%)
 rename Documentation/{sysctl/sunrpc.txt => admin-guide/sysctl/sunrpc.rst} (62%)
 rename Documentation/{sysctl/user.txt => admin-guide/sysctl/user.rst} (77%)
 rename Documentation/{sysctl/vm.txt => admin-guide/sysctl/vm.rst} (84%)
 rename Documentation/{video-output.txt => admin-guide/video-output.rst} (99%)
 rename Documentation/block/{bfq-iosched.txt => bfq-iosched.rst} (95%)
 rename Documentation/block/{biodoc.txt => biodoc.rst} (83%)
 rename Documentation/block/{biovecs.txt => biovecs.rst} (92%)
 rename Documentation/block/{capability.txt => capability.rst} (40%)
 rename Documentation/block/{cmdline-partition.txt => cmdline-partition.rst} (92%)
 rename Documentation/block/{data-integrity.txt => data-integrity.rst} (91%)
 rename Documentation/block/{deadline-iosched.txt => deadline-iosched.rst} (89%)
 create mode 100644 Documentation/block/index.rst
 rename Documentation/block/{ioprio.txt => ioprio.rst} (75%)
 rename Documentation/block/{kyber-iosched.txt => kyber-iosched.rst} (86%)
 rename Documentation/block/{null_blk.txt => null_blk.rst} (60%)
 rename Documentation/block/{pr.txt => pr.rst} (93%)
 rename Documentation/block/{queue-sysfs.txt => queue-sysfs.rst} (99%)
 rename Documentation/block/{request.txt => request.rst} (59%)
 rename Documentation/block/{stat.txt => stat.rst} (89%)
 rename Documentation/block/{switching-sched.txt => switching-sched.rst} (67%)
 rename Documentation/block/{writeback_cache_control.txt => writeback_cache_control.rst} (94%)
 rename Documentation/blockdev/drbd/{data-structure-v9.txt => data-structure-v9.rst} (94%)
 create mode 100644 Documentation/blockdev/drbd/figures.rst
 rename Documentation/blockdev/drbd/{README.txt => index.rst} (55%)
 rename Documentation/blockdev/{floppy.txt => floppy.rst} (81%)
 create mode 100644 Documentation/blockdev/index.rst
 rename Documentation/blockdev/{nbd.txt => nbd.rst} (96%)
 rename Documentation/blockdev/{paride.txt => paride.rst} (81%)
 rename Documentation/blockdev/{ramdisk.txt => ramdisk.rst} (84%)
 rename Documentation/blockdev/{zram.txt => zram.rst} (76%)
 rename Documentation/{atomic_bitops.txt => driver-api/atomic_bitops.rst} (99%)
 rename Documentation/{bt8xxgpio.txt => driver-api/bt8xxgpio.rst} (99%)
 rename Documentation/{bus-virt-phys-mapping.txt => driver-api/bus-virt-phys-mapping.rst} (93%)
 rename Documentation/{connector => driver-api}/connector.rst (99%)
 rename Documentation/{console => driver-api}/console.rst (99%)
 rename Documentation/{crc32.txt => driver-api/crc32.rst} (100%)
 rename Documentation/{dcdbas.txt => driver-api/dcdbas.rst} (100%)
 rename Documentation/{debugging-modules.txt => driver-api/debugging-modules.rst} (100%)
 rename Documentation/{debugging-via-ohci1394.txt => driver-api/debugging-via-ohci1394.rst} (100%)
 rename Documentation/{dell_rbu.txt => driver-api/dell_rbu.rst} (99%)
 rename Documentation/{digsig.txt => driver-api/digsig.rst} (100%)
 rename Documentation/{EDID/howto.rst => driver-api/edid.rst} (99%)
 rename Documentation/{eisa.txt => driver-api/eisa.rst} (100%)
 rename Documentation/{futex-requeue-pi.txt => driver-api/futex-requeue-pi.rst} (100%)
 rename Documentation/{gcc-plugins.txt => driver-api/gcc-plugins.rst} (100%)
 rename Documentation/{hwspinlock.txt => driver-api/hwspinlock.rst} (100%)
 rename Documentation/{io-mapping.txt => driver-api/io-mapping.rst} (100%)
 rename Documentation/{io_ordering.txt => driver-api/io_ordering.rst} (100%)
 rename Documentation/{IPMI.txt => driver-api/ipmi.rst} (100%)
 rename Documentation/{IRQ-affinity.txt => driver-api/irq-affinity.rst} (100%)
 rename Documentation/{IRQ-domain.txt => driver-api/irq-domain.rst} (100%)
 rename Documentation/{IRQ.txt => driver-api/irq.rst} (100%)
 rename Documentation/{irqflags-tracing.txt => driver-api/irqflags-tracing.rst} (99%)
 rename Documentation/{isa.txt => driver-api/isa.rst} (100%)
 rename Documentation/{isapnp.txt => driver-api/isapnp.rst} (100%)
 rename Documentation/{kobject.txt => driver-api/kobject.rst} (99%)
 rename Documentation/{kprobes.txt => driver-api/kprobes.rst} (99%)
 rename Documentation/{kref.txt => driver-api/kref.rst} (100%)
 rename Documentation/{lightnvm/pblk.txt => driver-api/lightnvm-pblk.rst} (100%)
 rename Documentation/{lzo.txt => driver-api/lzo.rst} (100%)
 rename Documentation/{mailbox.txt => driver-api/mailbox.rst} (100%)
 rename Documentation/{men-chameleon-bus.txt => driver-api/men-chameleon-bus.rst} (100%)
 rename Documentation/{DMA-API-HOWTO.txt => driver-api/mm/dma-api-howto.rst} (100%)
 rename Documentation/{DMA-API.txt => driver-api/mm/dma-api.rst} (99%)
 rename Documentation/{DMA-attributes.txt => driver-api/mm/dma-attributes.rst} (100%)
 rename Documentation/{DMA-ISA-LPC.txt => driver-api/mm/dma-isa-lpc.rst} (98%)
 create mode 100644 Documentation/driver-api/mm/index.rst
 rename Documentation/{nommu-mmap.txt => driver-api/nommu-mmap.rst} (100%)
 rename Documentation/{ntb.txt => driver-api/ntb.rst} (100%)
 rename Documentation/{nvmem => driver-api}/nvmem.rst (99%)
 rename Documentation/{padata.txt => driver-api/padata.rst} (100%)
 rename Documentation/{parport-lowlevel.txt => driver-api/parport-lowlevel.rst} (100%)
 rename Documentation/{percpu-rw-semaphore.txt => driver-api/percpu-rw-semaphore.rst} (100%)
 rename Documentation/{pi-futex.txt => driver-api/pi-futex.rst} (100%)
 rename Documentation/{preempt-locking.txt => driver-api/preempt-locking.rst} (99%)
 rename Documentation/{pti => driver-api}/pti_intel_mid.rst (99%)
 rename Documentation/{pwm.txt => driver-api/pwm.rst} (100%)
 rename Documentation/{rbtree.txt => driver-api/rbtree.rst} (94%)
 rename Documentation/{remoteproc.txt => driver-api/remoteproc.rst} (99%)
 rename Documentation/{rfkill.txt => driver-api/rfkill.rst} (100%)
 rename Documentation/{robust-futex-ABI.txt => driver-api/robust-futex-ABI.rst} (100%)
 rename Documentation/{robust-futexes.txt => driver-api/robust-futexes.rst} (100%)
 rename Documentation/{rpmsg.txt => driver-api/rpmsg.rst} (100%)
 rename Documentation/{sgi-ioc4.txt => driver-api/sgi-ioc4.rst} (100%)
 rename Documentation/{SM501.txt => driver-api/sm501.rst} (100%)
 rename Documentation/{smsc_ece1099.txt => driver-api/smsc_ece1099.rst} (100%)
 rename Documentation/{speculation.txt => driver-api/speculation.rst} (100%)
 rename Documentation/{static-keys.txt => driver-api/static-keys.rst} (100%)
 rename Documentation/{switchtec.txt => driver-api/switchtec.rst} (97%)
 rename Documentation/{sync_file.txt => driver-api/sync_file.rst} (100%)
 rename Documentation/{tee.txt => driver-api/tee.rst} (100%)
 rename Documentation/{this_cpu_ops.txt => driver-api/this_cpu_ops.rst} (100%)
 rename Documentation/{unaligned-memory-access.txt => driver-api/unaligned-memory-access.rst} (100%)
 rename Documentation/{vfio-mediated-device.txt => driver-api/vfio-mediated-device.rst} (99%)
 rename Documentation/{vfio.txt => driver-api/vfio.rst} (100%)
 rename Documentation/{ => driver-api}/xilinx/eemi.rst (100%)
 rename Documentation/{ => driver-api}/xilinx/index.rst (94%)
 rename Documentation/{xillybus.txt => driver-api/xillybus.rst} (100%)
 rename Documentation/{xz.txt => driver-api/xz.rst} (100%)
 rename Documentation/{zorro.txt => driver-api/zorro.rst} (99%)
 rename Documentation/{extcon/intel-int3496.txt => firmware-guide/acpi/extcon-intel-int3496.rst} (66%)
 rename Documentation/ioctl/{botching-up-ioctls.txt => botching-up-ioctls.rst} (99%)
 rename Documentation/ioctl/{cdrom.txt => cdrom.rst} (39%)
 rename Documentation/ioctl/{hdio.txt => hdio.rst} (54%)
 create mode 100644 Documentation/ioctl/index.rst
 rename Documentation/ioctl/{ioctl-decoding.txt => ioctl-decoding.rst} (54%)
 rename Documentation/ioctl/{ioctl-number.txt => ioctl-number.rst} (11%)
 rename Documentation/perf/{arm-ccn.txt => arm-ccn.rst} (86%)
 rename Documentation/perf/{arm_dsu_pmu.txt => arm_dsu_pmu.rst} (92%)
 rename Documentation/perf/{hisi-pmu.txt => hisi-pmu.rst} (73%)
 create mode 100644 Documentation/perf/index.rst
 rename Documentation/perf/{qcom_l2_pmu.txt => qcom_l2_pmu.rst} (94%)
 rename Documentation/perf/{qcom_l3_pmu.txt => qcom_l3_pmu.rst} (93%)
 rename Documentation/perf/{thunderx2-pmu.txt => thunderx2-pmu.rst} (73%)
 rename Documentation/perf/{xgene-pmu.txt => xgene-pmu.rst} (96%)
 rename Documentation/{phy.txt => phy.rst} (99%)
 create mode 100644 Documentation/rapidio/index.rst
 rename Documentation/rapidio/{mport_cdev.txt => mport_cdev.rst} (84%)
 rename Documentation/rapidio/{rapidio.txt => rapidio.rst} (97%)
 rename Documentation/rapidio/{rio_cm.txt => rio_cm.rst} (76%)
 rename Documentation/rapidio/{sysfs.txt => sysfs.rst} (75%)
 rename Documentation/rapidio/{tsi721.txt => tsi721.rst} (79%)
 rename Documentation/security/{LSM.rst => lsm-development.rst} (100%)
 rename Documentation/{lsm.txt => security/lsm.rst} (100%)
 rename Documentation/{SAK.txt => security/sak.rst} (99%)
 rename Documentation/{siphash.txt => security/siphash.rst} (100%)
 rename Documentation/thermal/{cpu-cooling-api.txt => cpu-cooling-api.rst} (82%)
 rename Documentation/thermal/{exynos_thermal => exynos_thermal.rst} (67%)
 rename Documentation/thermal/{exynos_thermal_emulation => exynos_thermal_emulation.rst} (36%)
 create mode 100644 Documentation/thermal/index.rst
 rename Documentation/thermal/{intel_powerclamp.txt => intel_powerclamp.rst} (76%)
 rename Documentation/thermal/{nouveau_thermal => nouveau_thermal.rst} (64%)
 rename Documentation/thermal/{power_allocator.txt => power_allocator.rst} (74%)
 rename Documentation/thermal/{sysfs-api.txt => sysfs-api.rst} (66%)
 rename Documentation/thermal/{x86_pkg_temperature_thermal => x86_pkg_temperature_thermal.rst} (80%)
 rename Documentation/usb/{acm.txt => acm.rst} (100%)
 rename Documentation/usb/{authorization.txt => authorization.rst} (100%)
 rename Documentation/usb/{chipidea.txt => chipidea.rst} (100%)
 rename Documentation/usb/{dwc3.txt => dwc3.rst} (100%)
 rename Documentation/usb/{ehci.txt => ehci.rst} (100%)
 rename Documentation/usb/{functionfs.txt => functionfs.rst} (100%)
 rename Documentation/usb/{gadget-testing.txt => gadget-testing.rst} (99%)
 rename Documentation/usb/{gadget_configfs.txt => gadget_configfs.rst} (100%)
 rename Documentation/usb/{gadget_hid.txt => gadget_hid.rst} (100%)
 rename Documentation/usb/{gadget_multi.txt => gadget_multi.rst} (100%)
 rename Documentation/usb/{gadget_printer.txt => gadget_printer.rst} (100%)
 rename Documentation/usb/{gadget_serial.txt => gadget_serial.rst} (100%)
 create mode 100644 Documentation/usb/index.rst
 rename Documentation/usb/{iuu_phoenix.txt => iuu_phoenix.rst} (100%)
 rename Documentation/usb/{mass-storage.txt => mass-storage.rst} (100%)
 rename Documentation/usb/{misc_usbsevseg.txt => misc_usbsevseg.rst} (100%)
 rename Documentation/usb/{mtouchusb.txt => mtouchusb.rst} (100%)
 rename Documentation/usb/{ohci.txt => ohci.rst} (100%)
 rename Documentation/usb/{rio.txt => rio.rst} (100%)
 create mode 100644 Documentation/usb/text_files.rst
 rename Documentation/usb/{usb-help.txt => usb-help.rst} (100%)
 rename Documentation/usb/{usb-serial.txt => usb-serial.rst} (100%)
 rename Documentation/usb/{usbip_protocol.txt => usbip_protocol.rst} (100%)
 rename Documentation/usb/{usbmon.txt => usbmon.rst} (100%)
 rename Documentation/usb/{WUSB-Design-overview.txt => wusb-design-overview.rst} (100%)
 rename Documentation/{Intel-IOMMU.txt => x86/intel-iommu.rst} (99%)
 rename Documentation/{intel_txt.txt => x86/intel_txt.rst} (99%)

-- 
2.21.0


