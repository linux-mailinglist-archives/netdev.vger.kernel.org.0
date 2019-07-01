Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 242914ACC7
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 23:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730999AbfFRVG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 17:06:29 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:34754 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730852AbfFRVF4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 17:05:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
        To:From:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=FISmA4+yooQYp3UXQ1RSWHaYngXi1oOul8B4uyUy5LE=; b=PSJTf+ybuqVO2Rt29OuvJXzN+S
        0KaaHzpgf1WzI7BpGiGlhRg435AgTjDzbKuSCvKpz8H61ttb+lIpYvJZmvnGGQva7XThVn0ASLdFO
        9Sv0WxVy86ltUJNKalEO05AmMVzziCwwlqvDvuIilZ0XFgMWHZohbPsDuq6DbpuMUZ5hVKe8UKJdB
        cdSxcGn+p3zCCT7zRTbtaWEx86QtRiVcFMv7k2KHn+aAhpmUsSQskpjRtBcp/E0lykGIQFuoLZ2Y3
        Q3ZxPkahCCqsKocpkHHgvWrMnCriIMxK4DkNKT1Ssce+IYyScqgPdAaTh9WUWR2GG+xKPFBHd4Wpn
        N2UAMvvg==;
Received: from 177.133.86.196.dynamic.adsl.gvt.net.br ([177.133.86.196] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hdLIc-0006yu-Ff; Tue, 18 Jun 2019 21:05:52 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1hdLIZ-0002CX-VH; Tue, 18 Jun 2019 18:05:47 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        linux-wireless@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-arch@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        kernel-hardening@lists.openwall.com,
        linux-remoteproc@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linux-pwm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        linux-gpio@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v1 12/22] docs: driver-api: add .rst files from the main dir
Date:   Tue, 18 Jun 2019 18:05:36 -0300
Message-Id: <b0d24e805d5368719cc64e8104d64ee9b5b89dd0.1560891322.git.mchehab+samsung@kernel.org>
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

Those files belong to the driver-api guide. Add them to the
driver-api book.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---

I had to remove the long list of maintainers got by
getpatch.pl, as it was too long. I opted to keep only the
mailing lists.

 Documentation/ABI/removed/sysfs-class-rfkill  |  2 +-
 Documentation/ABI/stable/sysfs-class-rfkill   |  2 +-
 .../ABI/testing/sysfs-class-switchtec         |  2 +-
 Documentation/PCI/pci.rst                     |  2 +-
 Documentation/admin-guide/hw-vuln/l1tf.rst    |  2 +-
 .../admin-guide/kernel-parameters.txt         |  4 +-
 .../admin-guide/kernel-per-cpu-kthreads.rst   |  2 +-
 .../{ => driver-api}/atomic_bitops.rst        |  2 -
 Documentation/{ => driver-api}/bt8xxgpio.rst  |  2 -
 .../bus-virt-phys-mapping.rst                 |  2 -
 .../{connector => driver-api}/connector.rst   |  2 -
 .../{console => driver-api}/console.rst       |  2 -
 Documentation/{ => driver-api}/crc32.rst      |  2 -
 Documentation/{ => driver-api}/dcdbas.rst     |  2 -
 .../{ => driver-api}/debugging-modules.rst    |  2 -
 .../debugging-via-ohci1394.rst                |  2 -
 Documentation/{ => driver-api}/dell_rbu.rst   |  2 -
 Documentation/{ => driver-api}/digsig.rst     |  2 -
 .../{EDID/howto.rst => driver-api/edid.rst}   |  2 -
 Documentation/{ => driver-api}/eisa.rst       |  2 -
 .../{ => driver-api}/futex-requeue-pi.rst     |  2 -
 .../{ => driver-api}/gcc-plugins.rst          |  2 -
 Documentation/{ => driver-api}/hwspinlock.rst |  2 -
 Documentation/driver-api/index.rst            | 66 +++++++++++++++++++
 Documentation/{ => driver-api}/io-mapping.rst |  2 -
 .../{ => driver-api}/io_ordering.rst          |  2 -
 .../{IPMI.rst => driver-api/ipmi.rst}         |  2 -
 .../irq-affinity.rst}                         |  2 -
 .../irq-domain.rst}                           |  2 -
 Documentation/{IRQ.rst => driver-api/irq.rst} |  2 -
 .../{ => driver-api}/irqflags-tracing.rst     |  2 -
 Documentation/{ => driver-api}/isa.rst        |  2 -
 Documentation/{ => driver-api}/isapnp.rst     |  2 -
 Documentation/{ => driver-api}/kobject.rst    |  4 +-
 Documentation/{ => driver-api}/kprobes.rst    |  2 -
 Documentation/{ => driver-api}/kref.rst       |  2 -
 .../pblk.txt => driver-api/lightnvm-pblk.rst} |  0
 Documentation/{ => driver-api}/lzo.rst        |  2 -
 Documentation/{ => driver-api}/mailbox.rst    |  2 -
 .../{ => driver-api}/men-chameleon-bus.rst    |  2 -
 Documentation/{ => driver-api}/nommu-mmap.rst |  2 -
 Documentation/{ => driver-api}/ntb.rst        |  2 -
 Documentation/{nvmem => driver-api}/nvmem.rst |  2 -
 Documentation/{ => driver-api}/padata.rst     |  2 -
 .../{ => driver-api}/parport-lowlevel.rst     |  2 -
 .../{ => driver-api}/percpu-rw-semaphore.rst  |  2 -
 Documentation/{ => driver-api}/pi-futex.rst   |  2 -
 Documentation/driver-api/pps.rst              |  2 -
 .../{ => driver-api}/preempt-locking.rst      |  2 -
 .../{pti => driver-api}/pti_intel_mid.rst     |  2 -
 Documentation/driver-api/ptp.rst              |  2 -
 Documentation/{ => driver-api}/pwm.rst        |  2 -
 Documentation/{ => driver-api}/rbtree.rst     |  2 -
 Documentation/{ => driver-api}/remoteproc.rst |  4 +-
 Documentation/{ => driver-api}/rfkill.rst     |  2 -
 .../{ => driver-api}/robust-futex-ABI.rst     |  2 -
 .../{ => driver-api}/robust-futexes.rst       |  2 -
 Documentation/{ => driver-api}/rpmsg.rst      |  2 -
 Documentation/{ => driver-api}/sgi-ioc4.rst   |  2 -
 .../{SM501.rst => driver-api/sm501.rst}       |  2 -
 .../{ => driver-api}/smsc_ece1099.rst         |  2 -
 .../{ => driver-api}/speculation.rst          |  8 +--
 .../{ => driver-api}/static-keys.rst          |  2 -
 Documentation/{ => driver-api}/switchtec.rst  |  4 +-
 Documentation/{ => driver-api}/sync_file.rst  |  2 -
 Documentation/{ => driver-api}/tee.rst        |  2 -
 .../{ => driver-api}/this_cpu_ops.rst         |  2 -
 .../unaligned-memory-access.rst               |  2 -
 .../{ => driver-api}/vfio-mediated-device.rst |  4 +-
 Documentation/{ => driver-api}/vfio.rst       |  2 -
 Documentation/{ => driver-api}/xillybus.rst   |  2 -
 Documentation/{ => driver-api}/xz.rst         |  2 -
 Documentation/{ => driver-api}/zorro.rst      |  2 -
 Documentation/driver-model/device.rst         |  2 +-
 Documentation/fb/fbcon.rst                    |  4 +-
 Documentation/filesystems/sysfs.txt           |  2 +-
 Documentation/gpu/drm-mm.rst                  |  2 +-
 Documentation/ia64/irq-redir.rst              |  2 +-
 Documentation/laptops/thinkpad-acpi.rst       |  6 +-
 Documentation/locking/rt-mutex.rst            |  2 +-
 Documentation/networking/scaling.rst          |  4 +-
 Documentation/s390/vfio-ccw.rst               |  6 +-
 Documentation/sysctl/kernel.rst               |  2 +-
 Documentation/sysctl/vm.rst                   |  2 +-
 Documentation/trace/kprobetrace.rst           |  2 +-
 Documentation/translations/zh_CN/IRQ.txt      |  4 +-
 .../translations/zh_CN/filesystems/sysfs.txt  |  2 +-
 .../translations/zh_CN/io_ordering.txt        |  4 +-
 Documentation/w1/w1.netlink                   |  2 +-
 Documentation/watchdog/hpwdt.rst              |  2 +-
 MAINTAINERS                                   | 46 ++++++-------
 arch/Kconfig                                  |  4 +-
 arch/unicore32/include/asm/io.h               |  2 +-
 drivers/base/core.c                           |  2 +-
 drivers/char/ipmi/Kconfig                     |  2 +-
 drivers/char/ipmi/ipmi_si_hotmod.c            |  2 +-
 drivers/char/ipmi/ipmi_si_intf.c              |  2 +-
 drivers/dma-buf/Kconfig                       |  2 +-
 drivers/gpio/Kconfig                          |  2 +-
 drivers/gpu/drm/Kconfig                       |  2 +-
 drivers/pci/switch/Kconfig                    |  2 +-
 drivers/platform/x86/Kconfig                  |  4 +-
 drivers/platform/x86/dcdbas.c                 |  2 +-
 drivers/platform/x86/dell_rbu.c               |  2 +-
 drivers/pnp/isapnp/Kconfig                    |  2 +-
 drivers/tty/Kconfig                           |  2 +-
 drivers/vfio/Kconfig                          |  2 +-
 drivers/vfio/mdev/Kconfig                     |  2 +-
 drivers/w1/Kconfig                            |  2 +-
 include/asm-generic/bitops/atomic.h           |  2 +-
 include/linux/io-mapping.h                    |  2 +-
 include/linux/jump_label.h                    |  2 +-
 include/linux/kobject.h                       |  2 +-
 include/linux/kobject_ns.h                    |  2 +-
 include/linux/rbtree.h                        |  2 +-
 include/linux/rbtree_augmented.h              |  2 +-
 init/Kconfig                                  |  2 +-
 kernel/padata.c                               |  2 +-
 lib/Kconfig                                   |  2 +-
 lib/Kconfig.debug                             |  2 +-
 lib/crc32.c                                   |  2 +-
 lib/kobject.c                                 |  4 +-
 lib/lzo/lzo1x_decompress_safe.c               |  2 +-
 lib/xz/Kconfig                                |  2 +-
 mm/Kconfig                                    |  2 +-
 mm/nommu.c                                    |  2 +-
 samples/Kconfig                               |  2 +-
 samples/kprobes/kprobe_example.c              |  2 +-
 samples/kprobes/kretprobe_example.c           |  2 +-
 scripts/gcc-plugins/Kconfig                   |  2 +-
 tools/include/linux/rbtree.h                  |  2 +-
 tools/include/linux/rbtree_augmented.h        |  2 +-
 132 files changed, 173 insertions(+), 235 deletions(-)
 rename Documentation/{ => driver-api}/atomic_bitops.rst (99%)
 rename Documentation/{ => driver-api}/bt8xxgpio.rst (99%)
 rename Documentation/{ => driver-api}/bus-virt-phys-mapping.rst (99%)
 rename Documentation/{connector => driver-api}/connector.rst (99%)
 rename Documentation/{console => driver-api}/console.rst (99%)
 rename Documentation/{ => driver-api}/crc32.rst (99%)
 rename Documentation/{ => driver-api}/dcdbas.rst (99%)
 rename Documentation/{ => driver-api}/debugging-modules.rst (98%)
 rename Documentation/{ => driver-api}/debugging-via-ohci1394.rst (99%)
 rename Documentation/{ => driver-api}/dell_rbu.rst (99%)
 rename Documentation/{ => driver-api}/digsig.rst (99%)
 rename Documentation/{EDID/howto.rst => driver-api/edid.rst} (99%)
 rename Documentation/{ => driver-api}/eisa.rst (99%)
 rename Documentation/{ => driver-api}/futex-requeue-pi.rst (99%)
 rename Documentation/{ => driver-api}/gcc-plugins.rst (99%)
 rename Documentation/{ => driver-api}/hwspinlock.rst (99%)
 rename Documentation/{ => driver-api}/io-mapping.rst (99%)
 rename Documentation/{ => driver-api}/io_ordering.rst (99%)
 rename Documentation/{IPMI.rst => driver-api/ipmi.rst} (99%)
 rename Documentation/{IRQ-affinity.rst => driver-api/irq-affinity.rst} (99%)
 rename Documentation/{IRQ-domain.rst => driver-api/irq-domain.rst} (99%)
 rename Documentation/{IRQ.rst => driver-api/irq.rst} (99%)
 rename Documentation/{ => driver-api}/irqflags-tracing.rst (99%)
 rename Documentation/{ => driver-api}/isa.rst (99%)
 rename Documentation/{ => driver-api}/isapnp.rst (98%)
 rename Documentation/{ => driver-api}/kobject.rst (99%)
 rename Documentation/{ => driver-api}/kprobes.rst (99%)
 rename Documentation/{ => driver-api}/kref.rst (99%)
 rename Documentation/{lightnvm/pblk.txt => driver-api/lightnvm-pblk.rst} (100%)
 rename Documentation/{ => driver-api}/lzo.rst (99%)
 rename Documentation/{ => driver-api}/mailbox.rst (99%)
 rename Documentation/{ => driver-api}/men-chameleon-bus.rst (99%)
 rename Documentation/{ => driver-api}/nommu-mmap.rst (99%)
 rename Documentation/{ => driver-api}/ntb.rst (99%)
 rename Documentation/{nvmem => driver-api}/nvmem.rst (99%)
 rename Documentation/{ => driver-api}/padata.rst (99%)
 rename Documentation/{ => driver-api}/parport-lowlevel.rst (99%)
 rename Documentation/{ => driver-api}/percpu-rw-semaphore.rst (99%)
 rename Documentation/{ => driver-api}/pi-futex.rst (99%)
 rename Documentation/{ => driver-api}/preempt-locking.rst (99%)
 rename Documentation/{pti => driver-api}/pti_intel_mid.rst (99%)
 rename Documentation/{ => driver-api}/pwm.rst (99%)
 rename Documentation/{ => driver-api}/rbtree.rst (99%)
 rename Documentation/{ => driver-api}/remoteproc.rst (99%)
 rename Documentation/{ => driver-api}/rfkill.rst (99%)
 rename Documentation/{ => driver-api}/robust-futex-ABI.rst (99%)
 rename Documentation/{ => driver-api}/robust-futexes.rst (99%)
 rename Documentation/{ => driver-api}/rpmsg.rst (99%)
 rename Documentation/{ => driver-api}/sgi-ioc4.rst (99%)
 rename Documentation/{SM501.rst => driver-api/sm501.rst} (99%)
 rename Documentation/{ => driver-api}/smsc_ece1099.rst (99%)
 rename Documentation/{ => driver-api}/speculation.rst (99%)
 rename Documentation/{ => driver-api}/static-keys.rst (99%)
 rename Documentation/{ => driver-api}/switchtec.rst (97%)
 rename Documentation/{ => driver-api}/sync_file.rst (99%)
 rename Documentation/{ => driver-api}/tee.rst (99%)
 rename Documentation/{ => driver-api}/this_cpu_ops.rst (99%)
 rename Documentation/{ => driver-api}/unaligned-memory-access.rst (99%)
 rename Documentation/{ => driver-api}/vfio-mediated-device.rst (99%)
 rename Documentation/{ => driver-api}/vfio.rst (99%)
 rename Documentation/{ => driver-api}/xillybus.rst (99%)
 rename Documentation/{ => driver-api}/xz.rst (99%)
 rename Documentation/{ => driver-api}/zorro.rst (99%)

diff --git a/Documentation/ABI/removed/sysfs-class-rfkill b/Documentation/ABI/removed/sysfs-class-rfkill
index 1652b2381dda..9c08c7f98ffb 100644
--- a/Documentation/ABI/removed/sysfs-class-rfkill
+++ b/Documentation/ABI/removed/sysfs-class-rfkill
@@ -1,6 +1,6 @@
 rfkill - radio frequency (RF) connector kill switch support
 
-For details to this subsystem look at Documentation/rfkill.rst.
+For details to this subsystem look at Documentation/driver-api/rfkill.rst.
 
 What:		/sys/class/rfkill/rfkill[0-9]+/claim
 Date:		09-Jul-2007
diff --git a/Documentation/ABI/stable/sysfs-class-rfkill b/Documentation/ABI/stable/sysfs-class-rfkill
index 68fd0afdad0d..5b154f922643 100644
--- a/Documentation/ABI/stable/sysfs-class-rfkill
+++ b/Documentation/ABI/stable/sysfs-class-rfkill
@@ -1,6 +1,6 @@
 rfkill - radio frequency (RF) connector kill switch support
 
-For details to this subsystem look at Documentation/rfkill.rst.
+For details to this subsystem look at Documentation/driver-api/rfkill.rst.
 
 For the deprecated /sys/class/rfkill/*/claim knobs of this interface look in
 Documentation/ABI/removed/sysfs-class-rfkill.
diff --git a/Documentation/ABI/testing/sysfs-class-switchtec b/Documentation/ABI/testing/sysfs-class-switchtec
index c8d80db1e32c..76c7a661a595 100644
--- a/Documentation/ABI/testing/sysfs-class-switchtec
+++ b/Documentation/ABI/testing/sysfs-class-switchtec
@@ -1,6 +1,6 @@
 switchtec - Microsemi Switchtec PCI Switch Management Endpoint
 
-For details on this subsystem look at Documentation/switchtec.rst.
+For details on this subsystem look at Documentation/driver-api/switchtec.rst.
 
 What: 		/sys/class/switchtec
 Date:		05-Jan-2017
diff --git a/Documentation/PCI/pci.rst b/Documentation/PCI/pci.rst
index 840cbf5f37a7..0f52d172c9ac 100644
--- a/Documentation/PCI/pci.rst
+++ b/Documentation/PCI/pci.rst
@@ -239,7 +239,7 @@ from the PCI device config space. Use the values in the pci_dev structure
 as the PCI "bus address" might have been remapped to a "host physical"
 address by the arch/chip-set specific kernel support.
 
-See Documentation/io-mapping.rst for how to access device registers
+See Documentation/driver-api/io-mapping.rst for how to access device registers
 or device memory.
 
 The device driver needs to call pci_request_region() to verify
diff --git a/Documentation/admin-guide/hw-vuln/l1tf.rst b/Documentation/admin-guide/hw-vuln/l1tf.rst
index 9b1e6aafea1f..29449ba7773c 100644
--- a/Documentation/admin-guide/hw-vuln/l1tf.rst
+++ b/Documentation/admin-guide/hw-vuln/l1tf.rst
@@ -268,7 +268,7 @@ Guest mitigation mechanisms
    /proc/irq/$NR/smp_affinity[_list] files. Limited documentation is
    available at:
 
-   https://www.kernel.org/doc/Documentation/IRQ-affinity.rst
+   https://www.kernel.org/doc/Documentation/driver-api/irq-affinity.rst
 
 .. _smt_control:
 
diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 95885726778c..2f8751323f6d 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -930,7 +930,7 @@
 			edid/1680x1050.bin, or edid/1920x1080.bin is given
 			and no file with the same name exists. Details and
 			instructions how to build your own EDID data are
-			available in Documentation/EDID/howto.rst. An EDID
+			available in Documentation/driver-api/edid.rst. An EDID
 			data set will only be used for a particular connector,
 			if its name and a colon are prepended to the EDID
 			name. Each connector may use a unique EDID data
@@ -3162,7 +3162,7 @@
 			See Documentation/sysctl/vm.rst for details.
 
 	ohci1394_dma=early	[HW] enable debugging via the ohci1394 driver.
-			See Documentation/debugging-via-ohci1394.rst for more
+			See Documentation/driver-api/debugging-via-ohci1394.rst for more
 			info.
 
 	olpc_ec_timeout= [OLPC] ms delay when issuing EC commands
diff --git a/Documentation/admin-guide/kernel-per-cpu-kthreads.rst b/Documentation/admin-guide/kernel-per-cpu-kthreads.rst
index d430048a0307..942b7835b9f6 100644
--- a/Documentation/admin-guide/kernel-per-cpu-kthreads.rst
+++ b/Documentation/admin-guide/kernel-per-cpu-kthreads.rst
@@ -10,7 +10,7 @@ them to a "housekeeping" CPU dedicated to such work.
 References
 ==========
 
--	Documentation/IRQ-affinity.rst:  Binding interrupts to sets of CPUs.
+-	Documentation/driver-api/irq-affinity.rst:  Binding interrupts to sets of CPUs.
 
 -	Documentation/admin-guide/cgroup-v1:  Using cgroups to bind tasks to sets of CPUs.
 
diff --git a/Documentation/atomic_bitops.rst b/Documentation/driver-api/atomic_bitops.rst
similarity index 99%
rename from Documentation/atomic_bitops.rst
rename to Documentation/driver-api/atomic_bitops.rst
index b683bcb71185..7c7d33ee64f7 100644
--- a/Documentation/atomic_bitops.rst
+++ b/Documentation/driver-api/atomic_bitops.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 =============
 Atomic bitops
 =============
diff --git a/Documentation/bt8xxgpio.rst b/Documentation/driver-api/bt8xxgpio.rst
similarity index 99%
rename from Documentation/bt8xxgpio.rst
rename to Documentation/driver-api/bt8xxgpio.rst
index 093875e1b0aa..4f937bead52c 100644
--- a/Documentation/bt8xxgpio.rst
+++ b/Documentation/driver-api/bt8xxgpio.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ===================================================================
 A driver for a selfmade cheap BT8xx based PCI GPIO-card (bt8xxgpio)
 ===================================================================
diff --git a/Documentation/bus-virt-phys-mapping.rst b/Documentation/driver-api/bus-virt-phys-mapping.rst
similarity index 99%
rename from Documentation/bus-virt-phys-mapping.rst
rename to Documentation/driver-api/bus-virt-phys-mapping.rst
index eefb0ae99ba8..80972916e88c 100644
--- a/Documentation/bus-virt-phys-mapping.rst
+++ b/Documentation/driver-api/bus-virt-phys-mapping.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ==========================================================
 How to access I/O mapped memory from within device drivers
 ==========================================================
diff --git a/Documentation/connector/connector.rst b/Documentation/driver-api/connector.rst
similarity index 99%
rename from Documentation/connector/connector.rst
rename to Documentation/driver-api/connector.rst
index 24e26dc22dbf..2cf9b5adfe2a 100644
--- a/Documentation/connector/connector.rst
+++ b/Documentation/driver-api/connector.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ================
 Kernel Connector
 ================
diff --git a/Documentation/console/console.rst b/Documentation/driver-api/console.rst
similarity index 99%
rename from Documentation/console/console.rst
rename to Documentation/driver-api/console.rst
index b374141b027e..8b0205d27a71 100644
--- a/Documentation/console/console.rst
+++ b/Documentation/driver-api/console.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ===============
 Console Drivers
 ===============
diff --git a/Documentation/crc32.rst b/Documentation/driver-api/crc32.rst
similarity index 99%
rename from Documentation/crc32.rst
rename to Documentation/driver-api/crc32.rst
index f7c73d713a35..8a6860f33b4e 100644
--- a/Documentation/crc32.rst
+++ b/Documentation/driver-api/crc32.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 =================================
 brief tutorial on CRC computation
 =================================
diff --git a/Documentation/dcdbas.rst b/Documentation/driver-api/dcdbas.rst
similarity index 99%
rename from Documentation/dcdbas.rst
rename to Documentation/driver-api/dcdbas.rst
index abbc2bfd58a7..309cc57a7c1c 100644
--- a/Documentation/dcdbas.rst
+++ b/Documentation/driver-api/dcdbas.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ===================================
 Dell Systems Management Base Driver
 ===================================
diff --git a/Documentation/debugging-modules.rst b/Documentation/driver-api/debugging-modules.rst
similarity index 98%
rename from Documentation/debugging-modules.rst
rename to Documentation/driver-api/debugging-modules.rst
index 994f4b021a81..172ad4aec493 100644
--- a/Documentation/debugging-modules.rst
+++ b/Documentation/driver-api/debugging-modules.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 Debugging Modules after 2.6.3
 -----------------------------
 
diff --git a/Documentation/debugging-via-ohci1394.rst b/Documentation/driver-api/debugging-via-ohci1394.rst
similarity index 99%
rename from Documentation/debugging-via-ohci1394.rst
rename to Documentation/driver-api/debugging-via-ohci1394.rst
index ead0196d94b7..981ad4f89fd3 100644
--- a/Documentation/debugging-via-ohci1394.rst
+++ b/Documentation/driver-api/debugging-via-ohci1394.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ===========================================================================
 Using physical DMA provided by OHCI-1394 FireWire controllers for debugging
 ===========================================================================
diff --git a/Documentation/dell_rbu.rst b/Documentation/driver-api/dell_rbu.rst
similarity index 99%
rename from Documentation/dell_rbu.rst
rename to Documentation/driver-api/dell_rbu.rst
index 45cd18abd98f..f3bfa1a17961 100644
--- a/Documentation/dell_rbu.rst
+++ b/Documentation/driver-api/dell_rbu.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 =============================================================
 Usage of the new open sourced rbu (Remote BIOS Update) driver
 =============================================================
diff --git a/Documentation/digsig.rst b/Documentation/driver-api/digsig.rst
similarity index 99%
rename from Documentation/digsig.rst
rename to Documentation/driver-api/digsig.rst
index 3597711d0df1..f6a8902d3ef7 100644
--- a/Documentation/digsig.rst
+++ b/Documentation/driver-api/digsig.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ==================================
 Digital Signature Verification API
 ==================================
diff --git a/Documentation/EDID/howto.rst b/Documentation/driver-api/edid.rst
similarity index 99%
rename from Documentation/EDID/howto.rst
rename to Documentation/driver-api/edid.rst
index 725fd49a88ca..9a9b512e0ac9 100644
--- a/Documentation/EDID/howto.rst
+++ b/Documentation/driver-api/edid.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ====
 EDID
 ====
diff --git a/Documentation/eisa.rst b/Documentation/driver-api/eisa.rst
similarity index 99%
rename from Documentation/eisa.rst
rename to Documentation/driver-api/eisa.rst
index d98949908405..f388545a85a7 100644
--- a/Documentation/eisa.rst
+++ b/Documentation/driver-api/eisa.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ================
 EISA bus support
 ================
diff --git a/Documentation/futex-requeue-pi.rst b/Documentation/driver-api/futex-requeue-pi.rst
similarity index 99%
rename from Documentation/futex-requeue-pi.rst
rename to Documentation/driver-api/futex-requeue-pi.rst
index a90dbff26629..14ab5787b9a7 100644
--- a/Documentation/futex-requeue-pi.rst
+++ b/Documentation/driver-api/futex-requeue-pi.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ================
 Futex Requeue PI
 ================
diff --git a/Documentation/gcc-plugins.rst b/Documentation/driver-api/gcc-plugins.rst
similarity index 99%
rename from Documentation/gcc-plugins.rst
rename to Documentation/driver-api/gcc-plugins.rst
index e08d013c6de2..8502f24396fb 100644
--- a/Documentation/gcc-plugins.rst
+++ b/Documentation/driver-api/gcc-plugins.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 =========================
 GCC plugin infrastructure
 =========================
diff --git a/Documentation/hwspinlock.rst b/Documentation/driver-api/hwspinlock.rst
similarity index 99%
rename from Documentation/hwspinlock.rst
rename to Documentation/driver-api/hwspinlock.rst
index 68297473647c..ed640a278185 100644
--- a/Documentation/hwspinlock.rst
+++ b/Documentation/driver-api/hwspinlock.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ===========================
 Hardware Spinlock Framework
 ===========================
diff --git a/Documentation/driver-api/index.rst b/Documentation/driver-api/index.rst
index c76a101c2a6b..bb2621b17212 100644
--- a/Documentation/driver-api/index.rst
+++ b/Documentation/driver-api/index.rst
@@ -60,6 +60,72 @@ available subsections can be seen below.
    acpi/index
    generic-counter
 
+   atomic_bitops
+   bt8xxgpio
+   bus-virt-phys-mapping
+   connector
+   console
+   crc32
+   dcdbas
+   debugging-modules
+   debugging-via-ohci1394
+   dell_rbu
+   digsig
+   edid
+   eisa
+   futex-requeue-pi
+   gcc-plugins
+   hwspinlock
+   io-mapping
+   io_ordering
+   ipmi
+   irq
+   irq-affinity
+   irq-domain
+   irqflags-tracing
+   isa
+   isapnp
+   kobject
+   kprobes
+   kref
+   lightnvm-pblk
+   lzo
+   mailbox
+   men-chameleon-bus
+   nommu-mmap
+   ntb
+   nvmem
+   padata
+   parport-lowlevel
+   percpu-rw-semaphore
+   pi-futex
+   pps
+   preempt-locking
+   pti_intel_mid
+   ptp
+   pwm
+   rbtree
+   remoteproc
+   rfkill
+   robust-futex-ABI
+   robust-futexes
+   rpmsg
+   sgi-ioc4
+   sm501
+   smsc_ece1099
+   speculation
+   static-keys
+   switchtec
+   sync_file
+   tee
+   this_cpu_ops
+   unaligned-memory-access
+   vfio
+   vfio-mediated-device
+   xillybus
+   xz
+   zorro
+
 .. only::  subproject and html
 
    Indices
diff --git a/Documentation/io-mapping.rst b/Documentation/driver-api/io-mapping.rst
similarity index 99%
rename from Documentation/io-mapping.rst
rename to Documentation/driver-api/io-mapping.rst
index 82a2cacf9a29..a966239f04e4 100644
--- a/Documentation/io-mapping.rst
+++ b/Documentation/driver-api/io-mapping.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ========================
 The io_mapping functions
 ========================
diff --git a/Documentation/io_ordering.rst b/Documentation/driver-api/io_ordering.rst
similarity index 99%
rename from Documentation/io_ordering.rst
rename to Documentation/driver-api/io_ordering.rst
index 18ef889c100e..2ab303ce9a0d 100644
--- a/Documentation/io_ordering.rst
+++ b/Documentation/driver-api/io_ordering.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ==============================================
 Ordering I/O writes to memory-mapped addresses
 ==============================================
diff --git a/Documentation/IPMI.rst b/Documentation/driver-api/ipmi.rst
similarity index 99%
rename from Documentation/IPMI.rst
rename to Documentation/driver-api/ipmi.rst
index f6c2d11710fe..5ef1047e2e66 100644
--- a/Documentation/IPMI.rst
+++ b/Documentation/driver-api/ipmi.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 =====================
 The Linux IPMI Driver
 =====================
diff --git a/Documentation/IRQ-affinity.rst b/Documentation/driver-api/irq-affinity.rst
similarity index 99%
rename from Documentation/IRQ-affinity.rst
rename to Documentation/driver-api/irq-affinity.rst
index 49ba271349d6..29da5000836a 100644
--- a/Documentation/IRQ-affinity.rst
+++ b/Documentation/driver-api/irq-affinity.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ================
 SMP IRQ affinity
 ================
diff --git a/Documentation/IRQ-domain.rst b/Documentation/driver-api/irq-domain.rst
similarity index 99%
rename from Documentation/IRQ-domain.rst
rename to Documentation/driver-api/irq-domain.rst
index a610a8ea9a92..507775cce753 100644
--- a/Documentation/IRQ-domain.rst
+++ b/Documentation/driver-api/irq-domain.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ===============================================
 The irq_domain interrupt number mapping library
 ===============================================
diff --git a/Documentation/IRQ.rst b/Documentation/driver-api/irq.rst
similarity index 99%
rename from Documentation/IRQ.rst
rename to Documentation/driver-api/irq.rst
index a9f3e192c2cb..4273806a606b 100644
--- a/Documentation/IRQ.rst
+++ b/Documentation/driver-api/irq.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ===============
 What is an IRQ?
 ===============
diff --git a/Documentation/irqflags-tracing.rst b/Documentation/driver-api/irqflags-tracing.rst
similarity index 99%
rename from Documentation/irqflags-tracing.rst
rename to Documentation/driver-api/irqflags-tracing.rst
index a2fbbb1a62b9..27d0d5a9d6b4 100644
--- a/Documentation/irqflags-tracing.rst
+++ b/Documentation/driver-api/irqflags-tracing.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 =======================
 IRQ-flags state tracing
 =======================
diff --git a/Documentation/isa.rst b/Documentation/driver-api/isa.rst
similarity index 99%
rename from Documentation/isa.rst
rename to Documentation/driver-api/isa.rst
index f3a412d266b0..def4a7b690b5 100644
--- a/Documentation/isa.rst
+++ b/Documentation/driver-api/isa.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ===========
 ISA Drivers
 ===========
diff --git a/Documentation/isapnp.rst b/Documentation/driver-api/isapnp.rst
similarity index 98%
rename from Documentation/isapnp.rst
rename to Documentation/driver-api/isapnp.rst
index 136a5e92be27..8d0840ac847b 100644
--- a/Documentation/isapnp.rst
+++ b/Documentation/driver-api/isapnp.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ==========================================================
 ISA Plug & Play support by Jaroslav Kysela <perex@suse.cz>
 ==========================================================
diff --git a/Documentation/kobject.rst b/Documentation/driver-api/kobject.rst
similarity index 99%
rename from Documentation/kobject.rst
rename to Documentation/driver-api/kobject.rst
index 6117192bf3e6..9f8c42b48867 100644
--- a/Documentation/kobject.rst
+++ b/Documentation/driver-api/kobject.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 =====================================================================
 Everything you never wanted to know about kobjects, ksets, and ktypes
 =====================================================================
@@ -212,7 +210,7 @@ statically and will warn the developer of this improper usage.
 If all that you want to use a kobject for is to provide a reference counter
 for your structure, please use the struct kref instead; a kobject would be
 overkill.  For more information on how to use struct kref, please see the
-file Documentation/kref.rst in the Linux kernel source tree.
+file Documentation/driver-api/kref.rst in the Linux kernel source tree.
 
 
 Creating "simple" kobjects
diff --git a/Documentation/kprobes.rst b/Documentation/driver-api/kprobes.rst
similarity index 99%
rename from Documentation/kprobes.rst
rename to Documentation/driver-api/kprobes.rst
index 6c0011755e68..a44cb5f49846 100644
--- a/Documentation/kprobes.rst
+++ b/Documentation/driver-api/kprobes.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 =======================
 Kernel Probes (Kprobes)
 =======================
diff --git a/Documentation/kref.rst b/Documentation/driver-api/kref.rst
similarity index 99%
rename from Documentation/kref.rst
rename to Documentation/driver-api/kref.rst
index 470e3c1bacdc..3af384156d7e 100644
--- a/Documentation/kref.rst
+++ b/Documentation/driver-api/kref.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ===================================================
 Adding reference counters (krefs) to kernel objects
 ===================================================
diff --git a/Documentation/lightnvm/pblk.txt b/Documentation/driver-api/lightnvm-pblk.rst
similarity index 100%
rename from Documentation/lightnvm/pblk.txt
rename to Documentation/driver-api/lightnvm-pblk.rst
diff --git a/Documentation/lzo.rst b/Documentation/driver-api/lzo.rst
similarity index 99%
rename from Documentation/lzo.rst
rename to Documentation/driver-api/lzo.rst
index 36965db785af..ca983328976b 100644
--- a/Documentation/lzo.rst
+++ b/Documentation/driver-api/lzo.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ===========================================================
 LZO stream format as understood by Linux's LZO decompressor
 ===========================================================
diff --git a/Documentation/mailbox.rst b/Documentation/driver-api/mailbox.rst
similarity index 99%
rename from Documentation/mailbox.rst
rename to Documentation/driver-api/mailbox.rst
index 02e754db3567..0ed95009cc30 100644
--- a/Documentation/mailbox.rst
+++ b/Documentation/driver-api/mailbox.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ============================
 The Common Mailbox Framework
 ============================
diff --git a/Documentation/men-chameleon-bus.rst b/Documentation/driver-api/men-chameleon-bus.rst
similarity index 99%
rename from Documentation/men-chameleon-bus.rst
rename to Documentation/driver-api/men-chameleon-bus.rst
index 2d6175229e58..1b1f048aa748 100644
--- a/Documentation/men-chameleon-bus.rst
+++ b/Documentation/driver-api/men-chameleon-bus.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 =================
 MEN Chameleon Bus
 =================
diff --git a/Documentation/nommu-mmap.rst b/Documentation/driver-api/nommu-mmap.rst
similarity index 99%
rename from Documentation/nommu-mmap.rst
rename to Documentation/driver-api/nommu-mmap.rst
index f7f75813dc9c..530fed08de2c 100644
--- a/Documentation/nommu-mmap.rst
+++ b/Documentation/driver-api/nommu-mmap.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 =============================
 No-MMU memory mapping support
 =============================
diff --git a/Documentation/ntb.rst b/Documentation/driver-api/ntb.rst
similarity index 99%
rename from Documentation/ntb.rst
rename to Documentation/driver-api/ntb.rst
index a25e7814b898..87d1372da879 100644
--- a/Documentation/ntb.rst
+++ b/Documentation/driver-api/ntb.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ===========
 NTB Drivers
 ===========
diff --git a/Documentation/nvmem/nvmem.rst b/Documentation/driver-api/nvmem.rst
similarity index 99%
rename from Documentation/nvmem/nvmem.rst
rename to Documentation/driver-api/nvmem.rst
index 3866b6e066d5..c93a9c6cd878 100644
--- a/Documentation/nvmem/nvmem.rst
+++ b/Documentation/driver-api/nvmem.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ===============
 NVMEM Subsystem
 ===============
diff --git a/Documentation/padata.rst b/Documentation/driver-api/padata.rst
similarity index 99%
rename from Documentation/padata.rst
rename to Documentation/driver-api/padata.rst
index f8369d18c846..b103d0c82000 100644
--- a/Documentation/padata.rst
+++ b/Documentation/driver-api/padata.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 =======================================
 The padata parallel execution mechanism
 =======================================
diff --git a/Documentation/parport-lowlevel.rst b/Documentation/driver-api/parport-lowlevel.rst
similarity index 99%
rename from Documentation/parport-lowlevel.rst
rename to Documentation/driver-api/parport-lowlevel.rst
index b8574d83d328..0633d70ffda7 100644
--- a/Documentation/parport-lowlevel.rst
+++ b/Documentation/driver-api/parport-lowlevel.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ===============================
 PARPORT interface documentation
 ===============================
diff --git a/Documentation/percpu-rw-semaphore.rst b/Documentation/driver-api/percpu-rw-semaphore.rst
similarity index 99%
rename from Documentation/percpu-rw-semaphore.rst
rename to Documentation/driver-api/percpu-rw-semaphore.rst
index 5c39c88d3719..247de6410855 100644
--- a/Documentation/percpu-rw-semaphore.rst
+++ b/Documentation/driver-api/percpu-rw-semaphore.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ====================
 Percpu rw semaphores
 ====================
diff --git a/Documentation/pi-futex.rst b/Documentation/driver-api/pi-futex.rst
similarity index 99%
rename from Documentation/pi-futex.rst
rename to Documentation/driver-api/pi-futex.rst
index 884ba7f2aa10..c33ba2befbf8 100644
--- a/Documentation/pi-futex.rst
+++ b/Documentation/driver-api/pi-futex.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ======================
 Lightweight PI-futexes
 ======================
diff --git a/Documentation/driver-api/pps.rst b/Documentation/driver-api/pps.rst
index 1456d2c32ebd..262151a6dad5 100644
--- a/Documentation/driver-api/pps.rst
+++ b/Documentation/driver-api/pps.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ======================
 PPS - Pulse Per Second
 ======================
diff --git a/Documentation/preempt-locking.rst b/Documentation/driver-api/preempt-locking.rst
similarity index 99%
rename from Documentation/preempt-locking.rst
rename to Documentation/driver-api/preempt-locking.rst
index 4dfa1512a75b..291c2a45b3e8 100644
--- a/Documentation/preempt-locking.rst
+++ b/Documentation/driver-api/preempt-locking.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ===========================================================================
 Proper Locking Under a Preemptible Kernel: Keeping Kernel Code Preempt-Safe
 ===========================================================================
diff --git a/Documentation/pti/pti_intel_mid.rst b/Documentation/driver-api/pti_intel_mid.rst
similarity index 99%
rename from Documentation/pti/pti_intel_mid.rst
rename to Documentation/driver-api/pti_intel_mid.rst
index ea05725174cb..a674317790ba 100644
--- a/Documentation/pti/pti_intel_mid.rst
+++ b/Documentation/driver-api/pti_intel_mid.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 =============
 Intel MID PTI
 =============
diff --git a/Documentation/driver-api/ptp.rst b/Documentation/driver-api/ptp.rst
index b6e65d66d37a..65c84a72e9fc 100644
--- a/Documentation/driver-api/ptp.rst
+++ b/Documentation/driver-api/ptp.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ===========================================
 PTP hardware clock infrastructure for Linux
 ===========================================
diff --git a/Documentation/pwm.rst b/Documentation/driver-api/pwm.rst
similarity index 99%
rename from Documentation/pwm.rst
rename to Documentation/driver-api/pwm.rst
index 78d06b7f5427..8fbf0aa3ba2d 100644
--- a/Documentation/pwm.rst
+++ b/Documentation/driver-api/pwm.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ======================================
 Pulse Width Modulation (PWM) interface
 ======================================
diff --git a/Documentation/rbtree.rst b/Documentation/driver-api/rbtree.rst
similarity index 99%
rename from Documentation/rbtree.rst
rename to Documentation/driver-api/rbtree.rst
index c0cbda408050..8bbfcac8db46 100644
--- a/Documentation/rbtree.rst
+++ b/Documentation/driver-api/rbtree.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 =================================
 Red-black Trees (rbtree) in Linux
 =================================
diff --git a/Documentation/remoteproc.rst b/Documentation/driver-api/remoteproc.rst
similarity index 99%
rename from Documentation/remoteproc.rst
rename to Documentation/driver-api/remoteproc.rst
index 71eb7728fcf3..2f525b00f8e7 100644
--- a/Documentation/remoteproc.rst
+++ b/Documentation/driver-api/remoteproc.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ==========================
 Remote Processor Framework
 ==========================
@@ -24,7 +22,7 @@ for remote processors that supports this kind of communication. This way,
 platform-specific remoteproc drivers only need to provide a few low-level
 handlers, and then all rpmsg drivers will then just work
 (for more information about the virtio-based rpmsg bus and its drivers,
-please read Documentation/rpmsg.rst).
+please read Documentation/driver-api/rpmsg.rst).
 Registration of other types of virtio devices is now also possible. Firmwares
 just need to publish what kind of virtio devices do they support, and then
 remoteproc will add those devices. This makes it possible to reuse the
diff --git a/Documentation/rfkill.rst b/Documentation/driver-api/rfkill.rst
similarity index 99%
rename from Documentation/rfkill.rst
rename to Documentation/driver-api/rfkill.rst
index 4da9994e9bb4..7d3684e81df6 100644
--- a/Documentation/rfkill.rst
+++ b/Documentation/driver-api/rfkill.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ===============================
 rfkill - RF kill switch support
 ===============================
diff --git a/Documentation/robust-futex-ABI.rst b/Documentation/driver-api/robust-futex-ABI.rst
similarity index 99%
rename from Documentation/robust-futex-ABI.rst
rename to Documentation/driver-api/robust-futex-ABI.rst
index 6d359b46610c..8a5d34abf726 100644
--- a/Documentation/robust-futex-ABI.rst
+++ b/Documentation/driver-api/robust-futex-ABI.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ====================
 The robust futex ABI
 ====================
diff --git a/Documentation/robust-futexes.rst b/Documentation/driver-api/robust-futexes.rst
similarity index 99%
rename from Documentation/robust-futexes.rst
rename to Documentation/driver-api/robust-futexes.rst
index 20beef77597a..6361fb01c9c1 100644
--- a/Documentation/robust-futexes.rst
+++ b/Documentation/driver-api/robust-futexes.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ========================================
 A description of what robust futexes are
 ========================================
diff --git a/Documentation/rpmsg.rst b/Documentation/driver-api/rpmsg.rst
similarity index 99%
rename from Documentation/rpmsg.rst
rename to Documentation/driver-api/rpmsg.rst
index ad53931f3e43..24b7a9e1a5f9 100644
--- a/Documentation/rpmsg.rst
+++ b/Documentation/driver-api/rpmsg.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ============================================
 Remote Processor Messaging (rpmsg) Framework
 ============================================
diff --git a/Documentation/sgi-ioc4.rst b/Documentation/driver-api/sgi-ioc4.rst
similarity index 99%
rename from Documentation/sgi-ioc4.rst
rename to Documentation/driver-api/sgi-ioc4.rst
index e6ed2e9b055b..72709222d3c0 100644
--- a/Documentation/sgi-ioc4.rst
+++ b/Documentation/driver-api/sgi-ioc4.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ====================================
 SGI IOC4 PCI (multi function) device
 ====================================
diff --git a/Documentation/SM501.rst b/Documentation/driver-api/sm501.rst
similarity index 99%
rename from Documentation/SM501.rst
rename to Documentation/driver-api/sm501.rst
index 772a9b5c7d49..882507453ba4 100644
--- a/Documentation/SM501.rst
+++ b/Documentation/driver-api/sm501.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 .. include:: <isonum.txt>
 
 ============
diff --git a/Documentation/smsc_ece1099.rst b/Documentation/driver-api/smsc_ece1099.rst
similarity index 99%
rename from Documentation/smsc_ece1099.rst
rename to Documentation/driver-api/smsc_ece1099.rst
index a403fcd7c64d..079277421eaf 100644
--- a/Documentation/smsc_ece1099.rst
+++ b/Documentation/driver-api/smsc_ece1099.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 =================================================
 Msc Keyboard Scan Expansion/GPIO Expansion device
 =================================================
diff --git a/Documentation/speculation.rst b/Documentation/driver-api/speculation.rst
similarity index 99%
rename from Documentation/speculation.rst
rename to Documentation/driver-api/speculation.rst
index e240f01b0983..47f8ad300695 100644
--- a/Documentation/speculation.rst
+++ b/Documentation/driver-api/speculation.rst
@@ -1,12 +1,10 @@
-:orphan:
+===========
+Speculation
+===========
 
 This document explains potential effects of speculation, and how undesirable
 effects can be mitigated portably using common APIs.
 
-===========
-Speculation
-===========
-
 To improve performance and minimize average latencies, many contemporary CPUs
 employ speculative execution techniques such as branch prediction, performing
 work which may be discarded at a later stage.
diff --git a/Documentation/static-keys.rst b/Documentation/driver-api/static-keys.rst
similarity index 99%
rename from Documentation/static-keys.rst
rename to Documentation/driver-api/static-keys.rst
index bdf545e3a37f..9803e14639bf 100644
--- a/Documentation/static-keys.rst
+++ b/Documentation/driver-api/static-keys.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ===========
 Static Keys
 ===========
diff --git a/Documentation/switchtec.rst b/Documentation/driver-api/switchtec.rst
similarity index 97%
rename from Documentation/switchtec.rst
rename to Documentation/driver-api/switchtec.rst
index 6879c92de8e2..7611fdc53e19 100644
--- a/Documentation/switchtec.rst
+++ b/Documentation/driver-api/switchtec.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ========================
 Linux Switchtec Support
 ========================
@@ -99,6 +97,6 @@ the following configuration settings:
 NT EP BAR 2 will be dynamically configured as a Direct Window, and
 the configuration file does not need to configure it explicitly.
 
-Please refer to Documentation/ntb.rst in Linux source tree for an overall
+Please refer to Documentation/driver-api/ntb.rst in Linux source tree for an overall
 understanding of the Linux NTB stack. ntb_hw_switchtec works as an NTB
 Hardware Driver in this stack.
diff --git a/Documentation/sync_file.rst b/Documentation/driver-api/sync_file.rst
similarity index 99%
rename from Documentation/sync_file.rst
rename to Documentation/driver-api/sync_file.rst
index a65a67cc06fa..496fb2c3b3e6 100644
--- a/Documentation/sync_file.rst
+++ b/Documentation/driver-api/sync_file.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ===================
 Sync File API Guide
 ===================
diff --git a/Documentation/tee.rst b/Documentation/driver-api/tee.rst
similarity index 99%
rename from Documentation/tee.rst
rename to Documentation/driver-api/tee.rst
index 5eacffb823b5..afacdf2fd1de 100644
--- a/Documentation/tee.rst
+++ b/Documentation/driver-api/tee.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 =============
 TEE subsystem
 =============
diff --git a/Documentation/this_cpu_ops.rst b/Documentation/driver-api/this_cpu_ops.rst
similarity index 99%
rename from Documentation/this_cpu_ops.rst
rename to Documentation/driver-api/this_cpu_ops.rst
index a489d25ff549..5cb8b883ae83 100644
--- a/Documentation/this_cpu_ops.rst
+++ b/Documentation/driver-api/this_cpu_ops.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ===================
 this_cpu operations
 ===================
diff --git a/Documentation/unaligned-memory-access.rst b/Documentation/driver-api/unaligned-memory-access.rst
similarity index 99%
rename from Documentation/unaligned-memory-access.rst
rename to Documentation/driver-api/unaligned-memory-access.rst
index 848013a8bc10..1ee82419d8aa 100644
--- a/Documentation/unaligned-memory-access.rst
+++ b/Documentation/driver-api/unaligned-memory-access.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 =========================
 Unaligned Memory Accesses
 =========================
diff --git a/Documentation/vfio-mediated-device.rst b/Documentation/driver-api/vfio-mediated-device.rst
similarity index 99%
rename from Documentation/vfio-mediated-device.rst
rename to Documentation/driver-api/vfio-mediated-device.rst
index 0ea57427e7e6..25eb7d5b834b 100644
--- a/Documentation/vfio-mediated-device.rst
+++ b/Documentation/driver-api/vfio-mediated-device.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 .. include:: <isonum.txt>
 
 =====================
@@ -410,7 +408,7 @@ card.
 References
 ==========
 
-1. See Documentation/vfio.rst for more information on VFIO.
+1. See Documentation/driver-api/vfio.rst for more information on VFIO.
 2. struct mdev_driver in include/linux/mdev.h
 3. struct mdev_parent_ops in include/linux/mdev.h
 4. struct vfio_iommu_driver_ops in include/linux/vfio.h
diff --git a/Documentation/vfio.rst b/Documentation/driver-api/vfio.rst
similarity index 99%
rename from Documentation/vfio.rst
rename to Documentation/driver-api/vfio.rst
index 8a3fbd7d96f0..f1a4d3c3ba0b 100644
--- a/Documentation/vfio.rst
+++ b/Documentation/driver-api/vfio.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ==================================
 VFIO - "Virtual Function I/O" [1]_
 ==================================
diff --git a/Documentation/xillybus.rst b/Documentation/driver-api/xillybus.rst
similarity index 99%
rename from Documentation/xillybus.rst
rename to Documentation/driver-api/xillybus.rst
index d99f4a37e8b6..2446ee303c09 100644
--- a/Documentation/xillybus.rst
+++ b/Documentation/driver-api/xillybus.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ==========================================
 Xillybus driver for generic FPGA interface
 ==========================================
diff --git a/Documentation/xz.rst b/Documentation/driver-api/xz.rst
similarity index 99%
rename from Documentation/xz.rst
rename to Documentation/driver-api/xz.rst
index 205edc6646d5..b2220d03aa50 100644
--- a/Documentation/xz.rst
+++ b/Documentation/driver-api/xz.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ============================
 XZ data compression in Linux
 ============================
diff --git a/Documentation/zorro.rst b/Documentation/driver-api/zorro.rst
similarity index 99%
rename from Documentation/zorro.rst
rename to Documentation/driver-api/zorro.rst
index 7cd509f31d57..59fb1634d903 100644
--- a/Documentation/zorro.rst
+++ b/Documentation/driver-api/zorro.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ========================================
 Writing Device Drivers for Zorro Devices
 ========================================
diff --git a/Documentation/driver-model/device.rst b/Documentation/driver-model/device.rst
index 17bcc483c4b1..b0734caf6b8f 100644
--- a/Documentation/driver-model/device.rst
+++ b/Documentation/driver-model/device.rst
@@ -53,7 +53,7 @@ Attributes of devices can be exported by a device driver through sysfs.
 Please see Documentation/filesystems/sysfs.txt for more information
 on how sysfs works.
 
-As explained in Documentation/kobject.rst, device attributes must be
+As explained in Documentation/driver-api/kobject.rst, device attributes must be
 created before the KOBJ_ADD uevent is generated. The only way to realize
 that is by defining an attribute group.
 
diff --git a/Documentation/fb/fbcon.rst b/Documentation/fb/fbcon.rst
index 22112718dd5d..b9aafb733db9 100644
--- a/Documentation/fb/fbcon.rst
+++ b/Documentation/fb/fbcon.rst
@@ -187,7 +187,7 @@ the hardware. Thus, in a VGA console::
 Assuming the VGA driver can be unloaded, one must first unbind the VGA driver
 from the console layer before unloading the driver.  The VGA driver cannot be
 unloaded if it is still bound to the console layer. (See
-Documentation/console/console.rst for more information).
+Documentation/driver-api/console.rst for more information).
 
 This is more complicated in the case of the framebuffer console (fbcon),
 because fbcon is an intermediate layer between the console and the drivers::
@@ -204,7 +204,7 @@ fbcon. Thus, there is no need to explicitly unbind the fbdev drivers from
 fbcon.
 
 So, how do we unbind fbcon from the console? Part of the answer is in
-Documentation/console/console.rst. To summarize:
+Documentation/driver-api/console.rst. To summarize:
 
 Echo a value to the bind file that represents the framebuffer console
 driver. So assuming vtcon1 represents fbcon, then::
diff --git a/Documentation/filesystems/sysfs.txt b/Documentation/filesystems/sysfs.txt
index d159826c5cf3..20ab929c0e0c 100644
--- a/Documentation/filesystems/sysfs.txt
+++ b/Documentation/filesystems/sysfs.txt
@@ -16,7 +16,7 @@ a means to export kernel data structures, their attributes, and the
 linkages between them to userspace. 
 
 sysfs is tied inherently to the kobject infrastructure. Please read
-Documentation/kobject.rst for more information concerning the kobject
+Documentation/driver-api/kobject.rst for more information concerning the kobject
 interface. 
 
 
diff --git a/Documentation/gpu/drm-mm.rst b/Documentation/gpu/drm-mm.rst
index fa30dfcfc3c8..b0f948d8733b 100644
--- a/Documentation/gpu/drm-mm.rst
+++ b/Documentation/gpu/drm-mm.rst
@@ -320,7 +320,7 @@ struct :c:type:`struct file_operations <file_operations>` get_unmapped_area
 field with a pointer on :c:func:`drm_gem_cma_get_unmapped_area`.
 
 More detailed information about get_unmapped_area can be found in
-Documentation/nommu-mmap.rst
+Documentation/driver-api/nommu-mmap.rst
 
 Memory Coherency
 ----------------
diff --git a/Documentation/ia64/irq-redir.rst b/Documentation/ia64/irq-redir.rst
index 0abc7b35f6c0..0cd7ba1b0b08 100644
--- a/Documentation/ia64/irq-redir.rst
+++ b/Documentation/ia64/irq-redir.rst
@@ -7,7 +7,7 @@ IRQ affinity on IA64 platforms
 
 By writing to /proc/irq/IRQ#/smp_affinity the interrupt routing can be
 controlled. The behavior on IA64 platforms is slightly different from
-that described in Documentation/IRQ-affinity.rst for i386 systems.
+that described in Documentation/driver-api/irq-affinity.rst for i386 systems.
 
 Because of the usage of SAPIC mode and physical destination mode the
 IRQ target is one particular CPU and cannot be a mask of several
diff --git a/Documentation/laptops/thinkpad-acpi.rst b/Documentation/laptops/thinkpad-acpi.rst
index d0f0d16c21b9..adea0bf2acc5 100644
--- a/Documentation/laptops/thinkpad-acpi.rst
+++ b/Documentation/laptops/thinkpad-acpi.rst
@@ -643,7 +643,7 @@ Sysfs notes
 	2010.
 
 	rfkill controller switch "tpacpi_bluetooth_sw": refer to
-	Documentation/rfkill.rst for details.
+	Documentation/driver-api/rfkill.rst for details.
 
 
 Video output control -- /proc/acpi/ibm/video
@@ -1406,7 +1406,7 @@ Sysfs notes
 	2010.
 
 	rfkill controller switch "tpacpi_wwan_sw": refer to
-	Documentation/rfkill.rst for details.
+	Documentation/driver-api/rfkill.rst for details.
 
 
 EXPERIMENTAL: UWB
@@ -1426,7 +1426,7 @@ Sysfs notes
 ^^^^^^^^^^^
 
 	rfkill controller switch "tpacpi_uwb_sw": refer to
-	Documentation/rfkill.rst for details.
+	Documentation/driver-api/rfkill.rst for details.
 
 Adaptive keyboard
 -----------------
diff --git a/Documentation/locking/rt-mutex.rst b/Documentation/locking/rt-mutex.rst
index 6e3dcff802f9..18b5f0f0418e 100644
--- a/Documentation/locking/rt-mutex.rst
+++ b/Documentation/locking/rt-mutex.rst
@@ -4,7 +4,7 @@ RT-mutex subsystem with PI support
 
 RT-mutexes with priority inheritance are used to support PI-futexes,
 which enable pthread_mutex_t priority inheritance attributes
-(PTHREAD_PRIO_INHERIT). [See Documentation/pi-futex.rst for more details
+(PTHREAD_PRIO_INHERIT). [See Documentation/driver-api/pi-futex.rst for more details
 about PI-futexes.]
 
 This technology was developed in the -rt tree and streamlined for
diff --git a/Documentation/networking/scaling.rst b/Documentation/networking/scaling.rst
index 05f0feb99320..a20325aa1330 100644
--- a/Documentation/networking/scaling.rst
+++ b/Documentation/networking/scaling.rst
@@ -81,7 +81,7 @@ of queues to IRQs can be determined from /proc/interrupts. By default,
 an IRQ may be handled on any CPU. Because a non-negligible part of packet
 processing takes place in receive interrupt handling, it is advantageous
 to spread receive interrupts between CPUs. To manually adjust the IRQ
-affinity of each interrupt see Documentation/IRQ-affinity.rst. Some systems
+affinity of each interrupt see Documentation/driver-api/irq-affinity.rst. Some systems
 will be running irqbalance, a daemon that dynamically optimizes IRQ
 assignments and as a result may override any manual settings.
 
@@ -160,7 +160,7 @@ can be configured for each receive queue using a sysfs file entry::
 
 This file implements a bitmap of CPUs. RPS is disabled when it is zero
 (the default), in which case packets are processed on the interrupting
-CPU. Documentation/IRQ-affinity.rst explains how CPUs are assigned to
+CPU. Documentation/driver-api/irq-affinity.rst explains how CPUs are assigned to
 the bitmap.
 
 
diff --git a/Documentation/s390/vfio-ccw.rst b/Documentation/s390/vfio-ccw.rst
index 87b5bb49b2f3..1e210c6afa88 100644
--- a/Documentation/s390/vfio-ccw.rst
+++ b/Documentation/s390/vfio-ccw.rst
@@ -38,7 +38,7 @@ every detail. More information/reference could be found here:
   qemu/hw/s390x/css.c
 
 For vfio mediated device framework:
-- Documentation/vfio-mediated-device.rst
+- Documentation/driver-api/vfio-mediated-device.rst
 
 Motivation of vfio-ccw
 ----------------------
@@ -322,5 +322,5 @@ Reference
 2. ESA/390 Common I/O Device Commands manual (IBM Form. No. SA22-7204)
 3. https://en.wikipedia.org/wiki/Channel_I/O
 4. Documentation/s390/cds.rst
-5. Documentation/vfio.rst
-6. Documentation/vfio-mediated-device.rst
+5. Documentation/driver-api/vfio.rst
+6. Documentation/driver-api/vfio-mediated-device.rst
diff --git a/Documentation/sysctl/kernel.rst b/Documentation/sysctl/kernel.rst
index 9324c3b1aa3e..6e9144bfba9c 100644
--- a/Documentation/sysctl/kernel.rst
+++ b/Documentation/sysctl/kernel.rst
@@ -50,7 +50,7 @@ show up in /proc/sys/kernel:
 - kexec_load_disabled
 - kptr_restrict
 - l2cr                        [ PPC only ]
-- modprobe                    ==> Documentation/debugging-modules.rst
+- modprobe                    ==> Documentation/driver-api/debugging-modules.rst
 - modules_disabled
 - msg_next_id		      [ sysv ipc ]
 - msgmax
diff --git a/Documentation/sysctl/vm.rst b/Documentation/sysctl/vm.rst
index 43d594877df7..4940ab610eb7 100644
--- a/Documentation/sysctl/vm.rst
+++ b/Documentation/sysctl/vm.rst
@@ -580,7 +580,7 @@ trimming of allocations is initiated.
 
 The default value is 1.
 
-See Documentation/nommu-mmap.rst for more information.
+See Documentation/driver-api/nommu-mmap.rst for more information.
 
 
 numa_zonelist_order
diff --git a/Documentation/trace/kprobetrace.rst b/Documentation/trace/kprobetrace.rst
index 74f698affea1..caa0a8ba081e 100644
--- a/Documentation/trace/kprobetrace.rst
+++ b/Documentation/trace/kprobetrace.rst
@@ -40,7 +40,7 @@ Synopsis of kprobe_events
  MEMADDR	: Address where the probe is inserted.
  MAXACTIVE	: Maximum number of instances of the specified function that
 		  can be probed simultaneously, or 0 for the default value
-		  as defined in Documentation/kprobes.rst section 1.3.1.
+		  as defined in Documentation/driver-api/kprobes.rst section 1.3.1.
 
  FETCHARGS	: Arguments. Each probe can have up to 128 args.
   %REG		: Fetch register REG
diff --git a/Documentation/translations/zh_CN/IRQ.txt b/Documentation/translations/zh_CN/IRQ.txt
index 0d9ec142e185..c6e77a1b14e7 100644
--- a/Documentation/translations/zh_CN/IRQ.txt
+++ b/Documentation/translations/zh_CN/IRQ.txt
@@ -1,4 +1,4 @@
-Chinese translated version of Documentation/IRQ.rst
+Chinese translated version of Documentation/driver-api/irq.rst
 
 If you have any comment or update to the content, please contact the
 original document maintainer directly.  However, if you have a problem
@@ -9,7 +9,7 @@ or if there is a problem with the translation.
 Maintainer: Eric W. Biederman <ebiederman@xmission.com>
 Chinese maintainer: Fu Wei <tekkamanninja@gmail.com>
 ---------------------------------------------------------------------
-Documentation/IRQ.rst 的中文翻译
+Documentation/driver-api/irq.rst 的中文翻译
 
 如果想评论或更新本文的内容，请直接联系原文档的维护者。如果你使用英文
 交流有困难的话，也可以向中文版维护者求助。如果本翻译更新不及时或者翻
diff --git a/Documentation/translations/zh_CN/filesystems/sysfs.txt b/Documentation/translations/zh_CN/filesystems/sysfs.txt
index f5482e082399..0e0c6d3d4129 100644
--- a/Documentation/translations/zh_CN/filesystems/sysfs.txt
+++ b/Documentation/translations/zh_CN/filesystems/sysfs.txt
@@ -40,7 +40,7 @@ sysfs 是一个最初基于 ramfs 且位于内存的文件系统。它提供导
 数据结构及其属性，以及它们之间的关联到用户空间的方法。
 
 sysfs 始终与 kobject 的底层结构紧密相关。请阅读
-Documentation/kobject.rst 文档以获得更多关于 kobject 接口的
+Documentation/driver-api/kobject.rst 文档以获得更多关于 kobject 接口的
 信息。
 
 
diff --git a/Documentation/translations/zh_CN/io_ordering.txt b/Documentation/translations/zh_CN/io_ordering.txt
index 4e9727990c10..7bb3086227ae 100644
--- a/Documentation/translations/zh_CN/io_ordering.txt
+++ b/Documentation/translations/zh_CN/io_ordering.txt
@@ -1,4 +1,4 @@
-Chinese translated version of Documentation/io_ordering.rst
+Chinese translated version of Documentation/driver-api/io_ordering.rst
 
 If you have any comment or update to the content, please contact the
 original document maintainer directly.  However, if you have a problem
@@ -8,7 +8,7 @@ or if there is a problem with the translation.
 
 Chinese maintainer: Lin Yongting <linyongting@gmail.com>
 ---------------------------------------------------------------------
-Documentation/io_ordering.rst 的中文翻译
+Documentation/driver-api/io_ordering.rst 的中文翻译
 
 如果想评论或更新本文的内容，请直接联系原文档的维护者。如果你使用英文
 交流有困难的话，也可以向中文版维护者求助。如果本翻译更新不及时或者翻
diff --git a/Documentation/w1/w1.netlink b/Documentation/w1/w1.netlink
index ef2727192d69..94ad4c420828 100644
--- a/Documentation/w1/w1.netlink
+++ b/Documentation/w1/w1.netlink
@@ -183,7 +183,7 @@ acknowledge number is set to seq+1.
 Additional documantion, source code examples.
 ============================================
 
-1. Documentation/connector
+1. Documentation/driver-api/connector.rst
 2. http://www.ioremap.net/archive/w1
 This archive includes userspace application w1d.c which uses
 read/write/search commands for all master/slave devices found on the bus.
diff --git a/Documentation/watchdog/hpwdt.rst b/Documentation/watchdog/hpwdt.rst
index f4ba329f011f..437456bd91a4 100644
--- a/Documentation/watchdog/hpwdt.rst
+++ b/Documentation/watchdog/hpwdt.rst
@@ -44,7 +44,7 @@ Last reviewed: 08/20/2018
  NOTE:
        More information about watchdog drivers in general, including the ioctl
        interface to /dev/watchdog can be found in
-       Documentation/watchdog/watchdog-api.rst and Documentation/IPMI.rst.
+       Documentation/watchdog/watchdog-api.rst and Documentation/driver-api/ipmi.rst.
 
  Due to limitations in the iLO hardware, the NMI pretimeout if enabled,
  can only be set to 9 seconds.  Attempts to set pretimeout to other
diff --git a/MAINTAINERS b/MAINTAINERS
index 98723afdbf0b..85a6f090ccc0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4588,7 +4588,7 @@ DELL SYSTEMS MANAGEMENT BASE DRIVER (dcdbas)
 M:	Stuart Hayes <stuart.w.hayes@gmail.com>
 L:	platform-driver-x86@vger.kernel.org
 S:	Maintained
-F:	Documentation/dcdbas.rst
+F:	Documentation/driver-api/dcdbas.rst
 F:	drivers/platform/x86/dcdbas.*
 
 DELL WMI NOTIFICATIONS DRIVER
@@ -4966,7 +4966,7 @@ M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 R:	"Rafael J. Wysocki" <rafael@kernel.org>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
 S:	Supported
-F:	Documentation/kobject.rst
+F:	Documentation/driver-api/kobject.rst
 F:	drivers/base/
 F:	fs/debugfs/
 F:	fs/sysfs/
@@ -6584,7 +6584,7 @@ F:	include/linux/futex.h
 F:	include/uapi/linux/futex.h
 F:	tools/testing/selftests/futex/
 F:	tools/perf/bench/futex*
-F:	Documentation/*futex*
+F:	Documentation/driver-api/*futex*
 
 GCC PLUGINS
 M:	Kees Cook <keescook@chromium.org>
@@ -6594,7 +6594,7 @@ S:	Maintained
 F:	scripts/gcc-plugins/
 F:	scripts/gcc-plugin.sh
 F:	scripts/Makefile.gcc-plugins
-F:	Documentation/gcc-plugins.rst
+F:	Documentation/driver-api/gcc-plugins.rst
 
 GASKET DRIVER FRAMEWORK
 M:	Rob Springer <rspringer@google.com>
@@ -7022,7 +7022,7 @@ L:	linux-remoteproc@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ohad/hwspinlock.git
 F:	Documentation/devicetree/bindings/hwlock/
-F:	Documentation/hwspinlock.rst
+F:	Documentation/driver-api/hwspinlock.rst
 F:	drivers/hwspinlock/
 F:	include/linux/hwspinlock.h
 
@@ -8292,7 +8292,7 @@ L:	openipmi-developer@lists.sourceforge.net (moderated for non-subscribers)
 W:	http://openipmi.sourceforge.net/
 S:	Supported
 F:	Documentation/devicetree/bindings/ipmi/
-F:	Documentation/IPMI.rst
+F:	Documentation/driver-api/ipmi.rst
 F:	drivers/char/ipmi/
 F:	include/linux/ipmi*
 F:	include/uapi/linux/ipmi*
@@ -8333,7 +8333,7 @@ IRQ DOMAINS (IRQ NUMBER MAPPING LIBRARY)
 M:	Marc Zyngier <marc.zyngier@arm.com>
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq/core
-F:	Documentation/IRQ-domain.rst
+F:	Documentation/driver-api/irq-domain.rst
 F:	include/linux/irqdomain.h
 F:	kernel/irq/irqdomain.c
 F:	kernel/irq/msi.c
@@ -8358,7 +8358,7 @@ F:	drivers/irqchip/
 ISA
 M:	William Breathitt Gray <vilhelm.gray@gmail.com>
 S:	Maintained
-F:	Documentation/isa.rst
+F:	Documentation/driver-api/isa.rst
 F:	drivers/base/isa.c
 F:	include/linux/isa.h
 
@@ -8373,7 +8373,7 @@ F:	drivers/media/radio/radio-isa*
 ISAPNP
 M:	Jaroslav Kysela <perex@perex.cz>
 S:	Maintained
-F:	Documentation/isapnp.rst
+F:	Documentation/driver-api/isapnp.rst
 F:	drivers/pnp/isapnp/
 F:	include/linux/isapnp.h
 
@@ -8823,7 +8823,7 @@ M:	Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
 M:	"David S. Miller" <davem@davemloft.net>
 M:	Masami Hiramatsu <mhiramat@kernel.org>
 S:	Maintained
-F:	Documentation/kprobes.rst
+F:	Documentation/driver-api/kprobes.rst
 F:	include/linux/kprobes.h
 F:	include/asm-generic/kprobes.h
 F:	kernel/kprobes.c
@@ -9182,7 +9182,7 @@ L:	linux-arch@vger.kernel.org
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git dev
 F:	tools/memory-model/
-F:	Documentation/atomic_bitops.rst
+F:	Documentation/driver-api/atomic_bitops.rst
 F:	Documentation/atomic_t.txt
 F:	Documentation/core-api/atomic_ops.rst
 F:	Documentation/core-api/refcount-vs-atomic.rst
@@ -10240,7 +10240,7 @@ M:	Johannes Thumshirn <morbidrsa@gmail.com>
 S:	Maintained
 F:	drivers/mcb/
 F:	include/linux/mcb.h
-F:	Documentation/men-chameleon-bus.rst
+F:	Documentation/driver-api/men-chameleon-bus.rst
 
 MEN F21BMC (Board Management Controller)
 M:	Andreas Werner <andreas.werner@men.de>
@@ -11923,7 +11923,7 @@ L:	linux-crypto@vger.kernel.org
 S:	Maintained
 F:	kernel/padata.c
 F:	include/linux/padata.h
-F:	Documentation/padata.rst
+F:	Documentation/driver-api/padata.rst
 
 PANASONIC LAPTOP ACPI EXTRAS DRIVER
 M:	Harald Welte <laforge@gnumonks.org>
@@ -11947,7 +11947,7 @@ F:	drivers/parport/
 F:	include/linux/parport*.h
 F:	drivers/char/ppdev.c
 F:	include/uapi/linux/ppdev.h
-F:	Documentation/parport*.rst
+F:	Documentation/driver-api/parport*.rst
 
 PARAVIRT_OPS INTERFACE
 M:	Juergen Gross <jgross@suse.com>
@@ -12122,7 +12122,7 @@ M:	Kurt Schwemmer <kurt.schwemmer@microsemi.com>
 M:	Logan Gunthorpe <logang@deltatee.com>
 L:	linux-pci@vger.kernel.org
 S:	Maintained
-F:	Documentation/switchtec.rst
+F:	Documentation/driver-api/switchtec.rst
 F:	Documentation/ABI/testing/sysfs-class-switchtec
 F:	drivers/pci/switch/switchtec*
 F:	include/uapi/linux/switchtec_ioctl.h
@@ -12884,7 +12884,7 @@ M:	Thierry Reding <thierry.reding@gmail.com>
 L:	linux-pwm@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/thierry.reding/linux-pwm.git
-F:	Documentation/pwm.rst
+F:	Documentation/driver-api/pwm.rst
 F:	Documentation/devicetree/bindings/pwm/
 F:	include/linux/pwm.h
 F:	drivers/pwm/
@@ -13405,7 +13405,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ohad/remoteproc.git
 S:	Maintained
 F:	Documentation/devicetree/bindings/remoteproc/
 F:	Documentation/ABI/testing/sysfs-class-remoteproc
-F:	Documentation/remoteproc.rst
+F:	Documentation/driver-api/remoteproc.rst
 F:	drivers/remoteproc/
 F:	include/linux/remoteproc.h
 F:	include/linux/remoteproc/
@@ -13417,7 +13417,7 @@ L:	linux-remoteproc@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ohad/rpmsg.git
 S:	Maintained
 F:	drivers/rpmsg/
-F:	Documentation/rpmsg.rst
+F:	Documentation/driver-api/rpmsg.rst
 F:	Documentation/ABI/testing/sysfs-bus-rpmsg
 F:	include/linux/rpmsg.h
 F:	include/linux/rpmsg/
@@ -13503,7 +13503,7 @@ W:	http://wireless.kernel.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git
 S:	Maintained
-F:	Documentation/rfkill.rst
+F:	Documentation/driver-api/rfkill.rst
 F:	Documentation/ABI/stable/sysfs-class-rfkill
 F:	net/rfkill/
 F:	include/linux/rfkill.h
@@ -15211,7 +15211,7 @@ F:	drivers/dma-buf/dma-fence*
 F:	drivers/dma-buf/sw_sync.c
 F:	include/linux/sync_file.h
 F:	include/uapi/linux/sync_file.h
-F:	Documentation/sync_file.rst
+F:	Documentation/driver-api/sync_file.rst
 T:	git git://anongit.freedesktop.org/drm/drm-misc
 
 SYNOPSYS ARC ARCHITECTURE
@@ -15537,7 +15537,7 @@ S:	Maintained
 F:	include/linux/tee_drv.h
 F:	include/uapi/linux/tee.h
 F:	drivers/tee/
-F:	Documentation/tee.rst
+F:	Documentation/driver-api/tee.rst
 
 TEGRA ARCHITECTURE SUPPORT
 M:	Thierry Reding <thierry.reding@gmail.com>
@@ -16706,7 +16706,7 @@ R:	Cornelia Huck <cohuck@redhat.com>
 L:	kvm@vger.kernel.org
 T:	git git://github.com/awilliam/linux-vfio.git
 S:	Maintained
-F:	Documentation/vfio.rst
+F:	Documentation/driver-api/vfio.rst
 F:	drivers/vfio/
 F:	include/linux/vfio.h
 F:	include/uapi/linux/vfio.h
@@ -16715,7 +16715,7 @@ VFIO MEDIATED DEVICE DRIVERS
 M:	Kirti Wankhede <kwankhede@nvidia.com>
 L:	kvm@vger.kernel.org
 S:	Maintained
-F:	Documentation/vfio-mediated-device.rst
+F:	Documentation/driver-api/vfio-mediated-device.rst
 F:	drivers/vfio/mdev/
 F:	include/linux/mdev.h
 F:	samples/vfio-mdev/
diff --git a/arch/Kconfig b/arch/Kconfig
index c2f2bee5b17b..bfc372208609 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -141,7 +141,7 @@ config HAVE_64BIT_ALIGNED_ACCESS
 	  accesses are required to be 64 bit aligned in this way even
 	  though it is not a 64 bit architecture.
 
-	  See Documentation/unaligned-memory-access.rst for more
+	  See Documentation/driver-api/unaligned-memory-access.rst for more
 	  information on the topic of unaligned memory accesses.
 
 config HAVE_EFFICIENT_UNALIGNED_ACCESS
@@ -160,7 +160,7 @@ config HAVE_EFFICIENT_UNALIGNED_ACCESS
 	  problems with received packets if doing so would not help
 	  much.
 
-	  See Documentation/unaligned-memory-access.rst for more
+	  See Documentation/driver-api/unaligned-memory-access.rst for more
 	  information on the topic of unaligned memory accesses.
 
 config ARCH_USE_BUILTIN_BSWAP
diff --git a/arch/unicore32/include/asm/io.h b/arch/unicore32/include/asm/io.h
index 86877df4b1ee..e396d4f658f9 100644
--- a/arch/unicore32/include/asm/io.h
+++ b/arch/unicore32/include/asm/io.h
@@ -31,7 +31,7 @@ extern void __uc32_iounmap(volatile void __iomem *addr);
  * ioremap and friends.
  *
  * ioremap takes a PCI memory address, as specified in
- * Documentation/io-mapping.rst.
+ * Documentation/driver-api/io-mapping.rst.
  *
  */
 #define ioremap(cookie, size)		__uc32_ioremap(cookie, size)
diff --git a/drivers/base/core.c b/drivers/base/core.c
index f98b33e9ec19..e40e4a171cdd 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1063,7 +1063,7 @@ static void device_release(struct kobject *kobj)
 	else if (dev->class && dev->class->dev_release)
 		dev->class->dev_release(dev);
 	else
-		WARN(1, KERN_ERR "Device '%s' does not have a release() function, it is broken and must be fixed. See Documentation/kobject.rst.\n",
+		WARN(1, KERN_ERR "Device '%s' does not have a release() function, it is broken and must be fixed. See Documentation/driver-api/kobject.rst.\n",
 			dev_name(dev));
 	kfree(p);
 }
diff --git a/drivers/char/ipmi/Kconfig b/drivers/char/ipmi/Kconfig
index e59ee81bc22f..d7f89cce656f 100644
--- a/drivers/char/ipmi/Kconfig
+++ b/drivers/char/ipmi/Kconfig
@@ -14,7 +14,7 @@ menuconfig IPMI_HANDLER
          IPMI is a standard for managing sensors (temperature,
          voltage, etc.) in a system.
 
-         See <file:Documentation/IPMI.rst> for more details on the driver.
+         See <file:Documentation/driver-api/ipmi.rst> for more details on the driver.
 
 	 If unsure, say N.
 
diff --git a/drivers/char/ipmi/ipmi_si_hotmod.c b/drivers/char/ipmi/ipmi_si_hotmod.c
index 2032f4ac52ac..4fbb4e18bae2 100644
--- a/drivers/char/ipmi/ipmi_si_hotmod.c
+++ b/drivers/char/ipmi/ipmi_si_hotmod.c
@@ -18,7 +18,7 @@ static int hotmod_handler(const char *val, const struct kernel_param *kp);
 
 module_param_call(hotmod, hotmod_handler, NULL, NULL, 0200);
 MODULE_PARM_DESC(hotmod, "Add and remove interfaces.  See"
-		 " Documentation/IPMI.rst in the kernel sources for the"
+		 " Documentation/driver-api/ipmi.rst in the kernel sources for the"
 		 " gory details.");
 
 /*
diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 7f729609979c..4a0258f886cf 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -977,7 +977,7 @@ static inline int ipmi_thread_busy_wait(enum si_sm_result smi_result,
  * that are not BT and do not have interrupts.  It starts spinning
  * when an operation is complete or until max_busy tells it to stop
  * (if that is enabled).  See the paragraph on kimid_max_busy_us in
- * Documentation/IPMI.rst for details.
+ * Documentation/driver-api/ipmi.rst for details.
  */
 static int ipmi_thread(void *data)
 {
diff --git a/drivers/dma-buf/Kconfig b/drivers/dma-buf/Kconfig
index 9afc7bb638c3..b6a9c2f1bc41 100644
--- a/drivers/dma-buf/Kconfig
+++ b/drivers/dma-buf/Kconfig
@@ -15,7 +15,7 @@ config SYNC_FILE
 	  associated with a buffer. When a job is submitted to the GPU a fence
 	  is attached to the buffer and is transferred via userspace, using Sync
 	  Files fds, to the DRM driver for example. More details at
-	  Documentation/sync_file.rst.
+	  Documentation/driver-api/sync_file.rst.
 
 config SW_SYNC
 	bool "Sync File Validation Framework"
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 85cecf58bcf5..49f04621279c 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -1300,7 +1300,7 @@ config GPIO_BT8XX
 	  The card needs to be physically altered for using it as a
 	  GPIO card. For more information on how to build a GPIO card
 	  from a BT8xx TV card, see the documentation file at
-	  Documentation/bt8xxgpio.rst
+	  Documentation/driver-api/bt8xxgpio.rst
 
 	  If unsure, say N.
 
diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index c3a6dd284c91..3c2cd3bf9ffc 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -141,7 +141,7 @@ config DRM_LOAD_EDID_FIRMWARE
 	  monitor are unable to provide appropriate EDID data. Since this
 	  feature is provided as a workaround for broken hardware, the
 	  default case is N. Details and instructions how to build your own
-	  EDID data are given in Documentation/EDID/howto.rst.
+	  EDID data are given in Documentation/driver-api/edid.rst.
 
 config DRM_DP_CEC
 	bool "Enable DisplayPort CEC-Tunneling-over-AUX HDMI support"
diff --git a/drivers/pci/switch/Kconfig b/drivers/pci/switch/Kconfig
index c1f5226cd0e5..d370f4ce0492 100644
--- a/drivers/pci/switch/Kconfig
+++ b/drivers/pci/switch/Kconfig
@@ -9,7 +9,7 @@ config PCI_SW_SWITCHTEC
 	 Enables support for the management interface for the MicroSemi
 	 Switchtec series of PCIe switches. Supports userspace access
 	 to submit MRPC commands to the switch via /dev/switchtecX
-	 devices. See <file:Documentation/switchtec.rst> for more
+	 devices. See <file:Documentation/driver-api/switchtec.rst> for more
 	 information.
 
 endmenu
diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 6cd4a620115d..9d866b6753fe 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -118,7 +118,7 @@ config DCDBAS
 	  Interrupts (SMIs) and Host Control Actions (system power cycle or
 	  power off after OS shutdown) on certain Dell systems.
 
-	  See <file:Documentation/dcdbas.rst> for more details on the driver
+	  See <file:Documentation/driver-api/dcdbas.rst> for more details on the driver
 	  and the Dell systems on which Dell systems management software makes
 	  use of this driver.
 
@@ -259,7 +259,7 @@ config DELL_RBU
 	 DELL system. Note you need a Dell OpenManage or Dell Update package (DUP)
 	 supporting application to communicate with the BIOS regarding the new
 	 image for the image update to take effect.
-	 See <file:Documentation/dell_rbu.rst> for more details on the driver.
+	 See <file:Documentation/driver-api/dell_rbu.rst> for more details on the driver.
 
 
 config FUJITSU_LAPTOP
diff --git a/drivers/platform/x86/dcdbas.c b/drivers/platform/x86/dcdbas.c
index ba8dff3511ec..84f4cc839cc3 100644
--- a/drivers/platform/x86/dcdbas.c
+++ b/drivers/platform/x86/dcdbas.c
@@ -7,7 +7,7 @@
  *  and Host Control Actions (power cycle or power off after OS shutdown) on
  *  Dell systems.
  *
- *  See Documentation/dcdbas.rst for more information.
+ *  See Documentation/driver-api/dcdbas.rst for more information.
  *
  *  Copyright (C) 1995-2006 Dell Inc.
  */
diff --git a/drivers/platform/x86/dell_rbu.c b/drivers/platform/x86/dell_rbu.c
index 18400bb38e09..3691391fea6b 100644
--- a/drivers/platform/x86/dell_rbu.c
+++ b/drivers/platform/x86/dell_rbu.c
@@ -24,7 +24,7 @@
  * on every time the packet data is written. This driver requires an
  * application to break the BIOS image in to fixed sized packet chunks.
  *
- * See Documentation/dell_rbu.rst for more info.
+ * See Documentation/driver-api/dell_rbu.rst for more info.
  */
 #include <linux/init.h>
 #include <linux/module.h>
diff --git a/drivers/pnp/isapnp/Kconfig b/drivers/pnp/isapnp/Kconfig
index c4ddf41c7fb8..d0479a563123 100644
--- a/drivers/pnp/isapnp/Kconfig
+++ b/drivers/pnp/isapnp/Kconfig
@@ -7,6 +7,6 @@ config ISAPNP
 	depends on ISA || COMPILE_TEST
 	help
 	  Say Y here if you would like support for ISA Plug and Play devices.
-	  Some information is in <file:Documentation/isapnp.rst>.
+	  Some information is in <file:Documentation/driver-api/isapnp.rst>.
 
 	  If unsure, say Y.
diff --git a/drivers/tty/Kconfig b/drivers/tty/Kconfig
index 1cb50f19d58c..ee51b9514225 100644
--- a/drivers/tty/Kconfig
+++ b/drivers/tty/Kconfig
@@ -93,7 +93,7 @@ config VT_HW_CONSOLE_BINDING
          select the console driver that will serve as the backend for the
          virtual terminals.
 
-	 See <file:Documentation/console/console.rst> for more
+	 See <file:Documentation/driver-api/console.rst> for more
 	 information. For framebuffer console users, please refer to
 	 <file:Documentation/fb/fbcon.rst>.
 
diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index 5d6151392571..fd17db9b432f 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -25,7 +25,7 @@ menuconfig VFIO
 	select VFIO_IOMMU_TYPE1 if (X86 || S390 || ARM || ARM64)
 	help
 	  VFIO provides a framework for secure userspace device drivers.
-	  See Documentation/vfio.rst for more details.
+	  See Documentation/driver-api/vfio.rst for more details.
 
 	  If you don't know what to do here, say N.
 
diff --git a/drivers/vfio/mdev/Kconfig b/drivers/vfio/mdev/Kconfig
index 10ec404acbfc..5da27f2100f9 100644
--- a/drivers/vfio/mdev/Kconfig
+++ b/drivers/vfio/mdev/Kconfig
@@ -6,7 +6,7 @@ config VFIO_MDEV
 	default n
 	help
 	  Provides a framework to virtualize devices.
-	  See Documentation/vfio-mediated-device.rst for more details.
+	  See Documentation/driver-api/vfio-mediated-device.rst for more details.
 
 	  If you don't know what do here, say N.
 
diff --git a/drivers/w1/Kconfig b/drivers/w1/Kconfig
index 160053c0baea..3e7ad7b232fe 100644
--- a/drivers/w1/Kconfig
+++ b/drivers/w1/Kconfig
@@ -19,7 +19,7 @@ config W1_CON
 	default y
 	---help---
 	  This allows to communicate with userspace using connector. For more
-	  information see <file:Documentation/connector/connector.rst>.
+	  information see <file:Documentation/driver-api/connector.rst>.
 	  There are three types of messages between w1 core and userspace:
 	  1. Events. They are generated each time new master or slave device found
 		either due to automatic or requested search.
diff --git a/include/asm-generic/bitops/atomic.h b/include/asm-generic/bitops/atomic.h
index 6ee11717bb65..0afe930eec72 100644
--- a/include/asm-generic/bitops/atomic.h
+++ b/include/asm-generic/bitops/atomic.h
@@ -8,7 +8,7 @@
 
 /*
  * Implementation of atomic bitops using atomic-fetch ops.
- * See Documentation/atomic_bitops.rst for details.
+ * See Documentation/driver-api/atomic_bitops.rst for details.
  */
 
 static inline void set_bit(unsigned int nr, volatile unsigned long *p)
diff --git a/include/linux/io-mapping.h b/include/linux/io-mapping.h
index b90c540696a4..c8bf4852b352 100644
--- a/include/linux/io-mapping.h
+++ b/include/linux/io-mapping.h
@@ -28,7 +28,7 @@
  * The io_mapping mechanism provides an abstraction for mapping
  * individual pages from an io device to the CPU in an efficient fashion.
  *
- * See Documentation/io-mapping.rst
+ * See Documentation/driver-api/io-mapping.rst
  */
 
 struct io_mapping {
diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index c3947cab2d27..32bdce895487 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -68,7 +68,7 @@
  * Lacking toolchain and or architecture support, static keys fall back to a
  * simple conditional branch.
  *
- * Additional babbling in: Documentation/static-keys.rst
+ * Additional babbling in: Documentation/driver-api/static-keys.rst
  */
 
 #ifndef __ASSEMBLY__
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 16f66fe28ec2..d32720743004 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -7,7 +7,7 @@
  * Copyright (c) 2006-2008 Greg Kroah-Hartman <greg@kroah.com>
  * Copyright (c) 2006-2008 Novell Inc.
  *
- * Please read Documentation/kobject.rst before using the kobject
+ * Please read Documentation/driver-api/kobject.rst before using the kobject
  * interface, ESPECIALLY the parts about reference counts and object
  * destructors.
  */
diff --git a/include/linux/kobject_ns.h b/include/linux/kobject_ns.h
index 8c86c4641739..b5b7d387d63d 100644
--- a/include/linux/kobject_ns.h
+++ b/include/linux/kobject_ns.h
@@ -8,7 +8,7 @@
  *
  * Split from kobject.h by David Howells (dhowells@redhat.com)
  *
- * Please read Documentation/kobject.rst before using the kobject
+ * Please read Documentation/driver-api/kobject.rst before using the kobject
  * interface, ESPECIALLY the parts about reference counts and object
  * destructors.
  */
diff --git a/include/linux/rbtree.h b/include/linux/rbtree.h
index 2c579b6000a5..d49f78a8be37 100644
--- a/include/linux/rbtree.h
+++ b/include/linux/rbtree.h
@@ -11,7 +11,7 @@
   I know it's not the cleaner way,  but in C (not in C++) to get
   performances and genericity...
 
-  See Documentation/rbtree.rst for documentation and samples.
+  See Documentation/driver-api/rbtree.rst for documentation and samples.
 */
 
 #ifndef	_LINUX_RBTREE_H
diff --git a/include/linux/rbtree_augmented.h b/include/linux/rbtree_augmented.h
index b3f64a2935ae..5f31af0da0a9 100644
--- a/include/linux/rbtree_augmented.h
+++ b/include/linux/rbtree_augmented.h
@@ -21,7 +21,7 @@
  * rb_insert_augmented() and rb_erase_augmented() are intended to be public.
  * The rest are implementation details you are not expected to depend on.
  *
- * See Documentation/rbtree.rst for documentation and samples.
+ * See Documentation/driver-api/rbtree.rst for documentation and samples.
  */
 
 struct rb_augment_callbacks {
diff --git a/init/Kconfig b/init/Kconfig
index e02cfae73ce5..b9cfef1452e3 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1807,7 +1807,7 @@ config MMAP_ALLOW_UNINITIALIZED
 	  userspace.  Since that isn't generally a problem on no-MMU systems,
 	  it is normally safe to say Y here.
 
-	  See Documentation/nommu-mmap.rst for more information.
+	  See Documentation/driver-api/nommu-mmap.rst for more information.
 
 config SYSTEM_DATA_VERIFICATION
 	def_bool n
diff --git a/kernel/padata.c b/kernel/padata.c
index a567973bb1ba..fa3fb3b4705e 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -2,7 +2,7 @@
 /*
  * padata.c - generic interface to process data streams in parallel
  *
- * See Documentation/padata.rst for an api documentation.
+ * See Documentation/driver-api/padata.rst for an api documentation.
  *
  * Copyright (C) 2008, 2009 secunet Security Networks AG
  * Copyright (C) 2008, 2009 Steffen Klassert <steffen.klassert@secunet.com>
diff --git a/lib/Kconfig b/lib/Kconfig
index 58e9dae6f424..f4785afbfd10 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -420,7 +420,7 @@ config INTERVAL_TREE
 
 	  See:
 
-		Documentation/rbtree.rst
+		Documentation/driver-api/rbtree.rst
 
 	  for more information.
 
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index ce47efa5f4e4..47072d67fca1 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1682,7 +1682,7 @@ config PROVIDE_OHCI1394_DMA_INIT
 	  This code (~1k) is freed after boot. By then, the firewire stack
 	  in charge of the OHCI-1394 controllers should be used instead.
 
-	  See Documentation/debugging-via-ohci1394.rst for more information.
+	  See Documentation/driver-api/debugging-via-ohci1394.rst for more information.
 
 menuconfig RUNTIME_TESTING_MENU
 	bool "Runtime Testing"
diff --git a/lib/crc32.c b/lib/crc32.c
index 0de37ccc70dd..78d4cd8b709e 100644
--- a/lib/crc32.c
+++ b/lib/crc32.c
@@ -24,7 +24,7 @@
  * Version 2.  See the file COPYING for more details.
  */
 
-/* see: Documentation/crc32.rst for a description of algorithms */
+/* see: Documentation/driver-api/crc32.rst for a description of algorithms */
 
 #include <linux/crc32.h>
 #include <linux/crc32poly.h>
diff --git a/lib/kobject.c b/lib/kobject.c
index 03157ff88495..fe01ed0504e2 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -6,7 +6,7 @@
  * Copyright (c) 2006-2007 Greg Kroah-Hartman <greg@kroah.com>
  * Copyright (c) 2006-2007 Novell Inc.
  *
- * Please see the file Documentation/kobject.rst for critical information
+ * Please see the file Documentation/driver-api/kobject.rst for critical information
  * about using the kobject interface.
  */
 
@@ -668,7 +668,7 @@ static void kobject_cleanup(struct kobject *kobj)
 		 kobject_name(kobj), kobj, __func__, kobj->parent);
 
 	if (t && !t->release)
-		pr_debug("kobject: '%s' (%p): does not have a release() function, it is broken and must be fixed. See Documentation/kobject.rst.\n",
+		pr_debug("kobject: '%s' (%p): does not have a release() function, it is broken and must be fixed. See Documentation/driver-api/kobject.rst.\n",
 			 kobject_name(kobj), kobj);
 
 	/* send "remove" if the caller did not do it but sent "add" */
diff --git a/lib/lzo/lzo1x_decompress_safe.c b/lib/lzo/lzo1x_decompress_safe.c
index 1642c28e6627..27401806c355 100644
--- a/lib/lzo/lzo1x_decompress_safe.c
+++ b/lib/lzo/lzo1x_decompress_safe.c
@@ -32,7 +32,7 @@
  * depending on the base count. Since the base count is taken from a u8
  * and a few bits, it is safe to assume that it will always be lower than
  * or equal to 2*255, thus we can always prevent any overflow by accepting
- * two less 255 steps. See Documentation/lzo.rst for more information.
+ * two less 255 steps. See Documentation/driver-api/lzo.rst for more information.
  */
 #define MAX_255_COUNT      ((((size_t)~0) / 255) - 2)
 
diff --git a/lib/xz/Kconfig b/lib/xz/Kconfig
index 314a89c13545..9d8a66fdea9b 100644
--- a/lib/xz/Kconfig
+++ b/lib/xz/Kconfig
@@ -5,7 +5,7 @@ config XZ_DEC
 	help
 	  LZMA2 compression algorithm and BCJ filters are supported using
 	  the .xz file format as the container. For integrity checking,
-	  CRC32 is supported. See Documentation/xz.rst for more information.
+	  CRC32 is supported. See Documentation/driver-api/xz.rst for more information.
 
 if XZ_DEC
 
diff --git a/mm/Kconfig b/mm/Kconfig
index ed5fe68590f4..9a0bbbeafb58 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -369,7 +369,7 @@ config NOMMU_INITIAL_TRIM_EXCESS
 	  This option specifies the initial value of this option.  The default
 	  of 1 says that all excess pages should be trimmed.
 
-	  See Documentation/nommu-mmap.rst for more information.
+	  See Documentation/driver-api/nommu-mmap.rst for more information.
 
 config TRANSPARENT_HUGEPAGE
 	bool "Transparent Hugepage Support"
diff --git a/mm/nommu.c b/mm/nommu.c
index 30a071ba838d..d44944512f07 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -5,7 +5,7 @@
  *  Replacement code for mm functions to support CPU's that don't
  *  have any form of memory management unit (thus no virtual memory).
  *
- *  See Documentation/nommu-mmap.rst
+ *  See Documentation/driver-api/nommu-mmap.rst
  *
  *  Copyright (c) 2004-2008 David Howells <dhowells@redhat.com>
  *  Copyright (c) 2000-2003 David McCullough <davidm@snapgear.com>
diff --git a/samples/Kconfig b/samples/Kconfig
index 9ec524b2e003..2b1b4d241e47 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -100,7 +100,7 @@ config SAMPLE_CONNECTOR
 	  When enabled, this builds both a sample kernel module for
 	  the connector interface and a user space tool to communicate
 	  with it.
-	  See also Documentation/connector/connector.rst
+	  See also Documentation/driver-api/connector.rst
 
 config SAMPLE_SECCOMP
 	bool "Build seccomp sample code"
diff --git a/samples/kprobes/kprobe_example.c b/samples/kprobes/kprobe_example.c
index d76fd05304a5..1928cef27fd1 100644
--- a/samples/kprobes/kprobe_example.c
+++ b/samples/kprobes/kprobe_example.c
@@ -5,7 +5,7 @@
  * stack trace and selected registers when _do_fork() is called.
  *
  * For more information on theory of operation of kprobes, see
- * Documentation/kprobes.rst
+ * Documentation/driver-api/kprobes.rst
  *
  * You will see the trace data in /var/log/messages and on the console
  * whenever _do_fork() is invoked to create a new process.
diff --git a/samples/kprobes/kretprobe_example.c b/samples/kprobes/kretprobe_example.c
index 9a2234ae0286..d007feaa92d4 100644
--- a/samples/kprobes/kretprobe_example.c
+++ b/samples/kprobes/kretprobe_example.c
@@ -11,7 +11,7 @@
  * If no func_name is specified, _do_fork is instrumented
  *
  * For more information on theory of operation of kretprobes, see
- * Documentation/kprobes.rst
+ * Documentation/driver-api/kprobes.rst
  *
  * Build and insert the kernel module as done in the kprobe example.
  * You will see the trace data in /var/log/messages and on the console
diff --git a/scripts/gcc-plugins/Kconfig b/scripts/gcc-plugins/Kconfig
index b4dc5b116bfe..4a568069728d 100644
--- a/scripts/gcc-plugins/Kconfig
+++ b/scripts/gcc-plugins/Kconfig
@@ -23,7 +23,7 @@ config GCC_PLUGINS
 	  GCC plugins are loadable modules that provide extra features to the
 	  compiler. They are useful for runtime instrumentation and static analysis.
 
-	  See Documentation/gcc-plugins.rst for details.
+	  See Documentation/driver-api/gcc-plugins.rst for details.
 
 menu "GCC plugins"
 	depends on GCC_PLUGINS
diff --git a/tools/include/linux/rbtree.h b/tools/include/linux/rbtree.h
index e96d7120ce2b..0a36c807f65d 100644
--- a/tools/include/linux/rbtree.h
+++ b/tools/include/linux/rbtree.h
@@ -11,7 +11,7 @@
   I know it's not the cleaner way,  but in C (not in C++) to get
   performances and genericity...
 
-  See Documentation/rbtree.rst for documentation and samples.
+  See Documentation/driver-api/rbtree.rst for documentation and samples.
 */
 
 #ifndef __TOOLS_LINUX_PERF_RBTREE_H
diff --git a/tools/include/linux/rbtree_augmented.h b/tools/include/linux/rbtree_augmented.h
index c251bb16f2e9..201a873c2111 100644
--- a/tools/include/linux/rbtree_augmented.h
+++ b/tools/include/linux/rbtree_augmented.h
@@ -23,7 +23,7 @@
  * rb_insert_augmented() and rb_erase_augmented() are intended to be public.
  * The rest are implementation details you are not expected to depend on.
  *
- * See Documentation/rbtree.rst for documentation and samples.
+ * See Documentation/driver-api/rbtree.rst for documentation and samples.
  */
 
 struct rb_augment_callbacks {
-- 
2.21.0

