Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 640DE4ACCE
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 23:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731032AbfFRVGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 17:06:40 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:34670 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730832AbfFRVF4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 17:05:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
        To:From:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=0Fd59qYHPeeoAztyC3BNaFmvhKSlCUBOd/6uerZbhRM=; b=NcWH33eQiz+NCf2Lwg00qXODSC
        Oh20oknzSq+1nnCh/4b8tnOP6VfFgO6sV9obgYj1rkgpLXXuUD/vZhkRx+ZC0TY1PjcORGTCaKqN7
        Fb49IN0K5wvmZuXt+9kPngkbxiGrSi+29jBNsd6g+isw1mVCnBSvzYIpU6YEK6hg/ZJe2AmO2WSG1
        F8g552zq/kvTEnYGNFW+TkxrqfQwvelk/Mh2dfAebgVzvZ1EQBGYugafKMVp6Yhb8lnE65710cyqk
        fDo0CjzeG2CeJ+uqnzTYrdsO+Mhoa/TL3vv5rub072QBsbZ8jfAjR+0HUABN9VSCilRgb/Lm2GFqa
        h5+UNbzA==;
Received: from 177.133.86.196.dynamic.adsl.gvt.net.br ([177.133.86.196] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hdLIc-0006yh-7n; Tue, 18 Jun 2019 21:05:52 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1hdLIZ-0002Bk-Kr; Tue, 18 Jun 2019 18:05:47 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        x86@kernel.org, linux-wireless@vger.kernel.org,
        linux-pci@vger.kernel.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
        linux-arch@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-ia64@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net,
        linaro-mm-sig@lists.linaro.org, linux-gpio@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-mm@kvack.org,
        kernel-hardening@lists.openwall.com,
        linux-security-module@vger.kernel.org
Subject: [PATCH v1 01/22] docs: Documentation/*.txt: rename all ReST files to *.rst
Date:   Tue, 18 Jun 2019 18:05:25 -0300
Message-Id: <6b6b6db8d6de9b66223dd6d4b43eb60ead4c71d7.1560891322.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1560891322.git.mchehab+samsung@kernel.org>
References: <cover.1560891322.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Those files are actually at ReST format. Ok, currently, they
don't belong to any place yet at the organized book series,
but we don't want patches to break them as ReST files. So,
rename them and add a :orphan: in order to shut up warning
messages like those:

...
    Documentation/svga.rst: WARNING: document isn't included in any toctree
    Documentation/switchtec.rst: WARNING: document isn't included in any toctree
...

Later patches will move them to a better place and remove the
:orphan: markup.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---

I had to remove the long list of maintainers got by
getpatch.pl, as it was too long. I opted to keep only the
mailing lists.

 Documentation/ABI/removed/sysfs-class-rfkill  |  2 +-
 Documentation/ABI/stable/sysfs-class-rfkill   |  2 +-
 Documentation/ABI/stable/sysfs-devices-node   |  2 +-
 Documentation/ABI/testing/procfs-diskstats    |  2 +-
 Documentation/ABI/testing/sysfs-block         |  2 +-
 .../ABI/testing/sysfs-class-switchtec         |  2 +-
 .../ABI/testing/sysfs-devices-system-cpu      |  4 +-
 .../{DMA-API-HOWTO.txt => DMA-API-HOWTO.rst}  |  2 +
 Documentation/{DMA-API.txt => DMA-API.rst}    |  8 ++-
 .../{DMA-ISA-LPC.txt => DMA-ISA-LPC.rst}      |  4 +-
 ...{DMA-attributes.txt => DMA-attributes.rst} |  2 +
 Documentation/{IPMI.txt => IPMI.rst}          |  2 +
 .../{IRQ-affinity.txt => IRQ-affinity.rst}    |  2 +
 .../{IRQ-domain.txt => IRQ-domain.rst}        |  2 +
 Documentation/{IRQ.txt => IRQ.rst}            |  2 +
 .../{Intel-IOMMU.txt => Intel-IOMMU.rst}      |  2 +
 Documentation/PCI/pci.rst                     |  8 +--
 Documentation/{SAK.txt => SAK.rst}            |  3 +-
 Documentation/{SM501.txt => SM501.rst}        |  2 +
 Documentation/admin-guide/hw-vuln/l1tf.rst    |  2 +-
 .../admin-guide/kernel-parameters.txt         |  4 +-
 .../{atomic_bitops.txt => atomic_bitops.rst}  |  3 +-
 Documentation/block/biodoc.txt                |  2 +-
 .../{bt8xxgpio.txt => bt8xxgpio.rst}          |  3 +-
 Documentation/{btmrvl.txt => btmrvl.rst}      |  2 +
 ...-mapping.txt => bus-virt-phys-mapping.rst} | 54 +++++++++---------
 ...g-warn-once.txt => clearing-warn-once.rst} |  2 +
 Documentation/{cpu-load.txt => cpu-load.rst}  |  2 +
 .../{cputopology.txt => cputopology.rst}      |  2 +
 Documentation/{crc32.txt => crc32.rst}        |  2 +
 Documentation/{dcdbas.txt => dcdbas.rst}      |  2 +
 ...ging-modules.txt => debugging-modules.rst} |  2 +
 ...hci1394.txt => debugging-via-ohci1394.rst} |  2 +
 Documentation/{dell_rbu.txt => dell_rbu.rst}  |  3 +-
 Documentation/device-mapper/statistics.rst    |  4 +-
 .../devicetree/bindings/phy/phy-bindings.txt  |  2 +-
 Documentation/{digsig.txt => digsig.rst}      |  2 +
 Documentation/driver-api/usb/dma.rst          |  6 +-
 Documentation/driver-model/device.rst         |  2 +-
 Documentation/{efi-stub.txt => efi-stub.rst}  |  2 +
 Documentation/{eisa.txt => eisa.rst}          |  2 +
 Documentation/fb/vesafb.rst                   |  2 +-
 Documentation/filesystems/sysfs.txt           |  2 +-
 ...ex-requeue-pi.txt => futex-requeue-pi.rst} |  2 +
 .../{gcc-plugins.txt => gcc-plugins.rst}      |  2 +
 Documentation/gpu/drm-mm.rst                  |  2 +-
 Documentation/{highuid.txt => highuid.rst}    |  4 +-
 .../{hw_random.txt => hw_random.rst}          |  2 +
 .../{hwspinlock.txt => hwspinlock.rst}        |  2 +
 Documentation/ia64/irq-redir.rst              |  2 +-
 .../{intel_txt.txt => intel_txt.rst}          |  2 +
 .../{io-mapping.txt => io-mapping.rst}        |  2 +
 .../{io_ordering.txt => io_ordering.rst}      |  2 +
 Documentation/{iostats.txt => iostats.rst}    |  2 +
 ...flags-tracing.txt => irqflags-tracing.rst} |  3 +-
 Documentation/{isa.txt => isa.rst}            |  2 +
 Documentation/{isapnp.txt => isapnp.rst}      |  2 +
 ...hreads.txt => kernel-per-CPU-kthreads.rst} |  4 +-
 Documentation/{kobject.txt => kobject.rst}    |  6 +-
 Documentation/{kprobes.txt => kprobes.rst}    |  3 +-
 Documentation/{kref.txt => kref.rst}          |  2 +
 Documentation/laptops/thinkpad-acpi.rst       |  6 +-
 Documentation/{ldm.txt => ldm.rst}            |  5 +-
 Documentation/locking/rt-mutex.rst            |  2 +-
 ...kup-watchdogs.txt => lockup-watchdogs.rst} |  2 +
 Documentation/{lsm.txt => lsm.rst}            |  2 +
 Documentation/{lzo.txt => lzo.rst}            |  2 +
 Documentation/{mailbox.txt => mailbox.rst}    |  2 +
 Documentation/memory-barriers.txt             |  6 +-
 ...hameleon-bus.txt => men-chameleon-bus.rst} |  2 +
 Documentation/networking/scaling.rst          |  4 +-
 .../{nommu-mmap.txt => nommu-mmap.rst}        |  2 +
 Documentation/{ntb.txt => ntb.rst}            |  2 +
 Documentation/{numastat.txt => numastat.rst}  |  3 +-
 Documentation/{padata.txt => padata.rst}      |  2 +
 ...port-lowlevel.txt => parport-lowlevel.rst} |  2 +
 ...-semaphore.txt => percpu-rw-semaphore.rst} |  2 +
 Documentation/{phy.txt => phy.rst}            |  2 +
 Documentation/{pi-futex.txt => pi-futex.rst}  |  2 +
 Documentation/{pnp.txt => pnp.rst}            | 13 +++--
 ...reempt-locking.txt => preempt-locking.rst} |  4 +-
 Documentation/{pwm.txt => pwm.rst}            |  2 +
 Documentation/{rbtree.txt => rbtree.rst}      | 54 +++++++++---------
 .../{remoteproc.txt => remoteproc.rst}        |  4 +-
 Documentation/{rfkill.txt => rfkill.rst}      |  2 +
 ...ust-futex-ABI.txt => robust-futex-ABI.rst} |  2 +
 ...{robust-futexes.txt => robust-futexes.rst} |  2 +
 Documentation/{rpmsg.txt => rpmsg.rst}        |  2 +
 Documentation/{rtc.txt => rtc.rst}            |  8 ++-
 Documentation/s390/vfio-ccw.rst               |  6 +-
 Documentation/{sgi-ioc4.txt => sgi-ioc4.rst}  |  2 +
 Documentation/{siphash.txt => siphash.rst}    |  2 +
 .../{smsc_ece1099.txt => smsc_ece1099.rst}    |  2 +
 .../{speculation.txt => speculation.rst}      |  2 +
 .../{static-keys.txt => static-keys.rst}      |  2 +
 Documentation/{svga.txt => svga.rst}          |  2 +
 .../{switchtec.txt => switchtec.rst}          |  4 +-
 .../{sync_file.txt => sync_file.rst}          |  2 +
 Documentation/sysctl/kernel.txt               |  4 +-
 Documentation/sysctl/vm.txt                   |  2 +-
 Documentation/{tee.txt => tee.rst}            |  2 +
 .../{this_cpu_ops.txt => this_cpu_ops.rst}    |  2 +
 Documentation/trace/kprobetrace.rst           |  2 +-
 .../translations/ko_KR/memory-barriers.txt    |  6 +-
 Documentation/translations/zh_CN/IRQ.txt      |  4 +-
 .../translations/zh_CN/filesystems/sysfs.txt  |  2 +-
 .../translations/zh_CN/io_ordering.txt        |  4 +-
 ...access.txt => unaligned-memory-access.rst} |  2 +
 ...ed-device.txt => vfio-mediated-device.rst} |  4 +-
 Documentation/{vfio.txt => vfio.rst}          |  2 +
 .../{video-output.txt => video-output.rst}    |  3 +-
 Documentation/watchdog/hpwdt.rst              |  2 +-
 Documentation/x86/topology.rst                |  2 +-
 Documentation/{xillybus.txt => xillybus.rst}  |  2 +
 Documentation/{xz.txt => xz.rst}              |  2 +
 Documentation/{zorro.txt => zorro.rst}        |  7 ++-
 MAINTAINERS                                   | 56 +++++++++----------
 arch/Kconfig                                  |  4 +-
 arch/arm/Kconfig                              |  2 +-
 arch/ia64/hp/common/sba_iommu.c               | 12 ++--
 arch/ia64/sn/pci/pci_dma.c                    |  4 +-
 arch/parisc/Kconfig                           |  2 +-
 arch/parisc/kernel/pci-dma.c                  |  2 +-
 arch/sh/Kconfig                               |  2 +-
 arch/sparc/Kconfig                            |  2 +-
 arch/unicore32/include/asm/io.h               |  2 +-
 arch/x86/Kconfig                              |  4 +-
 arch/x86/include/asm/dma-mapping.h            |  4 +-
 arch/x86/kernel/amd_gart_64.c                 |  2 +-
 block/partitions/Kconfig                      |  2 +-
 drivers/base/core.c                           |  2 +-
 drivers/char/Kconfig                          |  4 +-
 drivers/char/hw_random/core.c                 |  2 +-
 drivers/char/ipmi/Kconfig                     |  2 +-
 drivers/char/ipmi/ipmi_si_hotmod.c            |  2 +-
 drivers/char/ipmi/ipmi_si_intf.c              |  2 +-
 drivers/dma-buf/Kconfig                       |  2 +-
 drivers/gpio/Kconfig                          |  2 +-
 drivers/parisc/sba_iommu.c                    | 16 +++---
 drivers/pci/switch/Kconfig                    |  2 +-
 drivers/platform/x86/Kconfig                  |  4 +-
 drivers/platform/x86/dcdbas.c                 |  2 +-
 drivers/platform/x86/dell_rbu.c               |  2 +-
 drivers/pnp/isapnp/Kconfig                    |  2 +-
 drivers/vfio/Kconfig                          |  2 +-
 drivers/vfio/mdev/Kconfig                     |  2 +-
 include/asm-generic/bitops/atomic.h           |  2 +-
 include/linux/dma-mapping.h                   |  2 +-
 include/linux/hw_random.h                     |  2 +-
 include/linux/io-mapping.h                    |  2 +-
 include/linux/jump_label.h                    |  2 +-
 include/linux/kobject.h                       |  2 +-
 include/linux/kobject_ns.h                    |  2 +-
 include/linux/rbtree.h                        |  2 +-
 include/linux/rbtree_augmented.h              |  2 +-
 include/media/videobuf-dma-sg.h               |  2 +-
 init/Kconfig                                  |  2 +-
 kernel/dma/debug.c                            |  2 +-
 kernel/padata.c                               |  2 +-
 lib/Kconfig                                   |  2 +-
 lib/Kconfig.debug                             |  2 +-
 lib/crc32.c                                   |  2 +-
 lib/kobject.c                                 |  4 +-
 lib/lzo/lzo1x_decompress_safe.c               |  2 +-
 lib/xz/Kconfig                                |  2 +-
 mm/Kconfig                                    |  2 +-
 mm/nommu.c                                    |  2 +-
 samples/kprobes/kprobe_example.c              |  2 +-
 samples/kprobes/kretprobe_example.c           |  2 +-
 scripts/gcc-plugins/Kconfig                   |  2 +-
 security/Kconfig                              |  2 +-
 tools/include/linux/rbtree.h                  |  2 +-
 tools/include/linux/rbtree_augmented.h        |  2 +-
 173 files changed, 397 insertions(+), 242 deletions(-)
 rename Documentation/{DMA-API-HOWTO.txt => DMA-API-HOWTO.rst} (99%)
 rename Documentation/{DMA-API.txt => DMA-API.rst} (99%)
 rename Documentation/{DMA-ISA-LPC.txt => DMA-ISA-LPC.rst} (98%)
 rename Documentation/{DMA-attributes.txt => DMA-attributes.rst} (99%)
 rename Documentation/{IPMI.txt => IPMI.rst} (99%)
 rename Documentation/{IRQ-affinity.txt => IRQ-affinity.rst} (99%)
 rename Documentation/{IRQ-domain.txt => IRQ-domain.rst} (99%)
 rename Documentation/{IRQ.txt => IRQ.rst} (99%)
 rename Documentation/{Intel-IOMMU.txt => Intel-IOMMU.rst} (99%)
 rename Documentation/{SAK.txt => SAK.rst} (99%)
 rename Documentation/{SM501.txt => SM501.rst} (99%)
 rename Documentation/{atomic_bitops.txt => atomic_bitops.rst} (99%)
 rename Documentation/{bt8xxgpio.txt => bt8xxgpio.rst} (99%)
 rename Documentation/{btmrvl.txt => btmrvl.rst} (99%)
 rename Documentation/{bus-virt-phys-mapping.txt => bus-virt-phys-mapping.rst} (93%)
 rename Documentation/{clearing-warn-once.txt => clearing-warn-once.rst} (96%)
 rename Documentation/{cpu-load.txt => cpu-load.rst} (99%)
 rename Documentation/{cputopology.txt => cputopology.rst} (99%)
 rename Documentation/{crc32.txt => crc32.rst} (99%)
 rename Documentation/{dcdbas.txt => dcdbas.rst} (99%)
 rename Documentation/{debugging-modules.txt => debugging-modules.rst} (98%)
 rename Documentation/{debugging-via-ohci1394.txt => debugging-via-ohci1394.rst} (99%)
 rename Documentation/{dell_rbu.txt => dell_rbu.rst} (99%)
 rename Documentation/{digsig.txt => digsig.rst} (99%)
 rename Documentation/{efi-stub.txt => efi-stub.rst} (99%)
 rename Documentation/{eisa.txt => eisa.rst} (99%)
 rename Documentation/{futex-requeue-pi.txt => futex-requeue-pi.rst} (99%)
 rename Documentation/{gcc-plugins.txt => gcc-plugins.rst} (99%)
 rename Documentation/{highuid.txt => highuid.rst} (99%)
 rename Documentation/{hw_random.txt => hw_random.rst} (99%)
 rename Documentation/{hwspinlock.txt => hwspinlock.rst} (99%)
 rename Documentation/{intel_txt.txt => intel_txt.rst} (99%)
 rename Documentation/{io-mapping.txt => io-mapping.rst} (99%)
 rename Documentation/{io_ordering.txt => io_ordering.rst} (99%)
 rename Documentation/{iostats.txt => iostats.rst} (99%)
 rename Documentation/{irqflags-tracing.txt => irqflags-tracing.rst} (99%)
 rename Documentation/{isa.txt => isa.rst} (99%)
 rename Documentation/{isapnp.txt => isapnp.rst} (98%)
 rename Documentation/{kernel-per-CPU-kthreads.txt => kernel-per-CPU-kthreads.rst} (99%)
 rename Documentation/{kobject.txt => kobject.rst} (99%)
 rename Documentation/{kprobes.txt => kprobes.rst} (99%)
 rename Documentation/{kref.txt => kref.rst} (99%)
 rename Documentation/{ldm.txt => ldm.rst} (98%)
 rename Documentation/{lockup-watchdogs.txt => lockup-watchdogs.rst} (99%)
 rename Documentation/{lsm.txt => lsm.rst} (99%)
 rename Documentation/{lzo.txt => lzo.rst} (99%)
 rename Documentation/{mailbox.txt => mailbox.rst} (99%)
 rename Documentation/{men-chameleon-bus.txt => men-chameleon-bus.rst} (99%)
 rename Documentation/{nommu-mmap.txt => nommu-mmap.rst} (99%)
 rename Documentation/{ntb.txt => ntb.rst} (99%)
 rename Documentation/{numastat.txt => numastat.rst} (99%)
 rename Documentation/{padata.txt => padata.rst} (99%)
 rename Documentation/{parport-lowlevel.txt => parport-lowlevel.rst} (99%)
 rename Documentation/{percpu-rw-semaphore.txt => percpu-rw-semaphore.rst} (99%)
 rename Documentation/{phy.txt => phy.rst} (99%)
 rename Documentation/{pi-futex.txt => pi-futex.rst} (99%)
 rename Documentation/{pnp.txt => pnp.rst} (98%)
 rename Documentation/{preempt-locking.txt => preempt-locking.rst} (99%)
 rename Documentation/{pwm.txt => pwm.rst} (99%)
 rename Documentation/{rbtree.txt => rbtree.rst} (94%)
 rename Documentation/{remoteproc.txt => remoteproc.rst} (99%)
 rename Documentation/{rfkill.txt => rfkill.rst} (99%)
 rename Documentation/{robust-futex-ABI.txt => robust-futex-ABI.rst} (99%)
 rename Documentation/{robust-futexes.txt => robust-futexes.rst} (99%)
 rename Documentation/{rpmsg.txt => rpmsg.rst} (99%)
 rename Documentation/{rtc.txt => rtc.rst} (99%)
 rename Documentation/{sgi-ioc4.txt => sgi-ioc4.rst} (99%)
 rename Documentation/{siphash.txt => siphash.rst} (99%)
 rename Documentation/{smsc_ece1099.txt => smsc_ece1099.rst} (99%)
 rename Documentation/{speculation.txt => speculation.rst} (99%)
 rename Documentation/{static-keys.txt => static-keys.rst} (99%)
 rename Documentation/{svga.txt => svga.rst} (99%)
 rename Documentation/{switchtec.txt => switchtec.rst} (98%)
 rename Documentation/{sync_file.txt => sync_file.rst} (99%)
 rename Documentation/{tee.txt => tee.rst} (99%)
 rename Documentation/{this_cpu_ops.txt => this_cpu_ops.rst} (99%)
 rename Documentation/{unaligned-memory-access.txt => unaligned-memory-access.rst} (99%)
 rename Documentation/{vfio-mediated-device.txt => vfio-mediated-device.rst} (99%)
 rename Documentation/{vfio.txt => vfio.rst} (99%)
 rename Documentation/{video-output.txt => video-output.rst} (99%)
 rename Documentation/{xillybus.txt => xillybus.rst} (99%)
 rename Documentation/{xz.txt => xz.rst} (99%)
 rename Documentation/{zorro.txt => zorro.rst} (99%)

diff --git a/Documentation/ABI/removed/sysfs-class-rfkill b/Documentation/ABI/removed/sysfs-class-rfkill
index 3ce6231f20b2..1652b2381dda 100644
--- a/Documentation/ABI/removed/sysfs-class-rfkill
+++ b/Documentation/ABI/removed/sysfs-class-rfkill
@@ -1,6 +1,6 @@
 rfkill - radio frequency (RF) connector kill switch support
 
-For details to this subsystem look at Documentation/rfkill.txt.
+For details to this subsystem look at Documentation/rfkill.rst.
 
 What:		/sys/class/rfkill/rfkill[0-9]+/claim
 Date:		09-Jul-2007
diff --git a/Documentation/ABI/stable/sysfs-class-rfkill b/Documentation/ABI/stable/sysfs-class-rfkill
index 80151a409d67..68fd0afdad0d 100644
--- a/Documentation/ABI/stable/sysfs-class-rfkill
+++ b/Documentation/ABI/stable/sysfs-class-rfkill
@@ -1,6 +1,6 @@
 rfkill - radio frequency (RF) connector kill switch support
 
-For details to this subsystem look at Documentation/rfkill.txt.
+For details to this subsystem look at Documentation/rfkill.rst.
 
 For the deprecated /sys/class/rfkill/*/claim knobs of this interface look in
 Documentation/ABI/removed/sysfs-class-rfkill.
diff --git a/Documentation/ABI/stable/sysfs-devices-node b/Documentation/ABI/stable/sysfs-devices-node
index f7ce68fbd4b9..de1d022c0864 100644
--- a/Documentation/ABI/stable/sysfs-devices-node
+++ b/Documentation/ABI/stable/sysfs-devices-node
@@ -61,7 +61,7 @@ Date:		October 2002
 Contact:	Linux Memory Management list <linux-mm@kvack.org>
 Description:
 		The node's hit/miss statistics, in units of pages.
-		See Documentation/numastat.txt
+		See Documentation/numastat.rst
 
 What:		/sys/devices/system/node/nodeX/distance
 Date:		October 2002
diff --git a/Documentation/ABI/testing/procfs-diskstats b/Documentation/ABI/testing/procfs-diskstats
index abac31d216de..26661dd5188b 100644
--- a/Documentation/ABI/testing/procfs-diskstats
+++ b/Documentation/ABI/testing/procfs-diskstats
@@ -29,4 +29,4 @@ Description:
 		17 - sectors discarded
 		18 - time spent discarding
 
-		For more details refer to Documentation/iostats.txt
+		For more details refer to Documentation/iostats.rst
diff --git a/Documentation/ABI/testing/sysfs-block b/Documentation/ABI/testing/sysfs-block
index dfad7427817c..d300a6b9d17c 100644
--- a/Documentation/ABI/testing/sysfs-block
+++ b/Documentation/ABI/testing/sysfs-block
@@ -15,7 +15,7 @@ Description:
 		 9 - I/Os currently in progress
 		10 - time spent doing I/Os (ms)
 		11 - weighted time spent doing I/Os (ms)
-		For more details refer Documentation/iostats.txt
+		For more details refer Documentation/iostats.rst
 
 
 What:		/sys/block/<disk>/<part>/stat
diff --git a/Documentation/ABI/testing/sysfs-class-switchtec b/Documentation/ABI/testing/sysfs-class-switchtec
index 48cb4c15e430..c8d80db1e32c 100644
--- a/Documentation/ABI/testing/sysfs-class-switchtec
+++ b/Documentation/ABI/testing/sysfs-class-switchtec
@@ -1,6 +1,6 @@
 switchtec - Microsemi Switchtec PCI Switch Management Endpoint
 
-For details on this subsystem look at Documentation/switchtec.txt.
+For details on this subsystem look at Documentation/switchtec.rst.
 
 What: 		/sys/class/switchtec
 Date:		05-Jan-2017
diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index 87478ac6c2af..1a2653f5261f 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -34,7 +34,7 @@ Description:	CPU topology files that describe kernel limits related to
 		present: cpus that have been identified as being present in
 		the system.
 
-		See Documentation/cputopology.txt for more information.
+		See Documentation/cputopology.rst for more information.
 
 
 What:		/sys/devices/system/cpu/probe
@@ -103,7 +103,7 @@ Description:	CPU topology files that describe a logical CPU's relationship
 		thread_siblings_list: human-readable list of cpu#'s hardware
 		threads within the same core as cpu#
 
-		See Documentation/cputopology.txt for more information.
+		See Documentation/cputopology.rst for more information.
 
 
 What:		/sys/devices/system/cpu/cpuidle/current_driver
diff --git a/Documentation/DMA-API-HOWTO.txt b/Documentation/DMA-API-HOWTO.rst
similarity index 99%
rename from Documentation/DMA-API-HOWTO.txt
rename to Documentation/DMA-API-HOWTO.rst
index 358d495456d1..db9f8fcebe1f 100644
--- a/Documentation/DMA-API-HOWTO.txt
+++ b/Documentation/DMA-API-HOWTO.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 =========================
 Dynamic DMA mapping Guide
 =========================
diff --git a/Documentation/DMA-API.txt b/Documentation/DMA-API.rst
similarity index 99%
rename from Documentation/DMA-API.txt
rename to Documentation/DMA-API.rst
index e47c63bd4887..2f26857f97ff 100644
--- a/Documentation/DMA-API.txt
+++ b/Documentation/DMA-API.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ============================================
 Dynamic DMA mapping using the generic device
 ============================================
@@ -5,7 +7,7 @@ Dynamic DMA mapping using the generic device
 :Author: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
 
 This document describes the DMA API.  For a more gentle introduction
-of the API (and actual examples), see Documentation/DMA-API-HOWTO.txt.
+of the API (and actual examples), see Documentation/DMA-API-HOWTO.rst.
 
 This API is split into two pieces.  Part I describes the basic API.
 Part II describes extensions for supporting non-consistent memory
@@ -463,7 +465,7 @@ without the _attrs suffixes, except that they pass an optional
 dma_attrs.
 
 The interpretation of DMA attributes is architecture-specific, and
-each attribute should be documented in Documentation/DMA-attributes.txt.
+each attribute should be documented in Documentation/DMA-attributes.rst.
 
 If dma_attrs are 0, the semantics of each of these functions
 is identical to those of the corresponding function
@@ -476,7 +478,7 @@ for DMA::
 
 	#include <linux/dma-mapping.h>
 	/* DMA_ATTR_FOO should be defined in linux/dma-mapping.h and
-	* documented in Documentation/DMA-attributes.txt */
+	* documented in Documentation/DMA-attributes.rst */
 	...
 
 		unsigned long attr;
diff --git a/Documentation/DMA-ISA-LPC.txt b/Documentation/DMA-ISA-LPC.rst
similarity index 98%
rename from Documentation/DMA-ISA-LPC.txt
rename to Documentation/DMA-ISA-LPC.rst
index b1ec7b16c21f..205a379c2d62 100644
--- a/Documentation/DMA-ISA-LPC.txt
+++ b/Documentation/DMA-ISA-LPC.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ============================
 DMA with ISA and LPC devices
 ============================
@@ -17,7 +19,7 @@ To do ISA style DMA you need to include two headers::
 	#include <asm/dma.h>
 
 The first is the generic DMA API used to convert virtual addresses to
-bus addresses (see Documentation/DMA-API.txt for details).
+bus addresses (see Documentation/DMA-API.rst for details).
 
 The second contains the routines specific to ISA DMA transfers. Since
 this is not present on all platforms make sure you construct your
diff --git a/Documentation/DMA-attributes.txt b/Documentation/DMA-attributes.rst
similarity index 99%
rename from Documentation/DMA-attributes.txt
rename to Documentation/DMA-attributes.rst
index 8f8d97f65d73..471c5c38f9d9 100644
--- a/Documentation/DMA-attributes.txt
+++ b/Documentation/DMA-attributes.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ==============
 DMA attributes
 ==============
diff --git a/Documentation/IPMI.txt b/Documentation/IPMI.rst
similarity index 99%
rename from Documentation/IPMI.txt
rename to Documentation/IPMI.rst
index 5ef1047e2e66..f6c2d11710fe 100644
--- a/Documentation/IPMI.txt
+++ b/Documentation/IPMI.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 =====================
 The Linux IPMI Driver
 =====================
diff --git a/Documentation/IRQ-affinity.txt b/Documentation/IRQ-affinity.rst
similarity index 99%
rename from Documentation/IRQ-affinity.txt
rename to Documentation/IRQ-affinity.rst
index 29da5000836a..49ba271349d6 100644
--- a/Documentation/IRQ-affinity.txt
+++ b/Documentation/IRQ-affinity.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ================
 SMP IRQ affinity
 ================
diff --git a/Documentation/IRQ-domain.txt b/Documentation/IRQ-domain.rst
similarity index 99%
rename from Documentation/IRQ-domain.txt
rename to Documentation/IRQ-domain.rst
index 507775cce753..a610a8ea9a92 100644
--- a/Documentation/IRQ-domain.txt
+++ b/Documentation/IRQ-domain.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ===============================================
 The irq_domain interrupt number mapping library
 ===============================================
diff --git a/Documentation/IRQ.txt b/Documentation/IRQ.rst
similarity index 99%
rename from Documentation/IRQ.txt
rename to Documentation/IRQ.rst
index 4273806a606b..a9f3e192c2cb 100644
--- a/Documentation/IRQ.txt
+++ b/Documentation/IRQ.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ===============
 What is an IRQ?
 ===============
diff --git a/Documentation/Intel-IOMMU.txt b/Documentation/Intel-IOMMU.rst
similarity index 99%
rename from Documentation/Intel-IOMMU.txt
rename to Documentation/Intel-IOMMU.rst
index 9dae6b47e398..b001104c25c8 100644
--- a/Documentation/Intel-IOMMU.txt
+++ b/Documentation/Intel-IOMMU.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ===================
 Linux IOMMU Support
 ===================
diff --git a/Documentation/PCI/pci.rst b/Documentation/PCI/pci.rst
index 6864f9a70f5f..840cbf5f37a7 100644
--- a/Documentation/PCI/pci.rst
+++ b/Documentation/PCI/pci.rst
@@ -239,7 +239,7 @@ from the PCI device config space. Use the values in the pci_dev structure
 as the PCI "bus address" might have been remapped to a "host physical"
 address by the arch/chip-set specific kernel support.
 
-See Documentation/io-mapping.txt for how to access device registers
+See Documentation/io-mapping.rst for how to access device registers
 or device memory.
 
 The device driver needs to call pci_request_region() to verify
@@ -265,7 +265,7 @@ Set the DMA mask size
 ---------------------
 .. note::
    If anything below doesn't make sense, please refer to
-   Documentation/DMA-API.txt. This section is just a reminder that
+   Documentation/DMA-API.rst. This section is just a reminder that
    drivers need to indicate DMA capabilities of the device and is not
    an authoritative source for DMA interfaces.
 
@@ -291,7 +291,7 @@ Many 64-bit "PCI" devices (before PCI-X) and some PCI-X devices are
 Setup shared control data
 -------------------------
 Once the DMA masks are set, the driver can allocate "consistent" (a.k.a. shared)
-memory.  See Documentation/DMA-API.txt for a full description of
+memory.  See Documentation/DMA-API.rst for a full description of
 the DMA APIs. This section is just a reminder that it needs to be done
 before enabling DMA on the device.
 
@@ -421,7 +421,7 @@ owners if there is one.
 
 Then clean up "consistent" buffers which contain the control data.
 
-See Documentation/DMA-API.txt for details on unmapping interfaces.
+See Documentation/DMA-API.rst for details on unmapping interfaces.
 
 
 Unregister from other subsystems
diff --git a/Documentation/SAK.txt b/Documentation/SAK.rst
similarity index 99%
rename from Documentation/SAK.txt
rename to Documentation/SAK.rst
index 260e1d3687bd..73dd10fa4337 100644
--- a/Documentation/SAK.txt
+++ b/Documentation/SAK.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 =========================================
 Linux Secure Attention Key (SAK) handling
 =========================================
@@ -88,4 +90,3 @@ And that's it!  Only the superuser may reprogram the SAK key.
      /dev/console.  So SAK kills them all.  A workaround is to simply
      delete these lines, but this may cause system management
      applications to malfunction - test everything well.
-
diff --git a/Documentation/SM501.txt b/Documentation/SM501.rst
similarity index 99%
rename from Documentation/SM501.txt
rename to Documentation/SM501.rst
index 882507453ba4..772a9b5c7d49 100644
--- a/Documentation/SM501.txt
+++ b/Documentation/SM501.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 .. include:: <isonum.txt>
 
 ============
diff --git a/Documentation/admin-guide/hw-vuln/l1tf.rst b/Documentation/admin-guide/hw-vuln/l1tf.rst
index 656aee262e23..5668fc2013ce 100644
--- a/Documentation/admin-guide/hw-vuln/l1tf.rst
+++ b/Documentation/admin-guide/hw-vuln/l1tf.rst
@@ -268,7 +268,7 @@ Guest mitigation mechanisms
    /proc/irq/$NR/smp_affinity[_list] files. Limited documentation is
    available at:
 
-   https://www.kernel.org/doc/Documentation/IRQ-affinity.txt
+   https://www.kernel.org/doc/Documentation/IRQ-affinity.rst
 
 .. _smt_control:
 
diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 7abe677f8c5e..873062810484 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3162,7 +3162,7 @@
 			See Documentation/sysctl/vm.txt for details.
 
 	ohci1394_dma=early	[HW] enable debugging via the ohci1394 driver.
-			See Documentation/debugging-via-ohci1394.txt for more
+			See Documentation/debugging-via-ohci1394.rst for more
 			info.
 
 	olpc_ec_timeout= [OLPC] ms delay when issuing EC commands
@@ -5075,7 +5075,7 @@
 
 	vga=		[BOOT,X86-32] Select a particular video mode
 			See Documentation/x86/boot.rst and
-			Documentation/svga.txt.
+			Documentation/svga.rst.
 			Use vga=ask for menu.
 			This is actually a boot loader parameter; the value is
 			passed to the kernel using a special protocol.
diff --git a/Documentation/atomic_bitops.txt b/Documentation/atomic_bitops.rst
similarity index 99%
rename from Documentation/atomic_bitops.txt
rename to Documentation/atomic_bitops.rst
index 093cdaefdb37..b683bcb71185 100644
--- a/Documentation/atomic_bitops.txt
+++ b/Documentation/atomic_bitops.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 =============
 Atomic bitops
 =============
@@ -68,4 +70,3 @@ clear_bit_unlock() which has RELEASE semantics.
 
 Since a platform only has a single means of achieving atomic operations
 the same barriers as for atomic_t are used, see atomic_t.txt.
-
diff --git a/Documentation/block/biodoc.txt b/Documentation/block/biodoc.txt
index ac18b488cb5e..ac504de0cb93 100644
--- a/Documentation/block/biodoc.txt
+++ b/Documentation/block/biodoc.txt
@@ -184,7 +184,7 @@ a virtual address mapping (unlike the earlier scheme of virtual address
 do not have a corresponding kernel virtual address space mapping) and
 low-memory pages.
 
-Note: Please refer to Documentation/DMA-API-HOWTO.txt for a discussion
+Note: Please refer to Documentation/DMA-API-HOWTO.rst for a discussion
 on PCI high mem DMA aspects and mapping of scatter gather lists, and support
 for 64 bit PCI.
 
diff --git a/Documentation/bt8xxgpio.txt b/Documentation/bt8xxgpio.rst
similarity index 99%
rename from Documentation/bt8xxgpio.txt
rename to Documentation/bt8xxgpio.rst
index a845feb074de..093875e1b0aa 100644
--- a/Documentation/bt8xxgpio.txt
+++ b/Documentation/bt8xxgpio.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ===================================================================
 A driver for a selfmade cheap BT8xx based PCI GPIO-card (bt8xxgpio)
 ===================================================================
@@ -59,4 +61,3 @@ The GPIO pins are marked with G00-G23::
            | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | |
            ^
            This is pin 1
-
diff --git a/Documentation/btmrvl.txt b/Documentation/btmrvl.rst
similarity index 99%
rename from Documentation/btmrvl.txt
rename to Documentation/btmrvl.rst
index ec57740ead0c..e6dd1c96e842 100644
--- a/Documentation/btmrvl.txt
+++ b/Documentation/btmrvl.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 =============
 btmrvl driver
 =============
diff --git a/Documentation/bus-virt-phys-mapping.txt b/Documentation/bus-virt-phys-mapping.rst
similarity index 93%
rename from Documentation/bus-virt-phys-mapping.txt
rename to Documentation/bus-virt-phys-mapping.rst
index 4bb07c2f3e7d..eefb0ae99ba8 100644
--- a/Documentation/bus-virt-phys-mapping.txt
+++ b/Documentation/bus-virt-phys-mapping.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ==========================================================
 How to access I/O mapped memory from within device drivers
 ==========================================================
@@ -8,7 +10,7 @@ How to access I/O mapped memory from within device drivers
 
 	The virt_to_bus() and bus_to_virt() functions have been
 	superseded by the functionality provided by the PCI DMA interface
-	(see Documentation/DMA-API-HOWTO.txt).  They continue
+	(see Documentation/DMA-API-HOWTO.rst).  They continue
 	to be documented below for historical purposes, but new code
 	must not use them. --davidm 00/12/12
 
@@ -19,35 +21,35 @@ How to access I/O mapped memory from within device drivers
 
 The AHA-1542 is a bus-master device, and your patch makes the driver give the
 controller the physical address of the buffers, which is correct on x86
-(because all bus master devices see the physical memory mappings directly). 
+(because all bus master devices see the physical memory mappings directly).
 
 However, on many setups, there are actually **three** different ways of looking
 at memory addresses, and in this case we actually want the third, the
-so-called "bus address". 
+so-called "bus address".
 
 Essentially, the three ways of addressing memory are (this is "real memory",
-that is, normal RAM--see later about other details): 
+that is, normal RAM--see later about other details):
 
- - CPU untranslated.  This is the "physical" address.  Physical address 
+ - CPU untranslated.  This is the "physical" address.  Physical address
    0 is what the CPU sees when it drives zeroes on the memory bus.
 
- - CPU translated address. This is the "virtual" address, and is 
+ - CPU translated address. This is the "virtual" address, and is
    completely internal to the CPU itself with the CPU doing the appropriate
-   translations into "CPU untranslated". 
+   translations into "CPU untranslated".
 
- - bus address. This is the address of memory as seen by OTHER devices, 
-   not the CPU. Now, in theory there could be many different bus 
+ - bus address. This is the address of memory as seen by OTHER devices,
+   not the CPU. Now, in theory there could be many different bus
    addresses, with each device seeing memory in some device-specific way, but
    happily most hardware designers aren't actually actively trying to make
-   things any more complex than necessary, so you can assume that all 
-   external hardware sees the memory the same way. 
+   things any more complex than necessary, so you can assume that all
+   external hardware sees the memory the same way.
 
 Now, on normal PCs the bus address is exactly the same as the physical
 address, and things are very simple indeed. However, they are that simple
 because the memory and the devices share the same address space, and that is
-not generally necessarily true on other PCI/ISA setups. 
+not generally necessarily true on other PCI/ISA setups.
 
-Now, just as an example, on the PReP (PowerPC Reference Platform), the 
+Now, just as an example, on the PReP (PowerPC Reference Platform), the
 CPU sees a memory map something like this (this is from memory)::
 
 	0-2 GB		"real memory"
@@ -58,17 +60,17 @@ Now, that looks simple enough. However, when you look at the same thing from
 the viewpoint of the devices, you have the reverse, and the physical memory
 address 0 actually shows up as address 2 GB for any IO master.
 
-So when the CPU wants any bus master to write to physical memory 0, it 
+So when the CPU wants any bus master to write to physical memory 0, it
 has to give the master address 0x80000000 as the memory address.
 
-So, for example, depending on how the kernel is actually mapped on the 
+So, for example, depending on how the kernel is actually mapped on the
 PPC, you can end up with a setup like this::
 
  physical address:	0
  virtual address:	0xC0000000
  bus address:		0x80000000
 
-where all the addresses actually point to the same thing.  It's just seen 
+where all the addresses actually point to the same thing.  It's just seen
 through different translations..
 
 Similarly, on the Alpha, the normal translation is::
@@ -78,7 +80,7 @@ Similarly, on the Alpha, the normal translation is::
  bus address:		0x40000000
 
 (but there are also Alphas where the physical address and the bus address
-are the same). 
+are the same).
 
 Anyway, the way to look up all these translations, you do::
 
@@ -113,7 +115,7 @@ pointer from the kernel. So you can have something like this::
 			case STATUS_OK:
 				...
 
-on the other hand, you want the bus address when you have a buffer that 
+on the other hand, you want the bus address when you have a buffer that
 you want to give to the controller::
 
 	/* ask the controller to read the sense status into "sense_buffer" */
@@ -124,7 +126,7 @@ you want to give to the controller::
 
 And you generally **never** want to use the physical address, because you can't
 use that from the CPU (the CPU only uses translated virtual addresses), and
-you can't use it from the bus master. 
+you can't use it from the bus master.
 
 So why do we care about the physical address at all? We do need the physical
 address in some cases, it's just not very often in normal code.  The physical
@@ -142,7 +144,7 @@ shouldn't need to know about "bus addresses" etc).
 There is a completely different type of memory too, and that's the "shared
 memory" on the PCI or ISA bus. That's generally not RAM (although in the case
 of a video graphics card it can be normal DRAM that is just used for a frame
-buffer), but can be things like a packet buffer in a network card etc. 
+buffer), but can be things like a packet buffer in a network card etc.
 
 This memory is called "PCI memory" or "shared memory" or "IO memory" or
 whatever, and there is only one way to access it: the readb/writeb and
@@ -151,7 +153,7 @@ there is really nothing you can do with such an address: it's not
 conceptually in the same memory space as "real memory" at all, so you cannot
 just dereference a pointer. (Sadly, on x86 it **is** in the same memory space,
 so on x86 it actually works to just deference a pointer, but it's not
-portable). 
+portable).
 
 For such memory, you can do things like:
 
@@ -197,19 +199,19 @@ Note that kernel versions 2.0.x (and earlier) mistakenly called the
 ioremap() function "vremap()".  ioremap() is the proper name, but I
 didn't think straight when I wrote it originally.  People who have to
 support both can do something like::
- 
+
 	/* support old naming silliness */
 	#if LINUX_VERSION_CODE < 0x020100
 	#define ioremap vremap
-	#define iounmap vfree                                                     
+	#define iounmap vfree
 	#endif
- 
+
 at the top of their source files, and then they can use the right names
-even on 2.0.x systems. 
+even on 2.0.x systems.
 
 And the above sounds worse than it really is.  Most real drivers really
 don't do all that complex things (or rather: the complexity is not so
-much in the actual IO accesses as in error handling and timeouts etc). 
+much in the actual IO accesses as in error handling and timeouts etc).
 It's generally not hard to fix drivers, and in many cases the code
 actually looks better afterwards::
 
diff --git a/Documentation/clearing-warn-once.txt b/Documentation/clearing-warn-once.rst
similarity index 96%
rename from Documentation/clearing-warn-once.txt
rename to Documentation/clearing-warn-once.rst
index 211fd926cf00..cdfa892c7fdf 100644
--- a/Documentation/clearing-warn-once.txt
+++ b/Documentation/clearing-warn-once.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 Clearing WARN_ONCE
 ------------------
 
diff --git a/Documentation/cpu-load.txt b/Documentation/cpu-load.rst
similarity index 99%
rename from Documentation/cpu-load.txt
rename to Documentation/cpu-load.rst
index 2d01ce43d2a2..6b2815b78683 100644
--- a/Documentation/cpu-load.txt
+++ b/Documentation/cpu-load.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ========
 CPU load
 ========
diff --git a/Documentation/cputopology.txt b/Documentation/cputopology.rst
similarity index 99%
rename from Documentation/cputopology.txt
rename to Documentation/cputopology.rst
index b90dafcc8237..ef1e6b105957 100644
--- a/Documentation/cputopology.txt
+++ b/Documentation/cputopology.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ===========================================
 How CPU topology info is exported via sysfs
 ===========================================
diff --git a/Documentation/crc32.txt b/Documentation/crc32.rst
similarity index 99%
rename from Documentation/crc32.txt
rename to Documentation/crc32.rst
index 8a6860f33b4e..f7c73d713a35 100644
--- a/Documentation/crc32.txt
+++ b/Documentation/crc32.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 =================================
 brief tutorial on CRC computation
 =================================
diff --git a/Documentation/dcdbas.txt b/Documentation/dcdbas.rst
similarity index 99%
rename from Documentation/dcdbas.txt
rename to Documentation/dcdbas.rst
index 309cc57a7c1c..abbc2bfd58a7 100644
--- a/Documentation/dcdbas.txt
+++ b/Documentation/dcdbas.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ===================================
 Dell Systems Management Base Driver
 ===================================
diff --git a/Documentation/debugging-modules.txt b/Documentation/debugging-modules.rst
similarity index 98%
rename from Documentation/debugging-modules.txt
rename to Documentation/debugging-modules.rst
index 172ad4aec493..994f4b021a81 100644
--- a/Documentation/debugging-modules.txt
+++ b/Documentation/debugging-modules.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 Debugging Modules after 2.6.3
 -----------------------------
 
diff --git a/Documentation/debugging-via-ohci1394.txt b/Documentation/debugging-via-ohci1394.rst
similarity index 99%
rename from Documentation/debugging-via-ohci1394.txt
rename to Documentation/debugging-via-ohci1394.rst
index 981ad4f89fd3..ead0196d94b7 100644
--- a/Documentation/debugging-via-ohci1394.txt
+++ b/Documentation/debugging-via-ohci1394.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ===========================================================================
 Using physical DMA provided by OHCI-1394 FireWire controllers for debugging
 ===========================================================================
diff --git a/Documentation/dell_rbu.txt b/Documentation/dell_rbu.rst
similarity index 99%
rename from Documentation/dell_rbu.txt
rename to Documentation/dell_rbu.rst
index 5d1ce7bcd04d..45cd18abd98f 100644
--- a/Documentation/dell_rbu.txt
+++ b/Documentation/dell_rbu.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 =============================================================
 Usage of the new open sourced rbu (Remote BIOS Update) driver
 =============================================================
@@ -125,4 +127,3 @@ read back the image downloaded.
    code which sends the BIOS update request to the BIOS. So on the next reboot
    the BIOS knows about the new image downloaded and it updates itself.
    Also don't unload the rbu driver if the image has to be updated.
-
diff --git a/Documentation/device-mapper/statistics.rst b/Documentation/device-mapper/statistics.rst
index 3d80a9f850cc..39f74af35abb 100644
--- a/Documentation/device-mapper/statistics.rst
+++ b/Documentation/device-mapper/statistics.rst
@@ -13,7 +13,7 @@ the range specified.
 
 The I/O statistics counters for each step-sized area of a region are
 in the same format as `/sys/block/*/stat` or `/proc/diskstats` (see:
-Documentation/iostats.txt).  But two extra counters (12 and 13) are
+Documentation/iostats.rst).  But two extra counters (12 and 13) are
 provided: total time spent reading and writing.  When the histogram
 argument is used, the 14th parameter is reported that represents the
 histogram of latencies.  All these counters may be accessed by sending
@@ -151,7 +151,7 @@ Messages
 	  The first 11 counters have the same meaning as
 	  `/sys/block/*/stat or /proc/diskstats`.
 
-	  Please refer to Documentation/iostats.txt for details.
+	  Please refer to Documentation/iostats.rst for details.
 
 	  1. the number of reads completed
 	  2. the number of reads merged
diff --git a/Documentation/devicetree/bindings/phy/phy-bindings.txt b/Documentation/devicetree/bindings/phy/phy-bindings.txt
index a403b81d0679..5e2a53bcba0e 100644
--- a/Documentation/devicetree/bindings/phy/phy-bindings.txt
+++ b/Documentation/devicetree/bindings/phy/phy-bindings.txt
@@ -1,5 +1,5 @@
 This document explains only the device tree data binding. For general
-information about PHY subsystem refer to Documentation/phy.txt
+information about PHY subsystem refer to Documentation/phy.rst
 
 PHY device node
 ===============
diff --git a/Documentation/digsig.txt b/Documentation/digsig.rst
similarity index 99%
rename from Documentation/digsig.txt
rename to Documentation/digsig.rst
index f6a8902d3ef7..3597711d0df1 100644
--- a/Documentation/digsig.txt
+++ b/Documentation/digsig.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ==================================
 Digital Signature Verification API
 ==================================
diff --git a/Documentation/driver-api/usb/dma.rst b/Documentation/driver-api/usb/dma.rst
index 59d5aee89e37..12955a77c7fe 100644
--- a/Documentation/driver-api/usb/dma.rst
+++ b/Documentation/driver-api/usb/dma.rst
@@ -10,7 +10,7 @@ API overview
 
 The big picture is that USB drivers can continue to ignore most DMA issues,
 though they still must provide DMA-ready buffers (see
-``Documentation/DMA-API-HOWTO.txt``).  That's how they've worked through
+``Documentation/DMA-API-HOWTO.rst``).  That's how they've worked through
 the 2.4 (and earlier) kernels, or they can now be DMA-aware.
 
 DMA-aware usb drivers:
@@ -60,7 +60,7 @@ and effects like cache-trashing can impose subtle penalties.
   force a consistent memory access ordering by using memory barriers.  It's
   not using a streaming DMA mapping, so it's good for small transfers on
   systems where the I/O would otherwise thrash an IOMMU mapping.  (See
-  ``Documentation/DMA-API-HOWTO.txt`` for definitions of "coherent" and
+  ``Documentation/DMA-API-HOWTO.rst`` for definitions of "coherent" and
   "streaming" DMA mappings.)
 
   Asking for 1/Nth of a page (as well as asking for N pages) is reasonably
@@ -91,7 +91,7 @@ Working with existing buffers
 Existing buffers aren't usable for DMA without first being mapped into the
 DMA address space of the device.  However, most buffers passed to your
 driver can safely be used with such DMA mapping.  (See the first section
-of Documentation/DMA-API-HOWTO.txt, titled "What memory is DMA-able?")
+of Documentation/DMA-API-HOWTO.rst, titled "What memory is DMA-able?")
 
 - When you're using scatterlists, you can map everything at once.  On some
   systems, this kicks in an IOMMU and turns the scatterlists into single
diff --git a/Documentation/driver-model/device.rst b/Documentation/driver-model/device.rst
index 2b868d49d349..17bcc483c4b1 100644
--- a/Documentation/driver-model/device.rst
+++ b/Documentation/driver-model/device.rst
@@ -53,7 +53,7 @@ Attributes of devices can be exported by a device driver through sysfs.
 Please see Documentation/filesystems/sysfs.txt for more information
 on how sysfs works.
 
-As explained in Documentation/kobject.txt, device attributes must be
+As explained in Documentation/kobject.rst, device attributes must be
 created before the KOBJ_ADD uevent is generated. The only way to realize
 that is by defining an attribute group.
 
diff --git a/Documentation/efi-stub.txt b/Documentation/efi-stub.rst
similarity index 99%
rename from Documentation/efi-stub.txt
rename to Documentation/efi-stub.rst
index 833edb0d0bc4..29256cad8af3 100644
--- a/Documentation/efi-stub.txt
+++ b/Documentation/efi-stub.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 =================
 The EFI Boot Stub
 =================
diff --git a/Documentation/eisa.txt b/Documentation/eisa.rst
similarity index 99%
rename from Documentation/eisa.txt
rename to Documentation/eisa.rst
index f388545a85a7..d98949908405 100644
--- a/Documentation/eisa.txt
+++ b/Documentation/eisa.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ================
 EISA bus support
 ================
diff --git a/Documentation/fb/vesafb.rst b/Documentation/fb/vesafb.rst
index 2ed0dfb661cf..a0b658091b07 100644
--- a/Documentation/fb/vesafb.rst
+++ b/Documentation/fb/vesafb.rst
@@ -30,7 +30,7 @@ How to use it?
 ==============
 
 Switching modes is done using the vga=... boot parameter.  Read
-Documentation/svga.txt for details.
+Documentation/svga.rst for details.
 
 You should compile in both vgacon (for text mode) and vesafb (for
 graphics mode). Which of them takes over the console depends on
diff --git a/Documentation/filesystems/sysfs.txt b/Documentation/filesystems/sysfs.txt
index 5b5311f9358d..d159826c5cf3 100644
--- a/Documentation/filesystems/sysfs.txt
+++ b/Documentation/filesystems/sysfs.txt
@@ -16,7 +16,7 @@ a means to export kernel data structures, their attributes, and the
 linkages between them to userspace. 
 
 sysfs is tied inherently to the kobject infrastructure. Please read
-Documentation/kobject.txt for more information concerning the kobject
+Documentation/kobject.rst for more information concerning the kobject
 interface. 
 
 
diff --git a/Documentation/futex-requeue-pi.txt b/Documentation/futex-requeue-pi.rst
similarity index 99%
rename from Documentation/futex-requeue-pi.txt
rename to Documentation/futex-requeue-pi.rst
index 14ab5787b9a7..a90dbff26629 100644
--- a/Documentation/futex-requeue-pi.txt
+++ b/Documentation/futex-requeue-pi.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ================
 Futex Requeue PI
 ================
diff --git a/Documentation/gcc-plugins.txt b/Documentation/gcc-plugins.rst
similarity index 99%
rename from Documentation/gcc-plugins.txt
rename to Documentation/gcc-plugins.rst
index 8502f24396fb..e08d013c6de2 100644
--- a/Documentation/gcc-plugins.txt
+++ b/Documentation/gcc-plugins.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 =========================
 GCC plugin infrastructure
 =========================
diff --git a/Documentation/gpu/drm-mm.rst b/Documentation/gpu/drm-mm.rst
index c8ebd4f66a6a..fa30dfcfc3c8 100644
--- a/Documentation/gpu/drm-mm.rst
+++ b/Documentation/gpu/drm-mm.rst
@@ -320,7 +320,7 @@ struct :c:type:`struct file_operations <file_operations>` get_unmapped_area
 field with a pointer on :c:func:`drm_gem_cma_get_unmapped_area`.
 
 More detailed information about get_unmapped_area can be found in
-Documentation/nommu-mmap.txt
+Documentation/nommu-mmap.rst
 
 Memory Coherency
 ----------------
diff --git a/Documentation/highuid.txt b/Documentation/highuid.rst
similarity index 99%
rename from Documentation/highuid.txt
rename to Documentation/highuid.rst
index 6ee70465c0ea..d1cbc71a59a2 100644
--- a/Documentation/highuid.txt
+++ b/Documentation/highuid.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ===================================================
 Notes on the change from 16-bit UIDs to 32-bit UIDs
 ===================================================
@@ -19,7 +21,7 @@ What's left to be done for 32-bit UIDs on all Linux architectures:
   underlying filesystem, because quota records are written at offsets
   corresponding to the UID in question.
   Further investigation is needed to see if the quota system can cope
-  properly with huge UIDs. If it can deal with 64-bit file offsets on all 
+  properly with huge UIDs. If it can deal with 64-bit file offsets on all
   architectures, this should not be a problem.
 
 - Decide whether or not to keep backwards compatibility with the system
diff --git a/Documentation/hw_random.txt b/Documentation/hw_random.rst
similarity index 99%
rename from Documentation/hw_random.txt
rename to Documentation/hw_random.rst
index 121de96e395e..fb5e32fae384 100644
--- a/Documentation/hw_random.txt
+++ b/Documentation/hw_random.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ==========================================================
 Linux support for random number generator in i8xx chipsets
 ==========================================================
diff --git a/Documentation/hwspinlock.txt b/Documentation/hwspinlock.rst
similarity index 99%
rename from Documentation/hwspinlock.txt
rename to Documentation/hwspinlock.rst
index ed640a278185..68297473647c 100644
--- a/Documentation/hwspinlock.txt
+++ b/Documentation/hwspinlock.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ===========================
 Hardware Spinlock Framework
 ===========================
diff --git a/Documentation/ia64/irq-redir.rst b/Documentation/ia64/irq-redir.rst
index 39bf94484a15..0abc7b35f6c0 100644
--- a/Documentation/ia64/irq-redir.rst
+++ b/Documentation/ia64/irq-redir.rst
@@ -7,7 +7,7 @@ IRQ affinity on IA64 platforms
 
 By writing to /proc/irq/IRQ#/smp_affinity the interrupt routing can be
 controlled. The behavior on IA64 platforms is slightly different from
-that described in Documentation/IRQ-affinity.txt for i386 systems.
+that described in Documentation/IRQ-affinity.rst for i386 systems.
 
 Because of the usage of SAPIC mode and physical destination mode the
 IRQ target is one particular CPU and cannot be a mask of several
diff --git a/Documentation/intel_txt.txt b/Documentation/intel_txt.rst
similarity index 99%
rename from Documentation/intel_txt.txt
rename to Documentation/intel_txt.rst
index d83c1a2122c9..5a55007ecf08 100644
--- a/Documentation/intel_txt.txt
+++ b/Documentation/intel_txt.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 =====================
 Intel(R) TXT Overview
 =====================
diff --git a/Documentation/io-mapping.txt b/Documentation/io-mapping.rst
similarity index 99%
rename from Documentation/io-mapping.txt
rename to Documentation/io-mapping.rst
index a966239f04e4..82a2cacf9a29 100644
--- a/Documentation/io-mapping.txt
+++ b/Documentation/io-mapping.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ========================
 The io_mapping functions
 ========================
diff --git a/Documentation/io_ordering.txt b/Documentation/io_ordering.rst
similarity index 99%
rename from Documentation/io_ordering.txt
rename to Documentation/io_ordering.rst
index 2ab303ce9a0d..18ef889c100e 100644
--- a/Documentation/io_ordering.txt
+++ b/Documentation/io_ordering.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ==============================================
 Ordering I/O writes to memory-mapped addresses
 ==============================================
diff --git a/Documentation/iostats.txt b/Documentation/iostats.rst
similarity index 99%
rename from Documentation/iostats.txt
rename to Documentation/iostats.rst
index 5d63b18bd6d1..f4d37d812c30 100644
--- a/Documentation/iostats.txt
+++ b/Documentation/iostats.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 =====================
 I/O statistics fields
 =====================
diff --git a/Documentation/irqflags-tracing.txt b/Documentation/irqflags-tracing.rst
similarity index 99%
rename from Documentation/irqflags-tracing.txt
rename to Documentation/irqflags-tracing.rst
index bdd208259fb3..a2fbbb1a62b9 100644
--- a/Documentation/irqflags-tracing.txt
+++ b/Documentation/irqflags-tracing.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 =======================
 IRQ-flags state tracing
 =======================
@@ -49,4 +51,3 @@ turn itself off. I.e. the lock validator will still be reliable. There
 should be no crashes due to irq-tracing bugs. (except if the assembly
 changes break other code by modifying conditions or registers that
 shouldn't be)
-
diff --git a/Documentation/isa.txt b/Documentation/isa.rst
similarity index 99%
rename from Documentation/isa.txt
rename to Documentation/isa.rst
index def4a7b690b5..f3a412d266b0 100644
--- a/Documentation/isa.txt
+++ b/Documentation/isa.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ===========
 ISA Drivers
 ===========
diff --git a/Documentation/isapnp.txt b/Documentation/isapnp.rst
similarity index 98%
rename from Documentation/isapnp.txt
rename to Documentation/isapnp.rst
index 8d0840ac847b..136a5e92be27 100644
--- a/Documentation/isapnp.txt
+++ b/Documentation/isapnp.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ==========================================================
 ISA Plug & Play support by Jaroslav Kysela <perex@suse.cz>
 ==========================================================
diff --git a/Documentation/kernel-per-CPU-kthreads.txt b/Documentation/kernel-per-CPU-kthreads.rst
similarity index 99%
rename from Documentation/kernel-per-CPU-kthreads.txt
rename to Documentation/kernel-per-CPU-kthreads.rst
index 5623b9916411..765c7b9bd7fd 100644
--- a/Documentation/kernel-per-CPU-kthreads.txt
+++ b/Documentation/kernel-per-CPU-kthreads.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ==========================================
 Reducing OS jitter due to per-cpu kthreads
 ==========================================
@@ -10,7 +12,7 @@ them to a "housekeeping" CPU dedicated to such work.
 References
 ==========
 
--	Documentation/IRQ-affinity.txt:  Binding interrupts to sets of CPUs.
+-	Documentation/IRQ-affinity.rst:  Binding interrupts to sets of CPUs.
 
 -	Documentation/cgroup-v1:  Using cgroups to bind tasks to sets of CPUs.
 
diff --git a/Documentation/kobject.txt b/Documentation/kobject.rst
similarity index 99%
rename from Documentation/kobject.txt
rename to Documentation/kobject.rst
index ff4c25098119..6117192bf3e6 100644
--- a/Documentation/kobject.txt
+++ b/Documentation/kobject.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 =====================================================================
 Everything you never wanted to know about kobjects, ksets, and ktypes
 =====================================================================
@@ -210,7 +212,7 @@ statically and will warn the developer of this improper usage.
 If all that you want to use a kobject for is to provide a reference counter
 for your structure, please use the struct kref instead; a kobject would be
 overkill.  For more information on how to use struct kref, please see the
-file Documentation/kref.txt in the Linux kernel source tree.
+file Documentation/kref.rst in the Linux kernel source tree.
 
 
 Creating "simple" kobjects
@@ -270,7 +272,7 @@ such a method has a form like::
 
     void my_object_release(struct kobject *kobj)
     {
-    	    struct my_object *mine = container_of(kobj, struct my_object, kobj);
+	    struct my_object *mine = container_of(kobj, struct my_object, kobj);
 
 	    /* Perform any additional cleanup on this object, then... */
 	    kfree(mine);
diff --git a/Documentation/kprobes.txt b/Documentation/kprobes.rst
similarity index 99%
rename from Documentation/kprobes.txt
rename to Documentation/kprobes.rst
index 8baab8832c5b..6c0011755e68 100644
--- a/Documentation/kprobes.txt
+++ b/Documentation/kprobes.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 =======================
 Kernel Probes (Kprobes)
 =======================
@@ -798,4 +800,3 @@ unoptimized, and any new probes registered after that will not be optimized.
 Note that this knob *changes* the optimized state. This means that optimized
 probes (marked [OPTIMIZED]) will be unoptimized ([OPTIMIZED] tag will be
 removed). If the knob is turned on, they will be optimized again.
-
diff --git a/Documentation/kref.txt b/Documentation/kref.rst
similarity index 99%
rename from Documentation/kref.txt
rename to Documentation/kref.rst
index 3af384156d7e..470e3c1bacdc 100644
--- a/Documentation/kref.txt
+++ b/Documentation/kref.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ===================================================
 Adding reference counters (krefs) to kernel objects
 ===================================================
diff --git a/Documentation/laptops/thinkpad-acpi.rst b/Documentation/laptops/thinkpad-acpi.rst
index 19d52fc3c5e9..d0f0d16c21b9 100644
--- a/Documentation/laptops/thinkpad-acpi.rst
+++ b/Documentation/laptops/thinkpad-acpi.rst
@@ -643,7 +643,7 @@ Sysfs notes
 	2010.
 
 	rfkill controller switch "tpacpi_bluetooth_sw": refer to
-	Documentation/rfkill.txt for details.
+	Documentation/rfkill.rst for details.
 
 
 Video output control -- /proc/acpi/ibm/video
@@ -1406,7 +1406,7 @@ Sysfs notes
 	2010.
 
 	rfkill controller switch "tpacpi_wwan_sw": refer to
-	Documentation/rfkill.txt for details.
+	Documentation/rfkill.rst for details.
 
 
 EXPERIMENTAL: UWB
@@ -1426,7 +1426,7 @@ Sysfs notes
 ^^^^^^^^^^^
 
 	rfkill controller switch "tpacpi_uwb_sw": refer to
-	Documentation/rfkill.txt for details.
+	Documentation/rfkill.rst for details.
 
 Adaptive keyboard
 -----------------
diff --git a/Documentation/ldm.txt b/Documentation/ldm.rst
similarity index 98%
rename from Documentation/ldm.txt
rename to Documentation/ldm.rst
index 12c571368e73..1e8739669541 100644
--- a/Documentation/ldm.txt
+++ b/Documentation/ldm.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ==========================================
 LDM - Logical Disk Manager (Dynamic Disks)
 ==========================================
@@ -75,7 +77,7 @@ When Linux boots, you will see something like::
 Compiling LDM Support
 ---------------------
 
-To enable LDM, choose the following two options: 
+To enable LDM, choose the following two options:
 
   - "Advanced partition selection" CONFIG_PARTITION_ADVANCED
   - "Windows Logical Disk Manager (Dynamic Disk) support" CONFIG_LDM_PARTITION
@@ -118,4 +120,3 @@ me.
 Cheers,
     FlatCap - Richard Russon
     ldm@flatcap.org
-
diff --git a/Documentation/locking/rt-mutex.rst b/Documentation/locking/rt-mutex.rst
index c365dc302081..6e3dcff802f9 100644
--- a/Documentation/locking/rt-mutex.rst
+++ b/Documentation/locking/rt-mutex.rst
@@ -4,7 +4,7 @@ RT-mutex subsystem with PI support
 
 RT-mutexes with priority inheritance are used to support PI-futexes,
 which enable pthread_mutex_t priority inheritance attributes
-(PTHREAD_PRIO_INHERIT). [See Documentation/pi-futex.txt for more details
+(PTHREAD_PRIO_INHERIT). [See Documentation/pi-futex.rst for more details
 about PI-futexes.]
 
 This technology was developed in the -rt tree and streamlined for
diff --git a/Documentation/lockup-watchdogs.txt b/Documentation/lockup-watchdogs.rst
similarity index 99%
rename from Documentation/lockup-watchdogs.txt
rename to Documentation/lockup-watchdogs.rst
index 290840c160af..a60598bfd50f 100644
--- a/Documentation/lockup-watchdogs.txt
+++ b/Documentation/lockup-watchdogs.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ===============================================================
 Softlockup detector and hardlockup detector (aka nmi_watchdog)
 ===============================================================
diff --git a/Documentation/lsm.txt b/Documentation/lsm.rst
similarity index 99%
rename from Documentation/lsm.txt
rename to Documentation/lsm.rst
index ad4dfd020e0d..4f0b1a6ea76c 100644
--- a/Documentation/lsm.txt
+++ b/Documentation/lsm.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ========================================================
 Linux Security Modules: General Security Hooks for Linux
 ========================================================
diff --git a/Documentation/lzo.txt b/Documentation/lzo.rst
similarity index 99%
rename from Documentation/lzo.txt
rename to Documentation/lzo.rst
index ca983328976b..36965db785af 100644
--- a/Documentation/lzo.txt
+++ b/Documentation/lzo.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ===========================================================
 LZO stream format as understood by Linux's LZO decompressor
 ===========================================================
diff --git a/Documentation/mailbox.txt b/Documentation/mailbox.rst
similarity index 99%
rename from Documentation/mailbox.txt
rename to Documentation/mailbox.rst
index 0ed95009cc30..02e754db3567 100644
--- a/Documentation/mailbox.txt
+++ b/Documentation/mailbox.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ============================
 The Common Mailbox Framework
 ============================
diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index f4170aae1d75..4a44f00478db 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -549,8 +549,8 @@ There are certain things that the Linux kernel memory barriers do not guarantee:
 	[*] For information on bus mastering DMA and coherency please read:
 
 	    Documentation/PCI/pci.rst
-	    Documentation/DMA-API-HOWTO.txt
-	    Documentation/DMA-API.txt
+	    Documentation/DMA-API-HOWTO.rst
+	    Documentation/DMA-API.rst
 
 
 DATA DEPENDENCY BARRIERS (HISTORICAL)
@@ -1933,7 +1933,7 @@ There are some more advanced barrier functions:
      here.
 
      See the subsection "Kernel I/O barrier effects" for more information on
-     relaxed I/O accessors and the Documentation/DMA-API.txt file for more
+     relaxed I/O accessors and the Documentation/DMA-API.rst file for more
      information on consistent memory.
 
 
diff --git a/Documentation/men-chameleon-bus.txt b/Documentation/men-chameleon-bus.rst
similarity index 99%
rename from Documentation/men-chameleon-bus.txt
rename to Documentation/men-chameleon-bus.rst
index 1b1f048aa748..2d6175229e58 100644
--- a/Documentation/men-chameleon-bus.txt
+++ b/Documentation/men-chameleon-bus.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 =================
 MEN Chameleon Bus
 =================
diff --git a/Documentation/networking/scaling.rst b/Documentation/networking/scaling.rst
index f78d7bf27ff5..05f0feb99320 100644
--- a/Documentation/networking/scaling.rst
+++ b/Documentation/networking/scaling.rst
@@ -81,7 +81,7 @@ of queues to IRQs can be determined from /proc/interrupts. By default,
 an IRQ may be handled on any CPU. Because a non-negligible part of packet
 processing takes place in receive interrupt handling, it is advantageous
 to spread receive interrupts between CPUs. To manually adjust the IRQ
-affinity of each interrupt see Documentation/IRQ-affinity.txt. Some systems
+affinity of each interrupt see Documentation/IRQ-affinity.rst. Some systems
 will be running irqbalance, a daemon that dynamically optimizes IRQ
 assignments and as a result may override any manual settings.
 
@@ -160,7 +160,7 @@ can be configured for each receive queue using a sysfs file entry::
 
 This file implements a bitmap of CPUs. RPS is disabled when it is zero
 (the default), in which case packets are processed on the interrupting
-CPU. Documentation/IRQ-affinity.txt explains how CPUs are assigned to
+CPU. Documentation/IRQ-affinity.rst explains how CPUs are assigned to
 the bitmap.
 
 
diff --git a/Documentation/nommu-mmap.txt b/Documentation/nommu-mmap.rst
similarity index 99%
rename from Documentation/nommu-mmap.txt
rename to Documentation/nommu-mmap.rst
index 530fed08de2c..f7f75813dc9c 100644
--- a/Documentation/nommu-mmap.txt
+++ b/Documentation/nommu-mmap.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 =============================
 No-MMU memory mapping support
 =============================
diff --git a/Documentation/ntb.txt b/Documentation/ntb.rst
similarity index 99%
rename from Documentation/ntb.txt
rename to Documentation/ntb.rst
index 87d1372da879..a25e7814b898 100644
--- a/Documentation/ntb.txt
+++ b/Documentation/ntb.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ===========
 NTB Drivers
 ===========
diff --git a/Documentation/numastat.txt b/Documentation/numastat.rst
similarity index 99%
rename from Documentation/numastat.txt
rename to Documentation/numastat.rst
index aaf1667489f8..762925cfe882 100644
--- a/Documentation/numastat.txt
+++ b/Documentation/numastat.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ===============================
 Numa policy hit/miss statistics
 ===============================
@@ -27,4 +29,3 @@ interleave_hit 	Interleaving wanted to allocate from this node
 For easier reading you can use the numastat utility from the numactl package
 (http://oss.sgi.com/projects/libnuma/). Note that it only works
 well right now on machines with a small number of CPUs.
-
diff --git a/Documentation/padata.txt b/Documentation/padata.rst
similarity index 99%
rename from Documentation/padata.txt
rename to Documentation/padata.rst
index b103d0c82000..f8369d18c846 100644
--- a/Documentation/padata.txt
+++ b/Documentation/padata.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 =======================================
 The padata parallel execution mechanism
 =======================================
diff --git a/Documentation/parport-lowlevel.txt b/Documentation/parport-lowlevel.rst
similarity index 99%
rename from Documentation/parport-lowlevel.txt
rename to Documentation/parport-lowlevel.rst
index 0633d70ffda7..b8574d83d328 100644
--- a/Documentation/parport-lowlevel.txt
+++ b/Documentation/parport-lowlevel.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ===============================
 PARPORT interface documentation
 ===============================
diff --git a/Documentation/percpu-rw-semaphore.txt b/Documentation/percpu-rw-semaphore.rst
similarity index 99%
rename from Documentation/percpu-rw-semaphore.txt
rename to Documentation/percpu-rw-semaphore.rst
index 247de6410855..5c39c88d3719 100644
--- a/Documentation/percpu-rw-semaphore.txt
+++ b/Documentation/percpu-rw-semaphore.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ====================
 Percpu rw semaphores
 ====================
diff --git a/Documentation/phy.txt b/Documentation/phy.rst
similarity index 99%
rename from Documentation/phy.txt
rename to Documentation/phy.rst
index 457c3e0f86d6..129a45ccc857 100644
--- a/Documentation/phy.txt
+++ b/Documentation/phy.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 =============
 PHY subsystem
 =============
diff --git a/Documentation/pi-futex.txt b/Documentation/pi-futex.rst
similarity index 99%
rename from Documentation/pi-futex.txt
rename to Documentation/pi-futex.rst
index c33ba2befbf8..884ba7f2aa10 100644
--- a/Documentation/pi-futex.txt
+++ b/Documentation/pi-futex.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ======================
 Lightweight PI-futexes
 ======================
diff --git a/Documentation/pnp.txt b/Documentation/pnp.rst
similarity index 98%
rename from Documentation/pnp.txt
rename to Documentation/pnp.rst
index bab2d10631f0..ef84f35a9b47 100644
--- a/Documentation/pnp.txt
+++ b/Documentation/pnp.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 =================================
 Linux Plug and Play Documentation
 =================================
@@ -10,7 +12,7 @@ Overview
 --------
 
 Plug and Play provides a means of detecting and setting resources for legacy or
-otherwise unconfigurable devices.  The Linux Plug and Play Layer provides these 
+otherwise unconfigurable devices.  The Linux Plug and Play Layer provides these
 services to compatible drivers.
 
 
@@ -18,7 +20,7 @@ The User Interface
 ------------------
 
 The Linux Plug and Play user interface provides a means to activate PnP devices
-for legacy and user level drivers that do not support Linux Plug and Play.  The 
+for legacy and user level drivers that do not support Linux Plug and Play.  The
 user interface is integrated into sysfs.
 
 In addition to the standard sysfs file the following are created in each
@@ -113,9 +115,9 @@ The Unified Plug and Play Layer
 -------------------------------
 
 All Plug and Play drivers, protocols, and services meet at a central location
-called the Plug and Play Layer.  This layer is responsible for the exchange of 
-information between PnP drivers and PnP protocols.  Thus it automatically 
-forwards commands to the proper protocol.  This makes writing PnP drivers 
+called the Plug and Play Layer.  This layer is responsible for the exchange of
+information between PnP drivers and PnP protocols.  Thus it automatically
+forwards commands to the proper protocol.  This makes writing PnP drivers
 significantly easier.
 
 The following functions are available from the Plug and Play Layer:
@@ -289,4 +291,3 @@ They are as follows::
 				     unsigned short vendor,
 				     unsigned short function,
 				     struct pnp_dev *from)
-
diff --git a/Documentation/preempt-locking.txt b/Documentation/preempt-locking.rst
similarity index 99%
rename from Documentation/preempt-locking.txt
rename to Documentation/preempt-locking.rst
index dce336134e54..4dfa1512a75b 100644
--- a/Documentation/preempt-locking.txt
+++ b/Documentation/preempt-locking.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ===========================================================================
 Proper Locking Under a Preemptible Kernel: Keeping Kernel Code Preempt-Safe
 ===========================================================================
@@ -16,7 +18,7 @@ requires explicit additional locking for very few additional situations.
 
 This document is for all kernel hackers.  Developing code in the kernel
 requires protecting these situations.
- 
+
 
 RULE #1: Per-CPU data structures need explicit protection
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
diff --git a/Documentation/pwm.txt b/Documentation/pwm.rst
similarity index 99%
rename from Documentation/pwm.txt
rename to Documentation/pwm.rst
index 8fbf0aa3ba2d..78d06b7f5427 100644
--- a/Documentation/pwm.txt
+++ b/Documentation/pwm.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ======================================
 Pulse Width Modulation (PWM) interface
 ======================================
diff --git a/Documentation/rbtree.txt b/Documentation/rbtree.rst
similarity index 94%
rename from Documentation/rbtree.txt
rename to Documentation/rbtree.rst
index 523d54b60087..c0cbda408050 100644
--- a/Documentation/rbtree.txt
+++ b/Documentation/rbtree.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 =================================
 Red-black Trees (rbtree) in Linux
 =================================
@@ -62,8 +64,8 @@ Creating a new rbtree
 Data nodes in an rbtree tree are structures containing a struct rb_node member::
 
   struct mytype {
-  	struct rb_node node;
-  	char *keystring;
+	struct rb_node node;
+	char *keystring;
   };
 
 When dealing with a pointer to the embedded struct rb_node, the containing data
@@ -85,20 +87,20 @@ Example::
 
   struct mytype *my_search(struct rb_root *root, char *string)
   {
-  	struct rb_node *node = root->rb_node;
+	struct rb_node *node = root->rb_node;
 
-  	while (node) {
-  		struct mytype *data = container_of(node, struct mytype, node);
+	while (node) {
+		struct mytype *data = container_of(node, struct mytype, node);
 		int result;
 
 		result = strcmp(string, data->keystring);
 
 		if (result < 0)
-  			node = node->rb_left;
+			node = node->rb_left;
 		else if (result > 0)
-  			node = node->rb_right;
+			node = node->rb_right;
 		else
-  			return data;
+			return data;
 	}
 	return NULL;
   }
@@ -117,25 +119,25 @@ Example::
 
   int my_insert(struct rb_root *root, struct mytype *data)
   {
-  	struct rb_node **new = &(root->rb_node), *parent = NULL;
+	struct rb_node **new = &(root->rb_node), *parent = NULL;
 
-  	/* Figure out where to put new node */
-  	while (*new) {
-  		struct mytype *this = container_of(*new, struct mytype, node);
-  		int result = strcmp(data->keystring, this->keystring);
+	/* Figure out where to put new node */
+	while (*new) {
+		struct mytype *this = container_of(*new, struct mytype, node);
+		int result = strcmp(data->keystring, this->keystring);
 
 		parent = *new;
-  		if (result < 0)
-  			new = &((*new)->rb_left);
-  		else if (result > 0)
-  			new = &((*new)->rb_right);
-  		else
-  			return FALSE;
-  	}
+		if (result < 0)
+			new = &((*new)->rb_left);
+		else if (result > 0)
+			new = &((*new)->rb_right);
+		else
+			return FALSE;
+	}
 
-  	/* Add new node and rebalance tree. */
-  	rb_link_node(&data->node, parent, new);
-  	rb_insert_color(&data->node, root);
+	/* Add new node and rebalance tree. */
+	rb_link_node(&data->node, parent, new);
+	rb_insert_color(&data->node, root);
 
 	return TRUE;
   }
@@ -152,14 +154,14 @@ Example::
   struct mytype *data = mysearch(&mytree, "walrus");
 
   if (data) {
-  	rb_erase(&data->node, &mytree);
-  	myfree(data);
+	rb_erase(&data->node, &mytree);
+	myfree(data);
   }
 
 To replace an existing node in a tree with a new one with the same key, call::
 
   void rb_replace_node(struct rb_node *old, struct rb_node *new,
-  			struct rb_root *tree);
+			struct rb_root *tree);
 
 Replacing a node this way does not re-sort the tree: If the new node doesn't
 have the same key as the old node, the rbtree will probably become corrupted.
diff --git a/Documentation/remoteproc.txt b/Documentation/remoteproc.rst
similarity index 99%
rename from Documentation/remoteproc.txt
rename to Documentation/remoteproc.rst
index 77fb03acdbb4..71eb7728fcf3 100644
--- a/Documentation/remoteproc.txt
+++ b/Documentation/remoteproc.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ==========================
 Remote Processor Framework
 ==========================
@@ -22,7 +24,7 @@ for remote processors that supports this kind of communication. This way,
 platform-specific remoteproc drivers only need to provide a few low-level
 handlers, and then all rpmsg drivers will then just work
 (for more information about the virtio-based rpmsg bus and its drivers,
-please read Documentation/rpmsg.txt).
+please read Documentation/rpmsg.rst).
 Registration of other types of virtio devices is now also possible. Firmwares
 just need to publish what kind of virtio devices do they support, and then
 remoteproc will add those devices. This makes it possible to reuse the
diff --git a/Documentation/rfkill.txt b/Documentation/rfkill.rst
similarity index 99%
rename from Documentation/rfkill.txt
rename to Documentation/rfkill.rst
index 7d3684e81df6..4da9994e9bb4 100644
--- a/Documentation/rfkill.txt
+++ b/Documentation/rfkill.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ===============================
 rfkill - RF kill switch support
 ===============================
diff --git a/Documentation/robust-futex-ABI.txt b/Documentation/robust-futex-ABI.rst
similarity index 99%
rename from Documentation/robust-futex-ABI.txt
rename to Documentation/robust-futex-ABI.rst
index 8a5d34abf726..6d359b46610c 100644
--- a/Documentation/robust-futex-ABI.txt
+++ b/Documentation/robust-futex-ABI.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ====================
 The robust futex ABI
 ====================
diff --git a/Documentation/robust-futexes.txt b/Documentation/robust-futexes.rst
similarity index 99%
rename from Documentation/robust-futexes.txt
rename to Documentation/robust-futexes.rst
index 6361fb01c9c1..20beef77597a 100644
--- a/Documentation/robust-futexes.txt
+++ b/Documentation/robust-futexes.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ========================================
 A description of what robust futexes are
 ========================================
diff --git a/Documentation/rpmsg.txt b/Documentation/rpmsg.rst
similarity index 99%
rename from Documentation/rpmsg.txt
rename to Documentation/rpmsg.rst
index 24b7a9e1a5f9..ad53931f3e43 100644
--- a/Documentation/rpmsg.txt
+++ b/Documentation/rpmsg.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ============================================
 Remote Processor Messaging (rpmsg) Framework
 ============================================
diff --git a/Documentation/rtc.txt b/Documentation/rtc.rst
similarity index 99%
rename from Documentation/rtc.txt
rename to Documentation/rtc.rst
index 688c95b11919..6893bb5cf0ef 100644
--- a/Documentation/rtc.txt
+++ b/Documentation/rtc.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 =======================================
 Real Time Clock (RTC) Drivers for Linux
 =======================================
@@ -86,9 +88,9 @@ a different value to /proc/sys/dev/rtc/max-user-freq. Note that the
 interrupt handler is only a few lines of code to minimize any possibility
 of this effect.
 
-Also, if the kernel time is synchronized with an external source, the 
-kernel will write the time back to the CMOS clock every 11 minutes. In 
-the process of doing this, the kernel briefly turns off RTC periodic 
+Also, if the kernel time is synchronized with an external source, the
+kernel will write the time back to the CMOS clock every 11 minutes. In
+the process of doing this, the kernel briefly turns off RTC periodic
 interrupts, so be aware of this if you are doing serious work. If you
 don't synchronize the kernel time with an external source (via ntp or
 whatever) then the kernel will keep its hands off the RTC, allowing you
diff --git a/Documentation/s390/vfio-ccw.rst b/Documentation/s390/vfio-ccw.rst
index 1f6d0b56d53e..87b5bb49b2f3 100644
--- a/Documentation/s390/vfio-ccw.rst
+++ b/Documentation/s390/vfio-ccw.rst
@@ -38,7 +38,7 @@ every detail. More information/reference could be found here:
   qemu/hw/s390x/css.c
 
 For vfio mediated device framework:
-- Documentation/vfio-mediated-device.txt
+- Documentation/vfio-mediated-device.rst
 
 Motivation of vfio-ccw
 ----------------------
@@ -322,5 +322,5 @@ Reference
 2. ESA/390 Common I/O Device Commands manual (IBM Form. No. SA22-7204)
 3. https://en.wikipedia.org/wiki/Channel_I/O
 4. Documentation/s390/cds.rst
-5. Documentation/vfio.txt
-6. Documentation/vfio-mediated-device.txt
+5. Documentation/vfio.rst
+6. Documentation/vfio-mediated-device.rst
diff --git a/Documentation/sgi-ioc4.txt b/Documentation/sgi-ioc4.rst
similarity index 99%
rename from Documentation/sgi-ioc4.txt
rename to Documentation/sgi-ioc4.rst
index 72709222d3c0..e6ed2e9b055b 100644
--- a/Documentation/sgi-ioc4.txt
+++ b/Documentation/sgi-ioc4.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ====================================
 SGI IOC4 PCI (multi function) device
 ====================================
diff --git a/Documentation/siphash.txt b/Documentation/siphash.rst
similarity index 99%
rename from Documentation/siphash.txt
rename to Documentation/siphash.rst
index 9965821ab333..833eef3a7956 100644
--- a/Documentation/siphash.txt
+++ b/Documentation/siphash.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ===========================
 SipHash - a short input PRF
 ===========================
diff --git a/Documentation/smsc_ece1099.txt b/Documentation/smsc_ece1099.rst
similarity index 99%
rename from Documentation/smsc_ece1099.txt
rename to Documentation/smsc_ece1099.rst
index 079277421eaf..a403fcd7c64d 100644
--- a/Documentation/smsc_ece1099.txt
+++ b/Documentation/smsc_ece1099.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 =================================================
 Msc Keyboard Scan Expansion/GPIO Expansion device
 =================================================
diff --git a/Documentation/speculation.txt b/Documentation/speculation.rst
similarity index 99%
rename from Documentation/speculation.txt
rename to Documentation/speculation.rst
index 50d7ea857cff..e240f01b0983 100644
--- a/Documentation/speculation.txt
+++ b/Documentation/speculation.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 This document explains potential effects of speculation, and how undesirable
 effects can be mitigated portably using common APIs.
 
diff --git a/Documentation/static-keys.txt b/Documentation/static-keys.rst
similarity index 99%
rename from Documentation/static-keys.txt
rename to Documentation/static-keys.rst
index 9803e14639bf..bdf545e3a37f 100644
--- a/Documentation/static-keys.txt
+++ b/Documentation/static-keys.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ===========
 Static Keys
 ===========
diff --git a/Documentation/svga.txt b/Documentation/svga.rst
similarity index 99%
rename from Documentation/svga.txt
rename to Documentation/svga.rst
index b6c2f9acca92..1bfd54d9fb59 100644
--- a/Documentation/svga.txt
+++ b/Documentation/svga.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 .. include:: <isonum.txt>
 
 =================================
diff --git a/Documentation/switchtec.txt b/Documentation/switchtec.rst
similarity index 98%
rename from Documentation/switchtec.txt
rename to Documentation/switchtec.rst
index 30d6a64e53f7..6879c92de8e2 100644
--- a/Documentation/switchtec.txt
+++ b/Documentation/switchtec.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ========================
 Linux Switchtec Support
 ========================
@@ -97,6 +99,6 @@ the following configuration settings:
 NT EP BAR 2 will be dynamically configured as a Direct Window, and
 the configuration file does not need to configure it explicitly.
 
-Please refer to Documentation/ntb.txt in Linux source tree for an overall
+Please refer to Documentation/ntb.rst in Linux source tree for an overall
 understanding of the Linux NTB stack. ntb_hw_switchtec works as an NTB
 Hardware Driver in this stack.
diff --git a/Documentation/sync_file.txt b/Documentation/sync_file.rst
similarity index 99%
rename from Documentation/sync_file.txt
rename to Documentation/sync_file.rst
index 496fb2c3b3e6..a65a67cc06fa 100644
--- a/Documentation/sync_file.txt
+++ b/Documentation/sync_file.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ===================
 Sync File API Guide
 ===================
diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 92f7f34b021a..e6139d88f819 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -44,7 +44,7 @@ show up in /proc/sys/kernel:
 - kexec_load_disabled
 - kptr_restrict
 - l2cr                        [ PPC only ]
-- modprobe                    ==> Documentation/debugging-modules.txt
+- modprobe                    ==> Documentation/debugging-modules.rst
 - modules_disabled
 - msg_next_id		      [ sysv ipc ]
 - msgmax
@@ -327,7 +327,7 @@ when a hard lockup is detected.
    0 - don't panic on hard lockup
    1 - panic on hard lockup
 
-See Documentation/lockup-watchdogs.txt for more information.  This can
+See Documentation/lockup-watchdogs.rst for more information.  This can
 also be set using the nmi_watchdog kernel parameter.
 
 ==============================================================
diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
index c5f0d44433a2..046691580ba6 100644
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -566,7 +566,7 @@ trimming of allocations is initiated.
 
 The default value is 1.
 
-See Documentation/nommu-mmap.txt for more information.
+See Documentation/nommu-mmap.rst for more information.
 
 ==============================================================
 
diff --git a/Documentation/tee.txt b/Documentation/tee.rst
similarity index 99%
rename from Documentation/tee.txt
rename to Documentation/tee.rst
index afacdf2fd1de..5eacffb823b5 100644
--- a/Documentation/tee.txt
+++ b/Documentation/tee.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 =============
 TEE subsystem
 =============
diff --git a/Documentation/this_cpu_ops.txt b/Documentation/this_cpu_ops.rst
similarity index 99%
rename from Documentation/this_cpu_ops.txt
rename to Documentation/this_cpu_ops.rst
index 5cb8b883ae83..a489d25ff549 100644
--- a/Documentation/this_cpu_ops.txt
+++ b/Documentation/this_cpu_ops.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ===================
 this_cpu operations
 ===================
diff --git a/Documentation/trace/kprobetrace.rst b/Documentation/trace/kprobetrace.rst
index 89ba487d4399..74f698affea1 100644
--- a/Documentation/trace/kprobetrace.rst
+++ b/Documentation/trace/kprobetrace.rst
@@ -40,7 +40,7 @@ Synopsis of kprobe_events
  MEMADDR	: Address where the probe is inserted.
  MAXACTIVE	: Maximum number of instances of the specified function that
 		  can be probed simultaneously, or 0 for the default value
-		  as defined in Documentation/kprobes.txt section 1.3.1.
+		  as defined in Documentation/kprobes.rst section 1.3.1.
 
  FETCHARGS	: Arguments. Each probe can have up to 128 args.
   %REG		: Fetch register REG
diff --git a/Documentation/translations/ko_KR/memory-barriers.txt b/Documentation/translations/ko_KR/memory-barriers.txt
index 07725b1df002..03c06a7800c3 100644
--- a/Documentation/translations/ko_KR/memory-barriers.txt
+++ b/Documentation/translations/ko_KR/memory-barriers.txt
@@ -570,8 +570,8 @@ ACQUIRE 는 해당 오퍼레이션의 로드 부분에만 적용되고 RELEASE 
 	[*] 버스 마스터링 DMA 와 일관성에 대해서는 다음을 참고하시기 바랍니다:
 
 	    Documentation/PCI/pci.rst
-	    Documentation/DMA-API-HOWTO.txt
-	    Documentation/DMA-API.txt
+	    Documentation/DMA-API-HOWTO.rst
+	    Documentation/DMA-API.rst
 
 
 데이터 의존성 배리어 (역사적)
@@ -1904,7 +1904,7 @@ Mandatory 배리어들은 SMP 시스템에서도 UP 시스템에서도 SMP 효
 
      writel_relaxed() 와 같은 완화된 I/O 접근자들에 대한 자세한 내용을 위해서는
      "커널 I/O 배리어의 효과" 섹션을, consistent memory 에 대한 자세한 내용을
-     위해선 Documentation/DMA-API.txt 문서를 참고하세요.
+     위해선 Documentation/DMA-API.rst 문서를 참고하세요.
 
 
 MMIO 쓰기 배리어
diff --git a/Documentation/translations/zh_CN/IRQ.txt b/Documentation/translations/zh_CN/IRQ.txt
index 956026d5cf82..0d9ec142e185 100644
--- a/Documentation/translations/zh_CN/IRQ.txt
+++ b/Documentation/translations/zh_CN/IRQ.txt
@@ -1,4 +1,4 @@
-Chinese translated version of Documentation/IRQ.txt
+Chinese translated version of Documentation/IRQ.rst
 
 If you have any comment or update to the content, please contact the
 original document maintainer directly.  However, if you have a problem
@@ -9,7 +9,7 @@ or if there is a problem with the translation.
 Maintainer: Eric W. Biederman <ebiederman@xmission.com>
 Chinese maintainer: Fu Wei <tekkamanninja@gmail.com>
 ---------------------------------------------------------------------
-Documentation/IRQ.txt 的中文翻译
+Documentation/IRQ.rst 的中文翻译
 
 如果想评论或更新本文的内容，请直接联系原文档的维护者。如果你使用英文
 交流有困难的话，也可以向中文版维护者求助。如果本翻译更新不及时或者翻
diff --git a/Documentation/translations/zh_CN/filesystems/sysfs.txt b/Documentation/translations/zh_CN/filesystems/sysfs.txt
index 452271dda141..f5482e082399 100644
--- a/Documentation/translations/zh_CN/filesystems/sysfs.txt
+++ b/Documentation/translations/zh_CN/filesystems/sysfs.txt
@@ -40,7 +40,7 @@ sysfs 是一个最初基于 ramfs 且位于内存的文件系统。它提供导
 数据结构及其属性，以及它们之间的关联到用户空间的方法。
 
 sysfs 始终与 kobject 的底层结构紧密相关。请阅读
-Documentation/kobject.txt 文档以获得更多关于 kobject 接口的
+Documentation/kobject.rst 文档以获得更多关于 kobject 接口的
 信息。
 
 
diff --git a/Documentation/translations/zh_CN/io_ordering.txt b/Documentation/translations/zh_CN/io_ordering.txt
index 1f8127bdd415..4e9727990c10 100644
--- a/Documentation/translations/zh_CN/io_ordering.txt
+++ b/Documentation/translations/zh_CN/io_ordering.txt
@@ -1,4 +1,4 @@
-Chinese translated version of Documentation/io_ordering.txt
+Chinese translated version of Documentation/io_ordering.rst
 
 If you have any comment or update to the content, please contact the
 original document maintainer directly.  However, if you have a problem
@@ -8,7 +8,7 @@ or if there is a problem with the translation.
 
 Chinese maintainer: Lin Yongting <linyongting@gmail.com>
 ---------------------------------------------------------------------
-Documentation/io_ordering.txt 的中文翻译
+Documentation/io_ordering.rst 的中文翻译
 
 如果想评论或更新本文的内容，请直接联系原文档的维护者。如果你使用英文
 交流有困难的话，也可以向中文版维护者求助。如果本翻译更新不及时或者翻
diff --git a/Documentation/unaligned-memory-access.txt b/Documentation/unaligned-memory-access.rst
similarity index 99%
rename from Documentation/unaligned-memory-access.txt
rename to Documentation/unaligned-memory-access.rst
index 1ee82419d8aa..848013a8bc10 100644
--- a/Documentation/unaligned-memory-access.txt
+++ b/Documentation/unaligned-memory-access.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 =========================
 Unaligned Memory Accesses
 =========================
diff --git a/Documentation/vfio-mediated-device.txt b/Documentation/vfio-mediated-device.rst
similarity index 99%
rename from Documentation/vfio-mediated-device.txt
rename to Documentation/vfio-mediated-device.rst
index c3f69bcaf96e..0ea57427e7e6 100644
--- a/Documentation/vfio-mediated-device.txt
+++ b/Documentation/vfio-mediated-device.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 .. include:: <isonum.txt>
 
 =====================
@@ -408,7 +410,7 @@ card.
 References
 ==========
 
-1. See Documentation/vfio.txt for more information on VFIO.
+1. See Documentation/vfio.rst for more information on VFIO.
 2. struct mdev_driver in include/linux/mdev.h
 3. struct mdev_parent_ops in include/linux/mdev.h
 4. struct vfio_iommu_driver_ops in include/linux/vfio.h
diff --git a/Documentation/vfio.txt b/Documentation/vfio.rst
similarity index 99%
rename from Documentation/vfio.txt
rename to Documentation/vfio.rst
index f1a4d3c3ba0b..8a3fbd7d96f0 100644
--- a/Documentation/vfio.txt
+++ b/Documentation/vfio.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ==================================
 VFIO - "Virtual Function I/O" [1]_
 ==================================
diff --git a/Documentation/video-output.txt b/Documentation/video-output.rst
similarity index 99%
rename from Documentation/video-output.txt
rename to Documentation/video-output.rst
index 56d6fa2e2368..9095c4be45e5 100644
--- a/Documentation/video-output.txt
+++ b/Documentation/video-output.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 Video Output Switcher Control
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
@@ -31,4 +33,3 @@ method for 'state' with output sysfs class. The user interface under sysfs is::
      |-- state
      |-- subsystem -> ../../../class/video_output
      `-- uevent
-
diff --git a/Documentation/watchdog/hpwdt.rst b/Documentation/watchdog/hpwdt.rst
index 94a96371113e..f4ba329f011f 100644
--- a/Documentation/watchdog/hpwdt.rst
+++ b/Documentation/watchdog/hpwdt.rst
@@ -44,7 +44,7 @@ Last reviewed: 08/20/2018
  NOTE:
        More information about watchdog drivers in general, including the ioctl
        interface to /dev/watchdog can be found in
-       Documentation/watchdog/watchdog-api.rst and Documentation/IPMI.txt.
+       Documentation/watchdog/watchdog-api.rst and Documentation/IPMI.rst.
 
  Due to limitations in the iLO hardware, the NMI pretimeout if enabled,
  can only be set to 9 seconds.  Attempts to set pretimeout to other
diff --git a/Documentation/x86/topology.rst b/Documentation/x86/topology.rst
index 8e9704f61017..b06d895becce 100644
--- a/Documentation/x86/topology.rst
+++ b/Documentation/x86/topology.rst
@@ -9,7 +9,7 @@ representation in the kernel. Update/change when doing changes to the
 respective code.
 
 The architecture-agnostic topology definitions are in
-Documentation/cputopology.txt. This file holds x86-specific
+Documentation/cputopology.rst. This file holds x86-specific
 differences/specialities which must not necessarily apply to the generic
 definitions. Thus, the way to read up on Linux topology on x86 is to start
 with the generic one and look at this one in parallel for the x86 specifics.
diff --git a/Documentation/xillybus.txt b/Documentation/xillybus.rst
similarity index 99%
rename from Documentation/xillybus.txt
rename to Documentation/xillybus.rst
index 2446ee303c09..d99f4a37e8b6 100644
--- a/Documentation/xillybus.txt
+++ b/Documentation/xillybus.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ==========================================
 Xillybus driver for generic FPGA interface
 ==========================================
diff --git a/Documentation/xz.txt b/Documentation/xz.rst
similarity index 99%
rename from Documentation/xz.txt
rename to Documentation/xz.rst
index b2220d03aa50..205edc6646d5 100644
--- a/Documentation/xz.txt
+++ b/Documentation/xz.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ============================
 XZ data compression in Linux
 ============================
diff --git a/Documentation/zorro.txt b/Documentation/zorro.rst
similarity index 99%
rename from Documentation/zorro.txt
rename to Documentation/zorro.rst
index 664072b017e3..7cd509f31d57 100644
--- a/Documentation/zorro.txt
+++ b/Documentation/zorro.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ========================================
 Writing Device Drivers for Zorro Devices
 ========================================
@@ -77,7 +79,7 @@ The treatment of these regions depends on the type of Zorro space:
 
   - Zorro II address space is always mapped and does not have to be mapped
     explicitly using z_ioremap().
-    
+
     Conversion from bus/physical Zorro II addresses to kernel virtual addresses
     and vice versa is done using::
 
@@ -86,7 +88,7 @@ The treatment of these regions depends on the type of Zorro space:
 
   - Zorro III address space must be mapped explicitly using z_ioremap() first
     before it can be accessed::
- 
+
 	virt_addr = z_ioremap(bus_addr, size);
 	...
 	z_iounmap(virt_addr);
@@ -101,4 +103,3 @@ References
 #. linux/arch/m68k/include/asm/zorro.h
 #. linux/drivers/zorro
 #. /proc/bus/zorro
-
diff --git a/MAINTAINERS b/MAINTAINERS
index 58e103015dea..d9e214f68e52 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4588,7 +4588,7 @@ DELL SYSTEMS MANAGEMENT BASE DRIVER (dcdbas)
 M:	Stuart Hayes <stuart.w.hayes@gmail.com>
 L:	platform-driver-x86@vger.kernel.org
 S:	Maintained
-F:	Documentation/dcdbas.txt
+F:	Documentation/dcdbas.rst
 F:	drivers/platform/x86/dcdbas.*
 
 DELL WMI NOTIFICATIONS DRIVER
@@ -4966,7 +4966,7 @@ M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 R:	"Rafael J. Wysocki" <rafael@kernel.org>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
 S:	Supported
-F:	Documentation/kobject.txt
+F:	Documentation/kobject.rst
 F:	drivers/base/
 F:	fs/debugfs/
 F:	fs/sysfs/
@@ -6038,7 +6038,7 @@ M:	Ard Biesheuvel <ard.biesheuvel@linaro.org>
 L:	linux-efi@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git
 S:	Maintained
-F:	Documentation/efi-stub.txt
+F:	Documentation/efi-stub.rst
 F:	arch/*/kernel/efi.c
 F:	arch/x86/boot/compressed/eboot.[ch]
 F:	arch/*/include/asm/efi.h
@@ -6594,7 +6594,7 @@ S:	Maintained
 F:	scripts/gcc-plugins/
 F:	scripts/gcc-plugin.sh
 F:	scripts/Makefile.gcc-plugins
-F:	Documentation/gcc-plugins.txt
+F:	Documentation/gcc-plugins.rst
 
 GASKET DRIVER FRAMEWORK
 M:	Rob Springer <rspringer@google.com>
@@ -7006,7 +7006,7 @@ M:	Herbert Xu <herbert@gondor.apana.org.au>
 L:	linux-crypto@vger.kernel.org
 S:	Odd fixes
 F:	Documentation/devicetree/bindings/rng/
-F:	Documentation/hw_random.txt
+F:	Documentation/hw_random.rst
 F:	drivers/char/hw_random/
 F:	include/linux/hw_random.h
 
@@ -7022,7 +7022,7 @@ L:	linux-remoteproc@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ohad/hwspinlock.git
 F:	Documentation/devicetree/bindings/hwlock/
-F:	Documentation/hwspinlock.txt
+F:	Documentation/hwspinlock.rst
 F:	drivers/hwspinlock/
 F:	include/linux/hwspinlock.h
 
@@ -8208,7 +8208,7 @@ L:	tboot-devel@lists.sourceforge.net
 W:	http://tboot.sourceforge.net
 T:	hg http://tboot.hg.sourceforge.net:8000/hgroot/tboot/tboot
 S:	Supported
-F:	Documentation/intel_txt.txt
+F:	Documentation/intel_txt.rst
 F:	include/linux/tboot.h
 F:	arch/x86/kernel/tboot.c
 
@@ -8292,7 +8292,7 @@ L:	openipmi-developer@lists.sourceforge.net (moderated for non-subscribers)
 W:	http://openipmi.sourceforge.net/
 S:	Supported
 F:	Documentation/devicetree/bindings/ipmi/
-F:	Documentation/IPMI.txt
+F:	Documentation/IPMI.rst
 F:	drivers/char/ipmi/
 F:	include/linux/ipmi*
 F:	include/uapi/linux/ipmi*
@@ -8333,7 +8333,7 @@ IRQ DOMAINS (IRQ NUMBER MAPPING LIBRARY)
 M:	Marc Zyngier <marc.zyngier@arm.com>
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq/core
-F:	Documentation/IRQ-domain.txt
+F:	Documentation/IRQ-domain.rst
 F:	include/linux/irqdomain.h
 F:	kernel/irq/irqdomain.c
 F:	kernel/irq/msi.c
@@ -8358,7 +8358,7 @@ F:	drivers/irqchip/
 ISA
 M:	William Breathitt Gray <vilhelm.gray@gmail.com>
 S:	Maintained
-F:	Documentation/isa.txt
+F:	Documentation/isa.rst
 F:	drivers/base/isa.c
 F:	include/linux/isa.h
 
@@ -8373,7 +8373,7 @@ F:	drivers/media/radio/radio-isa*
 ISAPNP
 M:	Jaroslav Kysela <perex@perex.cz>
 S:	Maintained
-F:	Documentation/isapnp.txt
+F:	Documentation/isapnp.rst
 F:	drivers/pnp/isapnp/
 F:	include/linux/isapnp.h
 
@@ -8823,7 +8823,7 @@ M:	Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
 M:	"David S. Miller" <davem@davemloft.net>
 M:	Masami Hiramatsu <mhiramat@kernel.org>
 S:	Maintained
-F:	Documentation/kprobes.txt
+F:	Documentation/kprobes.rst
 F:	include/linux/kprobes.h
 F:	include/asm-generic/kprobes.h
 F:	kernel/kprobes.c
@@ -9182,7 +9182,7 @@ L:	linux-arch@vger.kernel.org
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git dev
 F:	tools/memory-model/
-F:	Documentation/atomic_bitops.txt
+F:	Documentation/atomic_bitops.rst
 F:	Documentation/atomic_t.txt
 F:	Documentation/core-api/atomic_ops.rst
 F:	Documentation/core-api/refcount-vs-atomic.rst
@@ -9296,7 +9296,7 @@ M:	"Richard Russon (FlatCap)" <ldm@flatcap.org>
 L:	linux-ntfs-dev@lists.sourceforge.net
 W:	http://www.linux-ntfs.org/content/view/19/37/
 S:	Maintained
-F:	Documentation/ldm.txt
+F:	Documentation/ldm.rst
 F:	block/partitions/ldm.*
 
 LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)
@@ -10240,7 +10240,7 @@ M:	Johannes Thumshirn <morbidrsa@gmail.com>
 S:	Maintained
 F:	drivers/mcb/
 F:	include/linux/mcb.h
-F:	Documentation/men-chameleon-bus.txt
+F:	Documentation/men-chameleon-bus.rst
 
 MEN F21BMC (Board Management Controller)
 M:	Andreas Werner <andreas.werner@men.de>
@@ -11923,7 +11923,7 @@ L:	linux-crypto@vger.kernel.org
 S:	Maintained
 F:	kernel/padata.c
 F:	include/linux/padata.h
-F:	Documentation/padata.txt
+F:	Documentation/padata.rst
 
 PANASONIC LAPTOP ACPI EXTRAS DRIVER
 M:	Harald Welte <laforge@gnumonks.org>
@@ -11947,7 +11947,7 @@ F:	drivers/parport/
 F:	include/linux/parport*.h
 F:	drivers/char/ppdev.c
 F:	include/uapi/linux/ppdev.h
-F:	Documentation/parport*.txt
+F:	Documentation/parport*.rst
 
 PARAVIRT_OPS INTERFACE
 M:	Juergen Gross <jgross@suse.com>
@@ -12122,7 +12122,7 @@ M:	Kurt Schwemmer <kurt.schwemmer@microsemi.com>
 M:	Logan Gunthorpe <logang@deltatee.com>
 L:	linux-pci@vger.kernel.org
 S:	Maintained
-F:	Documentation/switchtec.txt
+F:	Documentation/switchtec.rst
 F:	Documentation/ABI/testing/sysfs-class-switchtec
 F:	drivers/pci/switch/switchtec*
 F:	include/uapi/linux/switchtec_ioctl.h
@@ -12884,7 +12884,7 @@ M:	Thierry Reding <thierry.reding@gmail.com>
 L:	linux-pwm@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/thierry.reding/linux-pwm.git
-F:	Documentation/pwm.txt
+F:	Documentation/pwm.rst
 F:	Documentation/devicetree/bindings/pwm/
 F:	include/linux/pwm.h
 F:	drivers/pwm/
@@ -13354,7 +13354,7 @@ Q:	http://patchwork.ozlabs.org/project/rtc-linux/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/abelloni/linux.git
 S:	Maintained
 F:	Documentation/devicetree/bindings/rtc/
-F:	Documentation/rtc.txt
+F:	Documentation/rtc.rst
 F:	drivers/rtc/
 F:	include/linux/rtc.h
 F:	include/uapi/linux/rtc.h
@@ -13405,7 +13405,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ohad/remoteproc.git
 S:	Maintained
 F:	Documentation/devicetree/bindings/remoteproc/
 F:	Documentation/ABI/testing/sysfs-class-remoteproc
-F:	Documentation/remoteproc.txt
+F:	Documentation/remoteproc.rst
 F:	drivers/remoteproc/
 F:	include/linux/remoteproc.h
 F:	include/linux/remoteproc/
@@ -13417,7 +13417,7 @@ L:	linux-remoteproc@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ohad/rpmsg.git
 S:	Maintained
 F:	drivers/rpmsg/
-F:	Documentation/rpmsg.txt
+F:	Documentation/rpmsg.rst
 F:	Documentation/ABI/testing/sysfs-bus-rpmsg
 F:	include/linux/rpmsg.h
 F:	include/linux/rpmsg/
@@ -13503,7 +13503,7 @@ W:	http://wireless.kernel.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git
 S:	Maintained
-F:	Documentation/rfkill.txt
+F:	Documentation/rfkill.rst
 F:	Documentation/ABI/stable/sysfs-class-rfkill
 F:	net/rfkill/
 F:	include/linux/rfkill.h
@@ -15174,7 +15174,7 @@ SVGA HANDLING
 M:	Martin Mares <mj@ucw.cz>
 L:	linux-video@atrey.karlin.mff.cuni.cz
 S:	Maintained
-F:	Documentation/svga.txt
+F:	Documentation/svga.rst
 F:	arch/x86/boot/video*
 
 SWIOTLB SUBSYSTEM
@@ -15211,7 +15211,7 @@ F:	drivers/dma-buf/dma-fence*
 F:	drivers/dma-buf/sw_sync.c
 F:	include/linux/sync_file.h
 F:	include/uapi/linux/sync_file.h
-F:	Documentation/sync_file.txt
+F:	Documentation/sync_file.rst
 T:	git git://anongit.freedesktop.org/drm/drm-misc
 
 SYNOPSYS ARC ARCHITECTURE
@@ -15537,7 +15537,7 @@ S:	Maintained
 F:	include/linux/tee_drv.h
 F:	include/uapi/linux/tee.h
 F:	drivers/tee/
-F:	Documentation/tee.txt
+F:	Documentation/tee.rst
 
 TEGRA ARCHITECTURE SUPPORT
 M:	Thierry Reding <thierry.reding@gmail.com>
@@ -16706,7 +16706,7 @@ R:	Cornelia Huck <cohuck@redhat.com>
 L:	kvm@vger.kernel.org
 T:	git git://github.com/awilliam/linux-vfio.git
 S:	Maintained
-F:	Documentation/vfio.txt
+F:	Documentation/vfio.rst
 F:	drivers/vfio/
 F:	include/linux/vfio.h
 F:	include/uapi/linux/vfio.h
@@ -16715,7 +16715,7 @@ VFIO MEDIATED DEVICE DRIVERS
 M:	Kirti Wankhede <kwankhede@nvidia.com>
 L:	kvm@vger.kernel.org
 S:	Maintained
-F:	Documentation/vfio-mediated-device.txt
+F:	Documentation/vfio-mediated-device.rst
 F:	drivers/vfio/mdev/
 F:	include/linux/mdev.h
 F:	samples/vfio-mdev/
diff --git a/arch/Kconfig b/arch/Kconfig
index e8d19c3cb91f..c2f2bee5b17b 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -141,7 +141,7 @@ config HAVE_64BIT_ALIGNED_ACCESS
 	  accesses are required to be 64 bit aligned in this way even
 	  though it is not a 64 bit architecture.
 
-	  See Documentation/unaligned-memory-access.txt for more
+	  See Documentation/unaligned-memory-access.rst for more
 	  information on the topic of unaligned memory accesses.
 
 config HAVE_EFFICIENT_UNALIGNED_ACCESS
@@ -160,7 +160,7 @@ config HAVE_EFFICIENT_UNALIGNED_ACCESS
 	  problems with received packets if doing so would not help
 	  much.
 
-	  See Documentation/unaligned-memory-access.txt for more
+	  See Documentation/unaligned-memory-access.rst for more
 	  information on the topic of unaligned memory accesses.
 
 config ARCH_USE_BUILTIN_BSWAP
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 71b35159b4ce..2d0a14a4286c 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1266,7 +1266,7 @@ config SMP
 	  will run faster if you say N here.
 
 	  See also <file:Documentation/x86/i386/IO-APIC.rst>,
-	  <file:Documentation/lockup-watchdogs.txt> and the SMP-HOWTO available at
+	  <file:Documentation/lockup-watchdogs.rst> and the SMP-HOWTO available at
 	  <http://tldp.org/HOWTO/SMP-HOWTO.html>.
 
 	  If you don't know what to do here, say N.
diff --git a/arch/ia64/hp/common/sba_iommu.c b/arch/ia64/hp/common/sba_iommu.c
index 3d24cc43385b..8f97d42316e8 100644
--- a/arch/ia64/hp/common/sba_iommu.c
+++ b/arch/ia64/hp/common/sba_iommu.c
@@ -912,7 +912,7 @@ sba_mark_invalid(struct ioc *ioc, dma_addr_t iova, size_t byte_cnt)
  * @dir: dma direction
  * @attrs: optional dma attributes
  *
- * See Documentation/DMA-API-HOWTO.txt
+ * See Documentation/DMA-API-HOWTO.rst
  */
 static dma_addr_t sba_map_page(struct device *dev, struct page *page,
 			       unsigned long poff, size_t size,
@@ -1033,7 +1033,7 @@ sba_mark_clean(struct ioc *ioc, dma_addr_t iova, size_t size)
  * @dir:  R/W or both.
  * @attrs: optional dma attributes
  *
- * See Documentation/DMA-API-HOWTO.txt
+ * See Documentation/DMA-API-HOWTO.rst
  */
 static void sba_unmap_page(struct device *dev, dma_addr_t iova, size_t size,
 			   enum dma_data_direction dir, unsigned long attrs)
@@ -1110,7 +1110,7 @@ static void sba_unmap_page(struct device *dev, dma_addr_t iova, size_t size,
  * @size:  number of bytes mapped in driver buffer.
  * @dma_handle:  IOVA of new buffer.
  *
- * See Documentation/DMA-API-HOWTO.txt
+ * See Documentation/DMA-API-HOWTO.rst
  */
 static void *
 sba_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
@@ -1167,7 +1167,7 @@ sba_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
  * @vaddr:  virtual address IOVA of "consistent" buffer.
  * @dma_handler:  IO virtual address of "consistent" buffer.
  *
- * See Documentation/DMA-API-HOWTO.txt
+ * See Documentation/DMA-API-HOWTO.rst
  */
 static void sba_free_coherent(struct device *dev, size_t size, void *vaddr,
 			      dma_addr_t dma_handle, unsigned long attrs)
@@ -1430,7 +1430,7 @@ static void sba_unmap_sg_attrs(struct device *dev, struct scatterlist *sglist,
  * @dir:  R/W or both.
  * @attrs: optional dma attributes
  *
- * See Documentation/DMA-API-HOWTO.txt
+ * See Documentation/DMA-API-HOWTO.rst
  */
 static int sba_map_sg_attrs(struct device *dev, struct scatterlist *sglist,
 			    int nents, enum dma_data_direction dir,
@@ -1529,7 +1529,7 @@ static int sba_map_sg_attrs(struct device *dev, struct scatterlist *sglist,
  * @dir:  R/W or both.
  * @attrs: optional dma attributes
  *
- * See Documentation/DMA-API-HOWTO.txt
+ * See Documentation/DMA-API-HOWTO.rst
  */
 static void sba_unmap_sg_attrs(struct device *dev, struct scatterlist *sglist,
 			       int nents, enum dma_data_direction dir,
diff --git a/arch/ia64/sn/pci/pci_dma.c b/arch/ia64/sn/pci/pci_dma.c
index b7d42e4edc1f..f475fccea152 100644
--- a/arch/ia64/sn/pci/pci_dma.c
+++ b/arch/ia64/sn/pci/pci_dma.c
@@ -5,7 +5,7 @@
  *
  * Copyright (C) 2000,2002-2005 Silicon Graphics, Inc. All rights reserved.
  *
- * Routines for PCI DMA mapping.  See Documentation/DMA-API.txt for
+ * Routines for PCI DMA mapping.  See Documentation/DMA-API.rst for
  * a description of how these routines should be used.
  */
 
@@ -72,7 +72,7 @@ EXPORT_SYMBOL(sn_dma_set_mask);
  * that @dma_handle will have the %PCIIO_DMA_CMD flag set.
  *
  * This interface is usually used for "command" streams (e.g. the command
- * queue for a SCSI controller).  See Documentation/DMA-API.txt for
+ * queue for a SCSI controller).  See Documentation/DMA-API.rst for
  * more information.
  */
 static void *sn_dma_alloc_coherent(struct device *dev, size_t size,
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 4860efa91d7b..188fdf4f5080 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -275,7 +275,7 @@ config SMP
 	  machines, but will use only one CPU of a multiprocessor machine.
 	  On a uniprocessor machine, the kernel will run faster if you say N.
 
-	  See also <file:Documentation/lockup-watchdogs.txt> and the SMP-HOWTO
+	  See also <file:Documentation/lockup-watchdogs.rst> and the SMP-HOWTO
 	  available at <http://www.tldp.org/docs.html#howto>.
 
 	  If you don't know what to do here, say N.
diff --git a/arch/parisc/kernel/pci-dma.c b/arch/parisc/kernel/pci-dma.c
index 239162355b58..2bb63062f6c3 100644
--- a/arch/parisc/kernel/pci-dma.c
+++ b/arch/parisc/kernel/pci-dma.c
@@ -3,7 +3,7 @@
 ** PARISC 1.1 Dynamic DMA mapping support.
 ** This implementation is for PA-RISC platforms that do not support
 ** I/O TLBs (aka DMA address translation hardware).
-** See Documentation/DMA-API-HOWTO.txt for interface definitions.
+** See Documentation/DMA-API-HOWTO.rst for interface definitions.
 **
 **      (c) Copyright 1999,2000 Hewlett-Packard Company
 **      (c) Copyright 2000 Grant Grundler
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index c7c99e18d5ff..669adef94507 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -677,7 +677,7 @@ config SMP
 	  People using multiprocessor machines who say Y here should also say
 	  Y to "Enhanced Real Time Clock Support", below.
 
-	  See also <file:Documentation/lockup-watchdogs.txt> and the SMP-HOWTO
+	  See also <file:Documentation/lockup-watchdogs.rst> and the SMP-HOWTO
 	  available at <http://www.tldp.org/docs.html#howto>.
 
 	  If you don't know what to do here, say N.
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 8fc95c7809ef..04a3b2246a2a 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -179,7 +179,7 @@ config SMP
 	  Y to "Enhanced Real Time Clock Support", below. The "Advanced Power
 	  Management" code will be disabled if you say Y here.
 
-	  See also <file:Documentation/lockup-watchdogs.txt> and the SMP-HOWTO
+	  See also <file:Documentation/lockup-watchdogs.rst> and the SMP-HOWTO
 	  available at <http://www.tldp.org/docs.html#howto>.
 
 	  If you don't know what to do here, say N.
diff --git a/arch/unicore32/include/asm/io.h b/arch/unicore32/include/asm/io.h
index cb1d8fd2b16b..86877df4b1ee 100644
--- a/arch/unicore32/include/asm/io.h
+++ b/arch/unicore32/include/asm/io.h
@@ -31,7 +31,7 @@ extern void __uc32_iounmap(volatile void __iomem *addr);
  * ioremap and friends.
  *
  * ioremap takes a PCI memory address, as specified in
- * Documentation/io-mapping.txt.
+ * Documentation/io-mapping.rst.
  *
  */
 #define ioremap(cookie, size)		__uc32_ioremap(cookie, size)
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a5bee44cfb9d..0d5f0710347c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -397,7 +397,7 @@ config SMP
 	  Management" code will be disabled if you say Y here.
 
 	  See also <file:Documentation/x86/i386/IO-APIC.rst>,
-	  <file:Documentation/lockup-watchdogs.txt> and the SMP-HOWTO available at
+	  <file:Documentation/lockup-watchdogs.rst> and the SMP-HOWTO available at
 	  <http://www.tldp.org/docs.html#howto>.
 
 	  If you don't know what to do here, say N.
@@ -1954,7 +1954,7 @@ config EFI_STUB
           This kernel feature allows a bzImage to be loaded directly
 	  by EFI firmware without the use of a bootloader.
 
-	  See Documentation/efi-stub.txt for more information.
+	  See Documentation/efi-stub.rst for more information.
 
 config EFI_MIXED
 	bool "EFI mixed-mode support"
diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
index 6b15a24930e0..dfa443fe17c2 100644
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -3,8 +3,8 @@
 #define _ASM_X86_DMA_MAPPING_H
 
 /*
- * IOMMU interface. See Documentation/DMA-API-HOWTO.txt and
- * Documentation/DMA-API.txt for documentation.
+ * IOMMU interface. See Documentation/DMA-API-HOWTO.rst and
+ * Documentation/DMA-API.rst for documentation.
  */
 
 #include <linux/scatterlist.h>
diff --git a/arch/x86/kernel/amd_gart_64.c b/arch/x86/kernel/amd_gart_64.c
index a585ea6f686a..03108de30105 100644
--- a/arch/x86/kernel/amd_gart_64.c
+++ b/arch/x86/kernel/amd_gart_64.c
@@ -6,7 +6,7 @@
  * This allows to use PCI devices that only support 32bit addresses on systems
  * with more than 4GB.
  *
- * See Documentation/DMA-API-HOWTO.txt for the interface specification.
+ * See Documentation/DMA-API-HOWTO.rst for the interface specification.
  *
  * Copyright 2002 Andi Kleen, SuSE Labs.
  */
diff --git a/block/partitions/Kconfig b/block/partitions/Kconfig
index 37b9710cc80a..51b28e1e225d 100644
--- a/block/partitions/Kconfig
+++ b/block/partitions/Kconfig
@@ -194,7 +194,7 @@ config LDM_PARTITION
 	  Normal partitions are now called Basic Disks under Windows 2000, XP,
 	  and Vista.
 
-	  For a fuller description read <file:Documentation/ldm.txt>.
+	  For a fuller description read <file:Documentation/ldm.rst>.
 
 	  If unsure, say N.
 
diff --git a/drivers/base/core.c b/drivers/base/core.c
index b4c64528f13c..f98b33e9ec19 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1063,7 +1063,7 @@ static void device_release(struct kobject *kobj)
 	else if (dev->class && dev->class->dev_release)
 		dev->class->dev_release(dev);
 	else
-		WARN(1, KERN_ERR "Device '%s' does not have a release() function, it is broken and must be fixed. See Documentation/kobject.txt.\n",
+		WARN(1, KERN_ERR "Device '%s' does not have a release() function, it is broken and must be fixed. See Documentation/kobject.rst.\n",
 			dev_name(dev));
 	kfree(p);
 }
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index bb734066075f..ba90034f5b8f 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -291,7 +291,7 @@ config RTC
 	  and set the RTC in an SMP compatible fashion.
 
 	  If you think you have a use for such a device (such as periodic data
-	  sampling), then say Y here, and read <file:Documentation/rtc.txt>
+	  sampling), then say Y here, and read <file:Documentation/rtc.rst>
 	  for details.
 
 	  To compile this driver as a module, choose M here: the
@@ -313,7 +313,7 @@ config JS_RTC
 	  /dev/rtc.
 
 	  If you think you have a use for such a device (such as periodic data
-	  sampling), then say Y here, and read <file:Documentation/rtc.txt>
+	  sampling), then say Y here, and read <file:Documentation/rtc.rst>
 	  for details.
 
 	  To compile this driver as a module, choose M here: the
diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 95be7228f327..41acde92bedc 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -4,7 +4,7 @@
  * Copyright 2006 Michael Buesch <m@bues.ch>
  * Copyright 2005 (c) MontaVista Software, Inc.
  *
- * Please read Documentation/hw_random.txt for details on use.
+ * Please read Documentation/hw_random.rst for details on use.
  *
  * This software may be used and distributed according to the terms
  * of the GNU General Public License, incorporated herein by reference.
diff --git a/drivers/char/ipmi/Kconfig b/drivers/char/ipmi/Kconfig
index 4bad0614109b..e59ee81bc22f 100644
--- a/drivers/char/ipmi/Kconfig
+++ b/drivers/char/ipmi/Kconfig
@@ -14,7 +14,7 @@ menuconfig IPMI_HANDLER
          IPMI is a standard for managing sensors (temperature,
          voltage, etc.) in a system.
 
-         See <file:Documentation/IPMI.txt> for more details on the driver.
+         See <file:Documentation/IPMI.rst> for more details on the driver.
 
 	 If unsure, say N.
 
diff --git a/drivers/char/ipmi/ipmi_si_hotmod.c b/drivers/char/ipmi/ipmi_si_hotmod.c
index 42a925f8cf69..2032f4ac52ac 100644
--- a/drivers/char/ipmi/ipmi_si_hotmod.c
+++ b/drivers/char/ipmi/ipmi_si_hotmod.c
@@ -18,7 +18,7 @@ static int hotmod_handler(const char *val, const struct kernel_param *kp);
 
 module_param_call(hotmod, hotmod_handler, NULL, NULL, 0200);
 MODULE_PARM_DESC(hotmod, "Add and remove interfaces.  See"
-		 " Documentation/IPMI.txt in the kernel sources for the"
+		 " Documentation/IPMI.rst in the kernel sources for the"
 		 " gory details.");
 
 /*
diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index da5b6723329a..7f729609979c 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -977,7 +977,7 @@ static inline int ipmi_thread_busy_wait(enum si_sm_result smi_result,
  * that are not BT and do not have interrupts.  It starts spinning
  * when an operation is complete or until max_busy tells it to stop
  * (if that is enabled).  See the paragraph on kimid_max_busy_us in
- * Documentation/IPMI.txt for details.
+ * Documentation/IPMI.rst for details.
  */
 static int ipmi_thread(void *data)
 {
diff --git a/drivers/dma-buf/Kconfig b/drivers/dma-buf/Kconfig
index d5f915830b68..9afc7bb638c3 100644
--- a/drivers/dma-buf/Kconfig
+++ b/drivers/dma-buf/Kconfig
@@ -15,7 +15,7 @@ config SYNC_FILE
 	  associated with a buffer. When a job is submitted to the GPU a fence
 	  is attached to the buffer and is transferred via userspace, using Sync
 	  Files fds, to the DRM driver for example. More details at
-	  Documentation/sync_file.txt.
+	  Documentation/sync_file.rst.
 
 config SW_SYNC
 	bool "Sync File Validation Framework"
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index c377c989000c..85cecf58bcf5 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -1300,7 +1300,7 @@ config GPIO_BT8XX
 	  The card needs to be physically altered for using it as a
 	  GPIO card. For more information on how to build a GPIO card
 	  from a BT8xx TV card, see the documentation file at
-	  Documentation/bt8xxgpio.txt
+	  Documentation/bt8xxgpio.rst
 
 	  If unsure, say N.
 
diff --git a/drivers/parisc/sba_iommu.c b/drivers/parisc/sba_iommu.c
index 296668caf7e5..267ceb5f7838 100644
--- a/drivers/parisc/sba_iommu.c
+++ b/drivers/parisc/sba_iommu.c
@@ -666,7 +666,7 @@ sba_mark_invalid(struct ioc *ioc, dma_addr_t iova, size_t byte_cnt)
  * @dev: instance of PCI owned by the driver that's asking
  * @mask:  number of address bits this PCI device can handle
  *
- * See Documentation/DMA-API-HOWTO.txt
+ * See Documentation/DMA-API-HOWTO.rst
  */
 static int sba_dma_supported( struct device *dev, u64 mask)
 {
@@ -678,7 +678,7 @@ static int sba_dma_supported( struct device *dev, u64 mask)
 		return(0);
 	}
 
-	/* Documentation/DMA-API-HOWTO.txt tells drivers to try 64-bit
+	/* Documentation/DMA-API-HOWTO.rst tells drivers to try 64-bit
 	 * first, then fall back to 32-bit if that fails.
 	 * We are just "encouraging" 32-bit DMA masks here since we can
 	 * never allow IOMMU bypass unless we add special support for ZX1.
@@ -706,7 +706,7 @@ static int sba_dma_supported( struct device *dev, u64 mask)
  * @size:  number of bytes to map in driver buffer.
  * @direction:  R/W or both.
  *
- * See Documentation/DMA-API-HOWTO.txt
+ * See Documentation/DMA-API-HOWTO.rst
  */
 static dma_addr_t
 sba_map_single(struct device *dev, void *addr, size_t size,
@@ -796,7 +796,7 @@ sba_map_page(struct device *dev, struct page *page, unsigned long offset,
  * @size:  number of bytes mapped in driver buffer.
  * @direction:  R/W or both.
  *
- * See Documentation/DMA-API-HOWTO.txt
+ * See Documentation/DMA-API-HOWTO.rst
  */
 static void
 sba_unmap_page(struct device *dev, dma_addr_t iova, size_t size,
@@ -875,7 +875,7 @@ sba_unmap_page(struct device *dev, dma_addr_t iova, size_t size,
  * @size:  number of bytes mapped in driver buffer.
  * @dma_handle:  IOVA of new buffer.
  *
- * See Documentation/DMA-API-HOWTO.txt
+ * See Documentation/DMA-API-HOWTO.rst
  */
 static void *sba_alloc(struct device *hwdev, size_t size, dma_addr_t *dma_handle,
 		gfp_t gfp, unsigned long attrs)
@@ -906,7 +906,7 @@ static void *sba_alloc(struct device *hwdev, size_t size, dma_addr_t *dma_handle
  * @vaddr:  virtual address IOVA of "consistent" buffer.
  * @dma_handler:  IO virtual address of "consistent" buffer.
  *
- * See Documentation/DMA-API-HOWTO.txt
+ * See Documentation/DMA-API-HOWTO.rst
  */
 static void
 sba_free(struct device *hwdev, size_t size, void *vaddr,
@@ -941,7 +941,7 @@ int dump_run_sg = 0;
  * @nents:  number of entries in list
  * @direction:  R/W or both.
  *
- * See Documentation/DMA-API-HOWTO.txt
+ * See Documentation/DMA-API-HOWTO.rst
  */
 static int
 sba_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
@@ -1025,7 +1025,7 @@ sba_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
  * @nents:  number of entries in list
  * @direction:  R/W or both.
  *
- * See Documentation/DMA-API-HOWTO.txt
+ * See Documentation/DMA-API-HOWTO.rst
  */
 static void 
 sba_unmap_sg(struct device *dev, struct scatterlist *sglist, int nents,
diff --git a/drivers/pci/switch/Kconfig b/drivers/pci/switch/Kconfig
index aee28a5bb98f..c1f5226cd0e5 100644
--- a/drivers/pci/switch/Kconfig
+++ b/drivers/pci/switch/Kconfig
@@ -9,7 +9,7 @@ config PCI_SW_SWITCHTEC
 	 Enables support for the management interface for the MicroSemi
 	 Switchtec series of PCIe switches. Supports userspace access
 	 to submit MRPC commands to the switch via /dev/switchtecX
-	 devices. See <file:Documentation/switchtec.txt> for more
+	 devices. See <file:Documentation/switchtec.rst> for more
 	 information.
 
 endmenu
diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index abae73f72e75..6cd4a620115d 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -118,7 +118,7 @@ config DCDBAS
 	  Interrupts (SMIs) and Host Control Actions (system power cycle or
 	  power off after OS shutdown) on certain Dell systems.
 
-	  See <file:Documentation/dcdbas.txt> for more details on the driver
+	  See <file:Documentation/dcdbas.rst> for more details on the driver
 	  and the Dell systems on which Dell systems management software makes
 	  use of this driver.
 
@@ -259,7 +259,7 @@ config DELL_RBU
 	 DELL system. Note you need a Dell OpenManage or Dell Update package (DUP)
 	 supporting application to communicate with the BIOS regarding the new
 	 image for the image update to take effect.
-	 See <file:Documentation/dell_rbu.txt> for more details on the driver.
+	 See <file:Documentation/dell_rbu.rst> for more details on the driver.
 
 
 config FUJITSU_LAPTOP
diff --git a/drivers/platform/x86/dcdbas.c b/drivers/platform/x86/dcdbas.c
index 12cf9475ac85..ba8dff3511ec 100644
--- a/drivers/platform/x86/dcdbas.c
+++ b/drivers/platform/x86/dcdbas.c
@@ -7,7 +7,7 @@
  *  and Host Control Actions (power cycle or power off after OS shutdown) on
  *  Dell systems.
  *
- *  See Documentation/dcdbas.txt for more information.
+ *  See Documentation/dcdbas.rst for more information.
  *
  *  Copyright (C) 1995-2006 Dell Inc.
  */
diff --git a/drivers/platform/x86/dell_rbu.c b/drivers/platform/x86/dell_rbu.c
index a58fc10293ee..18400bb38e09 100644
--- a/drivers/platform/x86/dell_rbu.c
+++ b/drivers/platform/x86/dell_rbu.c
@@ -24,7 +24,7 @@
  * on every time the packet data is written. This driver requires an
  * application to break the BIOS image in to fixed sized packet chunks.
  *
- * See Documentation/dell_rbu.txt for more info.
+ * See Documentation/dell_rbu.rst for more info.
  */
 #include <linux/init.h>
 #include <linux/module.h>
diff --git a/drivers/pnp/isapnp/Kconfig b/drivers/pnp/isapnp/Kconfig
index 4b58a3dcb52b..c4ddf41c7fb8 100644
--- a/drivers/pnp/isapnp/Kconfig
+++ b/drivers/pnp/isapnp/Kconfig
@@ -7,6 +7,6 @@ config ISAPNP
 	depends on ISA || COMPILE_TEST
 	help
 	  Say Y here if you would like support for ISA Plug and Play devices.
-	  Some information is in <file:Documentation/isapnp.txt>.
+	  Some information is in <file:Documentation/isapnp.rst>.
 
 	  If unsure, say Y.
diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index e5a7a454fe17..5d6151392571 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -25,7 +25,7 @@ menuconfig VFIO
 	select VFIO_IOMMU_TYPE1 if (X86 || S390 || ARM || ARM64)
 	help
 	  VFIO provides a framework for secure userspace device drivers.
-	  See Documentation/vfio.txt for more details.
+	  See Documentation/vfio.rst for more details.
 
 	  If you don't know what to do here, say N.
 
diff --git a/drivers/vfio/mdev/Kconfig b/drivers/vfio/mdev/Kconfig
index ba94a076887f..10ec404acbfc 100644
--- a/drivers/vfio/mdev/Kconfig
+++ b/drivers/vfio/mdev/Kconfig
@@ -6,7 +6,7 @@ config VFIO_MDEV
 	default n
 	help
 	  Provides a framework to virtualize devices.
-	  See Documentation/vfio-mediated-device.txt for more details.
+	  See Documentation/vfio-mediated-device.rst for more details.
 
 	  If you don't know what do here, say N.
 
diff --git a/include/asm-generic/bitops/atomic.h b/include/asm-generic/bitops/atomic.h
index dd90c9792909..6ee11717bb65 100644
--- a/include/asm-generic/bitops/atomic.h
+++ b/include/asm-generic/bitops/atomic.h
@@ -8,7 +8,7 @@
 
 /*
  * Implementation of atomic bitops using atomic-fetch ops.
- * See Documentation/atomic_bitops.txt for details.
+ * See Documentation/atomic_bitops.rst for details.
  */
 
 static inline void set_bit(unsigned int nr, volatile unsigned long *p)
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 6309a721394b..7ff3fcd73cec 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -14,7 +14,7 @@
 
 /**
  * List of possible attributes associated with a DMA mapping. The semantics
- * of each attribute should be defined in Documentation/DMA-attributes.txt.
+ * of each attribute should be defined in Documentation/DMA-attributes.rst.
  *
  * DMA_ATTR_WRITE_BARRIER: DMA to a memory region with this attribute
  * forces all pending DMA writes to complete.
diff --git a/include/linux/hw_random.h b/include/linux/hw_random.h
index c0b93e0ff0c0..e533eac9942b 100644
--- a/include/linux/hw_random.h
+++ b/include/linux/hw_random.h
@@ -1,7 +1,7 @@
 /*
 	Hardware Random Number Generator
 
-	Please read Documentation/hw_random.txt for details on use.
+	Please read Documentation/hw_random.rst for details on use.
 
 	----------------------------------------------------------
 	This software may be used and distributed according to the terms
diff --git a/include/linux/io-mapping.h b/include/linux/io-mapping.h
index 58df02bd93c9..b90c540696a4 100644
--- a/include/linux/io-mapping.h
+++ b/include/linux/io-mapping.h
@@ -28,7 +28,7 @@
  * The io_mapping mechanism provides an abstraction for mapping
  * individual pages from an io device to the CPU in an efficient fashion.
  *
- * See Documentation/io-mapping.txt
+ * See Documentation/io-mapping.rst
  */
 
 struct io_mapping {
diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 3e113a1fa0f1..c3947cab2d27 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -68,7 +68,7 @@
  * Lacking toolchain and or architecture support, static keys fall back to a
  * simple conditional branch.
  *
- * Additional babbling in: Documentation/static-keys.txt
+ * Additional babbling in: Documentation/static-keys.rst
  */
 
 #ifndef __ASSEMBLY__
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index e2ca0a292e21..16f66fe28ec2 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -7,7 +7,7 @@
  * Copyright (c) 2006-2008 Greg Kroah-Hartman <greg@kroah.com>
  * Copyright (c) 2006-2008 Novell Inc.
  *
- * Please read Documentation/kobject.txt before using the kobject
+ * Please read Documentation/kobject.rst before using the kobject
  * interface, ESPECIALLY the parts about reference counts and object
  * destructors.
  */
diff --git a/include/linux/kobject_ns.h b/include/linux/kobject_ns.h
index 069aa2ebef90..8c86c4641739 100644
--- a/include/linux/kobject_ns.h
+++ b/include/linux/kobject_ns.h
@@ -8,7 +8,7 @@
  *
  * Split from kobject.h by David Howells (dhowells@redhat.com)
  *
- * Please read Documentation/kobject.txt before using the kobject
+ * Please read Documentation/kobject.rst before using the kobject
  * interface, ESPECIALLY the parts about reference counts and object
  * destructors.
  */
diff --git a/include/linux/rbtree.h b/include/linux/rbtree.h
index e6337fce08f2..2c579b6000a5 100644
--- a/include/linux/rbtree.h
+++ b/include/linux/rbtree.h
@@ -11,7 +11,7 @@
   I know it's not the cleaner way,  but in C (not in C++) to get
   performances and genericity...
 
-  See Documentation/rbtree.txt for documentation and samples.
+  See Documentation/rbtree.rst for documentation and samples.
 */
 
 #ifndef	_LINUX_RBTREE_H
diff --git a/include/linux/rbtree_augmented.h b/include/linux/rbtree_augmented.h
index 0f902ccb48b0..b3f64a2935ae 100644
--- a/include/linux/rbtree_augmented.h
+++ b/include/linux/rbtree_augmented.h
@@ -21,7 +21,7 @@
  * rb_insert_augmented() and rb_erase_augmented() are intended to be public.
  * The rest are implementation details you are not expected to depend on.
  *
- * See Documentation/rbtree.txt for documentation and samples.
+ * See Documentation/rbtree.rst for documentation and samples.
  */
 
 struct rb_augment_callbacks {
diff --git a/include/media/videobuf-dma-sg.h b/include/media/videobuf-dma-sg.h
index 01bd142b979d..50a549e5b477 100644
--- a/include/media/videobuf-dma-sg.h
+++ b/include/media/videobuf-dma-sg.h
@@ -34,7 +34,7 @@
  *	does memory allocation too using vmalloc_32().
  *
  * videobuf_dma_*()
- *	see Documentation/DMA-API-HOWTO.txt, these functions to
+ *	see Documentation/DMA-API-HOWTO.rst, these functions to
  *	basically the same.  The map function does also build a
  *	scatterlist for the buffer (and unmap frees it ...)
  *
diff --git a/init/Kconfig b/init/Kconfig
index 1707cf0802a7..501126df6336 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1807,7 +1807,7 @@ config MMAP_ALLOW_UNINITIALIZED
 	  userspace.  Since that isn't generally a problem on no-MMU systems,
 	  it is normally safe to say Y here.
 
-	  See Documentation/nommu-mmap.txt for more information.
+	  See Documentation/nommu-mmap.rst for more information.
 
 config SYSTEM_DATA_VERIFICATION
 	def_bool n
diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
index 099002d84f46..616919c774a5 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -1069,7 +1069,7 @@ static void check_unmap(struct dma_debug_entry *ref)
 	/*
 	 * Drivers should use dma_mapping_error() to check the returned
 	 * addresses of dma_map_single() and dma_map_page().
-	 * If not, print this warning message. See Documentation/DMA-API.txt.
+	 * If not, print this warning message. See Documentation/DMA-API.rst.
 	 */
 	if (entry->map_err_type == MAP_ERR_NOT_CHECKED) {
 		err_printk(ref->dev, entry,
diff --git a/kernel/padata.c b/kernel/padata.c
index 2d2fddbb7a4c..a567973bb1ba 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -2,7 +2,7 @@
 /*
  * padata.c - generic interface to process data streams in parallel
  *
- * See Documentation/padata.txt for an api documentation.
+ * See Documentation/padata.rst for an api documentation.
  *
  * Copyright (C) 2008, 2009 secunet Security Networks AG
  * Copyright (C) 2008, 2009 Steffen Klassert <steffen.klassert@secunet.com>
diff --git a/lib/Kconfig b/lib/Kconfig
index 90623a0e1942..58e9dae6f424 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -420,7 +420,7 @@ config INTERVAL_TREE
 
 	  See:
 
-		Documentation/rbtree.txt
+		Documentation/rbtree.rst
 
 	  for more information.
 
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 45c37f5c96ea..ce47efa5f4e4 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1682,7 +1682,7 @@ config PROVIDE_OHCI1394_DMA_INIT
 	  This code (~1k) is freed after boot. By then, the firewire stack
 	  in charge of the OHCI-1394 controllers should be used instead.
 
-	  See Documentation/debugging-via-ohci1394.txt for more information.
+	  See Documentation/debugging-via-ohci1394.rst for more information.
 
 menuconfig RUNTIME_TESTING_MENU
 	bool "Runtime Testing"
diff --git a/lib/crc32.c b/lib/crc32.c
index 4a20455d1f61..0de37ccc70dd 100644
--- a/lib/crc32.c
+++ b/lib/crc32.c
@@ -24,7 +24,7 @@
  * Version 2.  See the file COPYING for more details.
  */
 
-/* see: Documentation/crc32.txt for a description of algorithms */
+/* see: Documentation/crc32.rst for a description of algorithms */
 
 #include <linux/crc32.h>
 #include <linux/crc32poly.h>
diff --git a/lib/kobject.c b/lib/kobject.c
index f2ccdbac8ed9..03157ff88495 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -6,7 +6,7 @@
  * Copyright (c) 2006-2007 Greg Kroah-Hartman <greg@kroah.com>
  * Copyright (c) 2006-2007 Novell Inc.
  *
- * Please see the file Documentation/kobject.txt for critical information
+ * Please see the file Documentation/kobject.rst for critical information
  * about using the kobject interface.
  */
 
@@ -668,7 +668,7 @@ static void kobject_cleanup(struct kobject *kobj)
 		 kobject_name(kobj), kobj, __func__, kobj->parent);
 
 	if (t && !t->release)
-		pr_debug("kobject: '%s' (%p): does not have a release() function, it is broken and must be fixed. See Documentation/kobject.txt.\n",
+		pr_debug("kobject: '%s' (%p): does not have a release() function, it is broken and must be fixed. See Documentation/kobject.rst.\n",
 			 kobject_name(kobj), kobj);
 
 	/* send "remove" if the caller did not do it but sent "add" */
diff --git a/lib/lzo/lzo1x_decompress_safe.c b/lib/lzo/lzo1x_decompress_safe.c
index 2717c7963acd..1642c28e6627 100644
--- a/lib/lzo/lzo1x_decompress_safe.c
+++ b/lib/lzo/lzo1x_decompress_safe.c
@@ -32,7 +32,7 @@
  * depending on the base count. Since the base count is taken from a u8
  * and a few bits, it is safe to assume that it will always be lower than
  * or equal to 2*255, thus we can always prevent any overflow by accepting
- * two less 255 steps. See Documentation/lzo.txt for more information.
+ * two less 255 steps. See Documentation/lzo.rst for more information.
  */
 #define MAX_255_COUNT      ((((size_t)~0) / 255) - 2)
 
diff --git a/lib/xz/Kconfig b/lib/xz/Kconfig
index 22528743d4ce..314a89c13545 100644
--- a/lib/xz/Kconfig
+++ b/lib/xz/Kconfig
@@ -5,7 +5,7 @@ config XZ_DEC
 	help
 	  LZMA2 compression algorithm and BCJ filters are supported using
 	  the .xz file format as the container. For integrity checking,
-	  CRC32 is supported. See Documentation/xz.txt for more information.
+	  CRC32 is supported. See Documentation/xz.rst for more information.
 
 if XZ_DEC
 
diff --git a/mm/Kconfig b/mm/Kconfig
index 7c41d2300e07..ed5fe68590f4 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -369,7 +369,7 @@ config NOMMU_INITIAL_TRIM_EXCESS
 	  This option specifies the initial value of this option.  The default
 	  of 1 says that all excess pages should be trimmed.
 
-	  See Documentation/nommu-mmap.txt for more information.
+	  See Documentation/nommu-mmap.rst for more information.
 
 config TRANSPARENT_HUGEPAGE
 	bool "Transparent Hugepage Support"
diff --git a/mm/nommu.c b/mm/nommu.c
index b2823519f8cd..30a071ba838d 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -5,7 +5,7 @@
  *  Replacement code for mm functions to support CPU's that don't
  *  have any form of memory management unit (thus no virtual memory).
  *
- *  See Documentation/nommu-mmap.txt
+ *  See Documentation/nommu-mmap.rst
  *
  *  Copyright (c) 2004-2008 David Howells <dhowells@redhat.com>
  *  Copyright (c) 2000-2003 David McCullough <davidm@snapgear.com>
diff --git a/samples/kprobes/kprobe_example.c b/samples/kprobes/kprobe_example.c
index d693c23a85e8..d76fd05304a5 100644
--- a/samples/kprobes/kprobe_example.c
+++ b/samples/kprobes/kprobe_example.c
@@ -5,7 +5,7 @@
  * stack trace and selected registers when _do_fork() is called.
  *
  * For more information on theory of operation of kprobes, see
- * Documentation/kprobes.txt
+ * Documentation/kprobes.rst
  *
  * You will see the trace data in /var/log/messages and on the console
  * whenever _do_fork() is invoked to create a new process.
diff --git a/samples/kprobes/kretprobe_example.c b/samples/kprobes/kretprobe_example.c
index 186315ca88b3..9a2234ae0286 100644
--- a/samples/kprobes/kretprobe_example.c
+++ b/samples/kprobes/kretprobe_example.c
@@ -11,7 +11,7 @@
  * If no func_name is specified, _do_fork is instrumented
  *
  * For more information on theory of operation of kretprobes, see
- * Documentation/kprobes.txt
+ * Documentation/kprobes.rst
  *
  * Build and insert the kernel module as done in the kprobe example.
  * You will see the trace data in /var/log/messages and on the console
diff --git a/scripts/gcc-plugins/Kconfig b/scripts/gcc-plugins/Kconfig
index e9c677a53c74..b4dc5b116bfe 100644
--- a/scripts/gcc-plugins/Kconfig
+++ b/scripts/gcc-plugins/Kconfig
@@ -23,7 +23,7 @@ config GCC_PLUGINS
 	  GCC plugins are loadable modules that provide extra features to the
 	  compiler. They are useful for runtime instrumentation and static analysis.
 
-	  See Documentation/gcc-plugins.txt for details.
+	  See Documentation/gcc-plugins.rst for details.
 
 menu "GCC plugins"
 	depends on GCC_PLUGINS
diff --git a/security/Kconfig b/security/Kconfig
index 06a30851511a..4da0d09c3e49 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -121,7 +121,7 @@ config INTEL_TXT
 	  See <http://www.intel.com/technology/security/> for more information
 	  about Intel(R) TXT.
 	  See <http://tboot.sourceforge.net> for more information about tboot.
-	  See Documentation/intel_txt.txt for a description of how to enable
+	  See Documentation/intel_txt.rst for a description of how to enable
 	  Intel TXT support in a kernel boot.
 
 	  If you are unsure as to whether this is required, answer N.
diff --git a/tools/include/linux/rbtree.h b/tools/include/linux/rbtree.h
index d83763a5327c..e96d7120ce2b 100644
--- a/tools/include/linux/rbtree.h
+++ b/tools/include/linux/rbtree.h
@@ -11,7 +11,7 @@
   I know it's not the cleaner way,  but in C (not in C++) to get
   performances and genericity...
 
-  See Documentation/rbtree.txt for documentation and samples.
+  See Documentation/rbtree.rst for documentation and samples.
 */
 
 #ifndef __TOOLS_LINUX_PERF_RBTREE_H
diff --git a/tools/include/linux/rbtree_augmented.h b/tools/include/linux/rbtree_augmented.h
index ddd01006ece5..c251bb16f2e9 100644
--- a/tools/include/linux/rbtree_augmented.h
+++ b/tools/include/linux/rbtree_augmented.h
@@ -23,7 +23,7 @@
  * rb_insert_augmented() and rb_erase_augmented() are intended to be public.
  * The rest are implementation details you are not expected to depend on.
  *
- * See Documentation/rbtree.txt for documentation and samples.
+ * See Documentation/rbtree.rst for documentation and samples.
  */
 
 struct rb_augment_callbacks {
-- 
2.21.0

