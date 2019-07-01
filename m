Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2778A23B0E
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 16:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403936AbfETOsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 10:48:45 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:35256 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387692AbfETOsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 10:48:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
        To:From:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=U/K9yxJT4IlEpIM3OGpo6SRaZIfVwwXhb7z7p+swaU8=; b=rCQ7VCUTTkp/XmFYFqRHGbxWRt
        PzkrLXS9OOCpyb1ziaSu1THw2S3GgEac8oETYhy0N/o91uHYH8SSgxusj74kTaC4mmI2R6KEuI+si
        H0sKpe56FDS8kv1XdNsYaEtRlYzvAIcJCn1tdZnMvBMUl3jvWW8nrVIFLQPAAHHNjsPyRs3F/5vIE
        LthoURlT11FjA1Bpz0spPKr3BybseFSzQ74+uPI15Tcg9W9hm1+MZBL+79r1V3QWuhNmOL6Nh8+UO
        7ChgBgxsC0anADHJSWGjGXP+Y2cD4Gx44Ip0u/Qc+r49HBeQWh1bK97eT9vkwhAHiVWSQ93Pto1Ai
        bzM9KK7Q==;
Received: from [179.176.119.151] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hSja3-0000Ha-SF; Mon, 20 May 2019 14:48:00 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1hSja0-00011M-6w; Mon, 20 May 2019 11:47:56 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        x86@kernel.org, linux-acpi@vger.kernel.org,
        linux-edac@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-i2c@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, xen-devel@lists.xenproject.org,
        platform-driver-x86@vger.kernel.org, devel@driverdev.osuosl.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        devel@acpica.org, linux-mm@kvack.org,
        linux-security-module@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH 10/10] docs: fix broken documentation links
Date:   Mon, 20 May 2019 11:47:39 -0300
Message-Id: <4fd1182b4a41feb2447c7ccde4d7f0a6b3c92686.1558362030.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1558362030.git.mchehab+samsung@kernel.org>
References: <cover.1558362030.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mostly due to x86 and acpi conversion, several documentation
links are still pointing to the old file. Fix them.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 Documentation/acpi/dsd/leds.txt                  |  2 +-
 Documentation/admin-guide/kernel-parameters.rst  |  6 +++---
 Documentation/admin-guide/kernel-parameters.txt  | 16 ++++++++--------
 Documentation/admin-guide/ras.rst                |  2 +-
 .../devicetree/bindings/net/fsl-enetc.txt        |  7 +++----
 .../bindings/pci/amlogic,meson-pcie.txt          |  2 +-
 .../bindings/regulator/qcom,rpmh-regulator.txt   |  2 +-
 Documentation/devicetree/booting-without-of.txt  |  2 +-
 Documentation/driver-api/gpio/board.rst          |  2 +-
 Documentation/driver-api/gpio/consumer.rst       |  2 +-
 .../firmware-guide/acpi/enumeration.rst          |  2 +-
 .../firmware-guide/acpi/method-tracing.rst       |  2 +-
 Documentation/i2c/instantiating-devices          |  2 +-
 Documentation/sysctl/kernel.txt                  |  4 ++--
 .../translations/it_IT/process/4.Coding.rst      |  2 +-
 .../translations/it_IT/process/howto.rst         |  2 +-
 .../it_IT/process/stable-kernel-rules.rst        |  4 ++--
 .../translations/zh_CN/process/4.Coding.rst      |  2 +-
 Documentation/x86/x86_64/5level-paging.rst       |  2 +-
 Documentation/x86/x86_64/boot-options.rst        |  4 ++--
 .../x86/x86_64/fake-numa-for-cpusets.rst         |  2 +-
 MAINTAINERS                                      |  6 +++---
 arch/arm/Kconfig                                 |  2 +-
 arch/arm64/kernel/kexec_image.c                  |  2 +-
 arch/powerpc/Kconfig                             |  2 +-
 arch/x86/Kconfig                                 | 16 ++++++++--------
 arch/x86/Kconfig.debug                           |  2 +-
 arch/x86/boot/header.S                           |  2 +-
 arch/x86/entry/entry_64.S                        |  2 +-
 arch/x86/include/asm/bootparam_utils.h           |  2 +-
 arch/x86/include/asm/page_64_types.h             |  2 +-
 arch/x86/include/asm/pgtable_64_types.h          |  2 +-
 arch/x86/kernel/cpu/microcode/amd.c              |  2 +-
 arch/x86/kernel/kexec-bzimage64.c                |  2 +-
 arch/x86/kernel/pci-dma.c                        |  2 +-
 arch/x86/mm/tlb.c                                |  2 +-
 arch/x86/platform/pvh/enlighten.c                |  2 +-
 drivers/acpi/Kconfig                             | 10 +++++-----
 drivers/net/ethernet/faraday/ftgmac100.c         |  2 +-
 .../fieldbus/Documentation/fieldbus_dev.txt      |  4 ++--
 drivers/vhost/vhost.c                            |  2 +-
 include/acpi/acpi_drivers.h                      |  2 +-
 include/linux/fs_context.h                       |  2 +-
 include/linux/lsm_hooks.h                        |  2 +-
 mm/Kconfig                                       |  2 +-
 security/Kconfig                                 |  2 +-
 tools/include/linux/err.h                        |  2 +-
 tools/objtool/Documentation/stack-validation.txt |  4 ++--
 tools/testing/selftests/x86/protection_keys.c    |  2 +-
 49 files changed, 78 insertions(+), 79 deletions(-)

diff --git a/Documentation/acpi/dsd/leds.txt b/Documentation/acpi/dsd/leds.txt
index 81a63af42ed2..cc58b1a574c5 100644
--- a/Documentation/acpi/dsd/leds.txt
+++ b/Documentation/acpi/dsd/leds.txt
@@ -96,4 +96,4 @@ where
     <URL:http://www.uefi.org/sites/default/files/resources/_DSD-hierarchical-data-extension-UUID-v1.1.pdf>,
     referenced 2019-02-21.
 
-[7] Documentation/acpi/dsd/data-node-reference.txt
+[7] Documentation/firmware-guide/acpi/dsd/data-node-references.rst
diff --git a/Documentation/admin-guide/kernel-parameters.rst b/Documentation/admin-guide/kernel-parameters.rst
index 0124980dca2d..8d3273e32eb1 100644
--- a/Documentation/admin-guide/kernel-parameters.rst
+++ b/Documentation/admin-guide/kernel-parameters.rst
@@ -167,7 +167,7 @@ parameter is applicable::
 	X86-32	X86-32, aka i386 architecture is enabled.
 	X86-64	X86-64 architecture is enabled.
 			More X86-64 boot options can be found in
-			Documentation/x86/x86_64/boot-options.txt .
+			Documentation/x86/x86_64/boot-options.rst.
 	X86	Either 32-bit or 64-bit x86 (same as X86-32+X86-64)
 	X86_UV	SGI UV support is enabled.
 	XEN	Xen support is enabled
@@ -181,10 +181,10 @@ In addition, the following text indicates that the option::
 Parameters denoted with BOOT are actually interpreted by the boot
 loader, and have no meaning to the kernel directly.
 Do not modify the syntax of boot loader parameters without extreme
-need or coordination with <Documentation/x86/boot.txt>.
+need or coordination with <Documentation/x86/boot.rst>.
 
 There are also arch-specific kernel-parameters not documented here.
-See for example <Documentation/x86/x86_64/boot-options.txt>.
+See for example <Documentation/x86/x86_64/boot-options.rst>.
 
 Note that ALL kernel parameters listed below are CASE SENSITIVE, and that
 a trailing = on the name of any parameter states that that parameter will
diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 138f6664b2e2..bc5f202d42ec 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -53,7 +53,7 @@
 			ACPI_DEBUG_PRINT statements, e.g.,
 			    ACPI_DEBUG_PRINT((ACPI_DB_INFO, ...
 			The debug_level mask defaults to "info".  See
-			Documentation/acpi/debug.txt for more information about
+			Documentation/firmware-guide/acpi/debug.rst for more information about
 			debug layers and levels.
 
 			Enable processor driver info messages:
@@ -963,7 +963,7 @@
 			for details.
 
 	nompx		[X86] Disables Intel Memory Protection Extensions.
-			See Documentation/x86/intel_mpx.txt for more
+			See Documentation/x86/intel_mpx.rst for more
 			information about the feature.
 
 	nopku		[X86] Disable Memory Protection Keys CPU feature found
@@ -1189,7 +1189,7 @@
 			that is to be dynamically loaded by Linux. If there are
 			multiple variables with the same name but with different
 			vendor GUIDs, all of them will be loaded. See
-			Documentation/acpi/ssdt-overlays.txt for details.
+			Documentation/admin-guide/acpi/ssdt-overlays.rst for details.
 
 
 	eisa_irq_edge=	[PARISC,HW]
@@ -2383,7 +2383,7 @@
 
 	mce		[X86-32] Machine Check Exception
 
-	mce=option	[X86-64] See Documentation/x86/x86_64/boot-options.txt
+	mce=option	[X86-64] See Documentation/x86/x86_64/boot-options.rst
 
 	md=		[HW] RAID subsystems devices and level
 			See Documentation/admin-guide/md.rst.
@@ -2439,7 +2439,7 @@
 			set according to the
 			CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE kernel config
 			option.
-			See Documentation/memory-hotplug.txt.
+			See Documentation/admin-guide/mm/memory-hotplug.rst.
 
 	memmap=exactmap	[KNL,X86] Enable setting of an exact
 			E820 memory map, as specified by the user.
@@ -2528,7 +2528,7 @@
 			mem_encrypt=on:		Activate SME
 			mem_encrypt=off:	Do not activate SME
 
-			Refer to Documentation/x86/amd-memory-encryption.txt
+			Refer to Documentation/x86/amd-memory-encryption.rst
 			for details on when memory encryption can be activated.
 
 	mem_sleep_default=	[SUSPEND] Default system suspend mode:
@@ -3528,7 +3528,7 @@
 			See Documentation/blockdev/paride.txt.
 
 	pirq=		[SMP,APIC] Manual mp-table setup
-			See Documentation/x86/i386/IO-APIC.txt.
+			See Documentation/x86/i386/IO-APIC.rst.
 
 	plip=		[PPT,NET] Parallel port network link
 			Format: { parport<nr> | timid | 0 }
@@ -5054,7 +5054,7 @@
 			Can be used multiple times for multiple devices.
 
 	vga=		[BOOT,X86-32] Select a particular video mode
-			See Documentation/x86/boot.txt and
+			See Documentation/x86/boot.rst and
 			Documentation/svga.txt.
 			Use vga=ask for menu.
 			This is actually a boot loader parameter; the value is
diff --git a/Documentation/admin-guide/ras.rst b/Documentation/admin-guide/ras.rst
index c7495e42e6f4..2b20f5f7380d 100644
--- a/Documentation/admin-guide/ras.rst
+++ b/Documentation/admin-guide/ras.rst
@@ -199,7 +199,7 @@ Architecture (MCA)\ [#f3]_.
   mode).
 
 .. [#f3] For more details about the Machine Check Architecture (MCA),
-  please read Documentation/x86/x86_64/machinecheck at the Kernel tree.
+  please read Documentation/x86/x86_64/machinecheck.rst at the Kernel tree.
 
 EDAC - Error Detection And Correction
 *************************************
diff --git a/Documentation/devicetree/bindings/net/fsl-enetc.txt b/Documentation/devicetree/bindings/net/fsl-enetc.txt
index c812e25ae90f..25fc687419db 100644
--- a/Documentation/devicetree/bindings/net/fsl-enetc.txt
+++ b/Documentation/devicetree/bindings/net/fsl-enetc.txt
@@ -16,8 +16,8 @@ Required properties:
 In this case, the ENETC node should include a "mdio" sub-node
 that in turn should contain the "ethernet-phy" node describing the
 external phy.  Below properties are required, their bindings
-already defined in ethernet.txt or phy.txt, under
-Documentation/devicetree/bindings/net/*.
+already defined in Documentation/devicetree/bindings/net/ethernet.txt or
+Documentation/devicetree/bindings/net/phy.txt.
 
 Required:
 
@@ -51,8 +51,7 @@ Example:
 connection:
 
 In this case, the ENETC port node defines a fixed link connection,
-as specified by "fixed-link.txt", under
-Documentation/devicetree/bindings/net/*.
+as specified by Documentation/devicetree/bindings/net/fixed-link.txt.
 
 Required:
 
diff --git a/Documentation/devicetree/bindings/pci/amlogic,meson-pcie.txt b/Documentation/devicetree/bindings/pci/amlogic,meson-pcie.txt
index 12b18f82d441..efa2c8b9b85a 100644
--- a/Documentation/devicetree/bindings/pci/amlogic,meson-pcie.txt
+++ b/Documentation/devicetree/bindings/pci/amlogic,meson-pcie.txt
@@ -3,7 +3,7 @@ Amlogic Meson AXG DWC PCIE SoC controller
 Amlogic Meson PCIe host controller is based on the Synopsys DesignWare PCI core.
 It shares common functions with the PCIe DesignWare core driver and
 inherits common properties defined in
-Documentation/devicetree/bindings/pci/designware-pci.txt.
+Documentation/devicetree/bindings/pci/designware-pcie.txt.
 
 Additional properties are described here:
 
diff --git a/Documentation/devicetree/bindings/regulator/qcom,rpmh-regulator.txt b/Documentation/devicetree/bindings/regulator/qcom,rpmh-regulator.txt
index 7ef2dbe48e8a..14d2eee96b3d 100644
--- a/Documentation/devicetree/bindings/regulator/qcom,rpmh-regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/qcom,rpmh-regulator.txt
@@ -97,7 +97,7 @@ Second Level Nodes - Regulators
 		    sent for this regulator including those which are for a
 		    strictly lower power state.
 
-Other properties defined in Documentation/devicetree/bindings/regulator.txt
+Other properties defined in Documentation/devicetree/bindings/regulator/regulator.txt
 may also be used.  regulator-initial-mode and regulator-allowed-modes may be
 specified for VRM regulators using mode values from
 include/dt-bindings/regulator/qcom,rpmh-regulator.h.  regulator-allow-bypass
diff --git a/Documentation/devicetree/booting-without-of.txt b/Documentation/devicetree/booting-without-of.txt
index e86bd2f64117..60f8640f2b2f 100644
--- a/Documentation/devicetree/booting-without-of.txt
+++ b/Documentation/devicetree/booting-without-of.txt
@@ -277,7 +277,7 @@ it with special cases.
   the decompressor (the real mode entry point goes to the same  32bit
   entry point once it switched into protected mode). That entry point
   supports one calling convention which is documented in
-  Documentation/x86/boot.txt
+  Documentation/x86/boot.rst
   The physical pointer to the device-tree block (defined in chapter II)
   is passed via setup_data which requires at least boot protocol 2.09.
   The type filed is defined as
diff --git a/Documentation/driver-api/gpio/board.rst b/Documentation/driver-api/gpio/board.rst
index b37f3f7b8926..ce91518bf9f4 100644
--- a/Documentation/driver-api/gpio/board.rst
+++ b/Documentation/driver-api/gpio/board.rst
@@ -101,7 +101,7 @@ with the help of _DSD (Device Specific Data), introduced in ACPI 5.1::
 	}
 
 For more information about the ACPI GPIO bindings see
-Documentation/acpi/gpio-properties.txt.
+Documentation/firmware-guide/acpi/gpio-properties.rst.
 
 Platform Data
 -------------
diff --git a/Documentation/driver-api/gpio/consumer.rst b/Documentation/driver-api/gpio/consumer.rst
index 5e4d8aa68913..fdecb6d711db 100644
--- a/Documentation/driver-api/gpio/consumer.rst
+++ b/Documentation/driver-api/gpio/consumer.rst
@@ -437,7 +437,7 @@ case, it will be handled by the GPIO subsystem automatically.  However, if the
 _DSD is not present, the mappings between GpioIo()/GpioInt() resources and GPIO
 connection IDs need to be provided by device drivers.
 
-For details refer to Documentation/acpi/gpio-properties.txt
+For details refer to Documentation/firmware-guide/acpi/gpio-properties.rst
 
 
 Interacting With the Legacy GPIO Subsystem
diff --git a/Documentation/firmware-guide/acpi/enumeration.rst b/Documentation/firmware-guide/acpi/enumeration.rst
index 6b32b7be8c85..65f5bb5725ac 100644
--- a/Documentation/firmware-guide/acpi/enumeration.rst
+++ b/Documentation/firmware-guide/acpi/enumeration.rst
@@ -339,7 +339,7 @@ a code like this::
 There are also devm_* versions of these functions which release the
 descriptors once the device is released.
 
-See Documentation/acpi/gpio-properties.txt for more information about the
+See Documentation/firmware-guide/acpi/gpio-properties.rst for more information about the
 _DSD binding related to GPIOs.
 
 MFD devices
diff --git a/Documentation/firmware-guide/acpi/method-tracing.rst b/Documentation/firmware-guide/acpi/method-tracing.rst
index d0b077b73f5f..0aa7e2c5d32a 100644
--- a/Documentation/firmware-guide/acpi/method-tracing.rst
+++ b/Documentation/firmware-guide/acpi/method-tracing.rst
@@ -68,7 +68,7 @@ c. Filter out the debug layer/level matched logs when the specified
 
 Where:
    0xXXXXXXXX/0xYYYYYYYY
-     Refer to Documentation/acpi/debug.txt for possible debug layer/level
+     Refer to Documentation/firmware-guide/acpi/debug.rst for possible debug layer/level
      masking values.
    \PPPP.AAAA.TTTT.HHHH
      Full path of a control method that can be found in the ACPI namespace.
diff --git a/Documentation/i2c/instantiating-devices b/Documentation/i2c/instantiating-devices
index 0d85ac1935b7..5a3e2f331e8c 100644
--- a/Documentation/i2c/instantiating-devices
+++ b/Documentation/i2c/instantiating-devices
@@ -85,7 +85,7 @@ Method 1c: Declare the I2C devices via ACPI
 -------------------------------------------
 
 ACPI can also describe I2C devices. There is special documentation for this
-which is currently located at Documentation/acpi/enumeration.txt.
+which is currently located at Documentation/firmware-guide/acpi/enumeration.rst.
 
 
 Method 2: Instantiate the devices explicitly
diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index f0c86fbb3b48..92f7f34b021a 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -155,7 +155,7 @@ is 0x15 and the full version number is 0x234, this file will contain
 the value 340 = 0x154.
 
 See the type_of_loader and ext_loader_type fields in
-Documentation/x86/boot.txt for additional information.
+Documentation/x86/boot.rst for additional information.
 
 ==============================================================
 
@@ -167,7 +167,7 @@ The complete bootloader version number.  In the example above, this
 file will contain the value 564 = 0x234.
 
 See the type_of_loader and ext_loader_ver fields in
-Documentation/x86/boot.txt for additional information.
+Documentation/x86/boot.rst for additional information.
 
 ==============================================================
 
diff --git a/Documentation/translations/it_IT/process/4.Coding.rst b/Documentation/translations/it_IT/process/4.Coding.rst
index c05b89e616dd..1d23e951491f 100644
--- a/Documentation/translations/it_IT/process/4.Coding.rst
+++ b/Documentation/translations/it_IT/process/4.Coding.rst
@@ -370,7 +370,7 @@ con cosa stanno lavorando.  Consultate: Documentation/ABI/README per avere una
 descrizione di come questi documenti devono essere impostati e quali
 informazioni devono essere fornite.
 
-Il file :ref:`Documentation/translations/it_IT/admin-guide/kernel-parameters.rst <kernelparameters>`
+Il file :ref:`Documentation/admin-guide/kernel-parameters.rst <kernelparameters>`
 descrive tutti i parametri di avvio del kernel.  Ogni patch che aggiunga
 nuovi parametri dovrebbe aggiungere nuove voci a questo file.
 
diff --git a/Documentation/translations/it_IT/process/howto.rst b/Documentation/translations/it_IT/process/howto.rst
index 9903ac7c566b..44e6077730e8 100644
--- a/Documentation/translations/it_IT/process/howto.rst
+++ b/Documentation/translations/it_IT/process/howto.rst
@@ -131,7 +131,7 @@ Di seguito una lista di file che sono presenti nei sorgente del kernel e che
 	"Linux kernel patch submission format"
 		http://linux.yyz.us/patch-format.html
 
-  :ref:`Documentation/process/translations/it_IT/stable-api-nonsense.rst <it_stable_api_nonsense>`
+  :ref:`Documentation/translations/it_IT/process/stable-api-nonsense.rst <it_stable_api_nonsense>`
 
     Questo file descrive la motivazioni sottostanti la conscia decisione di
     non avere un API stabile all'interno del kernel, incluso cose come:
diff --git a/Documentation/translations/it_IT/process/stable-kernel-rules.rst b/Documentation/translations/it_IT/process/stable-kernel-rules.rst
index 48e88e5ad2c5..4f206cee31a7 100644
--- a/Documentation/translations/it_IT/process/stable-kernel-rules.rst
+++ b/Documentation/translations/it_IT/process/stable-kernel-rules.rst
@@ -33,7 +33,7 @@ Regole sul tipo di patch che vengono o non vengono accettate nei sorgenti
  - Non deve includere alcuna correzione "banale" (correzioni grammaticali,
    pulizia dagli spazi bianchi, eccetera).
  - Deve rispettare le regole scritte in
-   :ref:`Documentation/translation/it_IT/process/submitting-patches.rst <it_submittingpatches>`
+   :ref:`Documentation/translations/it_IT/process/submitting-patches.rst <it_submittingpatches>`
  - Questa patch o una equivalente deve esistere già nei sorgenti principali di
    Linux
 
@@ -43,7 +43,7 @@ Procedura per sottomettere patch per i sorgenti -stable
 
  - Se la patch contiene modifiche a dei file nelle cartelle net/ o drivers/net,
    allora seguite le linee guida descritte in
-   :ref:`Documentation/translation/it_IT/networking/netdev-FAQ.rst <it_netdev-FAQ>`;
+   :ref:`Documentation/translations/it_IT/networking/netdev-FAQ.rst <it_netdev-FAQ>`;
    ma solo dopo aver verificato al seguente indirizzo che la patch non sia
    già in coda:
    https://patchwork.ozlabs.org/bundle/davem/stable/?series=&submitter=&state=*&q=&archive=
diff --git a/Documentation/translations/zh_CN/process/4.Coding.rst b/Documentation/translations/zh_CN/process/4.Coding.rst
index 5301e9d55255..8bb777941394 100644
--- a/Documentation/translations/zh_CN/process/4.Coding.rst
+++ b/Documentation/translations/zh_CN/process/4.Coding.rst
@@ -241,7 +241,7 @@ scripts/coccinelle目录下已经打包了相当多的内核“语义补丁”
 
 任何添加新用户空间界面的代码（包括新的sysfs或/proc文件）都应该包含该界面的
 文档，该文档使用户空间开发人员能够知道他们在使用什么。请参阅
-Documentation/abi/readme，了解如何格式化此文档以及需要提供哪些信息。
+Documentation/ABI/README，了解如何格式化此文档以及需要提供哪些信息。
 
 文件 :ref:`Documentation/admin-guide/kernel-parameters.rst <kernelparameters>`
 描述了内核的所有引导时间参数。任何添加新参数的补丁都应该向该文件添加适当的
diff --git a/Documentation/x86/x86_64/5level-paging.rst b/Documentation/x86/x86_64/5level-paging.rst
index ab88a4514163..44856417e6a5 100644
--- a/Documentation/x86/x86_64/5level-paging.rst
+++ b/Documentation/x86/x86_64/5level-paging.rst
@@ -20,7 +20,7 @@ physical address space. This "ought to be enough for anybody" ©.
 QEMU 2.9 and later support 5-level paging.
 
 Virtual memory layout for 5-level paging is described in
-Documentation/x86/x86_64/mm.txt
+Documentation/x86/x86_64/mm.rst
 
 
 Enabling 5-level paging
diff --git a/Documentation/x86/x86_64/boot-options.rst b/Documentation/x86/x86_64/boot-options.rst
index 2f69836b8445..6a4285a3c7a4 100644
--- a/Documentation/x86/x86_64/boot-options.rst
+++ b/Documentation/x86/x86_64/boot-options.rst
@@ -9,7 +9,7 @@ only the AMD64 specific ones are listed here.
 
 Machine check
 =============
-Please see Documentation/x86/x86_64/machinecheck for sysfs runtime tunables.
+Please see Documentation/x86/x86_64/machinecheck.rst for sysfs runtime tunables.
 
    mce=off
 		Disable machine check
@@ -89,7 +89,7 @@ APICs
      Don't use the local APIC (alias for i386 compatibility)
 
    pirq=...
-	See Documentation/x86/i386/IO-APIC.txt
+	See Documentation/x86/i386/IO-APIC.rst
 
    noapictimer
 	Don't set up the APIC timer
diff --git a/Documentation/x86/x86_64/fake-numa-for-cpusets.rst b/Documentation/x86/x86_64/fake-numa-for-cpusets.rst
index 74fbb78b3c67..04df57b9aa3f 100644
--- a/Documentation/x86/x86_64/fake-numa-for-cpusets.rst
+++ b/Documentation/x86/x86_64/fake-numa-for-cpusets.rst
@@ -18,7 +18,7 @@ For more information on the features of cpusets, see
 Documentation/cgroup-v1/cpusets.txt.
 There are a number of different configurations you can use for your needs.  For
 more information on the numa=fake command line option and its various ways of
-configuring fake nodes, see Documentation/x86/x86_64/boot-options.txt.
+configuring fake nodes, see Documentation/x86/x86_64/boot-options.rst.
 
 For the purposes of this introduction, we'll assume a very primitive NUMA
 emulation setup of "numa=fake=4*512,".  This will split our system memory into
diff --git a/MAINTAINERS b/MAINTAINERS
index 0c84bf76d165..47aa4f6defb9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3874,7 +3874,7 @@ F:	Documentation/devicetree/bindings/hwmon/cirrus,lochnagar.txt
 F:	Documentation/devicetree/bindings/pinctrl/cirrus,lochnagar.txt
 F:	Documentation/devicetree/bindings/regulator/cirrus,lochnagar.txt
 F:	Documentation/devicetree/bindings/sound/cirrus,lochnagar.txt
-F:	Documentation/hwmon/lochnagar
+F:	Documentation/hwmon/lochnagar.rst
 
 CISCO FCOE HBA DRIVER
 M:	Satish Kharat <satishkh@cisco.com>
@@ -11272,7 +11272,7 @@ NXP FXAS21002C DRIVER
 M:	Rui Miguel Silva <rmfrfs@gmail.com>
 L:	linux-iio@vger.kernel.org
 S:	Maintained
-F:	Documentation/devicetree/bindings/iio/gyroscope/fxas21002c.txt
+F:	Documentation/devicetree/bindings/iio/gyroscope/nxp,fxas21002c.txt
 F:	drivers/iio/gyro/fxas21002c_core.c
 F:	drivers/iio/gyro/fxas21002c.h
 F:	drivers/iio/gyro/fxas21002c_i2c.c
@@ -13043,7 +13043,7 @@ M:	Niklas Cassel <niklas.cassel@linaro.org>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
-F:	Documentation/devicetree/bindings/net/qcom,dwmac.txt
+F:	Documentation/devicetree/bindings/net/qcom,ethqos.txt
 
 QUALCOMM GENERIC INTERFACE I2C DRIVER
 M:	Alok Chauhan <alokc@codeaurora.org>
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 8869742a85df..0f220264cc23 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1263,7 +1263,7 @@ config SMP
 	  uniprocessor machines. On a uniprocessor machine, the kernel
 	  will run faster if you say N here.
 
-	  See also <file:Documentation/x86/i386/IO-APIC.txt>,
+	  See also <file:Documentation/x86/i386/IO-APIC.rst>,
 	  <file:Documentation/lockup-watchdogs.txt> and the SMP-HOWTO available at
 	  <http://tldp.org/HOWTO/SMP-HOWTO.html>.
 
diff --git a/arch/arm64/kernel/kexec_image.c b/arch/arm64/kernel/kexec_image.c
index 07bf740bea91..31cc2f423aa8 100644
--- a/arch/arm64/kernel/kexec_image.c
+++ b/arch/arm64/kernel/kexec_image.c
@@ -53,7 +53,7 @@ static void *image_load(struct kimage *image,
 
 	/*
 	 * We require a kernel with an unambiguous Image header. Per
-	 * Documentation/booting.txt, this is the case when image_size
+	 * Documentation/arm64/booting.txt, this is the case when image_size
 	 * is non-zero (practically speaking, since v3.17).
 	 */
 	h = (struct arm64_image_header *)kernel;
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 8c1c636308c8..e868d2bd48b8 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -898,7 +898,7 @@ config PPC_MEM_KEYS
 	  page-based protections, but without requiring modification of the
 	  page tables when an application changes protection domains.
 
-	  For details, see Documentation/vm/protection-keys.rst
+	  For details, see Documentation/x86/protection-keys.rst
 
 	  If unsure, say y.
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 2bbbd4d1ba31..78fdf2dd71d1 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -395,7 +395,7 @@ config SMP
 	  Y to "Enhanced Real Time Clock Support", below. The "Advanced Power
 	  Management" code will be disabled if you say Y here.
 
-	  See also <file:Documentation/x86/i386/IO-APIC.txt>,
+	  See also <file:Documentation/x86/i386/IO-APIC.rst>,
 	  <file:Documentation/lockup-watchdogs.txt> and the SMP-HOWTO available at
 	  <http://www.tldp.org/docs.html#howto>.
 
@@ -1290,7 +1290,7 @@ config MICROCODE
 	  the Linux kernel.
 
 	  The preferred method to load microcode from a detached initrd is described
-	  in Documentation/x86/microcode.txt. For that you need to enable
+	  in Documentation/x86/microcode.rst. For that you need to enable
 	  CONFIG_BLK_DEV_INITRD in order for the loader to be able to scan the
 	  initrd for microcode blobs.
 
@@ -1329,7 +1329,7 @@ config MICROCODE_OLD_INTERFACE
 	  It is inadequate because it runs too late to be able to properly
 	  load microcode on a machine and it needs special tools. Instead, you
 	  should've switched to the early loading method with the initrd or
-	  builtin microcode by now: Documentation/x86/microcode.txt
+	  builtin microcode by now: Documentation/x86/microcode.rst
 
 config X86_MSR
 	tristate "/dev/cpu/*/msr - Model-specific register support"
@@ -1478,7 +1478,7 @@ config X86_5LEVEL
 	  A kernel with the option enabled can be booted on machines that
 	  support 4- or 5-level paging.
 
-	  See Documentation/x86/x86_64/5level-paging.txt for more
+	  See Documentation/x86/x86_64/5level-paging.rst for more
 	  information.
 
 	  Say N if unsure.
@@ -1626,7 +1626,7 @@ config ARCH_MEMORY_PROBE
 	depends on X86_64 && MEMORY_HOTPLUG
 	help
 	  This option enables a sysfs memory/probe interface for testing.
-	  See Documentation/memory-hotplug.txt for more information.
+	  See Documentation/admin-guide/mm/memory-hotplug.rst for more information.
 	  If you are unsure how to answer this question, answer N.
 
 config ARCH_PROC_KCORE_TEXT
@@ -1783,7 +1783,7 @@ config MTRR
 	  You can safely say Y even if your machine doesn't have MTRRs, you'll
 	  just add about 9 KB to your kernel.
 
-	  See <file:Documentation/x86/mtrr.txt> for more information.
+	  See <file:Documentation/x86/mtrr.rst> for more information.
 
 config MTRR_SANITIZER
 	def_bool y
@@ -1895,7 +1895,7 @@ config X86_INTEL_MPX
 	  process and adds some branches to paths used during
 	  exec() and munmap().
 
-	  For details, see Documentation/x86/intel_mpx.txt
+	  For details, see Documentation/x86/intel_mpx.rst
 
 	  If unsure, say N.
 
@@ -1911,7 +1911,7 @@ config X86_INTEL_MEMORY_PROTECTION_KEYS
 	  page-based protections, but without requiring modification of the
 	  page tables when an application changes protection domains.
 
-	  For details, see Documentation/x86/protection-keys.txt
+	  For details, see Documentation/x86/protection-keys.rst
 
 	  If unsure, say y.
 
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index f730680dc818..59f598543203 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -156,7 +156,7 @@ config IOMMU_DEBUG
 	  code. When you use it make sure you have a big enough
 	  IOMMU/AGP aperture.  Most of the options enabled by this can
 	  be set more finegrained using the iommu= command line
-	  options. See Documentation/x86/x86_64/boot-options.txt for more
+	  options. See Documentation/x86/x86_64/boot-options.rst for more
 	  details.
 
 config IOMMU_LEAK
diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 850b8762e889..90d791ca1a95 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -313,7 +313,7 @@ start_sys_seg:	.word	SYSSEG		# obsolete and meaningless, but just
 
 type_of_loader:	.byte	0		# 0 means ancient bootloader, newer
 					# bootloaders know to change this.
-					# See Documentation/x86/boot.txt for
+					# See Documentation/x86/boot.rst for
 					# assigned ids
 
 # flags, unused bits must be zero (RFU) bit within loadflags
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 11aa3b2afa4d..33f9fc38d014 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -8,7 +8,7 @@
  *
  * entry.S contains the system-call and fault low-level handling routines.
  *
- * Some of this is documented in Documentation/x86/entry_64.txt
+ * Some of this is documented in Documentation/x86/entry_64.rst
  *
  * A note on terminology:
  * - iret frame:	Architecture defined interrupt frame from SS to RIP
diff --git a/arch/x86/include/asm/bootparam_utils.h b/arch/x86/include/asm/bootparam_utils.h
index f6f6ef436599..101eb944f13c 100644
--- a/arch/x86/include/asm/bootparam_utils.h
+++ b/arch/x86/include/asm/bootparam_utils.h
@@ -24,7 +24,7 @@ static void sanitize_boot_params(struct boot_params *boot_params)
 	 * IMPORTANT NOTE TO BOOTLOADER AUTHORS: do not simply clear
 	 * this field.  The purpose of this field is to guarantee
 	 * compliance with the x86 boot spec located in
-	 * Documentation/x86/boot.txt .  That spec says that the
+	 * Documentation/x86/boot.rst .  That spec says that the
 	 * *whole* structure should be cleared, after which only the
 	 * portion defined by struct setup_header (boot_params->hdr)
 	 * should be copied in.
diff --git a/arch/x86/include/asm/page_64_types.h b/arch/x86/include/asm/page_64_types.h
index 793c14c372cb..288b065955b7 100644
--- a/arch/x86/include/asm/page_64_types.h
+++ b/arch/x86/include/asm/page_64_types.h
@@ -48,7 +48,7 @@
 
 #define __START_KERNEL_map	_AC(0xffffffff80000000, UL)
 
-/* See Documentation/x86/x86_64/mm.txt for a description of the memory map. */
+/* See Documentation/x86/x86_64/mm.rst for a description of the memory map. */
 
 #define __PHYSICAL_MASK_SHIFT	52
 
diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
index 88bca456da99..52e5f5f2240d 100644
--- a/arch/x86/include/asm/pgtable_64_types.h
+++ b/arch/x86/include/asm/pgtable_64_types.h
@@ -103,7 +103,7 @@ extern unsigned int ptrs_per_p4d;
 #define PGDIR_MASK	(~(PGDIR_SIZE - 1))
 
 /*
- * See Documentation/x86/x86_64/mm.txt for a description of the memory map.
+ * See Documentation/x86/x86_64/mm.rst for a description of the memory map.
  *
  * Be very careful vs. KASLR when changing anything here. The KASLR address
  * range must not overlap with anything except the KASAN shadow area, which
diff --git a/arch/x86/kernel/cpu/microcode/amd.c b/arch/x86/kernel/cpu/microcode/amd.c
index e1f3ba19ba54..06d4e67f31ab 100644
--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -61,7 +61,7 @@ static u8 amd_ucode_patch[PATCH_MAX_SIZE];
 
 /*
  * Microcode patch container file is prepended to the initrd in cpio
- * format. See Documentation/x86/microcode.txt
+ * format. See Documentation/x86/microcode.rst
  */
 static const char
 ucode_path[] __maybe_unused = "kernel/x86/microcode/AuthenticAMD.bin";
diff --git a/arch/x86/kernel/kexec-bzimage64.c b/arch/x86/kernel/kexec-bzimage64.c
index 22f60dd26460..b07e7069b09e 100644
--- a/arch/x86/kernel/kexec-bzimage64.c
+++ b/arch/x86/kernel/kexec-bzimage64.c
@@ -416,7 +416,7 @@ static void *bzImage64_load(struct kimage *image, char *kernel,
 	efi_map_offset = params_cmdline_sz;
 	efi_setup_data_offset = efi_map_offset + ALIGN(efi_map_sz, 16);
 
-	/* Copy setup header onto bootparams. Documentation/x86/boot.txt */
+	/* Copy setup header onto bootparams. Documentation/x86/boot.rst */
 	setup_header_size = 0x0202 + kernel[0x0201] - setup_hdr_offset;
 
 	/* Is there a limit on setup header size? */
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index dcd272dbd0a9..f62b498b18fb 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -70,7 +70,7 @@ void __init pci_iommu_alloc(void)
 }
 
 /*
- * See <Documentation/x86/x86_64/boot-options.txt> for the iommu kernel
+ * See <Documentation/x86/x86_64/boot-options.rst> for the iommu kernel
  * parameter documentation.
  */
 static __init int iommu_setup(char *p)
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 7f61431c75fb..400c1ba033aa 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -711,7 +711,7 @@ void native_flush_tlb_others(const struct cpumask *cpumask,
 }
 
 /*
- * See Documentation/x86/tlb.txt for details.  We choose 33
+ * See Documentation/x86/tlb.rst for details.  We choose 33
  * because it is large enough to cover the vast majority (at
  * least 95%) of allocations, and is small enough that we are
  * confident it will not cause too much overhead.  Each single
diff --git a/arch/x86/platform/pvh/enlighten.c b/arch/x86/platform/pvh/enlighten.c
index 1861a2ba0f2b..c0a502f7e3a7 100644
--- a/arch/x86/platform/pvh/enlighten.c
+++ b/arch/x86/platform/pvh/enlighten.c
@@ -86,7 +86,7 @@ static void __init init_pvh_bootparams(bool xen_guest)
 	}
 
 	/*
-	 * See Documentation/x86/boot.txt.
+	 * See Documentation/x86/boot.rst.
 	 *
 	 * Version 2.12 supports Xen entry point but we will use default x86/PC
 	 * environment (i.e. hardware_subarch 0).
diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 283ee94224c6..2438f37f2ca1 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -333,7 +333,7 @@ config ACPI_CUSTOM_DSDT_FILE
 	depends on !STANDALONE
 	help
 	  This option supports a custom DSDT by linking it into the kernel.
-	  See Documentation/acpi/dsdt-override.txt
+	  See Documentation/admin-guide/acpi/dsdt-override.rst
 
 	  Enter the full path name to the file which includes the AmlCode
 	  or dsdt_aml_code declaration.
@@ -355,7 +355,7 @@ config ACPI_TABLE_UPGRADE
 	  This option provides functionality to upgrade arbitrary ACPI tables
 	  via initrd. No functional change if no ACPI tables are passed via
 	  initrd, therefore it's safe to say Y.
-	  See Documentation/acpi/initrd_table_override.txt for details
+	  See Documentation/admin-guide/acpi/initrd_table_override.rst for details
 
 config ACPI_TABLE_OVERRIDE_VIA_BUILTIN_INITRD
 	bool "Override ACPI tables from built-in initrd"
@@ -365,7 +365,7 @@ config ACPI_TABLE_OVERRIDE_VIA_BUILTIN_INITRD
 	  This option provides functionality to override arbitrary ACPI tables
 	  from built-in uncompressed initrd.
 
-	  See Documentation/acpi/initrd_table_override.txt for details
+	  See Documentation/admin-guide/acpi/initrd_table_override.rst for details
 
 config ACPI_DEBUG
 	bool "Debug Statements"
@@ -374,7 +374,7 @@ config ACPI_DEBUG
 	  output and increases the kernel size by around 50K.
 
 	  Use the acpi.debug_layer and acpi.debug_level kernel command-line
-	  parameters documented in Documentation/acpi/debug.txt and
+	  parameters documented in Documentation/firmware-guide/acpi/debug.rst and
 	  Documentation/admin-guide/kernel-parameters.rst to control the type and
 	  amount of debug output.
 
@@ -445,7 +445,7 @@ config ACPI_CUSTOM_METHOD
 	help
 	  This debug facility allows ACPI AML methods to be inserted and/or
 	  replaced without rebooting the system. For details refer to:
-	  Documentation/acpi/method-customizing.txt.
+	  Documentation/firmware-guide/acpi/method-customizing.rst.
 
 	  NOTE: This option is security sensitive, because it allows arbitrary
 	  kernel memory to be written to by root (uid=0) users, allowing them
diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index b17b79e612a3..ac6280ad43a1 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1075,7 +1075,7 @@ static int ftgmac100_mii_probe(struct ftgmac100 *priv, phy_interface_t intf)
 	}
 
 	/* Indicate that we support PAUSE frames (see comment in
-	 * Documentation/networking/phy.txt)
+	 * Documentation/networking/phy.rst)
 	 */
 	phy_support_asym_pause(phydev);
 
diff --git a/drivers/staging/fieldbus/Documentation/fieldbus_dev.txt b/drivers/staging/fieldbus/Documentation/fieldbus_dev.txt
index 56af3f650fa3..89fb8e14676f 100644
--- a/drivers/staging/fieldbus/Documentation/fieldbus_dev.txt
+++ b/drivers/staging/fieldbus/Documentation/fieldbus_dev.txt
@@ -54,8 +54,8 @@ a limited few common behaviours and properties. This allows us to define
 a simple interface consisting of a character device and a set of sysfs files:
 
 See:
-Documentation/ABI/testing/sysfs-class-fieldbus-dev
-Documentation/ABI/testing/fieldbus-dev-cdev
+drivers/staging/fieldbus/Documentation/ABI/sysfs-class-fieldbus-dev
+drivers/staging/fieldbus/Documentation/ABI/fieldbus-dev-cdev
 
 Note that this simple interface does not provide a way to modify adapter
 configuration settings. It is therefore useful only for adapters that get their
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 1e3ed41ae1f3..69938dbae2d0 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1694,7 +1694,7 @@ EXPORT_SYMBOL_GPL(vhost_dev_ioctl);
 
 /* TODO: This is really inefficient.  We need something like get_user()
  * (instruction directly accesses the data, with an exception table entry
- * returning -EFAULT). See Documentation/x86/exception-tables.txt.
+ * returning -EFAULT). See Documentation/x86/exception-tables.rst.
  */
 static int set_bit_to_user(int nr, void __user *addr)
 {
diff --git a/include/acpi/acpi_drivers.h b/include/acpi/acpi_drivers.h
index de1804aeaf69..98e3db7a89cd 100644
--- a/include/acpi/acpi_drivers.h
+++ b/include/acpi/acpi_drivers.h
@@ -25,7 +25,7 @@
 #define ACPI_MAX_STRING			80
 
 /*
- * Please update drivers/acpi/debug.c and Documentation/acpi/debug.txt
+ * Please update drivers/acpi/debug.c and Documentation/firmware-guide/acpi/debug.rst
  * if you add to this list.
  */
 #define ACPI_BUS_COMPONENT		0x00010000
diff --git a/include/linux/fs_context.h b/include/linux/fs_context.h
index 1f966670c8dc..623eb58560b9 100644
--- a/include/linux/fs_context.h
+++ b/include/linux/fs_context.h
@@ -85,7 +85,7 @@ struct fs_parameter {
  * Superblock creation fills in ->root whereas reconfiguration begins with this
  * already set.
  *
- * See Documentation/filesystems/mounting.txt
+ * See Documentation/filesystems/mount_api.txt
  */
 struct fs_context {
 	const struct fs_context_operations *ops;
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 47f58cfb6a19..df1318d85f7d 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -77,7 +77,7 @@
  *	state.  This is called immediately after commit_creds().
  *
  * Security hooks for mount using fs_context.
- *	[See also Documentation/filesystems/mounting.txt]
+ *	[See also Documentation/filesystems/mount_api.txt]
  *
  * @fs_context_dup:
  *	Allocate and attach a security structure to sc->security.  This pointer
diff --git a/mm/Kconfig b/mm/Kconfig
index ee8d1f311858..6e5fb81bde4b 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -165,7 +165,7 @@ config MEMORY_HOTPLUG_DEFAULT_ONLINE
 	  onlining policy (/sys/devices/system/memory/auto_online_blocks) which
 	  determines what happens to newly added memory regions. Policy setting
 	  can always be changed at runtime.
-	  See Documentation/memory-hotplug.txt for more information.
+	  See Documentation/admin-guide/mm/memory-hotplug.rst for more information.
 
 	  Say Y here if you want all hot-plugged memory blocks to appear in
 	  'online' state by default.
diff --git a/security/Kconfig b/security/Kconfig
index aeac3676dd4d..6d75ed71970c 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -62,7 +62,7 @@ config PAGE_TABLE_ISOLATION
 	  ensuring that the majority of kernel addresses are not mapped
 	  into userspace.
 
-	  See Documentation/x86/pti.txt for more details.
+	  See Documentation/x86/pti.rst for more details.
 
 config SECURITY_INFINIBAND
 	bool "Infiniband Security Hooks"
diff --git a/tools/include/linux/err.h b/tools/include/linux/err.h
index 2f5a12b88a86..25f2bb3a991d 100644
--- a/tools/include/linux/err.h
+++ b/tools/include/linux/err.h
@@ -20,7 +20,7 @@
  * Userspace note:
  * The same principle works for userspace, because 'error' pointers
  * fall down to the unused hole far from user space, as described
- * in Documentation/x86/x86_64/mm.txt for x86_64 arch:
+ * in Documentation/x86/x86_64/mm.rst for x86_64 arch:
  *
  * 0000000000000000 - 00007fffffffffff (=47 bits) user space, different per mm hole caused by [48:63] sign extension
  * ffffffffffe00000 - ffffffffffffffff (=2 MB) unused hole
diff --git a/tools/objtool/Documentation/stack-validation.txt b/tools/objtool/Documentation/stack-validation.txt
index 4dd11a554b9b..de094670050b 100644
--- a/tools/objtool/Documentation/stack-validation.txt
+++ b/tools/objtool/Documentation/stack-validation.txt
@@ -21,7 +21,7 @@ instructions).  Similarly, it knows how to follow switch statements, for
 which gcc sometimes uses jump tables.
 
 (Objtool also has an 'orc generate' subcommand which generates debuginfo
-for the ORC unwinder.  See Documentation/x86/orc-unwinder.txt in the
+for the ORC unwinder.  See Documentation/x86/orc-unwinder.rst in the
 kernel tree for more details.)
 
 
@@ -101,7 +101,7 @@ b) ORC (Oops Rewind Capability) unwind table generation
    band.  So it doesn't affect runtime performance and it can be
    reliable even when interrupts or exceptions are involved.
 
-   For more details, see Documentation/x86/orc-unwinder.txt.
+   For more details, see Documentation/x86/orc-unwinder.rst.
 
 c) Higher live patching compatibility rate
 
diff --git a/tools/testing/selftests/x86/protection_keys.c b/tools/testing/selftests/x86/protection_keys.c
index 5d546dcdbc80..798a5ddeee55 100644
--- a/tools/testing/selftests/x86/protection_keys.c
+++ b/tools/testing/selftests/x86/protection_keys.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * Tests x86 Memory Protection Keys (see Documentation/x86/protection-keys.txt)
+ * Tests x86 Memory Protection Keys (see Documentation/x86/protection-keys.rst)
  *
  * There are examples in here of:
  *  * how to set protection keys on memory
-- 
2.21.0

