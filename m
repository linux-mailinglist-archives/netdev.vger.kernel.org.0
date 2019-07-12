Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCB2B663CF
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 04:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729377AbfGLCUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 22:20:52 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:44115 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729187AbfGLCUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 22:20:44 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=alex.shi@linux.alibaba.com;NM=1;PH=DS;RN=28;SR=0;TI=SMTPD_---0TWfJjMr_1562898034;
Received: from localhost(mailfrom:alex.shi@linux.alibaba.com fp:SMTPD_---0TWfJjMr_1562898034)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 12 Jul 2019 10:20:35 +0800
From:   Alex Shi <alex.shi@linux.alibaba.com>
To:     linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Cc:     Alex Shi <alex.shi@linux.alibaba.com>,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-sh@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Changbin Du <changbin.du@intel.com>,
        xen-devel@lists.xenproject.org,
        platform-driver-x86@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: [PATCH 11/12] Documentation/x86: repointer docs to Documentation/arch/
Date:   Fri, 12 Jul 2019 10:20:17 +0800
Message-Id: <20190712022018.27989-11-alex.shi@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.856.g8858448bb
In-Reply-To: <20190712022018.27989-1-alex.shi@linux.alibaba.com>
References: <20190712022018.27989-1-alex.shi@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since we move Documentation/x86 docs to Documentation/arch/x86
dir, redirect the doc pointer to them.

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Tony Luck <tony.luck@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Changbin Du <changbin.du@intel.com>
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xenproject.org
Cc: platform-driver-x86@vger.kernel.org
Cc: kvm@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org
Cc: netdev@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
---
 Documentation/admin-guide/hw-vuln/mds.rst            |  2 +-
 Documentation/admin-guide/kernel-parameters.rst      |  6 +++---
 Documentation/admin-guide/kernel-parameters.txt      |  8 ++++----
 Documentation/admin-guide/ras.rst                    |  2 +-
 Documentation/arch/x86/x86_64/5level-paging.rst      |  2 +-
 Documentation/arch/x86/x86_64/boot-options.rst       |  4 ++--
 .../arch/x86/x86_64/fake-numa-for-cpusets.rst        |  2 +-
 Documentation/devicetree/booting-without-of.txt      |  2 +-
 Documentation/sysctl/kernel.txt                      |  4 ++--
 MAINTAINERS                                          |  4 ++--
 arch/arm/Kconfig                                     |  2 +-
 arch/x86/Kconfig                                     | 12 ++++++------
 arch/x86/Kconfig.debug                               |  2 +-
 arch/x86/boot/header.S                               |  2 +-
 arch/x86/entry/entry_64.S                            |  2 +-
 arch/x86/include/asm/bootparam_utils.h               |  2 +-
 arch/x86/include/asm/page_64_types.h                 |  2 +-
 arch/x86/include/asm/pgtable_64_types.h              |  2 +-
 arch/x86/kernel/cpu/microcode/amd.c                  |  2 +-
 arch/x86/kernel/kexec-bzimage64.c                    |  2 +-
 arch/x86/kernel/pci-dma.c                            |  2 +-
 arch/x86/mm/tlb.c                                    |  2 +-
 arch/x86/platform/pvh/enlighten.c                    |  2 +-
 drivers/vhost/vhost.c                                |  2 +-
 security/Kconfig                                     |  2 +-
 tools/include/linux/err.h                            |  2 +-
 tools/objtool/Documentation/stack-validation.txt     |  4 ++--
 27 files changed, 41 insertions(+), 41 deletions(-)

diff --git a/Documentation/admin-guide/hw-vuln/mds.rst b/Documentation/admin-guide/hw-vuln/mds.rst
index e3a796c0d3a2..303228380fdc 100644
--- a/Documentation/admin-guide/hw-vuln/mds.rst
+++ b/Documentation/admin-guide/hw-vuln/mds.rst
@@ -58,7 +58,7 @@ Because the buffers are potentially shared between Hyper-Threads cross
 Hyper-Thread attacks are possible.
 
 Deeper technical information is available in the MDS specific x86
-architecture section: :ref:`Documentation/x86/mds.rst <mds>`.
+architecture section: :ref:`Documentation/arch/x86/mds.rst <mds>`.
 
 
 Attack scenarios
diff --git a/Documentation/admin-guide/kernel-parameters.rst b/Documentation/admin-guide/kernel-parameters.rst
index dc283dcffae8..7c32484811c8 100644
--- a/Documentation/admin-guide/kernel-parameters.rst
+++ b/Documentation/admin-guide/kernel-parameters.rst
@@ -167,7 +167,7 @@ parameter is applicable::
 	X86-32	X86-32, aka i386 architecture is enabled.
 	X86-64	X86-64 architecture is enabled.
 			More X86-64 boot options can be found in
-			Documentation/x86/x86_64/boot-options.rst.
+			Documentation/arch/x86/x86_64/boot-options.rst.
 	X86	Either 32-bit or 64-bit x86 (same as X86-32+X86-64)
 	X86_UV	SGI UV support is enabled.
 	XEN	Xen support is enabled
@@ -181,10 +181,10 @@ In addition, the following text indicates that the option::
 Parameters denoted with BOOT are actually interpreted by the boot
 loader, and have no meaning to the kernel directly.
 Do not modify the syntax of boot loader parameters without extreme
-need or coordination with <Documentation/x86/boot.rst>.
+need or coordination with <Documentation/arch/x86/boot.rst>.
 
 There are also arch-specific kernel-parameters not documented here.
-See for example <Documentation/x86/x86_64/boot-options.rst>.
+See for example <Documentation/arch/x86/x86_64/boot-options.rst>.
 
 Note that ALL kernel parameters listed below are CASE SENSITIVE, and that
 a trailing = on the name of any parameter states that that parameter will
diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 4ceb4691245b..d9eb5895ea9e 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -963,7 +963,7 @@
 			for details.
 
 	nompx		[X86] Disables Intel Memory Protection Extensions.
-			See Documentation/x86/intel_mpx.rst for more
+			See Documentation/arch/x86/intel_mpx.rst for more
 			information about the feature.
 
 	nopku		[X86] Disable Memory Protection Keys CPU feature found
@@ -2380,7 +2380,7 @@
 
 	mce		[X86-32] Machine Check Exception
 
-	mce=option	[X86-64] See Documentation/x86/x86_64/boot-options.rst
+	mce=option	[X86-64] See Documentation/arch/x86/x86_64/boot-options.rst
 
 	md=		[HW] RAID subsystems devices and level
 			See Documentation/admin-guide/md.rst.
@@ -3526,7 +3526,7 @@
 			See Documentation/blockdev/paride.txt.
 
 	pirq=		[SMP,APIC] Manual mp-table setup
-			See Documentation/x86/i386/IO-APIC.rst.
+			See Documentation/arch/x86/i386/IO-APIC.rst.
 
 	plip=		[PPT,NET] Parallel port network link
 			Format: { parport<nr> | timid | 0 }
@@ -5058,7 +5058,7 @@
 			Can be used multiple times for multiple devices.
 
 	vga=		[BOOT,X86-32] Select a particular video mode
-			See Documentation/x86/boot.rst and
+			See Documentation/arch/x86/boot.rst and
 			Documentation/svga.txt.
 			Use vga=ask for menu.
 			This is actually a boot loader parameter; the value is
diff --git a/Documentation/admin-guide/ras.rst b/Documentation/admin-guide/ras.rst
index 2b20f5f7380d..2d86862458aa 100644
--- a/Documentation/admin-guide/ras.rst
+++ b/Documentation/admin-guide/ras.rst
@@ -199,7 +199,7 @@ Architecture (MCA)\ [#f3]_.
   mode).
 
 .. [#f3] For more details about the Machine Check Architecture (MCA),
-  please read Documentation/x86/x86_64/machinecheck.rst at the Kernel tree.
+  please read Documentation/arch/x86/x86_64/machinecheck.rst at the Kernel tree.
 
 EDAC - Error Detection And Correction
 *************************************
diff --git a/Documentation/arch/x86/x86_64/5level-paging.rst b/Documentation/arch/x86/x86_64/5level-paging.rst
index 44856417e6a5..000809878403 100644
--- a/Documentation/arch/x86/x86_64/5level-paging.rst
+++ b/Documentation/arch/x86/x86_64/5level-paging.rst
@@ -20,7 +20,7 @@ physical address space. This "ought to be enough for anybody" ©.
 QEMU 2.9 and later support 5-level paging.
 
 Virtual memory layout for 5-level paging is described in
-Documentation/x86/x86_64/mm.rst
+Documentation/arch/x86/x86_64/mm.rst
 
 
 Enabling 5-level paging
diff --git a/Documentation/arch/x86/x86_64/boot-options.rst b/Documentation/arch/x86/x86_64/boot-options.rst
index 6a4285a3c7a4..2a093128b28f 100644
--- a/Documentation/arch/x86/x86_64/boot-options.rst
+++ b/Documentation/arch/x86/x86_64/boot-options.rst
@@ -9,7 +9,7 @@ only the AMD64 specific ones are listed here.
 
 Machine check
 =============
-Please see Documentation/x86/x86_64/machinecheck.rst for sysfs runtime tunables.
+Please see Documentation/arch/x86/x86_64/machinecheck.rst for sysfs runtime tunables.
 
    mce=off
 		Disable machine check
@@ -89,7 +89,7 @@ APICs
      Don't use the local APIC (alias for i386 compatibility)
 
    pirq=...
-	See Documentation/x86/i386/IO-APIC.rst
+	See Documentation/arch/x86/i386/IO-APIC.rst
 
    noapictimer
 	Don't set up the APIC timer
diff --git a/Documentation/arch/x86/x86_64/fake-numa-for-cpusets.rst b/Documentation/arch/x86/x86_64/fake-numa-for-cpusets.rst
index 30108684ae87..d960f5cac258 100644
--- a/Documentation/arch/x86/x86_64/fake-numa-for-cpusets.rst
+++ b/Documentation/arch/x86/x86_64/fake-numa-for-cpusets.rst
@@ -18,7 +18,7 @@ For more information on the features of cpusets, see
 Documentation/cgroup-v1/cpusets.rst.
 There are a number of different configurations you can use for your needs.  For
 more information on the numa=fake command line option and its various ways of
-configuring fake nodes, see Documentation/x86/x86_64/boot-options.rst.
+configuring fake nodes, see Documentation/arch/x86/x86_64/boot-options.rst.
 
 For the purposes of this introduction, we'll assume a very primitive NUMA
 emulation setup of "numa=fake=4*512,".  This will split our system memory into
diff --git a/Documentation/devicetree/booting-without-of.txt b/Documentation/devicetree/booting-without-of.txt
index 58d606fca7eb..066778cbbdcb 100644
--- a/Documentation/devicetree/booting-without-of.txt
+++ b/Documentation/devicetree/booting-without-of.txt
@@ -277,7 +277,7 @@ it with special cases.
   the decompressor (the real mode entry point goes to the same  32bit
   entry point once it switched into protected mode). That entry point
   supports one calling convention which is documented in
-  Documentation/x86/boot.rst
+  Documentation/arch/x86/boot.rst
   The physical pointer to the device-tree block (defined in chapter II)
   is passed via setup_data which requires at least boot protocol 2.09.
   The type filed is defined as
diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 1b2fe17cd2fa..b3e3c56bdab8 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -154,7 +154,7 @@ is 0x15 and the full version number is 0x234, this file will contain
 the value 340 = 0x154.
 
 See the type_of_loader and ext_loader_type fields in
-Documentation/x86/boot.rst for additional information.
+Documentation/arch/x86/boot.rst for additional information.
 
 ==============================================================
 
@@ -166,7 +166,7 @@ The complete bootloader version number.  In the example above, this
 file will contain the value 564 = 0x234.
 
 See the type_of_loader and ext_loader_ver fields in
-Documentation/x86/boot.rst for additional information.
+Documentation/arch/x86/boot.rst for additional information.
 
 ==============================================================
 
diff --git a/MAINTAINERS b/MAINTAINERS
index 84448d5838b7..e1aa61c72cb1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13351,7 +13351,7 @@ L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	arch/x86/kernel/cpu/resctrl/
 F:	arch/x86/include/asm/resctrl_sched.h
-F:	Documentation/x86/resctrl*
+F:	Documentation/arch/x86/resctrl*
 
 READ-COPY UPDATE (RCU)
 M:	"Paul E. McKenney" <paulmck@linux.ibm.com>
@@ -17258,7 +17258,7 @@ L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/core
 S:	Maintained
 F:	Documentation/devicetree/bindings/x86/
-F:	Documentation/x86/
+F:	Documentation/arch/x86/
 F:	arch/x86/
 
 X86 ENTRY CODE
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 1b276dda837d..b2b8d3c15285 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1293,7 +1293,7 @@ config SMP
 	  uniprocessor machines. On a uniprocessor machine, the kernel
 	  will run faster if you say N here.
 
-	  See also <file:Documentation/x86/i386/IO-APIC.rst>,
+	  See also <file:Documentation/arch/x86/i386/IO-APIC.rst>,
 	  <file:Documentation/lockup-watchdogs.txt> and the SMP-HOWTO available at
 	  <http://tldp.org/HOWTO/SMP-HOWTO.html>.
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index dce10b18f4bc..5489f42e005e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -399,7 +399,7 @@ config SMP
 	  Y to "Enhanced Real Time Clock Support", below. The "Advanced Power
 	  Management" code will be disabled if you say Y here.
 
-	  See also <file:Documentation/x86/i386/IO-APIC.rst>,
+	  See also <file:Documentation/arch/x86/i386/IO-APIC.rst>,
 	  <file:Documentation/lockup-watchdogs.txt> and the SMP-HOWTO available at
 	  <http://www.tldp.org/docs.html#howto>.
 
@@ -1308,7 +1308,7 @@ config MICROCODE
 	  the Linux kernel.
 
 	  The preferred method to load microcode from a detached initrd is described
-	  in Documentation/x86/microcode.rst. For that you need to enable
+	  in Documentation/arch/x86/microcode.rst. For that you need to enable
 	  CONFIG_BLK_DEV_INITRD in order for the loader to be able to scan the
 	  initrd for microcode blobs.
 
@@ -1347,7 +1347,7 @@ config MICROCODE_OLD_INTERFACE
 	  It is inadequate because it runs too late to be able to properly
 	  load microcode on a machine and it needs special tools. Instead, you
 	  should've switched to the early loading method with the initrd or
-	  builtin microcode by now: Documentation/x86/microcode.rst
+	  builtin microcode by now: Documentation/arch/x86/microcode.rst
 
 config X86_MSR
 	tristate "/dev/cpu/*/msr - Model-specific register support"
@@ -1496,7 +1496,7 @@ config X86_5LEVEL
 	  A kernel with the option enabled can be booted on machines that
 	  support 4- or 5-level paging.
 
-	  See Documentation/x86/x86_64/5level-paging.rst for more
+	  See Documentation/arch/x86/x86_64/5level-paging.rst for more
 	  information.
 
 	  Say N if unsure.
@@ -1801,7 +1801,7 @@ config MTRR
 	  You can safely say Y even if your machine doesn't have MTRRs, you'll
 	  just add about 9 KB to your kernel.
 
-	  See <file:Documentation/x86/mtrr.rst> for more information.
+	  See <file:Documentation/arch/x86/mtrr.rst> for more information.
 
 config MTRR_SANITIZER
 	def_bool y
@@ -1913,7 +1913,7 @@ config X86_INTEL_MPX
 	  process and adds some branches to paths used during
 	  exec() and munmap().
 
-	  For details, see Documentation/x86/intel_mpx.rst
+	  For details, see Documentation/arch/x86/intel_mpx.rst
 
 	  If unsure, say N.
 
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 71c92db47c41..814353667075 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -156,7 +156,7 @@ config IOMMU_DEBUG
 	  code. When you use it make sure you have a big enough
 	  IOMMU/AGP aperture.  Most of the options enabled by this can
 	  be set more finegrained using the iommu= command line
-	  options. See Documentation/x86/x86_64/boot-options.rst for more
+	  options. See Documentation/arch/x86/x86_64/boot-options.rst for more
 	  details.
 
 config IOMMU_LEAK
diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 2c11c0f45d49..5ec825c863a6 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -313,7 +313,7 @@ start_sys_seg:	.word	SYSSEG		# obsolete and meaningless, but just
 
 type_of_loader:	.byte	0		# 0 means ancient bootloader, newer
 					# bootloaders know to change this.
-					# See Documentation/x86/boot.rst for
+					# See Documentation/arch/x86/boot.rst for
 					# assigned ids
 
 # flags, unused bits must be zero (RFU) bit within loadflags
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 0ea4831a72a4..981951124d53 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -8,7 +8,7 @@
  *
  * entry.S contains the system-call and fault low-level handling routines.
  *
- * Some of this is documented in Documentation/x86/entry_64.rst
+ * Some of this is documented in Documentation/arch/x86/entry_64.rst
  *
  * A note on terminology:
  * - iret frame:	Architecture defined interrupt frame from SS to RIP
diff --git a/arch/x86/include/asm/bootparam_utils.h b/arch/x86/include/asm/bootparam_utils.h
index 101eb944f13c..585daca7682b 100644
--- a/arch/x86/include/asm/bootparam_utils.h
+++ b/arch/x86/include/asm/bootparam_utils.h
@@ -24,7 +24,7 @@ static void sanitize_boot_params(struct boot_params *boot_params)
 	 * IMPORTANT NOTE TO BOOTLOADER AUTHORS: do not simply clear
 	 * this field.  The purpose of this field is to guarantee
 	 * compliance with the x86 boot spec located in
-	 * Documentation/x86/boot.rst .  That spec says that the
+	 * Documentation/arch/x86/boot.rst .  That spec says that the
 	 * *whole* structure should be cleared, after which only the
 	 * portion defined by struct setup_header (boot_params->hdr)
 	 * should be copied in.
diff --git a/arch/x86/include/asm/page_64_types.h b/arch/x86/include/asm/page_64_types.h
index 288b065955b7..70d71bdd77da 100644
--- a/arch/x86/include/asm/page_64_types.h
+++ b/arch/x86/include/asm/page_64_types.h
@@ -48,7 +48,7 @@
 
 #define __START_KERNEL_map	_AC(0xffffffff80000000, UL)
 
-/* See Documentation/x86/x86_64/mm.rst for a description of the memory map. */
+/* See Documentation/arch/x86/x86_64/mm.rst for a description of the memory map. */
 
 #define __PHYSICAL_MASK_SHIFT	52
 
diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
index 52e5f5f2240d..ec3fe348bbd4 100644
--- a/arch/x86/include/asm/pgtable_64_types.h
+++ b/arch/x86/include/asm/pgtable_64_types.h
@@ -103,7 +103,7 @@ extern unsigned int ptrs_per_p4d;
 #define PGDIR_MASK	(~(PGDIR_SIZE - 1))
 
 /*
- * See Documentation/x86/x86_64/mm.rst for a description of the memory map.
+ * See Documentation/arch/x86/x86_64/mm.rst for a description of the memory map.
  *
  * Be very careful vs. KASLR when changing anything here. The KASLR address
  * range must not overlap with anything except the KASAN shadow area, which
diff --git a/arch/x86/kernel/cpu/microcode/amd.c b/arch/x86/kernel/cpu/microcode/amd.c
index a0e52bd00ecc..146374651036 100644
--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -59,7 +59,7 @@ static u8 amd_ucode_patch[PATCH_MAX_SIZE];
 
 /*
  * Microcode patch container file is prepended to the initrd in cpio
- * format. See Documentation/x86/microcode.rst
+ * format. See Documentation/arch/x86/microcode.rst
  */
 static const char
 ucode_path[] __maybe_unused = "kernel/x86/microcode/AuthenticAMD.bin";
diff --git a/arch/x86/kernel/kexec-bzimage64.c b/arch/x86/kernel/kexec-bzimage64.c
index 5ebcd02cbca7..108d72bcfa28 100644
--- a/arch/x86/kernel/kexec-bzimage64.c
+++ b/arch/x86/kernel/kexec-bzimage64.c
@@ -419,7 +419,7 @@ static void *bzImage64_load(struct kimage *image, char *kernel,
 	efi_map_offset = params_cmdline_sz;
 	efi_setup_data_offset = efi_map_offset + ALIGN(efi_map_sz, 16);
 
-	/* Copy setup header onto bootparams. Documentation/x86/boot.rst */
+	/* Copy setup header onto bootparams. Documentation/arch/x86/boot.rst */
 	setup_header_size = 0x0202 + kernel[0x0201] - setup_hdr_offset;
 
 	/* Is there a limit on setup header size? */
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index f62b498b18fb..a34c72e924ec 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -70,7 +70,7 @@ void __init pci_iommu_alloc(void)
 }
 
 /*
- * See <Documentation/x86/x86_64/boot-options.rst> for the iommu kernel
+ * See <Documentation/arch/x86/x86_64/boot-options.rst> for the iommu kernel
  * parameter documentation.
  */
 static __init int iommu_setup(char *p)
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 4de9704c4aaf..855498ab4453 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -712,7 +712,7 @@ void native_flush_tlb_others(const struct cpumask *cpumask,
 }
 
 /*
- * See Documentation/x86/tlb.rst for details.  We choose 33
+ * See Documentation/arch/x86/tlb.rst for details.  We choose 33
  * because it is large enough to cover the vast majority (at
  * least 95%) of allocations, and is small enough that we are
  * confident it will not cause too much overhead.  Each single
diff --git a/arch/x86/platform/pvh/enlighten.c b/arch/x86/platform/pvh/enlighten.c
index c0a502f7e3a7..15a74dbc9b00 100644
--- a/arch/x86/platform/pvh/enlighten.c
+++ b/arch/x86/platform/pvh/enlighten.c
@@ -86,7 +86,7 @@ static void __init init_pvh_bootparams(bool xen_guest)
 	}
 
 	/*
-	 * See Documentation/x86/boot.rst.
+	 * See Documentation/arch/x86/boot.rst.
 	 *
 	 * Version 2.12 supports Xen entry point but we will use default x86/PC
 	 * environment (i.e. hardware_subarch 0).
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index ff8892c38666..f5c1868d5d5f 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1711,7 +1711,7 @@ EXPORT_SYMBOL_GPL(vhost_dev_ioctl);
 
 /* TODO: This is really inefficient.  We need something like get_user()
  * (instruction directly accesses the data, with an exception table entry
- * returning -EFAULT). See Documentation/x86/exception-tables.rst.
+ * returning -EFAULT). See Documentation/arch/x86/exception-tables.rst.
  */
 static int set_bit_to_user(int nr, void __user *addr)
 {
diff --git a/security/Kconfig b/security/Kconfig
index 06a30851511a..d26d9f205441 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -63,7 +63,7 @@ config PAGE_TABLE_ISOLATION
 	  ensuring that the majority of kernel addresses are not mapped
 	  into userspace.
 
-	  See Documentation/x86/pti.rst for more details.
+	  See Documentation/arch/x86/pti.rst for more details.
 
 config SECURITY_INFINIBAND
 	bool "Infiniband Security Hooks"
diff --git a/tools/include/linux/err.h b/tools/include/linux/err.h
index 25f2bb3a991d..332b983ead1e 100644
--- a/tools/include/linux/err.h
+++ b/tools/include/linux/err.h
@@ -20,7 +20,7 @@
  * Userspace note:
  * The same principle works for userspace, because 'error' pointers
  * fall down to the unused hole far from user space, as described
- * in Documentation/x86/x86_64/mm.rst for x86_64 arch:
+ * in Documentation/arch/x86/x86_64/mm.rst for x86_64 arch:
  *
  * 0000000000000000 - 00007fffffffffff (=47 bits) user space, different per mm hole caused by [48:63] sign extension
  * ffffffffffe00000 - ffffffffffffffff (=2 MB) unused hole
diff --git a/tools/objtool/Documentation/stack-validation.txt b/tools/objtool/Documentation/stack-validation.txt
index de094670050b..87b6b4d1175a 100644
--- a/tools/objtool/Documentation/stack-validation.txt
+++ b/tools/objtool/Documentation/stack-validation.txt
@@ -21,7 +21,7 @@ instructions).  Similarly, it knows how to follow switch statements, for
 which gcc sometimes uses jump tables.
 
 (Objtool also has an 'orc generate' subcommand which generates debuginfo
-for the ORC unwinder.  See Documentation/x86/orc-unwinder.rst in the
+for the ORC unwinder.  See Documentation/arch/x86/orc-unwinder.rst in the
 kernel tree for more details.)
 
 
@@ -101,7 +101,7 @@ b) ORC (Oops Rewind Capability) unwind table generation
    band.  So it doesn't affect runtime performance and it can be
    reliable even when interrupts or exceptions are involved.
 
-   For more details, see Documentation/x86/orc-unwinder.rst.
+   For more details, see Documentation/arch/x86/orc-unwinder.rst.
 
 c) Higher live patching compatibility rate
 
-- 
2.19.1.856.g8858448bb

