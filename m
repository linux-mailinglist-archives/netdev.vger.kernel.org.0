Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE9E83A317
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 04:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728342AbfFIC1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 22:27:52 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:56000 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728174AbfFIC1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 22:27:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
        To:From:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=KhsmOqFNASH28E6Mn/0awTeqOWJ4bMmvR8Kd5r2jtAQ=; b=dYVmQ04Ui94aJrdj8MzVvUHqZq
        mWGdrTLqvYtwW0hCEZuy9daJoGF4xWG331tsxfQehzESqkaJajy5gbHaX8plWU+EdYbX1Fk1Ny1D3
        fo/prJplROM6gr+IEurMuWKuKdqwtioE2eE7icemm84elqIUNPVUZ7LGIJRWlNiY9j/lhcZXiGN65
        xG1MI/rQM48vKS57+7V+H+A7caSLKUeiRXpDlyPYs6VRoyVcUTF7mwi05plPmm8Ua63gTp3Xa8NNN
        HQEz2O3ojrRrFXmsnbh5+OclZIugU9TltatdKdGzWEiztRJlu8h8ixc8dJa9ijb8es9PcKwq1zkqt
        rIGPXnJw==;
Received: from 179.176.115.133.dynamic.adsl.gvt.net.br ([179.176.115.133] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hZnYS-0001n5-Jj; Sun, 09 Jun 2019 02:27:35 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1hZnYL-0000Ji-C2; Sat, 08 Jun 2019 23:27:25 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Sebastian Reichel <sre@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Nishanth Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Harry Wei <harryxiyou@gmail.com>,
        Alex Shi <alex.shi@linux.alibaba.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-pci@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v3 20/33] docs: convert docs to ReST and rename to *.rst
Date:   Sat,  8 Jun 2019 23:27:10 -0300
Message-Id: <6674e9181f6d5264e7a0f829a46211457a64fae4.1560045490.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1560045490.git.mchehab+samsung@kernel.org>
References: <cover.1560045490.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the PM documents to ReST, in order to allow them to
build with Sphinx.

The conversion is actually:
  - add blank lines and identation in order to identify paragraphs;
  - fix tables markups;
  - add some lists markups;
  - mark literal blocks;
  - adjust title markups.

At its new index.rst, let's add a :orphan: while this is not linked to
the main index.rst file, in order to avoid build warnings.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 .../ABI/testing/sysfs-class-powercap          |   2 +-
 .../admin-guide/kernel-parameters.txt         |   6 +-
 Documentation/cpu-freq/core.rst               |   2 +-
 Documentation/driver-api/pm/devices.rst       |   6 +-
 .../driver-api/usb/power-management.rst       |   2 +-
 .../power/{apm-acpi.txt => apm-acpi.rst}      |  10 +-
 ...m-debugging.txt => basic-pm-debugging.rst} |  79 ++-
 ...harger-manager.txt => charger-manager.rst} | 101 +--
 ...rivers-testing.txt => drivers-testing.rst} |  15 +-
 .../{energy-model.txt => energy-model.rst}    | 101 +--
 ...ing-of-tasks.txt => freezing-of-tasks.rst} |  91 +--
 Documentation/power/index.rst                 |  46 ++
 .../power/{interface.txt => interface.rst}    |  24 +-
 Documentation/power/{opp.txt => opp.rst}      | 175 +++--
 Documentation/power/{pci.txt => pci.rst}      |  87 ++-
 ...qos_interface.txt => pm_qos_interface.rst} | 127 ++--
 ...upply_class.txt => power_supply_class.rst} | 269 +++++---
 .../powercap/{powercap.txt => powercap.rst}   | 297 ++++----
 .../regulator/{consumer.txt => consumer.rst}  | 141 ++--
 .../regulator/{design.txt => design.rst}      |   9 +-
 .../regulator/{machine.txt => machine.rst}    |  47 +-
 .../regulator/{overview.txt => overview.rst}  |  57 +-
 .../{regulator.txt => regulator.rst}          |  18 +-
 .../power/{runtime_pm.txt => runtime_pm.rst}  | 234 ++++---
 Documentation/power/{s2ram.txt => s2ram.rst}  |  20 +-
 ...hotplug.txt => suspend-and-cpuhotplug.rst} |  42 +-
 ...errupts.txt => suspend-and-interrupts.rst} |   2 +
 ...ap-files.txt => swsusp-and-swap-files.rst} |  17 +-
 ...{swsusp-dmcrypt.txt => swsusp-dmcrypt.rst} | 120 ++--
 .../power/{swsusp.txt => swsusp.rst}          | 639 ++++++++++--------
 .../power/{tricks.txt => tricks.rst}          |   6 +-
 ...serland-swsusp.txt => userland-swsusp.rst} |  55 +-
 Documentation/power/{video.txt => video.rst}  | 156 +++--
 Documentation/process/submitting-drivers.rst  |   2 +-
 Documentation/scheduler/sched-energy.txt      |   6 +-
 Documentation/trace/coresight-cpu-debug.txt   |   2 +-
 .../zh_CN/process/submitting-drivers.rst      |   2 +-
 MAINTAINERS                                   |   4 +-
 arch/x86/Kconfig                              |   2 +-
 drivers/gpu/drm/i915/i915_drv.h               |   2 +-
 drivers/opp/Kconfig                           |   2 +-
 drivers/power/supply/power_supply_core.c      |   2 +-
 include/linux/interrupt.h                     |   2 +-
 include/linux/pci.h                           |   2 +-
 include/linux/pm.h                            |   2 +-
 kernel/power/Kconfig                          |   6 +-
 net/wireless/Kconfig                          |   2 +-
 47 files changed, 1730 insertions(+), 1311 deletions(-)
 rename Documentation/power/{apm-acpi.txt => apm-acpi.rst} (87%)
 rename Documentation/power/{basic-pm-debugging.txt => basic-pm-debugging.rst} (87%)
 rename Documentation/power/{charger-manager.txt => charger-manager.rst} (78%)
 rename Documentation/power/{drivers-testing.txt => drivers-testing.rst} (86%)
 rename Documentation/power/{energy-model.txt => energy-model.rst} (74%)
 rename Documentation/power/{freezing-of-tasks.txt => freezing-of-tasks.rst} (75%)
 create mode 100644 Documentation/power/index.rst
 rename Documentation/power/{interface.txt => interface.rst} (84%)
 rename Documentation/power/{opp.txt => opp.rst} (78%)
 rename Documentation/power/{pci.txt => pci.rst} (97%)
 rename Documentation/power/{pm_qos_interface.txt => pm_qos_interface.rst} (62%)
 rename Documentation/power/{power_supply_class.txt => power_supply_class.rst} (46%)
 rename Documentation/power/powercap/{powercap.txt => powercap.rst} (40%)
 rename Documentation/power/regulator/{consumer.txt => consumer.rst} (61%)
 rename Documentation/power/regulator/{design.txt => design.rst} (86%)
 rename Documentation/power/regulator/{machine.txt => machine.rst} (75%)
 rename Documentation/power/regulator/{overview.txt => overview.rst} (79%)
 rename Documentation/power/regulator/{regulator.txt => regulator.rst} (49%)
 rename Documentation/power/{runtime_pm.txt => runtime_pm.rst} (89%)
 rename Documentation/power/{s2ram.txt => s2ram.rst} (92%)
 rename Documentation/power/{suspend-and-cpuhotplug.txt => suspend-and-cpuhotplug.rst} (90%)
 rename Documentation/power/{suspend-and-interrupts.txt => suspend-and-interrupts.rst} (98%)
 rename Documentation/power/{swsusp-and-swap-files.txt => swsusp-and-swap-files.rst} (83%)
 rename Documentation/power/{swsusp-dmcrypt.txt => swsusp-dmcrypt.rst} (67%)
 rename Documentation/power/{swsusp.txt => swsusp.rst} (20%)
 rename Documentation/power/{tricks.txt => tricks.rst} (93%)
 rename Documentation/power/{userland-swsusp.txt => userland-swsusp.rst} (85%)
 rename Documentation/power/{video.txt => video.rst} (56%)

diff --git a/Documentation/ABI/testing/sysfs-class-powercap b/Documentation/ABI/testing/sysfs-class-powercap
index db3b3ff70d84..742dfd966592 100644
--- a/Documentation/ABI/testing/sysfs-class-powercap
+++ b/Documentation/ABI/testing/sysfs-class-powercap
@@ -5,7 +5,7 @@ Contact:	linux-pm@vger.kernel.org
 Description:
 		The powercap/ class sub directory belongs to the power cap
 		subsystem. Refer to
-		Documentation/power/powercap/powercap.txt for details.
+		Documentation/power/powercap/powercap.rst for details.
 
 What:		/sys/class/powercap/<control type>
 Date:		September 2013
diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 9789328f5e9d..df96a896fafa 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -13,7 +13,7 @@
 			For ARM64, ONLY "acpi=off", "acpi=on" or "acpi=force"
 			are available
 
-			See also Documentation/power/runtime_pm.txt, pci=noacpi
+			See also Documentation/power/runtime_pm.rst, pci=noacpi
 
 	acpi_apic_instance=	[ACPI, IOAPIC]
 			Format: <int>
@@ -223,7 +223,7 @@
 	acpi_sleep=	[HW,ACPI] Sleep options
 			Format: { s3_bios, s3_mode, s3_beep, s4_nohwsig,
 				  old_ordering, nonvs, sci_force_enable, nobl }
-			See Documentation/power/video.txt for information on
+			See Documentation/power/video.rst for information on
 			s3_bios and s3_mode.
 			s3_beep is for debugging; it makes the PC's speaker beep
 			as soon as the kernel's real-mode entry point is called.
@@ -4128,7 +4128,7 @@
 			Specify the offset from the beginning of the partition
 			given by "resume=" at which the swap header is located,
 			in <PAGE_SIZE> units (needed only for swap files).
-			See  Documentation/power/swsusp-and-swap-files.txt
+			See  Documentation/power/swsusp-and-swap-files.rst
 
 	resumedelay=	[HIBERNATION] Delay (in seconds) to pause before attempting to
 			read the resume files
diff --git a/Documentation/cpu-freq/core.rst b/Documentation/cpu-freq/core.rst
index c719e3cb700c..003faebd42c2 100644
--- a/Documentation/cpu-freq/core.rst
+++ b/Documentation/cpu-freq/core.rst
@@ -89,7 +89,7 @@ flags	flags of the cpufreq driver
 
 3. CPUFreq Table Generation with Operating Performance Point (OPP)
 ==================================================================
-For details about OPP, see Documentation/power/opp.txt
+For details about OPP, see Documentation/power/opp.rst
 
 dev_pm_opp_init_cpufreq_table
 	This function provides a ready to use conversion routine to translate
diff --git a/Documentation/driver-api/pm/devices.rst b/Documentation/driver-api/pm/devices.rst
index 30835683616a..f66c7b9126ea 100644
--- a/Documentation/driver-api/pm/devices.rst
+++ b/Documentation/driver-api/pm/devices.rst
@@ -225,7 +225,7 @@ system-wide transition to a sleep state even though its :c:member:`runtime_auto`
 flag is clear.
 
 For more information about the runtime power management framework, refer to
-:file:`Documentation/power/runtime_pm.txt`.
+:file:`Documentation/power/runtime_pm.rst`.
 
 
 Calling Drivers to Enter and Leave System Sleep States
@@ -728,7 +728,7 @@ it into account in any way.
 
 Devices may be defined as IRQ-safe which indicates to the PM core that their
 runtime PM callbacks may be invoked with disabled interrupts (see
-:file:`Documentation/power/runtime_pm.txt` for more information).  If an
+:file:`Documentation/power/runtime_pm.rst` for more information).  If an
 IRQ-safe device belongs to a PM domain, the runtime PM of the domain will be
 disallowed, unless the domain itself is defined as IRQ-safe. However, it
 makes sense to define a PM domain as IRQ-safe only if all the devices in it
@@ -795,7 +795,7 @@ so on) and the final state of the device must reflect the "active" runtime PM
 status in that case.
 
 During system-wide resume from a sleep state it's easiest to put devices into
-the full-power state, as explained in :file:`Documentation/power/runtime_pm.txt`.
+the full-power state, as explained in :file:`Documentation/power/runtime_pm.rst`.
 [Refer to that document for more information regarding this particular issue as
 well as for information on the device runtime power management framework in
 general.]
diff --git a/Documentation/driver-api/usb/power-management.rst b/Documentation/driver-api/usb/power-management.rst
index 4a74cf6f2797..2525c3622cae 100644
--- a/Documentation/driver-api/usb/power-management.rst
+++ b/Documentation/driver-api/usb/power-management.rst
@@ -46,7 +46,7 @@ device is turned off while the system as a whole remains running, we
 call it a "dynamic suspend" (also known as a "runtime suspend" or
 "selective suspend").  This document concentrates mostly on how
 dynamic PM is implemented in the USB subsystem, although system PM is
-covered to some extent (see ``Documentation/power/*.txt`` for more
+covered to some extent (see ``Documentation/power/*.rst`` for more
 information about system PM).
 
 System PM support is present only if the kernel was built with
diff --git a/Documentation/power/apm-acpi.txt b/Documentation/power/apm-acpi.rst
similarity index 87%
rename from Documentation/power/apm-acpi.txt
rename to Documentation/power/apm-acpi.rst
index 6cc423d3662e..5b90d947126d 100644
--- a/Documentation/power/apm-acpi.txt
+++ b/Documentation/power/apm-acpi.rst
@@ -1,5 +1,7 @@
+============
 APM or ACPI?
-------------
+============
+
 If you have a relatively recent x86 mobile, desktop, or server system,
 odds are it supports either Advanced Power Management (APM) or
 Advanced Configuration and Power Interface (ACPI).  ACPI is the newer
@@ -28,5 +30,7 @@ and be sure that they are started sometime in the system boot process.
 Go ahead and start both.  If ACPI or APM is not available on your
 system the associated daemon will exit gracefully.
 
-  apmd:   http://ftp.debian.org/pool/main/a/apmd/
-  acpid:  http://acpid.sf.net/
+  =====  =======================================
+  apmd   http://ftp.debian.org/pool/main/a/apmd/
+  acpid  http://acpid.sf.net/
+  =====  =======================================
diff --git a/Documentation/power/basic-pm-debugging.txt b/Documentation/power/basic-pm-debugging.rst
similarity index 87%
rename from Documentation/power/basic-pm-debugging.txt
rename to Documentation/power/basic-pm-debugging.rst
index 708f87f78a75..69862e759c30 100644
--- a/Documentation/power/basic-pm-debugging.txt
+++ b/Documentation/power/basic-pm-debugging.rst
@@ -1,12 +1,16 @@
+=================================
 Debugging hibernation and suspend
+=================================
+
 	(C) 2007 Rafael J. Wysocki <rjw@sisk.pl>, GPL
 
 1. Testing hibernation (aka suspend to disk or STD)
+===================================================
 
-To check if hibernation works, you can try to hibernate in the "reboot" mode:
+To check if hibernation works, you can try to hibernate in the "reboot" mode::
 
-# echo reboot > /sys/power/disk
-# echo disk > /sys/power/state
+	# echo reboot > /sys/power/disk
+	# echo disk > /sys/power/state
 
 and the system should create a hibernation image, reboot, resume and get back to
 the command prompt where you have started the transition.  If that happens,
@@ -15,20 +19,21 @@ test at least a couple of times in a row for confidence.  [This is necessary,
 because some problems only show up on a second attempt at suspending and
 resuming the system.]  Moreover, hibernating in the "reboot" and "shutdown"
 modes causes the PM core to skip some platform-related callbacks which on ACPI
-systems might be necessary to make hibernation work.  Thus, if your machine fails
-to hibernate or resume in the "reboot" mode, you should try the "platform" mode:
+systems might be necessary to make hibernation work.  Thus, if your machine
+fails to hibernate or resume in the "reboot" mode, you should try the
+"platform" mode::
 
-# echo platform > /sys/power/disk
-# echo disk > /sys/power/state
+	# echo platform > /sys/power/disk
+	# echo disk > /sys/power/state
 
 which is the default and recommended mode of hibernation.
 
 Unfortunately, the "platform" mode of hibernation does not work on some systems
 with broken BIOSes.  In such cases the "shutdown" mode of hibernation might
-work:
+work::
 
-# echo shutdown > /sys/power/disk
-# echo disk > /sys/power/state
+	# echo shutdown > /sys/power/disk
+	# echo disk > /sys/power/state
 
 (it is similar to the "reboot" mode, but it requires you to press the power
 button to make the system resume).
@@ -37,6 +42,7 @@ If neither "platform" nor "shutdown" hibernation mode works, you will need to
 identify what goes wrong.
 
 a) Test modes of hibernation
+----------------------------
 
 To find out why hibernation fails on your system, you can use a special testing
 facility available if the kernel is compiled with CONFIG_PM_DEBUG set.  Then,
@@ -44,36 +50,38 @@ there is the file /sys/power/pm_test that can be used to make the hibernation
 core run in a test mode.  There are 5 test modes available:
 
 freezer
-- test the freezing of processes
+	- test the freezing of processes
 
 devices
-- test the freezing of processes and suspending of devices
+	- test the freezing of processes and suspending of devices
 
 platform
-- test the freezing of processes, suspending of devices and platform
-  global control methods(*)
+	- test the freezing of processes, suspending of devices and platform
+	  global control methods [1]_
 
 processors
-- test the freezing of processes, suspending of devices, platform
-  global control methods(*) and the disabling of nonboot CPUs
+	- test the freezing of processes, suspending of devices, platform
+	  global control methods [1]_ and the disabling of nonboot CPUs
 
 core
-- test the freezing of processes, suspending of devices, platform global
-  control methods(*), the disabling of nonboot CPUs and suspending of
-  platform/system devices
+	- test the freezing of processes, suspending of devices, platform global
+	  control methods\ [1]_, the disabling of nonboot CPUs and suspending
+	  of platform/system devices
 
-(*) the platform global control methods are only available on ACPI systems
+.. [1]
+
+    the platform global control methods are only available on ACPI systems
     and are only tested if the hibernation mode is set to "platform"
 
 To use one of them it is necessary to write the corresponding string to
 /sys/power/pm_test (eg. "devices" to test the freezing of processes and
 suspending devices) and issue the standard hibernation commands.  For example,
 to use the "devices" test mode along with the "platform" mode of hibernation,
-you should do the following:
+you should do the following::
 
-# echo devices > /sys/power/pm_test
-# echo platform > /sys/power/disk
-# echo disk > /sys/power/state
+	# echo devices > /sys/power/pm_test
+	# echo platform > /sys/power/disk
+	# echo disk > /sys/power/state
 
 Then, the kernel will try to freeze processes, suspend devices, wait a few
 seconds (5 by default, but configurable by the suspend.pm_test_delay module
@@ -108,11 +116,12 @@ If the "devices" test fails, most likely there is a driver that cannot suspend
 or resume its device (in the latter case the system may hang or become unstable
 after the test, so please take that into consideration).  To find this driver,
 you can carry out a binary search according to the rules:
+
 - if the test fails, unload a half of the drivers currently loaded and repeat
-(that would probably involve rebooting the system, so always note what drivers
-have been loaded before the test),
+  (that would probably involve rebooting the system, so always note what drivers
+  have been loaded before the test),
 - if the test succeeds, load a half of the drivers you have unloaded most
-recently and repeat.
+  recently and repeat.
 
 Once you have found the failing driver (there can be more than just one of
 them), you have to unload it every time before hibernation.  In that case please
@@ -146,6 +155,7 @@ indicates a serious problem that very well may be related to the hardware, but
 please report it anyway.
 
 b) Testing minimal configuration
+--------------------------------
 
 If all of the hibernation test modes work, you can boot the system with the
 "init=/bin/bash" command line parameter and attempt to hibernate in the
@@ -165,14 +175,15 @@ Again, if you find the offending module(s), it(they) must be unloaded every time
 before hibernation, and please report the problem with it(them).
 
 c) Using the "test_resume" hibernation option
+---------------------------------------------
 
 /sys/power/disk generally tells the kernel what to do after creating a
 hibernation image.  One of the available options is "test_resume" which
 causes the just created image to be used for immediate restoration.  Namely,
-after doing:
+after doing::
 
-# echo test_resume > /sys/power/disk
-# echo disk > /sys/power/state
+	# echo test_resume > /sys/power/disk
+	# echo disk > /sys/power/state
 
 a hibernation image will be created and a resume from it will be triggered
 immediately without involving the platform firmware in any way.
@@ -190,6 +201,7 @@ to resume may be related to the differences between the restore and image
 kernels.
 
 d) Advanced debugging
+---------------------
 
 In case that hibernation does not work on your system even in the minimal
 configuration and compiling more drivers as modules is not practical or some
@@ -200,9 +212,10 @@ kernel messages using the serial console.  This may provide you with some
 information about the reasons of the suspend (resume) failure.  Alternatively,
 it may be possible to use a FireWire port for debugging with firescope
 (http://v3.sk/~lkundrak/firescope/).  On x86 it is also possible to
-use the PM_TRACE mechanism documented in Documentation/power/s2ram.txt .
+use the PM_TRACE mechanism documented in Documentation/power/s2ram.rst .
 
 2. Testing suspend to RAM (STR)
+===============================
 
 To verify that the STR works, it is generally more convenient to use the s2ram
 tool available from http://suspend.sf.net and documented at
@@ -230,7 +243,8 @@ you will have to unload them every time before an STR transition (ie. before
 you run s2ram), and please report the problems with them.
 
 There is a debugfs entry which shows the suspend to RAM statistics. Here is an
-example of its output.
+example of its output::
+
 	# mount -t debugfs none /sys/kernel/debug
 	# cat /sys/kernel/debug/suspend_stats
 	success: 20
@@ -248,6 +262,7 @@ example of its output.
 				-16
 	  last_failed_step:	suspend
 				suspend
+
 Field success means the success number of suspend to RAM, and field fail means
 the failure number. Others are the failure number of different steps of suspend
 to RAM. suspend_stats just lists the last 2 failed devices, error number and
diff --git a/Documentation/power/charger-manager.txt b/Documentation/power/charger-manager.rst
similarity index 78%
rename from Documentation/power/charger-manager.txt
rename to Documentation/power/charger-manager.rst
index 9ff1105e58d6..84fab9376792 100644
--- a/Documentation/power/charger-manager.txt
+++ b/Documentation/power/charger-manager.rst
@@ -1,4 +1,7 @@
+===============
 Charger Manager
+===============
+
 	(C) 2011 MyungJoo Ham <myungjoo.ham@samsung.com>, GPL
 
 Charger Manager provides in-kernel battery charger management that
@@ -55,41 +58,39 @@ Charger Manager supports the following:
 	notification to users with UEVENT.
 
 2. Global Charger-Manager Data related with suspend_again
-========================================================
+=========================================================
 In order to setup Charger Manager with suspend-again feature
 (in-suspend monitoring), the user should provide charger_global_desc
-with setup_charger_manager(struct charger_global_desc *).
+with setup_charger_manager(`struct charger_global_desc *`).
 This charger_global_desc data for in-suspend monitoring is global
 as the name suggests. Thus, the user needs to provide only once even
 if there are multiple batteries. If there are multiple batteries, the
 multiple instances of Charger Manager share the same charger_global_desc
 and it will manage in-suspend monitoring for all instances of Charger Manager.
 
-The user needs to provide all the three entries properly in order to activate
-in-suspend monitoring:
+The user needs to provide all the three entries to `struct charger_global_desc`
+properly in order to activate in-suspend monitoring:
 
-struct charger_global_desc {
-
-char *rtc_name;
-	: The name of rtc (e.g., "rtc0") used to wakeup the system from
+`char *rtc_name;`
+	The name of rtc (e.g., "rtc0") used to wakeup the system from
 	suspend for Charger Manager. The alarm interrupt (AIE) of the rtc
 	should be able to wake up the system from suspend. Charger Manager
 	saves and restores the alarm value and use the previously-defined
 	alarm if it is going to go off earlier than Charger Manager so that
 	Charger Manager does not interfere with previously-defined alarms.
 
-bool (*rtc_only_wakeup)(void);
-	: This callback should let CM know whether
+`bool (*rtc_only_wakeup)(void);`
+	This callback should let CM know whether
 	the wakeup-from-suspend is caused only by the alarm of "rtc" in the
 	same struct. If there is any other wakeup source triggered the
 	wakeup, it should return false. If the "rtc" is the only wakeup
 	reason, it should return true.
 
-bool assume_timer_stops_in_suspend;
-	: if true, Charger Manager assumes that
+`bool assume_timer_stops_in_suspend;`
+	if true, Charger Manager assumes that
 	the timer (CM uses jiffies as timer) stops during suspend. Then, CM
 	assumes that the suspend-duration is same as the alarm length.
-};
+
 
 3. How to setup suspend_again
 =============================
@@ -109,26 +110,28 @@ if the system was woken up by Charger Manager and the polling
 =============================================
 For each battery charged independently from other batteries (if a series of
 batteries are charged by a single charger, they are counted as one independent
-battery), an instance of Charger Manager is attached to it.
+battery), an instance of Charger Manager is attached to it. The following
 
-struct charger_desc {
+struct charger_desc elements:
 
-char *psy_name;
-	: The power-supply-class name of the battery. Default is
+`char *psy_name;`
+	The power-supply-class name of the battery. Default is
 	"battery" if psy_name is NULL. Users can access the psy entries
 	at "/sys/class/power_supply/[psy_name]/".
 
-enum polling_modes polling_mode;
-	: CM_POLL_DISABLE: do not poll this battery.
-	  CM_POLL_ALWAYS: always poll this battery.
-	  CM_POLL_EXTERNAL_POWER_ONLY: poll this battery if and only if
-				       an external power source is attached.
-	  CM_POLL_CHARGING_ONLY: poll this battery if and only if the
-				 battery is being charged.
+`enum polling_modes polling_mode;`
+	  CM_POLL_DISABLE:
+		do not poll this battery.
+	  CM_POLL_ALWAYS:
+		always poll this battery.
+	  CM_POLL_EXTERNAL_POWER_ONLY:
+		poll this battery if and only if an external power
+		source is attached.
+	  CM_POLL_CHARGING_ONLY:
+		poll this battery if and only if the battery is being charged.
 
-unsigned int fullbatt_vchkdrop_ms;
-unsigned int fullbatt_vchkdrop_uV;
-	: If both have non-zero values, Charger Manager will check the
+`unsigned int fullbatt_vchkdrop_ms; / unsigned int fullbatt_vchkdrop_uV;`
+	If both have non-zero values, Charger Manager will check the
 	battery voltage drop fullbatt_vchkdrop_ms after the battery is fully
 	charged. If the voltage drop is over fullbatt_vchkdrop_uV, Charger
 	Manager will try to recharge the battery by disabling and enabling
@@ -136,50 +139,52 @@ unsigned int fullbatt_vchkdrop_uV;
 	condition) is needed to be implemented with hardware interrupts from
 	fuel gauges or charger devices/chips.
 
-unsigned int fullbatt_uV;
-	: If specified with a non-zero value, Charger Manager assumes
+`unsigned int fullbatt_uV;`
+	If specified with a non-zero value, Charger Manager assumes
 	that the battery is full (capacity = 100) if the battery is not being
 	charged and the battery voltage is equal to or greater than
 	fullbatt_uV.
 
-unsigned int polling_interval_ms;
-	: Required polling interval in ms. Charger Manager will poll
+`unsigned int polling_interval_ms;`
+	Required polling interval in ms. Charger Manager will poll
 	this battery every polling_interval_ms or more frequently.
 
-enum data_source battery_present;
-	: CM_BATTERY_PRESENT: assume that the battery exists.
-	CM_NO_BATTERY: assume that the battery does not exists.
-	CM_FUEL_GAUGE: get battery presence information from fuel gauge.
-	CM_CHARGER_STAT: get battery presence from chargers.
+`enum data_source battery_present;`
+	CM_BATTERY_PRESENT:
+		assume that the battery exists.
+	CM_NO_BATTERY:
+		assume that the battery does not exists.
+	CM_FUEL_GAUGE:
+		get battery presence information from fuel gauge.
+	CM_CHARGER_STAT:
+		get battery presence from chargers.
 
-char **psy_charger_stat;
-	: An array ending with NULL that has power-supply-class names of
+`char **psy_charger_stat;`
+	An array ending with NULL that has power-supply-class names of
 	chargers. Each power-supply-class should provide "PRESENT" (if
 	battery_present is "CM_CHARGER_STAT"), "ONLINE" (shows whether an
 	external power source is attached or not), and "STATUS" (shows whether
 	the battery is {"FULL" or not FULL} or {"FULL", "Charging",
 	"Discharging", "NotCharging"}).
 
-int num_charger_regulators;
-struct regulator_bulk_data *charger_regulators;
-	: Regulators representing the chargers in the form for
+`int num_charger_regulators; / struct regulator_bulk_data *charger_regulators;`
+	Regulators representing the chargers in the form for
 	regulator framework's bulk functions.
 
-char *psy_fuel_gauge;
-	: Power-supply-class name of the fuel gauge.
+`char *psy_fuel_gauge;`
+	Power-supply-class name of the fuel gauge.
 
-int (*temperature_out_of_range)(int *mC);
-bool measure_battery_temp;
-	: This callback returns 0 if the temperature is safe for charging,
+`int (*temperature_out_of_range)(int *mC); / bool measure_battery_temp;`
+	This callback returns 0 if the temperature is safe for charging,
 	a positive number if it is too hot to charge, and a negative number
 	if it is too cold to charge. With the variable mC, the callback returns
 	the temperature in 1/1000 of centigrade.
 	The source of temperature can be battery or ambient one according to
 	the value of measure_battery_temp.
-};
+
 
 5. Notify Charger-Manager of charger events: cm_notify_event()
-=========================================================
+==============================================================
 If there is an charger event is required to notify
 Charger Manager, a charger device driver that triggers the event can call
 cm_notify_event(psy, type, msg) to notify the corresponding Charger Manager.
diff --git a/Documentation/power/drivers-testing.txt b/Documentation/power/drivers-testing.rst
similarity index 86%
rename from Documentation/power/drivers-testing.txt
rename to Documentation/power/drivers-testing.rst
index 638afdf4d6b8..e53f1999fc39 100644
--- a/Documentation/power/drivers-testing.txt
+++ b/Documentation/power/drivers-testing.rst
@@ -1,7 +1,11 @@
+====================================================
 Testing suspend and resume support in device drivers
+====================================================
+
 	(C) 2007 Rafael J. Wysocki <rjw@sisk.pl>, GPL
 
 1. Preparing the test system
+============================
 
 Unfortunately, to effectively test the support for the system-wide suspend and
 resume transitions in a driver, it is necessary to suspend and resume a fully
@@ -14,19 +18,20 @@ the machine's BIOS.
 Of course, for this purpose the test system has to be known to suspend and
 resume without the driver being tested.  Thus, if possible, you should first
 resolve all suspend/resume-related problems in the test system before you start
-testing the new driver.  Please see Documentation/power/basic-pm-debugging.txt
+testing the new driver.  Please see Documentation/power/basic-pm-debugging.rst
 for more information about the debugging of suspend/resume functionality.
 
 2. Testing the driver
+=====================
 
 Once you have resolved the suspend/resume-related problems with your test system
 without the new driver, you are ready to test it:
 
 a) Build the driver as a module, load it and try the test modes of hibernation
-   (see: Documentation/power/basic-pm-debugging.txt, 1).
+   (see: Documentation/power/basic-pm-debugging.rst, 1).
 
 b) Load the driver and attempt to hibernate in the "reboot", "shutdown" and
-   "platform" modes (see: Documentation/power/basic-pm-debugging.txt, 1).
+   "platform" modes (see: Documentation/power/basic-pm-debugging.rst, 1).
 
 c) Compile the driver directly into the kernel and try the test modes of
    hibernation.
@@ -34,12 +39,12 @@ c) Compile the driver directly into the kernel and try the test modes of
 d) Attempt to hibernate with the driver compiled directly into the kernel
    in the "reboot", "shutdown" and "platform" modes.
 
-e) Try the test modes of suspend (see: Documentation/power/basic-pm-debugging.txt,
+e) Try the test modes of suspend (see: Documentation/power/basic-pm-debugging.rst,
    2).  [As far as the STR tests are concerned, it should not matter whether or
    not the driver is built as a module.]
 
 f) Attempt to suspend to RAM using the s2ram tool with the driver loaded
-   (see: Documentation/power/basic-pm-debugging.txt, 2).
+   (see: Documentation/power/basic-pm-debugging.rst, 2).
 
 Each of the above tests should be repeated several times and the STD tests
 should be mixed with the STR tests.  If any of them fails, the driver cannot be
diff --git a/Documentation/power/energy-model.txt b/Documentation/power/energy-model.rst
similarity index 74%
rename from Documentation/power/energy-model.txt
rename to Documentation/power/energy-model.rst
index a2b0ae4c76bd..90a345d57ae9 100644
--- a/Documentation/power/energy-model.txt
+++ b/Documentation/power/energy-model.rst
@@ -1,6 +1,6 @@
-                           ====================
-                           Energy Model of CPUs
-                           ====================
+====================
+Energy Model of CPUs
+====================
 
 1. Overview
 -----------
@@ -20,7 +20,7 @@ kernel, hence enabling to avoid redundant work.
 
 The figure below depicts an example of drivers (Arm-specific here, but the
 approach is applicable to any architecture) providing power costs to the EM
-framework, and interested clients reading the data from it.
+framework, and interested clients reading the data from it::
 
        +---------------+  +-----------------+  +---------------+
        | Thermal (IPA) |  | Scheduler (EAS) |  |     Other     |
@@ -58,15 +58,17 @@ micro-architectures.
 2. Core APIs
 ------------
 
-  2.1 Config options
+2.1 Config options
+^^^^^^^^^^^^^^^^^^
 
 CONFIG_ENERGY_MODEL must be enabled to use the EM framework.
 
 
-  2.2 Registration of performance domains
+2.2 Registration of performance domains
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 Drivers are expected to register performance domains into the EM framework by
-calling the following API:
+calling the following API::
 
   int em_register_perf_domain(cpumask_t *span, unsigned int nr_states,
 			      struct em_data_callback *cb);
@@ -80,7 +82,8 @@ callback, and kernel/power/energy_model.c for further documentation on this
 API.
 
 
-  2.3 Accessing performance domains
+2.3 Accessing performance domains
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 Subsystems interested in the energy model of a CPU can retrieve it using the
 em_cpu_get() API. The energy model tables are allocated once upon creation of
@@ -99,46 +102,46 @@ More details about the above APIs can be found in include/linux/energy_model.h.
 This section provides a simple example of a CPUFreq driver registering a
 performance domain in the Energy Model framework using the (fake) 'foo'
 protocol. The driver implements an est_power() function to be provided to the
-EM framework.
+EM framework::
 
- -> drivers/cpufreq/foo_cpufreq.c
+  -> drivers/cpufreq/foo_cpufreq.c
 
-01	static int est_power(unsigned long *mW, unsigned long *KHz, int cpu)
-02	{
-03		long freq, power;
-04
-05		/* Use the 'foo' protocol to ceil the frequency */
-06		freq = foo_get_freq_ceil(cpu, *KHz);
-07		if (freq < 0);
-08			return freq;
-09
-10		/* Estimate the power cost for the CPU at the relevant freq. */
-11		power = foo_estimate_power(cpu, freq);
-12		if (power < 0);
-13			return power;
-14
-15		/* Return the values to the EM framework */
-16		*mW = power;
-17		*KHz = freq;
-18
-19		return 0;
-20	}
-21
-22	static int foo_cpufreq_init(struct cpufreq_policy *policy)
-23	{
-24		struct em_data_callback em_cb = EM_DATA_CB(est_power);
-25		int nr_opp, ret;
-26
-27		/* Do the actual CPUFreq init work ... */
-28		ret = do_foo_cpufreq_init(policy);
-29		if (ret)
-30			return ret;
-31
-32		/* Find the number of OPPs for this policy */
-33		nr_opp = foo_get_nr_opp(policy);
-34
-35		/* And register the new performance domain */
-36		em_register_perf_domain(policy->cpus, nr_opp, &em_cb);
-37
-38	        return 0;
-39	}
+  01	static int est_power(unsigned long *mW, unsigned long *KHz, int cpu)
+  02	{
+  03		long freq, power;
+  04
+  05		/* Use the 'foo' protocol to ceil the frequency */
+  06		freq = foo_get_freq_ceil(cpu, *KHz);
+  07		if (freq < 0);
+  08			return freq;
+  09
+  10		/* Estimate the power cost for the CPU at the relevant freq. */
+  11		power = foo_estimate_power(cpu, freq);
+  12		if (power < 0);
+  13			return power;
+  14
+  15		/* Return the values to the EM framework */
+  16		*mW = power;
+  17		*KHz = freq;
+  18
+  19		return 0;
+  20	}
+  21
+  22	static int foo_cpufreq_init(struct cpufreq_policy *policy)
+  23	{
+  24		struct em_data_callback em_cb = EM_DATA_CB(est_power);
+  25		int nr_opp, ret;
+  26
+  27		/* Do the actual CPUFreq init work ... */
+  28		ret = do_foo_cpufreq_init(policy);
+  29		if (ret)
+  30			return ret;
+  31
+  32		/* Find the number of OPPs for this policy */
+  33		nr_opp = foo_get_nr_opp(policy);
+  34
+  35		/* And register the new performance domain */
+  36		em_register_perf_domain(policy->cpus, nr_opp, &em_cb);
+  37
+  38	        return 0;
+  39	}
diff --git a/Documentation/power/freezing-of-tasks.txt b/Documentation/power/freezing-of-tasks.rst
similarity index 75%
rename from Documentation/power/freezing-of-tasks.txt
rename to Documentation/power/freezing-of-tasks.rst
index cd283190855a..ef110fe55e82 100644
--- a/Documentation/power/freezing-of-tasks.txt
+++ b/Documentation/power/freezing-of-tasks.rst
@@ -1,13 +1,18 @@
+=================
 Freezing of tasks
-	(C) 2007 Rafael J. Wysocki <rjw@sisk.pl>, GPL
+=================
+
+(C) 2007 Rafael J. Wysocki <rjw@sisk.pl>, GPL
 
 I. What is the freezing of tasks?
+=================================
 
 The freezing of tasks is a mechanism by which user space processes and some
 kernel threads are controlled during hibernation or system-wide suspend (on some
 architectures).
 
 II. How does it work?
+=====================
 
 There are three per-task flags used for that, PF_NOFREEZE, PF_FROZEN
 and PF_FREEZER_SKIP (the last one is auxiliary).  The tasks that have
@@ -41,7 +46,7 @@ explicitly in suitable places or use the wait_event_freezable() or
 wait_event_freezable_timeout() macros (defined in include/linux/freezer.h)
 that combine interruptible sleep with checking if the task is to be frozen and
 calling try_to_freeze().  The main loop of a freezable kernel thread may look
-like the following one:
+like the following one::
 
 	set_freezable();
 	do {
@@ -65,7 +70,7 @@ order to clear the PF_FROZEN flag for each frozen task.  Then, the tasks that
 have been frozen leave __refrigerator() and continue running.
 
 
-Rationale behind the functions dealing with freezing and thawing of tasks:
+Rationale behind the functions dealing with freezing and thawing of tasks
 -------------------------------------------------------------------------
 
 freeze_processes():
@@ -86,6 +91,7 @@ thaw_processes():
 
 
 III. Which kernel threads are freezable?
+========================================
 
 Kernel threads are not freezable by default.  However, a kernel thread may clear
 PF_NOFREEZE for itself by calling set_freezable() (the resetting of PF_NOFREEZE
@@ -93,37 +99,39 @@ directly is not allowed).  From this point it is regarded as freezable
 and must call try_to_freeze() in a suitable place.
 
 IV. Why do we do that?
+======================
 
 Generally speaking, there is a couple of reasons to use the freezing of tasks:
 
 1. The principal reason is to prevent filesystems from being damaged after
-hibernation.  At the moment we have no simple means of checkpointing
-filesystems, so if there are any modifications made to filesystem data and/or
-metadata on disks, we cannot bring them back to the state from before the
-modifications.  At the same time each hibernation image contains some
-filesystem-related information that must be consistent with the state of the
-on-disk data and metadata after the system memory state has been restored from
-the image (otherwise the filesystems will be damaged in a nasty way, usually
-making them almost impossible to repair).  We therefore freeze tasks that might
-cause the on-disk filesystems' data and metadata to be modified after the
-hibernation image has been created and before the system is finally powered off.
-The majority of these are user space processes, but if any of the kernel threads
-may cause something like this to happen, they have to be freezable.
+   hibernation.  At the moment we have no simple means of checkpointing
+   filesystems, so if there are any modifications made to filesystem data and/or
+   metadata on disks, we cannot bring them back to the state from before the
+   modifications.  At the same time each hibernation image contains some
+   filesystem-related information that must be consistent with the state of the
+   on-disk data and metadata after the system memory state has been restored
+   from the image (otherwise the filesystems will be damaged in a nasty way,
+   usually making them almost impossible to repair).  We therefore freeze
+   tasks that might cause the on-disk filesystems' data and metadata to be
+   modified after the hibernation image has been created and before the
+   system is finally powered off. The majority of these are user space
+   processes, but if any of the kernel threads may cause something like this
+   to happen, they have to be freezable.
 
 2. Next, to create the hibernation image we need to free a sufficient amount of
-memory (approximately 50% of available RAM) and we need to do that before
-devices are deactivated, because we generally need them for swapping out.  Then,
-after the memory for the image has been freed, we don't want tasks to allocate
-additional memory and we prevent them from doing that by freezing them earlier.
-[Of course, this also means that device drivers should not allocate substantial
-amounts of memory from their .suspend() callbacks before hibernation, but this
-is a separate issue.]
+   memory (approximately 50% of available RAM) and we need to do that before
+   devices are deactivated, because we generally need them for swapping out.
+   Then, after the memory for the image has been freed, we don't want tasks
+   to allocate additional memory and we prevent them from doing that by
+   freezing them earlier. [Of course, this also means that device drivers
+   should not allocate substantial amounts of memory from their .suspend()
+   callbacks before hibernation, but this is a separate issue.]
 
 3. The third reason is to prevent user space processes and some kernel threads
-from interfering with the suspending and resuming of devices.  A user space
-process running on a second CPU while we are suspending devices may, for
-example, be troublesome and without the freezing of tasks we would need some
-safeguards against race conditions that might occur in such a case.
+   from interfering with the suspending and resuming of devices.  A user space
+   process running on a second CPU while we are suspending devices may, for
+   example, be troublesome and without the freezing of tasks we would need some
+   safeguards against race conditions that might occur in such a case.
 
 Although Linus Torvalds doesn't like the freezing of tasks, he said this in one
 of the discussions on LKML (http://lkml.org/lkml/2007/4/27/608):
@@ -132,7 +140,7 @@ of the discussions on LKML (http://lkml.org/lkml/2007/4/27/608):
 
 Linus: In many ways, 'at all'.
 
-I _do_ realize the IO request queue issues, and that we cannot actually do
+I **do** realize the IO request queue issues, and that we cannot actually do
 s2ram with some devices in the middle of a DMA.  So we want to be able to
 avoid *that*, there's no question about that.  And I suspect that stopping
 user threads and then waiting for a sync is practically one of the easier
@@ -150,17 +158,18 @@ thawed after the driver's .resume() callback has run, so it won't be accessing
 the device while it's suspended.
 
 4. Another reason for freezing tasks is to prevent user space processes from
-realizing that hibernation (or suspend) operation takes place.  Ideally, user
-space processes should not notice that such a system-wide operation has occurred
-and should continue running without any problems after the restore (or resume
-from suspend).  Unfortunately, in the most general case this is quite difficult
-to achieve without the freezing of tasks.  Consider, for example, a process
-that depends on all CPUs being online while it's running.  Since we need to
-disable nonboot CPUs during the hibernation, if this process is not frozen, it
-may notice that the number of CPUs has changed and may start to work incorrectly
-because of that.
+   realizing that hibernation (or suspend) operation takes place.  Ideally, user
+   space processes should not notice that such a system-wide operation has
+   occurred and should continue running without any problems after the restore
+   (or resume from suspend).  Unfortunately, in the most general case this
+   is quite difficult to achieve without the freezing of tasks.  Consider,
+   for example, a process that depends on all CPUs being online while it's
+   running.  Since we need to disable nonboot CPUs during the hibernation,
+   if this process is not frozen, it may notice that the number of CPUs has
+   changed and may start to work incorrectly because of that.
 
 V. Are there any problems related to the freezing of tasks?
+===========================================================
 
 Yes, there are.
 
@@ -172,11 +181,12 @@ may be undesirable.  That's why kernel threads are not freezable by default.
 
 Second, there are the following two problems related to the freezing of user
 space processes:
+
 1. Putting processes into an uninterruptible sleep distorts the load average.
 2. Now that we have FUSE, plus the framework for doing device drivers in
-userspace, it gets even more complicated because some userspace processes are
-now doing the sorts of things that kernel threads do
-(https://lists.linux-foundation.org/pipermail/linux-pm/2007-May/012309.html).
+   userspace, it gets even more complicated because some userspace processes are
+   now doing the sorts of things that kernel threads do
+   (https://lists.linux-foundation.org/pipermail/linux-pm/2007-May/012309.html).
 
 The problem 1. seems to be fixable, although it hasn't been fixed so far.  The
 other one is more serious, but it seems that we can work around it by using
@@ -201,6 +211,7 @@ requested early enough using the suspend notifier API described in
 Documentation/driver-api/pm/notifiers.rst.
 
 VI. Are there any precautions to be taken to prevent freezing failures?
+=======================================================================
 
 Yes, there are.
 
@@ -226,6 +237,8 @@ So, to summarize, use [un]lock_system_sleep() instead of directly using
 mutex_[un]lock(&system_transition_mutex). That would prevent freezing failures.
 
 V. Miscellaneous
+================
+
 /sys/power/pm_freeze_timeout controls how long it will cost at most to freeze
 all user space processes or all freezable kernel threads, in unit of millisecond.
 The default value is 20000, with range of unsigned integer.
diff --git a/Documentation/power/index.rst b/Documentation/power/index.rst
new file mode 100644
index 000000000000..20415f21e48a
--- /dev/null
+++ b/Documentation/power/index.rst
@@ -0,0 +1,46 @@
+:orphan:
+
+================
+Power Management
+================
+
+.. toctree::
+    :maxdepth: 1
+
+    apm-acpi
+    basic-pm-debugging
+    charger-manager
+    drivers-testing
+    energy-model
+    freezing-of-tasks
+    interface
+    opp
+    pci
+    pm_qos_interface
+    power_supply_class
+    runtime_pm
+    s2ram
+    suspend-and-cpuhotplug
+    suspend-and-interrupts
+    swsusp-and-swap-files
+    swsusp-dmcrypt
+    swsusp
+    video
+    tricks
+
+    userland-swsusp
+
+    powercap/powercap
+
+    regulator/consumer
+    regulator/design
+    regulator/machine
+    regulator/overview
+    regulator/regulator
+
+.. only::  subproject and html
+
+   Indices
+   =======
+
+   * :ref:`genindex`
diff --git a/Documentation/power/interface.txt b/Documentation/power/interface.rst
similarity index 84%
rename from Documentation/power/interface.txt
rename to Documentation/power/interface.rst
index 27df7f98668a..8d270ed27228 100644
--- a/Documentation/power/interface.txt
+++ b/Documentation/power/interface.rst
@@ -1,4 +1,6 @@
+===========================================
 Power Management Interface for System Sleep
+===========================================
 
 Copyright (c) 2016 Intel Corp., Rafael J. Wysocki <rafael.j.wysocki@intel.com>
 
@@ -11,10 +13,10 @@ mounted at /sys).
 
 Reading from it returns a list of supported sleep states, encoded as:
 
-'freeze' (Suspend-to-Idle)
-'standby' (Power-On Suspend)
-'mem' (Suspend-to-RAM)
-'disk' (Suspend-to-Disk)
+- 'freeze' (Suspend-to-Idle)
+- 'standby' (Power-On Suspend)
+- 'mem' (Suspend-to-RAM)
+- 'disk' (Suspend-to-Disk)
 
 Suspend-to-Idle is always supported.  Suspend-to-Disk is always supported
 too as long the kernel has been configured to support hibernation at all
@@ -32,18 +34,18 @@ Specifically, it tells the kernel what to do after creating a hibernation image.
 
 Reading from it returns a list of supported options encoded as:
 
-'platform' (put the system into sleep using a platform-provided method)
-'shutdown' (shut the system down)
-'reboot' (reboot the system)
-'suspend' (trigger a Suspend-to-RAM transition)
-'test_resume' (resume-after-hibernation test mode)
+- 'platform' (put the system into sleep using a platform-provided method)
+- 'shutdown' (shut the system down)
+- 'reboot' (reboot the system)
+- 'suspend' (trigger a Suspend-to-RAM transition)
+- 'test_resume' (resume-after-hibernation test mode)
 
 The currently selected option is printed in square brackets.
 
 The 'platform' option is only available if the platform provides a special
 mechanism to put the system to sleep after creating a hibernation image (ACPI
 does that, for example).  The 'suspend' option is available if Suspend-to-RAM
-is supported.  Refer to Documentation/power/basic-pm-debugging.txt for the
+is supported.  Refer to Documentation/power/basic-pm-debugging.rst for the
 description of the 'test_resume' option.
 
 To select an option, write the string representing it to /sys/power/disk.
@@ -71,7 +73,7 @@ If /sys/power/pm_trace contains '1', the fingerprint of each suspend/resume
 event point in turn will be stored in the RTC memory (overwriting the actual
 RTC information), so it will survive a system crash if one occurs right after
 storing it and it can be used later to identify the driver that caused the crash
-to happen (see Documentation/power/s2ram.txt for more information).
+to happen (see Documentation/power/s2ram.rst for more information).
 
 Initially it contains '0' which may be changed to '1' by writing a string
 representing a nonzero integer into it.
diff --git a/Documentation/power/opp.txt b/Documentation/power/opp.rst
similarity index 78%
rename from Documentation/power/opp.txt
rename to Documentation/power/opp.rst
index 0c007e250cd1..b3cf1def9dee 100644
--- a/Documentation/power/opp.txt
+++ b/Documentation/power/opp.rst
@@ -1,20 +1,23 @@
+==========================================
 Operating Performance Points (OPP) Library
 ==========================================
 
 (C) 2009-2010 Nishanth Menon <nm@ti.com>, Texas Instruments Incorporated
 
-Contents
---------
-1. Introduction
-2. Initial OPP List Registration
-3. OPP Search Functions
-4. OPP Availability Control Functions
-5. OPP Data Retrieval Functions
-6. Data Structures
+.. Contents
+
+  1. Introduction
+  2. Initial OPP List Registration
+  3. OPP Search Functions
+  4. OPP Availability Control Functions
+  5. OPP Data Retrieval Functions
+  6. Data Structures
 
 1. Introduction
 ===============
+
 1.1 What is an Operating Performance Point (OPP)?
+-------------------------------------------------
 
 Complex SoCs of today consists of a multiple sub-modules working in conjunction.
 In an operational system executing varied use cases, not all modules in the SoC
@@ -28,16 +31,19 @@ the device will support per domain are called Operating Performance Points or
 OPPs.
 
 As an example:
+
 Let us consider an MPU device which supports the following:
 {300MHz at minimum voltage of 1V}, {800MHz at minimum voltage of 1.2V},
 {1GHz at minimum voltage of 1.3V}
 
 We can represent these as three OPPs as the following {Hz, uV} tuples:
-{300000000, 1000000}
-{800000000, 1200000}
-{1000000000, 1300000}
+
+- {300000000, 1000000}
+- {800000000, 1200000}
+- {1000000000, 1300000}
 
 1.2 Operating Performance Points Library
+----------------------------------------
 
 OPP library provides a set of helper functions to organize and query the OPP
 information. The library is located in drivers/base/power/opp.c and the header
@@ -46,9 +52,10 @@ CONFIG_PM_OPP from power management menuconfig menu. OPP library depends on
 CONFIG_PM as certain SoCs such as Texas Instrument's OMAP framework allows to
 optionally boot at a certain OPP without needing cpufreq.
 
-Typical usage of the OPP library is as follows:
-(users)		-> registers a set of default OPPs		-> (library)
-SoC framework	-> modifies on required cases certain OPPs	-> OPP layer
+Typical usage of the OPP library is as follows::
+
+ (users)	-> registers a set of default OPPs		-> (library)
+ SoC framework	-> modifies on required cases certain OPPs	-> OPP layer
 		-> queries to search/retrieve information	->
 
 OPP layer expects each domain to be represented by a unique device pointer. SoC
@@ -57,8 +64,9 @@ list is expected to be an optimally small number typically around 5 per device.
 This initial list contains a set of OPPs that the framework expects to be safely
 enabled by default in the system.
 
-Note on OPP Availability:
-------------------------
+Note on OPP Availability
+^^^^^^^^^^^^^^^^^^^^^^^^
+
 As the system proceeds to operate, SoC framework may choose to make certain
 OPPs available or not available on each device based on various external
 factors. Example usage: Thermal management or other exceptional situations where
@@ -88,7 +96,8 @@ registering the OPPs is maintained by OPP library throughout the device
 operation. The SoC framework can subsequently control the availability of the
 OPPs dynamically using the dev_pm_opp_enable / disable functions.
 
-dev_pm_opp_add - Add a new OPP for a specific domain represented by the device pointer.
+dev_pm_opp_add
+	Add a new OPP for a specific domain represented by the device pointer.
 	The OPP is defined using the frequency and voltage. Once added, the OPP
 	is assumed to be available and control of it's availability can be done
 	with the dev_pm_opp_enable/disable functions. OPP library internally stores
@@ -96,9 +105,11 @@ dev_pm_opp_add - Add a new OPP for a specific domain represented by the device p
 	used by SoC framework to define a optimal list as per the demands of
 	SoC usage environment.
 
-	WARNING: Do not use this function in interrupt context.
+	WARNING:
+		Do not use this function in interrupt context.
+
+	Example::
 
-	Example:
 	 soc_pm_init()
 	 {
 		/* Do things */
@@ -125,12 +136,15 @@ Callers of these functions shall call dev_pm_opp_put() after they have used the
 OPP. Otherwise the memory for the OPP will never get freed and result in
 memleak.
 
-dev_pm_opp_find_freq_exact - Search for an OPP based on an *exact* frequency and
+dev_pm_opp_find_freq_exact
+	Search for an OPP based on an *exact* frequency and
 	availability. This function is especially useful to enable an OPP which
 	is not available by default.
 	Example: In a case when SoC framework detects a situation where a
 	higher frequency could be made available, it can use this function to
-	find the OPP prior to call the dev_pm_opp_enable to actually make it available.
+	find the OPP prior to call the dev_pm_opp_enable to actually make
+	it available::
+
 	 opp = dev_pm_opp_find_freq_exact(dev, 1000000000, false);
 	 dev_pm_opp_put(opp);
 	 /* dont operate on the pointer.. just do a sanity check.. */
@@ -141,27 +155,34 @@ dev_pm_opp_find_freq_exact - Search for an OPP based on an *exact* frequency and
 		dev_pm_opp_enable(dev,1000000000);
 	 }
 
-	NOTE: This is the only search function that operates on OPPs which are
-	not available.
+	NOTE:
+	  This is the only search function that operates on OPPs which are
+	  not available.
 
-dev_pm_opp_find_freq_floor - Search for an available OPP which is *at most* the
+dev_pm_opp_find_freq_floor
+	Search for an available OPP which is *at most* the
 	provided frequency. This function is useful while searching for a lesser
 	match OR operating on OPP information in the order of decreasing
 	frequency.
-	Example: To find the highest opp for a device:
+	Example: To find the highest opp for a device::
+
 	 freq = ULONG_MAX;
 	 opp = dev_pm_opp_find_freq_floor(dev, &freq);
 	 dev_pm_opp_put(opp);
 
-dev_pm_opp_find_freq_ceil - Search for an available OPP which is *at least* the
+dev_pm_opp_find_freq_ceil
+	Search for an available OPP which is *at least* the
 	provided frequency. This function is useful while searching for a
 	higher match OR operating on OPP information in the order of increasing
 	frequency.
-	Example 1: To find the lowest opp for a device:
+	Example 1: To find the lowest opp for a device::
+
 	 freq = 0;
 	 opp = dev_pm_opp_find_freq_ceil(dev, &freq);
 	 dev_pm_opp_put(opp);
-	Example 2: A simplified implementation of a SoC cpufreq_driver->target:
+
+	Example 2: A simplified implementation of a SoC cpufreq_driver->target::
+
 	 soc_cpufreq_target(..)
 	 {
 		/* Do stuff like policy checks etc. */
@@ -184,12 +205,15 @@ fine grained dynamic control of which sets of OPPs are operationally available.
 These functions are intended to *temporarily* remove an OPP in conditions such
 as thermal considerations (e.g. don't use OPPx until the temperature drops).
 
-WARNING: Do not use these functions in interrupt context.
+WARNING:
+	Do not use these functions in interrupt context.
 
-dev_pm_opp_enable - Make a OPP available for operation.
+dev_pm_opp_enable
+	Make a OPP available for operation.
 	Example: Lets say that 1GHz OPP is to be made available only if the
 	SoC temperature is lower than a certain threshold. The SoC framework
-	implementation might choose to do something as follows:
+	implementation might choose to do something as follows::
+
 	 if (cur_temp < temp_low_thresh) {
 		/* Enable 1GHz if it was disabled */
 		opp = dev_pm_opp_find_freq_exact(dev, 1000000000, false);
@@ -201,10 +225,12 @@ dev_pm_opp_enable - Make a OPP available for operation.
 			goto try_something_else;
 	 }
 
-dev_pm_opp_disable - Make an OPP to be not available for operation
+dev_pm_opp_disable
+	Make an OPP to be not available for operation
 	Example: Lets say that 1GHz OPP is to be disabled if the temperature
 	exceeds a threshold value. The SoC framework implementation might
-	choose to do something as follows:
+	choose to do something as follows::
+
 	 if (cur_temp > temp_high_thresh) {
 		/* Disable 1GHz if it was enabled */
 		opp = dev_pm_opp_find_freq_exact(dev, 1000000000, true);
@@ -223,11 +249,13 @@ information from the OPP structure is necessary. Once an OPP pointer is
 retrieved using the search functions, the following functions can be used by SoC
 framework to retrieve the information represented inside the OPP layer.
 
-dev_pm_opp_get_voltage - Retrieve the voltage represented by the opp pointer.
+dev_pm_opp_get_voltage
+	Retrieve the voltage represented by the opp pointer.
 	Example: At a cpufreq transition to a different frequency, SoC
 	framework requires to set the voltage represented by the OPP using
 	the regulator framework to the Power Management chip providing the
-	voltage.
+	voltage::
+
 	 soc_switch_to_freq_voltage(freq)
 	 {
 		/* do things */
@@ -239,10 +267,12 @@ dev_pm_opp_get_voltage - Retrieve the voltage represented by the opp pointer.
 		/* do other things */
 	 }
 
-dev_pm_opp_get_freq - Retrieve the freq represented by the opp pointer.
+dev_pm_opp_get_freq
+	Retrieve the freq represented by the opp pointer.
 	Example: Lets say the SoC framework uses a couple of helper functions
 	we could pass opp pointers instead of doing additional parameters to
-	handle quiet a bit of data parameters.
+	handle quiet a bit of data parameters::
+
 	 soc_cpufreq_target(..)
 	 {
 		/* do things.. */
@@ -264,9 +294,11 @@ dev_pm_opp_get_freq - Retrieve the freq represented by the opp pointer.
 		/* do things.. */
 	 }
 
-dev_pm_opp_get_opp_count - Retrieve the number of available opps for a device
+dev_pm_opp_get_opp_count
+	Retrieve the number of available opps for a device
 	Example: Lets say a co-processor in the SoC needs to know the available
-	frequencies in a table, the main processor can notify as following:
+	frequencies in a table, the main processor can notify as following::
+
 	 soc_notify_coproc_available_frequencies()
 	 {
 		/* Do things */
@@ -289,54 +321,59 @@ dev_pm_opp_get_opp_count - Retrieve the number of available opps for a device
 ==================
 Typically an SoC contains multiple voltage domains which are variable. Each
 domain is represented by a device pointer. The relationship to OPP can be
-represented as follows:
-SoC
- |- device 1
- |	|- opp 1 (availability, freq, voltage)
- |	|- opp 2 ..
- ...	...
- |	`- opp n ..
- |- device 2
- ...
- `- device m
+represented as follows::
+
+  SoC
+   |- device 1
+   |	|- opp 1 (availability, freq, voltage)
+   |	|- opp 2 ..
+   ...	...
+   |	`- opp n ..
+   |- device 2
+   ...
+   `- device m
 
 OPP library maintains a internal list that the SoC framework populates and
 accessed by various functions as described above. However, the structures
 representing the actual OPPs and domains are internal to the OPP library itself
 to allow for suitable abstraction reusable across systems.
 
-struct dev_pm_opp - The internal data structure of OPP library which is used to
+struct dev_pm_opp
+	The internal data structure of OPP library which is used to
 	represent an OPP. In addition to the freq, voltage, availability
 	information, it also contains internal book keeping information required
 	for the OPP library to operate on.  Pointer to this structure is
 	provided back to the users such as SoC framework to be used as a
 	identifier for OPP in the interactions with OPP layer.
 
-	WARNING: The struct dev_pm_opp pointer should not be parsed or modified by the
-	users. The defaults of for an instance is populated by dev_pm_opp_add, but the
-	availability of the OPP can be modified by dev_pm_opp_enable/disable functions.
+	WARNING:
+	  The struct dev_pm_opp pointer should not be parsed or modified by the
+	  users. The defaults of for an instance is populated by
+	  dev_pm_opp_add, but the availability of the OPP can be modified
+	  by dev_pm_opp_enable/disable functions.
 
-struct device - This is used to identify a domain to the OPP layer. The
+struct device
+	This is used to identify a domain to the OPP layer. The
 	nature of the device and it's implementation is left to the user of
 	OPP library such as the SoC framework.
 
 Overall, in a simplistic view, the data structure operations is represented as
-following:
+following::
 
-Initialization / modification:
-            +-----+        /- dev_pm_opp_enable
-dev_pm_opp_add --> | opp | <-------
-  |         +-----+        \- dev_pm_opp_disable
-  \-------> domain_info(device)
+  Initialization / modification:
+              +-----+        /- dev_pm_opp_enable
+  dev_pm_opp_add --> | opp | <-------
+    |         +-----+        \- dev_pm_opp_disable
+    \-------> domain_info(device)
 
-Search functions:
-             /-- dev_pm_opp_find_freq_ceil  ---\   +-----+
-domain_info<---- dev_pm_opp_find_freq_exact -----> | opp |
-             \-- dev_pm_opp_find_freq_floor ---/   +-----+
+  Search functions:
+               /-- dev_pm_opp_find_freq_ceil  ---\   +-----+
+  domain_info<---- dev_pm_opp_find_freq_exact -----> | opp |
+               \-- dev_pm_opp_find_freq_floor ---/   +-----+
 
-Retrieval functions:
-+-----+     /- dev_pm_opp_get_voltage
-| opp | <---
-+-----+     \- dev_pm_opp_get_freq
+  Retrieval functions:
+  +-----+     /- dev_pm_opp_get_voltage
+  | opp | <---
+  +-----+     \- dev_pm_opp_get_freq
 
-domain_info <- dev_pm_opp_get_opp_count
+  domain_info <- dev_pm_opp_get_opp_count
diff --git a/Documentation/power/pci.txt b/Documentation/power/pci.rst
similarity index 97%
rename from Documentation/power/pci.txt
rename to Documentation/power/pci.rst
index 8eaf9ee24d43..0e2ef7429304 100644
--- a/Documentation/power/pci.txt
+++ b/Documentation/power/pci.rst
@@ -1,4 +1,6 @@
+====================
 PCI Power Management
+====================
 
 Copyright (c) 2010 Rafael J. Wysocki <rjw@sisk.pl>, Novell Inc.
 
@@ -9,14 +11,14 @@ management.  Based on previous work by Patrick Mochel <mochel@transmeta.com>
 This document only covers the aspects of power management specific to PCI
 devices.  For general description of the kernel's interfaces related to device
 power management refer to Documentation/driver-api/pm/devices.rst and
-Documentation/power/runtime_pm.txt.
+Documentation/power/runtime_pm.rst.
 
----------------------------------------------------------------------------
+.. contents:
 
-1. Hardware and Platform Support for PCI Power Management
-2. PCI Subsystem and Device Power Management
-3. PCI Device Drivers and Power Management
-4. Resources
+   1. Hardware and Platform Support for PCI Power Management
+   2. PCI Subsystem and Device Power Management
+   3. PCI Device Drivers and Power Management
+   4. Resources
 
 
 1. Hardware and Platform Support for PCI Power Management
@@ -24,6 +26,7 @@ Documentation/power/runtime_pm.txt.
 
 1.1. Native and Platform-Based Power Management
 -----------------------------------------------
+
 In general, power management is a feature allowing one to save energy by putting
 devices into states in which they draw less power (low-power states) at the
 price of reduced functionality or performance.
@@ -67,6 +70,7 @@ mechanisms have to be used simultaneously to obtain the desired result.
 
 1.2. Native PCI Power Management
 --------------------------------
+
 The PCI Bus Power Management Interface Specification (PCI PM Spec) was
 introduced between the PCI 2.1 and PCI 2.2 Specifications.  It defined a
 standard interface for performing various operations related to power
@@ -134,6 +138,7 @@ sufficiently active to generate a wakeup signal.
 
 1.3. ACPI Device Power Management
 ---------------------------------
+
 The platform firmware support for the power management of PCI devices is
 system-specific.  However, if the system in question is compliant with the
 Advanced Configuration and Power Interface (ACPI) Specification, like the
@@ -194,6 +199,7 @@ enabled for the device to be able to generate wakeup signals.
 
 1.4. Wakeup Signaling
 ---------------------
+
 Wakeup signals generated by PCI devices, either as native PCI PMEs, or as
 a result of the execution of the _DSW (or _PSW) ACPI control method before
 putting the device into a low-power state, have to be caught and handled as
@@ -265,14 +271,15 @@ the native PCI Express PME signaling cannot be used by the kernel in that case.
 
 2.1. Device Power Management Callbacks
 --------------------------------------
+
 The PCI Subsystem participates in the power management of PCI devices in a
 number of ways.  First of all, it provides an intermediate code layer between
 the device power management core (PM core) and PCI device drivers.
 Specifically, the pm field of the PCI subsystem's struct bus_type object,
 pci_bus_type, points to a struct dev_pm_ops object, pci_dev_pm_ops, containing
-pointers to several device power management callbacks:
+pointers to several device power management callbacks::
 
-const struct dev_pm_ops pci_dev_pm_ops = {
+  const struct dev_pm_ops pci_dev_pm_ops = {
 	.prepare = pci_pm_prepare,
 	.complete = pci_pm_complete,
 	.suspend = pci_pm_suspend,
@@ -290,7 +297,7 @@ const struct dev_pm_ops pci_dev_pm_ops = {
 	.runtime_suspend = pci_pm_runtime_suspend,
 	.runtime_resume = pci_pm_runtime_resume,
 	.runtime_idle = pci_pm_runtime_idle,
-};
+  };
 
 These callbacks are executed by the PM core in various situations related to
 device power management and they, in turn, execute power management callbacks
@@ -299,9 +306,9 @@ involving some standard configuration registers of PCI devices that device
 drivers need not know or care about.
 
 The structure representing a PCI device, struct pci_dev, contains several fields
-that these callbacks operate on:
+that these callbacks operate on::
 
-struct pci_dev {
+  struct pci_dev {
 	...
 	pci_power_t     current_state;  /* Current operating state. */
 	int		pm_cap;		/* PM capability offset in the
@@ -315,13 +322,14 @@ struct pci_dev {
 	unsigned int	wakeup_prepared:1;  /* Device prepared for wake up */
 	unsigned int	d3_delay;	/* D3->D0 transition time in ms */
 	...
-};
+  };
 
 They also indirectly use some fields of the struct device that is embedded in
 struct pci_dev.
 
 2.2. Device Initialization
 --------------------------
+
 The PCI subsystem's first task related to device power management is to
 prepare the device for power management and initialize the fields of struct
 pci_dev used for this purpose.  This happens in two functions defined in
@@ -348,10 +356,11 @@ during system-wide transitions to a sleep state and back to the working state.
 
 2.3. Runtime Device Power Management
 ------------------------------------
+
 The PCI subsystem plays a vital role in the runtime power management of PCI
 devices.  For this purpose it uses the general runtime power management
-(runtime PM) framework described in Documentation/power/runtime_pm.txt.
-Namely, it provides subsystem-level callbacks:
+(runtime PM) framework described in Documentation/power/runtime_pm.rst.
+Namely, it provides subsystem-level callbacks::
 
 	pci_pm_runtime_suspend()
 	pci_pm_runtime_resume()
@@ -425,13 +434,14 @@ to the given subsystem before the next phase begins.  These phases always run
 after tasks have been frozen.
 
 2.4.1. System Suspend
+^^^^^^^^^^^^^^^^^^^^^
 
 When the system is going into a sleep state in which the contents of memory will
 be preserved, such as one of the ACPI sleep states S1-S3, the phases are:
 
 	prepare, suspend, suspend_noirq.
 
-The following PCI bus type's callbacks, respectively, are used in these phases:
+The following PCI bus type's callbacks, respectively, are used in these phases::
 
 	pci_pm_prepare()
 	pci_pm_suspend()
@@ -492,6 +502,7 @@ this purpose).  PCI device drivers are not encouraged to do that, but in some
 rare cases doing that in the driver may be the optimum approach.
 
 2.4.2. System Resume
+^^^^^^^^^^^^^^^^^^^^
 
 When the system is undergoing a transition from a sleep state in which the
 contents of memory have been preserved, such as one of the ACPI sleep states
@@ -500,7 +511,7 @@ S1-S3, into the working state (ACPI S0), the phases are:
 	resume_noirq, resume, complete.
 
 The following PCI bus type's callbacks, respectively, are executed in these
-phases:
+phases::
 
 	pci_pm_resume_noirq()
 	pci_pm_resume()
@@ -539,6 +550,7 @@ The pci_pm_complete() routine only executes the device driver's pm->complete()
 callback, if defined.
 
 2.4.3. System Hibernation
+^^^^^^^^^^^^^^^^^^^^^^^^^
 
 System hibernation is more complicated than system suspend, because it requires
 a system image to be created and written into a persistent storage medium.  The
@@ -551,7 +563,7 @@ to be free) in the following three phases:
 
 	prepare, freeze, freeze_noirq
 
-that correspond to the PCI bus type's callbacks:
+that correspond to the PCI bus type's callbacks::
 
 	pci_pm_prepare()
 	pci_pm_freeze()
@@ -580,7 +592,7 @@ back to the fully functional state and this is done in the following phases:
 
 	thaw_noirq, thaw, complete
 
-using the following PCI bus type's callbacks:
+using the following PCI bus type's callbacks::
 
 	pci_pm_thaw_noirq()
 	pci_pm_thaw()
@@ -608,7 +620,7 @@ three phases:
 
 where the prepare phase is exactly the same as for system suspend.  The other
 two phases are analogous to the suspend and suspend_noirq phases, respectively.
-The PCI subsystem-level callbacks they correspond to
+The PCI subsystem-level callbacks they correspond to::
 
 	pci_pm_poweroff()
 	pci_pm_poweroff_noirq()
@@ -618,6 +630,7 @@ although they don't attempt to save the device's standard configuration
 registers.
 
 2.4.4. System Restore
+^^^^^^^^^^^^^^^^^^^^^
 
 System restore requires a hibernation image to be loaded into memory and the
 pre-hibernation memory contents to be restored before the pre-hibernation system
@@ -653,7 +666,7 @@ phases:
 
 The first two of these are analogous to the resume_noirq and resume phases
 described above, respectively, and correspond to the following PCI subsystem
-callbacks:
+callbacks::
 
 	pci_pm_restore_noirq()
 	pci_pm_restore()
@@ -671,6 +684,7 @@ resume.
 
 3.1. Power Management Callbacks
 -------------------------------
+
 PCI device drivers participate in power management by providing callbacks to be
 executed by the PCI subsystem's power management routines described above and by
 controlling the runtime power management of their devices.
@@ -698,6 +712,7 @@ defined, though, they are expected to behave as described in the following
 subsections.
 
 3.1.1. prepare()
+^^^^^^^^^^^^^^^^
 
 The prepare() callback is executed during system suspend, during hibernation
 (when a hibernation image is about to be created), during power-off after
@@ -716,6 +731,7 @@ preallocated earlier, for example in a suspend/hibernate notifier as described
 in Documentation/driver-api/pm/notifiers.rst).
 
 3.1.2. suspend()
+^^^^^^^^^^^^^^^^
 
 The suspend() callback is only executed during system suspend, after prepare()
 callbacks have been executed for all devices in the system.
@@ -742,6 +758,7 @@ operations relying on the driver's ability to handle interrupts should be
 carried out in this callback.
 
 3.1.3. suspend_noirq()
+^^^^^^^^^^^^^^^^^^^^^^
 
 The suspend_noirq() callback is only executed during system suspend, after
 suspend() callbacks have been executed for all devices in the system and
@@ -753,6 +770,7 @@ suspend_noirq() can carry out operations that would cause race conditions to
 arise if they were performed in suspend().
 
 3.1.4. freeze()
+^^^^^^^^^^^^^^^
 
 The freeze() callback is hibernation-specific and is executed in two situations,
 during hibernation, after prepare() callbacks have been executed for all devices
@@ -770,6 +788,7 @@ or put it into a low-power state.  Still, either it or freeze_noirq() should
 save the device's standard configuration registers using pci_save_state().
 
 3.1.5. freeze_noirq()
+^^^^^^^^^^^^^^^^^^^^^
 
 The freeze_noirq() callback is hibernation-specific.  It is executed during
 hibernation, after prepare() and freeze() callbacks have been executed for all
@@ -786,6 +805,7 @@ The difference between freeze_noirq() and freeze() is analogous to the
 difference between suspend_noirq() and suspend().
 
 3.1.6. poweroff()
+^^^^^^^^^^^^^^^^^
 
 The poweroff() callback is hibernation-specific.  It is executed when the system
 is about to be powered off after saving a hibernation image to a persistent
@@ -802,6 +822,7 @@ into a low-power state, respectively, but it need not save the device's standard
 configuration registers.
 
 3.1.7. poweroff_noirq()
+^^^^^^^^^^^^^^^^^^^^^^^
 
 The poweroff_noirq() callback is hibernation-specific.  It is executed after
 poweroff() callbacks have been executed for all devices in the system.
@@ -814,6 +835,7 @@ The difference between poweroff_noirq() and poweroff() is analogous to the
 difference between suspend_noirq() and suspend().
 
 3.1.8. resume_noirq()
+^^^^^^^^^^^^^^^^^^^^^
 
 The resume_noirq() callback is only executed during system resume, after the
 PM core has enabled the non-boot CPUs.  The driver's interrupt handler will not
@@ -827,6 +849,7 @@ it should only be used for performing operations that would lead to race
 conditions if carried out by resume().
 
 3.1.9. resume()
+^^^^^^^^^^^^^^^
 
 The resume() callback is only executed during system resume, after
 resume_noirq() callbacks have been executed for all devices in the system and
@@ -837,6 +860,7 @@ device and bringing it back to the fully functional state.  The device should be
 able to process I/O in a usual way after resume() has returned.
 
 3.1.10. thaw_noirq()
+^^^^^^^^^^^^^^^^^^^^
 
 The thaw_noirq() callback is hibernation-specific.  It is executed after a
 system image has been created and the non-boot CPUs have been enabled by the PM
@@ -851,6 +875,7 @@ freeze() and freeze_noirq(), so in general it does not need to modify the
 contents of the device's registers.
 
 3.1.11. thaw()
+^^^^^^^^^^^^^^
 
 The thaw() callback is hibernation-specific.  It is executed after thaw_noirq()
 callbacks have been executed for all devices in the system and after device
@@ -860,6 +885,7 @@ This callback is responsible for restoring the pre-freeze configuration of
 the device, so that it will work in a usual way after thaw() has returned.
 
 3.1.12. restore_noirq()
+^^^^^^^^^^^^^^^^^^^^^^^
 
 The restore_noirq() callback is hibernation-specific.  It is executed in the
 restore_noirq phase of hibernation, when the boot kernel has passed control to
@@ -875,6 +901,7 @@ For the vast majority of PCI device drivers there is no difference between
 resume_noirq() and restore_noirq().
 
 3.1.13. restore()
+^^^^^^^^^^^^^^^^^
 
 The restore() callback is hibernation-specific.  It is executed after
 restore_noirq() callbacks have been executed for all devices in the system and
@@ -888,14 +915,17 @@ For the vast majority of PCI device drivers there is no difference between
 resume() and restore().
 
 3.1.14. complete()
+^^^^^^^^^^^^^^^^^^
 
 The complete() callback is executed in the following situations:
+
   - during system resume, after resume() callbacks have been executed for all
     devices,
   - during hibernation, before saving the system image, after thaw() callbacks
     have been executed for all devices,
   - during system restore, when the system is going back to its pre-hibernation
     state, after restore() callbacks have been executed for all devices.
+
 It also may be executed if the loading of a hibernation image into memory fails
 (in that case it is run after thaw() callbacks have been executed for all
 devices that have drivers in the boot kernel).
@@ -904,6 +934,7 @@ This callback is entirely optional, although it may be necessary if the
 prepare() callback performs operations that need to be reversed.
 
 3.1.15. runtime_suspend()
+^^^^^^^^^^^^^^^^^^^^^^^^^
 
 The runtime_suspend() callback is specific to device runtime power management
 (runtime PM).  It is executed by the PM core's runtime PM framework when the
@@ -915,6 +946,7 @@ put into a low-power state, but it must allow the PCI subsystem to perform all
 of the PCI-specific actions necessary for suspending the device.
 
 3.1.16. runtime_resume()
+^^^^^^^^^^^^^^^^^^^^^^^^
 
 The runtime_resume() callback is specific to device runtime PM.  It is executed
 by the PM core's runtime PM framework when the device is about to be resumed
@@ -927,6 +959,7 @@ The device is expected to be able to process I/O in the usual way after
 runtime_resume() has returned.
 
 3.1.17. runtime_idle()
+^^^^^^^^^^^^^^^^^^^^^^
 
 The runtime_idle() callback is specific to device runtime PM.  It is executed
 by the PM core's runtime PM framework whenever it may be desirable to suspend
@@ -939,6 +972,7 @@ PCI subsystem will call pm_runtime_suspend() for the device, which in turn will
 cause the driver's runtime_suspend() callback to be executed.
 
 3.1.18. Pointing Multiple Callback Pointers to One Routine
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 Although in principle each of the callbacks described in the previous
 subsections can be defined as a separate function, it often is convenient to
@@ -962,6 +996,7 @@ dev_pm_ops to indicate that one suspend routine is to be pointed to by the
 be pointed to by the .resume(), .thaw(), and .restore() members.
 
 3.1.19. Driver Flags for Power Management
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 The PM core allows device drivers to set flags that influence the handling of
 power management for the devices by the core itself and by middle layer code
@@ -1007,6 +1042,7 @@ it.
 
 3.2. Device Runtime Power Management
 ------------------------------------
+
 In addition to providing device power management callbacks PCI device drivers
 are responsible for controlling the runtime power management (runtime PM) of
 their devices.
@@ -1073,22 +1109,27 @@ device the PM core automatically queues a request to check if the device is
 idle), device drivers are generally responsible for queuing power management
 requests for their devices.  For this purpose they should use the runtime PM
 helper functions provided by the PM core, discussed in
-Documentation/power/runtime_pm.txt.
+Documentation/power/runtime_pm.rst.
 
 Devices can also be suspended and resumed synchronously, without placing a
 request into pm_wq.  In the majority of cases this also is done by their
 drivers that use helper functions provided by the PM core for this purpose.
 
 For more information on the runtime PM of devices refer to
-Documentation/power/runtime_pm.txt.
+Documentation/power/runtime_pm.rst.
 
 
 4. Resources
 ============
 
 PCI Local Bus Specification, Rev. 3.0
+
 PCI Bus Power Management Interface Specification, Rev. 1.2
+
 Advanced Configuration and Power Interface (ACPI) Specification, Rev. 3.0b
+
 PCI Express Base Specification, Rev. 2.0
+
 Documentation/driver-api/pm/devices.rst
-Documentation/power/runtime_pm.txt
+
+Documentation/power/runtime_pm.rst
diff --git a/Documentation/power/pm_qos_interface.txt b/Documentation/power/pm_qos_interface.rst
similarity index 62%
rename from Documentation/power/pm_qos_interface.txt
rename to Documentation/power/pm_qos_interface.rst
index 19c5f7b1a7ba..945fc6d760c9 100644
--- a/Documentation/power/pm_qos_interface.txt
+++ b/Documentation/power/pm_qos_interface.rst
@@ -1,4 +1,6 @@
-PM Quality Of Service Interface.
+===============================
+PM Quality Of Service Interface
+===============================
 
 This interface provides a kernel and user mode interface for registering
 performance expectations by drivers, subsystems and user space applications on
@@ -11,6 +13,7 @@ memory_bandwidth.
 constraints and PM QoS flags.
 
 Each parameters have defined units:
+
  * latency: usec
  * timeout: usec
  * throughput: kbs (kilo bit / sec)
@@ -18,6 +21,7 @@ Each parameters have defined units:
 
 
 1. PM QoS framework
+===================
 
 The infrastructure exposes multiple misc device nodes one per implemented
 parameter.  The set of parameters implement is defined by pm_qos_power_init()
@@ -37,38 +41,39 @@ reading the aggregated value does not require any locking mechanism.
 From kernel mode the use of this interface is simple:
 
 void pm_qos_add_request(handle, param_class, target_value):
-Will insert an element into the list for that identified PM QoS class with the
-target value.  Upon change to this list the new target is recomputed and any
-registered notifiers are called only if the target value is now different.
-Clients of pm_qos need to save the returned handle for future use in other
-pm_qos API functions.
+  Will insert an element into the list for that identified PM QoS class with the
+  target value.  Upon change to this list the new target is recomputed and any
+  registered notifiers are called only if the target value is now different.
+  Clients of pm_qos need to save the returned handle for future use in other
+  pm_qos API functions.
 
 void pm_qos_update_request(handle, new_target_value):
-Will update the list element pointed to by the handle with the new target value
-and recompute the new aggregated target, calling the notification tree if the
-target is changed.
+  Will update the list element pointed to by the handle with the new target value
+  and recompute the new aggregated target, calling the notification tree if the
+  target is changed.
 
 void pm_qos_remove_request(handle):
-Will remove the element.  After removal it will update the aggregate target and
-call the notification tree if the target was changed as a result of removing
-the request.
+  Will remove the element.  After removal it will update the aggregate target and
+  call the notification tree if the target was changed as a result of removing
+  the request.
 
 int pm_qos_request(param_class):
-Returns the aggregated value for a given PM QoS class.
+  Returns the aggregated value for a given PM QoS class.
 
 int pm_qos_request_active(handle):
-Returns if the request is still active, i.e. it has not been removed from a
-PM QoS class constraints list.
+  Returns if the request is still active, i.e. it has not been removed from a
+  PM QoS class constraints list.
 
 int pm_qos_add_notifier(param_class, notifier):
-Adds a notification callback function to the PM QoS class. The callback is
-called when the aggregated value for the PM QoS class is changed.
+  Adds a notification callback function to the PM QoS class. The callback is
+  called when the aggregated value for the PM QoS class is changed.
 
 int pm_qos_remove_notifier(int param_class, notifier):
-Removes the notification callback function for the PM QoS class.
+  Removes the notification callback function for the PM QoS class.
 
 
 From user mode:
+
 Only processes can register a pm_qos request.  To provide for automatic
 cleanup of a process, the interface requires the process to register its
 parameter requests in the following way:
@@ -89,6 +94,7 @@ node.
 
 
 2. PM QoS per-device latency and flags framework
+================================================
 
 For each device, there are three lists of PM QoS requests. Two of them are
 maintained along with the aggregated targets of resume latency and active
@@ -107,73 +113,80 @@ the aggregated value does not require any locking mechanism.
 From kernel mode the use of this interface is the following:
 
 int dev_pm_qos_add_request(device, handle, type, value):
-Will insert an element into the list for that identified device with the
-target value.  Upon change to this list the new target is recomputed and any
-registered notifiers are called only if the target value is now different.
-Clients of dev_pm_qos need to save the handle for future use in other
-dev_pm_qos API functions.
+  Will insert an element into the list for that identified device with the
+  target value.  Upon change to this list the new target is recomputed and any
+  registered notifiers are called only if the target value is now different.
+  Clients of dev_pm_qos need to save the handle for future use in other
+  dev_pm_qos API functions.
 
 int dev_pm_qos_update_request(handle, new_value):
-Will update the list element pointed to by the handle with the new target value
-and recompute the new aggregated target, calling the notification trees if the
-target is changed.
+  Will update the list element pointed to by the handle with the new target
+  value and recompute the new aggregated target, calling the notification
+  trees if the target is changed.
 
 int dev_pm_qos_remove_request(handle):
-Will remove the element.  After removal it will update the aggregate target and
-call the notification trees if the target was changed as a result of removing
-the request.
+  Will remove the element.  After removal it will update the aggregate target
+  and call the notification trees if the target was changed as a result of
+  removing the request.
 
 s32 dev_pm_qos_read_value(device):
-Returns the aggregated value for a given device's constraints list.
+  Returns the aggregated value for a given device's constraints list.
 
 enum pm_qos_flags_status dev_pm_qos_flags(device, mask)
-Check PM QoS flags of the given device against the given mask of flags.
-The meaning of the return values is as follows:
-	PM_QOS_FLAGS_ALL: All flags from the mask are set
-	PM_QOS_FLAGS_SOME: Some flags from the mask are set
-	PM_QOS_FLAGS_NONE: No flags from the mask are set
-	PM_QOS_FLAGS_UNDEFINED: The device's PM QoS structure has not been
-			initialized or the list of requests is empty.
+  Check PM QoS flags of the given device against the given mask of flags.
+  The meaning of the return values is as follows:
+
+	PM_QOS_FLAGS_ALL:
+		All flags from the mask are set
+	PM_QOS_FLAGS_SOME:
+		Some flags from the mask are set
+	PM_QOS_FLAGS_NONE:
+		No flags from the mask are set
+	PM_QOS_FLAGS_UNDEFINED:
+		The device's PM QoS structure has not been initialized
+		or the list of requests is empty.
 
 int dev_pm_qos_add_ancestor_request(dev, handle, type, value)
-Add a PM QoS request for the first direct ancestor of the given device whose
-power.ignore_children flag is unset (for DEV_PM_QOS_RESUME_LATENCY requests)
-or whose power.set_latency_tolerance callback pointer is not NULL (for
-DEV_PM_QOS_LATENCY_TOLERANCE requests).
+  Add a PM QoS request for the first direct ancestor of the given device whose
+  power.ignore_children flag is unset (for DEV_PM_QOS_RESUME_LATENCY requests)
+  or whose power.set_latency_tolerance callback pointer is not NULL (for
+  DEV_PM_QOS_LATENCY_TOLERANCE requests).
 
 int dev_pm_qos_expose_latency_limit(device, value)
-Add a request to the device's PM QoS list of resume latency constraints and
-create a sysfs attribute pm_qos_resume_latency_us under the device's power
-directory allowing user space to manipulate that request.
+  Add a request to the device's PM QoS list of resume latency constraints and
+  create a sysfs attribute pm_qos_resume_latency_us under the device's power
+  directory allowing user space to manipulate that request.
 
 void dev_pm_qos_hide_latency_limit(device)
-Drop the request added by dev_pm_qos_expose_latency_limit() from the device's
-PM QoS list of resume latency constraints and remove sysfs attribute
-pm_qos_resume_latency_us from the device's power directory.
+  Drop the request added by dev_pm_qos_expose_latency_limit() from the device's
+  PM QoS list of resume latency constraints and remove sysfs attribute
+  pm_qos_resume_latency_us from the device's power directory.
 
 int dev_pm_qos_expose_flags(device, value)
-Add a request to the device's PM QoS list of flags and create sysfs attribute
-pm_qos_no_power_off under the device's power directory allowing user space to
-change the value of the PM_QOS_FLAG_NO_POWER_OFF flag.
+  Add a request to the device's PM QoS list of flags and create sysfs attribute
+  pm_qos_no_power_off under the device's power directory allowing user space to
+  change the value of the PM_QOS_FLAG_NO_POWER_OFF flag.
 
 void dev_pm_qos_hide_flags(device)
-Drop the request added by dev_pm_qos_expose_flags() from the device's PM QoS list
-of flags and remove sysfs attribute pm_qos_no_power_off from the device's power
-directory.
+  Drop the request added by dev_pm_qos_expose_flags() from the device's PM QoS list
+  of flags and remove sysfs attribute pm_qos_no_power_off from the device's power
+  directory.
 
 Notification mechanisms:
+
 The per-device PM QoS framework has a per-device notification tree.
 
 int dev_pm_qos_add_notifier(device, notifier):
-Adds a notification callback function for the device.
-The callback is called when the aggregated value of the device constraints list
-is changed (for resume latency device PM QoS only).
+  Adds a notification callback function for the device.
+  The callback is called when the aggregated value of the device constraints list
+  is changed (for resume latency device PM QoS only).
 
 int dev_pm_qos_remove_notifier(device, notifier):
-Removes the notification callback function for the device.
+  Removes the notification callback function for the device.
 
 
 Active state latency tolerance
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 This device PM QoS type is used to support systems in which hardware may switch
 to energy-saving operation modes on the fly.  In those systems, if the operation
diff --git a/Documentation/power/power_supply_class.txt b/Documentation/power/power_supply_class.rst
similarity index 46%
rename from Documentation/power/power_supply_class.txt
rename to Documentation/power/power_supply_class.rst
index 300d37896e51..3f2c3fe38a61 100644
--- a/Documentation/power/power_supply_class.txt
+++ b/Documentation/power/power_supply_class.rst
@@ -1,3 +1,4 @@
+========================
 Linux power supply class
 ========================
 
@@ -56,112 +57,155 @@ Quoting include/linux/power_supply.h:
 Attributes/properties detailed
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-~ ~ ~ ~ ~ ~ ~  Charge/Energy/Capacity - how to not confuse  ~ ~ ~ ~ ~ ~ ~
-~                                                                       ~
-~ Because both "charge" (µAh) and "energy" (µWh) represents "capacity"  ~
-~ of battery, this class distinguish these terms. Don't mix them!       ~
-~                                                                       ~
-~ CHARGE_* attributes represents capacity in µAh only.                  ~
-~ ENERGY_* attributes represents capacity in µWh only.                  ~
-~ CAPACITY attribute represents capacity in *percents*, from 0 to 100.  ~
-~                                                                       ~
-~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
++--------------------------------------------------------------------------+
+|               **Charge/Energy/Capacity - how to not confuse**            |
++--------------------------------------------------------------------------+
+| **Because both "charge" (µAh) and "energy" (µWh) represents "capacity"   |
+| of battery, this class distinguish these terms. Don't mix them!**        |
+|                                                                          |
+| - `CHARGE_*`                                                             |
+|	attributes represents capacity in µAh only.                        |
+| - `ENERGY_*`                                                             |
+|	attributes represents capacity in µWh only.                        |
+| - `CAPACITY`                                                             |
+|	attribute represents capacity in *percents*, from 0 to 100.        |
++--------------------------------------------------------------------------+
 
 Postfixes:
-_AVG - *hardware* averaged value, use it if your hardware is really able to
-report averaged values.
-_NOW - momentary/instantaneous values.
 
-STATUS - this attribute represents operating status (charging, full,
-discharging (i.e. powering a load), etc.). This corresponds to
-BATTERY_STATUS_* values, as defined in battery.h.
-
-CHARGE_TYPE - batteries can typically charge at different rates.
-This defines trickle and fast charges.  For batteries that
-are already charged or discharging, 'n/a' can be displayed (or
-'unknown', if the status is not known).
-
-AUTHENTIC - indicates the power supply (battery or charger) connected
-to the platform is authentic(1) or non authentic(0).
-
-HEALTH - represents health of the battery, values corresponds to
-POWER_SUPPLY_HEALTH_*, defined in battery.h.
-
-VOLTAGE_OCV - open circuit voltage of the battery.
-
-VOLTAGE_MAX_DESIGN, VOLTAGE_MIN_DESIGN - design values for maximal and
-minimal power supply voltages. Maximal/minimal means values of voltages
-when battery considered "full"/"empty" at normal conditions. Yes, there is
-no direct relation between voltage and battery capacity, but some dumb
-batteries use voltage for very approximated calculation of capacity.
-Battery driver also can use this attribute just to inform userspace
-about maximal and minimal voltage thresholds of a given battery.
-
-VOLTAGE_MAX, VOLTAGE_MIN - same as _DESIGN voltage values except that
-these ones should be used if hardware could only guess (measure and
-retain) the thresholds of a given power supply.
-
-VOLTAGE_BOOT - Reports the voltage measured during boot
-
-CURRENT_BOOT - Reports the current measured during boot
-
-CHARGE_FULL_DESIGN, CHARGE_EMPTY_DESIGN - design charge values, when
-battery considered full/empty.
-
-ENERGY_FULL_DESIGN, ENERGY_EMPTY_DESIGN - same as above but for energy.
-
-CHARGE_FULL, CHARGE_EMPTY - These attributes means "last remembered value
-of charge when battery became full/empty". It also could mean "value of
-charge when battery considered full/empty at given conditions (temperature,
-age)". I.e. these attributes represents real thresholds, not design values.
-
-ENERGY_FULL, ENERGY_EMPTY - same as above but for energy.
-
-CHARGE_COUNTER - the current charge counter (in µAh).  This could easily
-be negative; there is no empty or full value.  It is only useful for
-relative, time-based measurements.
-
-PRECHARGE_CURRENT - the maximum charge current during precharge phase
-of charge cycle (typically 20% of battery capacity).
-CHARGE_TERM_CURRENT - Charge termination current. The charge cycle
-terminates when battery voltage is above recharge threshold, and charge
-current is below this setting (typically 10% of battery capacity).
-
-CONSTANT_CHARGE_CURRENT - constant charge current programmed by charger.
-CONSTANT_CHARGE_CURRENT_MAX - maximum charge current supported by the
-power supply object.
-
-CONSTANT_CHARGE_VOLTAGE - constant charge voltage programmed by charger.
-CONSTANT_CHARGE_VOLTAGE_MAX - maximum charge voltage supported by the
-power supply object.
-
-INPUT_CURRENT_LIMIT - input current limit programmed by charger. Indicates
-the current drawn from a charging source.
-
-CHARGE_CONTROL_LIMIT - current charge control limit setting
-CHARGE_CONTROL_LIMIT_MAX - maximum charge control limit setting
-
-CALIBRATE - battery or coulomb counter calibration status
-
-CAPACITY - capacity in percents.
-CAPACITY_ALERT_MIN - minimum capacity alert value in percents.
-CAPACITY_ALERT_MAX - maximum capacity alert value in percents.
-CAPACITY_LEVEL - capacity level. This corresponds to
-POWER_SUPPLY_CAPACITY_LEVEL_*.
-
-TEMP - temperature of the power supply.
-TEMP_ALERT_MIN - minimum battery temperature alert.
-TEMP_ALERT_MAX - maximum battery temperature alert.
-TEMP_AMBIENT - ambient temperature.
-TEMP_AMBIENT_ALERT_MIN - minimum ambient temperature alert.
-TEMP_AMBIENT_ALERT_MAX - maximum ambient temperature alert.
-TEMP_MIN - minimum operatable temperature
-TEMP_MAX - maximum operatable temperature
-
-TIME_TO_EMPTY - seconds left for battery to be considered empty (i.e.
-while battery powers a load)
-TIME_TO_FULL - seconds left for battery to be considered full (i.e.
-while battery is charging)
+_AVG
+  *hardware* averaged value, use it if your hardware is really able to
+  report averaged values.
+_NOW
+  momentary/instantaneous values.
+
+STATUS
+  this attribute represents operating status (charging, full,
+  discharging (i.e. powering a load), etc.). This corresponds to
+  `BATTERY_STATUS_*` values, as defined in battery.h.
+
+CHARGE_TYPE
+  batteries can typically charge at different rates.
+  This defines trickle and fast charges.  For batteries that
+  are already charged or discharging, 'n/a' can be displayed (or
+  'unknown', if the status is not known).
+
+AUTHENTIC
+  indicates the power supply (battery or charger) connected
+  to the platform is authentic(1) or non authentic(0).
+
+HEALTH
+  represents health of the battery, values corresponds to
+  POWER_SUPPLY_HEALTH_*, defined in battery.h.
+
+VOLTAGE_OCV
+  open circuit voltage of the battery.
+
+VOLTAGE_MAX_DESIGN, VOLTAGE_MIN_DESIGN
+  design values for maximal and minimal power supply voltages.
+  Maximal/minimal means values of voltages when battery considered
+  "full"/"empty" at normal conditions. Yes, there is no direct relation
+  between voltage and battery capacity, but some dumb
+  batteries use voltage for very approximated calculation of capacity.
+  Battery driver also can use this attribute just to inform userspace
+  about maximal and minimal voltage thresholds of a given battery.
+
+VOLTAGE_MAX, VOLTAGE_MIN
+  same as _DESIGN voltage values except that these ones should be used
+  if hardware could only guess (measure and retain) the thresholds of a
+  given power supply.
+
+VOLTAGE_BOOT
+  Reports the voltage measured during boot
+
+CURRENT_BOOT
+  Reports the current measured during boot
+
+CHARGE_FULL_DESIGN, CHARGE_EMPTY_DESIGN
+  design charge values, when battery considered full/empty.
+
+ENERGY_FULL_DESIGN, ENERGY_EMPTY_DESIGN
+  same as above but for energy.
+
+CHARGE_FULL, CHARGE_EMPTY
+  These attributes means "last remembered value of charge when battery
+  became full/empty". It also could mean "value of charge when battery
+  considered full/empty at given conditions (temperature, age)".
+  I.e. these attributes represents real thresholds, not design values.
+
+ENERGY_FULL, ENERGY_EMPTY
+  same as above but for energy.
+
+CHARGE_COUNTER
+  the current charge counter (in µAh).  This could easily
+  be negative; there is no empty or full value.  It is only useful for
+  relative, time-based measurements.
+
+PRECHARGE_CURRENT
+  the maximum charge current during precharge phase of charge cycle
+  (typically 20% of battery capacity).
+
+CHARGE_TERM_CURRENT
+  Charge termination current. The charge cycle terminates when battery
+  voltage is above recharge threshold, and charge current is below
+  this setting (typically 10% of battery capacity).
+
+CONSTANT_CHARGE_CURRENT
+  constant charge current programmed by charger.
+
+
+CONSTANT_CHARGE_CURRENT_MAX
+  maximum charge current supported by the power supply object.
+
+CONSTANT_CHARGE_VOLTAGE
+  constant charge voltage programmed by charger.
+CONSTANT_CHARGE_VOLTAGE_MAX
+  maximum charge voltage supported by the power supply object.
+
+INPUT_CURRENT_LIMIT
+  input current limit programmed by charger. Indicates
+  the current drawn from a charging source.
+
+CHARGE_CONTROL_LIMIT
+  current charge control limit setting
+CHARGE_CONTROL_LIMIT_MAX
+  maximum charge control limit setting
+
+CALIBRATE
+  battery or coulomb counter calibration status
+
+CAPACITY
+  capacity in percents.
+CAPACITY_ALERT_MIN
+  minimum capacity alert value in percents.
+CAPACITY_ALERT_MAX
+  maximum capacity alert value in percents.
+CAPACITY_LEVEL
+  capacity level. This corresponds to POWER_SUPPLY_CAPACITY_LEVEL_*.
+
+TEMP
+  temperature of the power supply.
+TEMP_ALERT_MIN
+  minimum battery temperature alert.
+TEMP_ALERT_MAX
+  maximum battery temperature alert.
+TEMP_AMBIENT
+  ambient temperature.
+TEMP_AMBIENT_ALERT_MIN
+  minimum ambient temperature alert.
+TEMP_AMBIENT_ALERT_MAX
+  maximum ambient temperature alert.
+TEMP_MIN
+  minimum operatable temperature
+TEMP_MAX
+  maximum operatable temperature
+
+TIME_TO_EMPTY
+  seconds left for battery to be considered empty
+  (i.e. while battery powers a load)
+TIME_TO_FULL
+  seconds left for battery to be considered full
+  (i.e. while battery is charging)
 
 
 Battery <-> external power supply interaction
@@ -193,8 +237,11 @@ for naming consistency between sysfs attributes and battery node properties.
 
 QA
 ~~
-Q: Where is POWER_SUPPLY_PROP_XYZ attribute?
-A: If you cannot find attribute suitable for your driver needs, feel free
+
+Q:
+   Where is POWER_SUPPLY_PROP_XYZ attribute?
+A:
+   If you cannot find attribute suitable for your driver needs, feel free
    to add it and send patch along with your driver.
 
    The attributes available currently are the ones currently provided by the
@@ -204,20 +251,24 @@ A: If you cannot find attribute suitable for your driver needs, feel free
    etc.
 
 
-Q: I have some very specific attribute (e.g. battery color), should I add
+Q:
+   I have some very specific attribute (e.g. battery color), should I add
    this attribute to standard ones?
-A: Most likely, no. Such attribute can be placed in the driver itself, if
+A:
+   Most likely, no. Such attribute can be placed in the driver itself, if
    it is useful. Of course, if the attribute in question applicable to
    large set of batteries, provided by many drivers, and/or comes from
    some general battery specification/standard, it may be a candidate to
    be added to the core attribute set.
 
 
-Q: Suppose, my battery monitoring chip/firmware does not provides capacity
+Q:
+   Suppose, my battery monitoring chip/firmware does not provides capacity
    in percents, but provides charge_{now,full,empty}. Should I calculate
    percentage capacity manually, inside the driver, and register CAPACITY
    attribute? The same question about time_to_empty/time_to_full.
-A: Most likely, no. This class is designed to export properties which are
+A:
+   Most likely, no. This class is designed to export properties which are
    directly measurable by the specific hardware available.
 
    Inferring not available properties using some heuristics or mathematical
diff --git a/Documentation/power/powercap/powercap.txt b/Documentation/power/powercap/powercap.rst
similarity index 40%
rename from Documentation/power/powercap/powercap.txt
rename to Documentation/power/powercap/powercap.rst
index 1e6ef164e07a..7ae3b44c7624 100644
--- a/Documentation/power/powercap/powercap.txt
+++ b/Documentation/power/powercap/powercap.rst
@@ -1,12 +1,14 @@
+=======================
 Power Capping Framework
-==================================
+=======================
 
 The power capping framework provides a consistent interface between the kernel
 and the user space that allows power capping drivers to expose the settings to
 user space in a uniform way.
 
 Terminology
-=========================
+===========
+
 The framework exposes power capping devices to user space via sysfs in the
 form of a tree of objects. The objects at the root level of the tree represent
 'control types', which correspond to different methods of power capping.  For
@@ -27,121 +29,121 @@ capping to a set of devices together using the parent power zone and if more
 fine grained control is required, it can be applied through the subzones.
 
 
-Example sysfs interface tree:
+Example sysfs interface tree::
 
-/sys/devices/virtual/powercap
-??? intel-rapl
-    ??? intel-rapl:0
-    ?   ??? constraint_0_name
-    ?   ??? constraint_0_power_limit_uw
-    ?   ??? constraint_0_time_window_us
-    ?   ??? constraint_1_name
-    ?   ??? constraint_1_power_limit_uw
-    ?   ??? constraint_1_time_window_us
-    ?   ??? device -> ../../intel-rapl
-    ?   ??? energy_uj
-    ?   ??? intel-rapl:0:0
-    ?   ?   ??? constraint_0_name
-    ?   ?   ??? constraint_0_power_limit_uw
-    ?   ?   ??? constraint_0_time_window_us
-    ?   ?   ??? constraint_1_name
-    ?   ?   ??? constraint_1_power_limit_uw
-    ?   ?   ??? constraint_1_time_window_us
-    ?   ?   ??? device -> ../../intel-rapl:0
-    ?   ?   ??? energy_uj
-    ?   ?   ??? max_energy_range_uj
-    ?   ?   ??? name
-    ?   ?   ??? enabled
-    ?   ?   ??? power
-    ?   ?   ?   ??? async
-    ?   ?   ?   []
-    ?   ?   ??? subsystem -> ../../../../../../class/power_cap
-    ?   ?   ??? uevent
-    ?   ??? intel-rapl:0:1
-    ?   ?   ??? constraint_0_name
-    ?   ?   ??? constraint_0_power_limit_uw
-    ?   ?   ??? constraint_0_time_window_us
-    ?   ?   ??? constraint_1_name
-    ?   ?   ??? constraint_1_power_limit_uw
-    ?   ?   ??? constraint_1_time_window_us
-    ?   ?   ??? device -> ../../intel-rapl:0
-    ?   ?   ??? energy_uj
-    ?   ?   ??? max_energy_range_uj
-    ?   ?   ??? name
-    ?   ?   ??? enabled
-    ?   ?   ??? power
-    ?   ?   ?   ??? async
-    ?   ?   ?   []
-    ?   ?   ??? subsystem -> ../../../../../../class/power_cap
-    ?   ?   ??? uevent
-    ?   ??? max_energy_range_uj
-    ?   ??? max_power_range_uw
-    ?   ??? name
-    ?   ??? enabled
-    ?   ??? power
-    ?   ?   ??? async
-    ?   ?   []
-    ?   ??? subsystem -> ../../../../../class/power_cap
-    ?   ??? enabled
-    ?   ??? uevent
-    ??? intel-rapl:1
-    ?   ??? constraint_0_name
-    ?   ??? constraint_0_power_limit_uw
-    ?   ??? constraint_0_time_window_us
-    ?   ??? constraint_1_name
-    ?   ??? constraint_1_power_limit_uw
-    ?   ??? constraint_1_time_window_us
-    ?   ??? device -> ../../intel-rapl
-    ?   ??? energy_uj
-    ?   ??? intel-rapl:1:0
-    ?   ?   ??? constraint_0_name
-    ?   ?   ??? constraint_0_power_limit_uw
-    ?   ?   ??? constraint_0_time_window_us
-    ?   ?   ??? constraint_1_name
-    ?   ?   ??? constraint_1_power_limit_uw
-    ?   ?   ??? constraint_1_time_window_us
-    ?   ?   ??? device -> ../../intel-rapl:1
-    ?   ?   ??? energy_uj
-    ?   ?   ??? max_energy_range_uj
-    ?   ?   ??? name
-    ?   ?   ??? enabled
-    ?   ?   ??? power
-    ?   ?   ?   ??? async
-    ?   ?   ?   []
-    ?   ?   ??? subsystem -> ../../../../../../class/power_cap
-    ?   ?   ??? uevent
-    ?   ??? intel-rapl:1:1
-    ?   ?   ??? constraint_0_name
-    ?   ?   ??? constraint_0_power_limit_uw
-    ?   ?   ??? constraint_0_time_window_us
-    ?   ?   ??? constraint_1_name
-    ?   ?   ??? constraint_1_power_limit_uw
-    ?   ?   ??? constraint_1_time_window_us
-    ?   ?   ??? device -> ../../intel-rapl:1
-    ?   ?   ??? energy_uj
-    ?   ?   ??? max_energy_range_uj
-    ?   ?   ??? name
-    ?   ?   ??? enabled
-    ?   ?   ??? power
-    ?   ?   ?   ??? async
-    ?   ?   ?   []
-    ?   ?   ??? subsystem -> ../../../../../../class/power_cap
-    ?   ?   ??? uevent
-    ?   ??? max_energy_range_uj
-    ?   ??? max_power_range_uw
-    ?   ??? name
-    ?   ??? enabled
-    ?   ??? power
-    ?   ?   ??? async
-    ?   ?   []
-    ?   ??? subsystem -> ../../../../../class/power_cap
-    ?   ??? uevent
-    ??? power
-    ?   ??? async
-    ?   []
-    ??? subsystem -> ../../../../class/power_cap
-    ??? enabled
-    ??? uevent
+  /sys/devices/virtual/powercap
+  └──intel-rapl
+      ├──intel-rapl:0
+      │   ├──constraint_0_name
+      │   ├──constraint_0_power_limit_uw
+      │   ├──constraint_0_time_window_us
+      │   ├──constraint_1_name
+      │   ├──constraint_1_power_limit_uw
+      │   ├──constraint_1_time_window_us
+      │   ├──device -> ../../intel-rapl
+      │   ├──energy_uj
+      │   ├──intel-rapl:0:0
+      │   │   ├──constraint_0_name
+      │   │   ├──constraint_0_power_limit_uw
+      │   │   ├──constraint_0_time_window_us
+      │   │   ├──constraint_1_name
+      │   │   ├──constraint_1_power_limit_uw
+      │   │   ├──constraint_1_time_window_us
+      │   │   ├──device -> ../../intel-rapl:0
+      │   │   ├──energy_uj
+      │   │   ├──max_energy_range_uj
+      │   │   ├──name
+      │   │   ├──enabled
+      │   │   ├──power
+      │   │   │   ├──async
+      │   │   │   []
+      │   │   ├──subsystem -> ../../../../../../class/power_cap
+      │   │   └──uevent
+      │   ├──intel-rapl:0:1
+      │   │   ├──constraint_0_name
+      │   │   ├──constraint_0_power_limit_uw
+      │   │   ├──constraint_0_time_window_us
+      │   │   ├──constraint_1_name
+      │   │   ├──constraint_1_power_limit_uw
+      │   │   ├──constraint_1_time_window_us
+      │   │   ├──device -> ../../intel-rapl:0
+      │   │   ├──energy_uj
+      │   │   ├──max_energy_range_uj
+      │   │   ├──name
+      │   │   ├──enabled
+      │   │   ├──power
+      │   │   │   ├──async
+      │   │   │   []
+      │   │   ├──subsystem -> ../../../../../../class/power_cap
+      │   │   └──uevent
+      │   ├──max_energy_range_uj
+      │   ├──max_power_range_uw
+      │   ├──name
+      │   ├──enabled
+      │   ├──power
+      │   │   ├──async
+      │   │   []
+      │   ├──subsystem -> ../../../../../class/power_cap
+      │   ├──enabled
+      │   ├──uevent
+      ├──intel-rapl:1
+      │   ├──constraint_0_name
+      │   ├──constraint_0_power_limit_uw
+      │   ├──constraint_0_time_window_us
+      │   ├──constraint_1_name
+      │   ├──constraint_1_power_limit_uw
+      │   ├──constraint_1_time_window_us
+      │   ├──device -> ../../intel-rapl
+      │   ├──energy_uj
+      │   ├──intel-rapl:1:0
+      │   │   ├──constraint_0_name
+      │   │   ├──constraint_0_power_limit_uw
+      │   │   ├──constraint_0_time_window_us
+      │   │   ├──constraint_1_name
+      │   │   ├──constraint_1_power_limit_uw
+      │   │   ├──constraint_1_time_window_us
+      │   │   ├──device -> ../../intel-rapl:1
+      │   │   ├──energy_uj
+      │   │   ├──max_energy_range_uj
+      │   │   ├──name
+      │   │   ├──enabled
+      │   │   ├──power
+      │   │   │   ├──async
+      │   │   │   []
+      │   │   ├──subsystem -> ../../../../../../class/power_cap
+      │   │   └──uevent
+      │   ├──intel-rapl:1:1
+      │   │   ├──constraint_0_name
+      │   │   ├──constraint_0_power_limit_uw
+      │   │   ├──constraint_0_time_window_us
+      │   │   ├──constraint_1_name
+      │   │   ├──constraint_1_power_limit_uw
+      │   │   ├──constraint_1_time_window_us
+      │   │   ├──device -> ../../intel-rapl:1
+      │   │   ├──energy_uj
+      │   │   ├──max_energy_range_uj
+      │   │   ├──name
+      │   │   ├──enabled
+      │   │   ├──power
+      │   │   │   ├──async
+      │   │   │   []
+      │   │   ├──subsystem -> ../../../../../../class/power_cap
+      │   │   └──uevent
+      │   ├──max_energy_range_uj
+      │   ├──max_power_range_uw
+      │   ├──name
+      │   ├──enabled
+      │   ├──power
+      │   │   ├──async
+      │   │   []
+      │   ├──subsystem -> ../../../../../class/power_cap
+      │   ├──uevent
+      ├──power
+      │   ├──async
+      │   []
+      ├──subsystem -> ../../../../class/power_cap
+      ├──enabled
+      └──uevent
 
 The above example illustrates a case in which the Intel RAPL technology,
 available in Intel® IA-64 and IA-32 Processor Architectures, is used. There is one
@@ -158,10 +160,12 @@ power value, there is no power_uw attribute.
 
 In addition to that, each power zone contains a name attribute, allowing the
 part of the system represented by that zone to be identified.
-For example:
+For example::
+
+	cat /sys/class/power_cap/intel-rapl/intel-rapl:0/name
 
-cat /sys/class/power_cap/intel-rapl/intel-rapl:0/name
 package-0
+---------
 
 The Intel RAPL technology allows two constraints, short term and long term,
 with two different time windows to be applied to each power zone.  Thus for
@@ -169,7 +173,8 @@ each zone there are 2 attributes representing the constraint names, 2 power
 limits and 2 attributes representing the sizes of the time windows. Such that,
 constraint_j_* attributes correspond to the jth constraint (j = 0,1).
 
-For example:
+For example::
+
 	constraint_0_name
 	constraint_0_power_limit_uw
 	constraint_0_time_window_us
@@ -178,50 +183,66 @@ For example:
 	constraint_1_time_window_us
 
 Power Zone Attributes
-=================================
+=====================
+
 Monitoring attributes
-----------------------
+---------------------
 
-energy_uj (rw): Current energy counter in micro joules. Write "0" to reset.
-If the counter can not be reset, then this attribute is read only.
+energy_uj (rw)
+	Current energy counter in micro joules. Write "0" to reset.
+	If the counter can not be reset, then this attribute is read only.
 
-max_energy_range_uj (ro): Range of the above energy counter in micro-joules.
+max_energy_range_uj (ro)
+	Range of the above energy counter in micro-joules.
 
-power_uw (ro): Current power in micro watts.
+power_uw (ro)
+	Current power in micro watts.
 
-max_power_range_uw (ro): Range of the above power value in micro-watts.
+max_power_range_uw (ro)
+	Range of the above power value in micro-watts.
 
-name (ro): Name of this power zone.
+name (ro)
+	Name of this power zone.
 
 It is possible that some domains have both power ranges and energy counter ranges;
 however, only one is mandatory.
 
 Constraints
-----------------
-constraint_X_power_limit_uw (rw): Power limit in micro watts, which should be
-applicable for the time window specified by "constraint_X_time_window_us".
+-----------
 
-constraint_X_time_window_us (rw): Time window in micro seconds.
+constraint_X_power_limit_uw (rw)
+	Power limit in micro watts, which should be applicable for the
+	time window specified by "constraint_X_time_window_us".
 
-constraint_X_name (ro): An optional name of the constraint
+constraint_X_time_window_us (rw)
+	Time window in micro seconds.
 
-constraint_X_max_power_uw(ro): Maximum allowed power in micro watts.
+constraint_X_name (ro)
+	An optional name of the constraint
 
-constraint_X_min_power_uw(ro): Minimum allowed power in micro watts.
+constraint_X_max_power_uw(ro)
+	Maximum allowed power in micro watts.
 
-constraint_X_max_time_window_us(ro): Maximum allowed time window in micro seconds.
+constraint_X_min_power_uw(ro)
+	Minimum allowed power in micro watts.
 
-constraint_X_min_time_window_us(ro): Minimum allowed time window in micro seconds.
+constraint_X_max_time_window_us(ro)
+	Maximum allowed time window in micro seconds.
+
+constraint_X_min_time_window_us(ro)
+	Minimum allowed time window in micro seconds.
 
 Except power_limit_uw and time_window_us other fields are optional.
 
 Common zone and control type attributes
-----------------------------------------
+---------------------------------------
+
 enabled (rw): Enable/Disable controls at zone level or for all zones using
 a control type.
 
 Power Cap Client Driver Interface
-==================================
+=================================
+
 The API summary:
 
 Call powercap_register_control_type() to register control type object.
diff --git a/Documentation/power/regulator/consumer.txt b/Documentation/power/regulator/consumer.rst
similarity index 61%
rename from Documentation/power/regulator/consumer.txt
rename to Documentation/power/regulator/consumer.rst
index e51564c1a140..0cd8cc1275a7 100644
--- a/Documentation/power/regulator/consumer.txt
+++ b/Documentation/power/regulator/consumer.rst
@@ -1,3 +1,4 @@
+===================================
 Regulator Consumer Driver Interface
 ===================================
 
@@ -8,73 +9,77 @@ Please see overview.txt for a description of the terms used in this text.
 1. Consumer Regulator Access (static & dynamic drivers)
 =======================================================
 
-A consumer driver can get access to its supply regulator by calling :-
+A consumer driver can get access to its supply regulator by calling ::
 
-regulator = regulator_get(dev, "Vcc");
+	regulator = regulator_get(dev, "Vcc");
 
 The consumer passes in its struct device pointer and power supply ID. The core
 then finds the correct regulator by consulting a machine specific lookup table.
 If the lookup is successful then this call will return a pointer to the struct
 regulator that supplies this consumer.
 
-To release the regulator the consumer driver should call :-
+To release the regulator the consumer driver should call ::
 
-regulator_put(regulator);
+	regulator_put(regulator);
 
 Consumers can be supplied by more than one regulator e.g. codec consumer with
-analog and digital supplies :-
+analog and digital supplies ::
 
-digital = regulator_get(dev, "Vcc");  /* digital core */
-analog = regulator_get(dev, "Avdd");  /* analog */
+	digital = regulator_get(dev, "Vcc");  /* digital core */
+	analog = regulator_get(dev, "Avdd");  /* analog */
 
 The regulator access functions regulator_get() and regulator_put() will
 usually be called in your device drivers probe() and remove() respectively.
 
 
 2. Regulator Output Enable & Disable (static & dynamic drivers)
-====================================================================
+===============================================================
 
-A consumer can enable its power supply by calling:-
 
-int regulator_enable(regulator);
+A consumer can enable its power supply by calling::
 
-NOTE: The supply may already be enabled before regulator_enabled() is called.
-This may happen if the consumer shares the regulator or the regulator has been
-previously enabled by bootloader or kernel board initialization code.
+	int regulator_enable(regulator);
 
-A consumer can determine if a regulator is enabled by calling :-
+NOTE:
+  The supply may already be enabled before regulator_enabled() is called.
+  This may happen if the consumer shares the regulator or the regulator has been
+  previously enabled by bootloader or kernel board initialization code.
 
-int regulator_is_enabled(regulator);
+A consumer can determine if a regulator is enabled by calling::
+
+	int regulator_is_enabled(regulator);
 
 This will return > zero when the regulator is enabled.
 
 
-A consumer can disable its supply when no longer needed by calling :-
+A consumer can disable its supply when no longer needed by calling::
 
-int regulator_disable(regulator);
+	int regulator_disable(regulator);
 
-NOTE: This may not disable the supply if it's shared with other consumers. The
-regulator will only be disabled when the enabled reference count is zero.
+NOTE:
+  This may not disable the supply if it's shared with other consumers. The
+  regulator will only be disabled when the enabled reference count is zero.
 
-Finally, a regulator can be forcefully disabled in the case of an emergency :-
+Finally, a regulator can be forcefully disabled in the case of an emergency::
 
-int regulator_force_disable(regulator);
+	int regulator_force_disable(regulator);
 
-NOTE: this will immediately and forcefully shutdown the regulator output. All
-consumers will be powered off.
+NOTE:
+  this will immediately and forcefully shutdown the regulator output. All
+  consumers will be powered off.
 
 
 3. Regulator Voltage Control & Status (dynamic drivers)
-======================================================
+=======================================================
 
 Some consumer drivers need to be able to dynamically change their supply
 voltage to match system operating points. e.g. CPUfreq drivers can scale
 voltage along with frequency to save power, SD drivers may need to select the
 correct card voltage, etc.
 
-Consumers can control their supply voltage by calling :-
+Consumers can control their supply voltage by calling::
 
-int regulator_set_voltage(regulator, min_uV, max_uV);
+	int regulator_set_voltage(regulator, min_uV, max_uV);
 
 Where min_uV and max_uV are the minimum and maximum acceptable voltages in
 microvolts.
@@ -84,47 +89,50 @@ when enabled, then the voltage changes instantly, otherwise the voltage
 configuration changes and the voltage is physically set when the regulator is
 next enabled.
 
-The regulators configured voltage output can be found by calling :-
+The regulators configured voltage output can be found by calling::
 
-int regulator_get_voltage(regulator);
+	int regulator_get_voltage(regulator);
 
-NOTE: get_voltage() will return the configured output voltage whether the
-regulator is enabled or disabled and should NOT be used to determine regulator
-output state. However this can be used in conjunction with is_enabled() to
-determine the regulator physical output voltage.
+NOTE:
+  get_voltage() will return the configured output voltage whether the
+  regulator is enabled or disabled and should NOT be used to determine regulator
+  output state. However this can be used in conjunction with is_enabled() to
+  determine the regulator physical output voltage.
 
 
 4. Regulator Current Limit Control & Status (dynamic drivers)
-===========================================================
+=============================================================
 
 Some consumer drivers need to be able to dynamically change their supply
 current limit to match system operating points. e.g. LCD backlight driver can
 change the current limit to vary the backlight brightness, USB drivers may want
 to set the limit to 500mA when supplying power.
 
-Consumers can control their supply current limit by calling :-
+Consumers can control their supply current limit by calling::
 
-int regulator_set_current_limit(regulator, min_uA, max_uA);
+	int regulator_set_current_limit(regulator, min_uA, max_uA);
 
 Where min_uA and max_uA are the minimum and maximum acceptable current limit in
 microamps.
 
-NOTE: this can be called when the regulator is enabled or disabled. If called
-when enabled, then the current limit changes instantly, otherwise the current
-limit configuration changes and the current limit is physically set when the
-regulator is next enabled.
+NOTE:
+  this can be called when the regulator is enabled or disabled. If called
+  when enabled, then the current limit changes instantly, otherwise the current
+  limit configuration changes and the current limit is physically set when the
+  regulator is next enabled.
 
-A regulators current limit can be found by calling :-
+A regulators current limit can be found by calling::
 
-int regulator_get_current_limit(regulator);
+	int regulator_get_current_limit(regulator);
 
-NOTE: get_current_limit() will return the current limit whether the regulator
-is enabled or disabled and should not be used to determine regulator current
-load.
+NOTE:
+  get_current_limit() will return the current limit whether the regulator
+  is enabled or disabled and should not be used to determine regulator current
+  load.
 
 
 5. Regulator Operating Mode Control & Status (dynamic drivers)
-=============================================================
+==============================================================
 
 Some consumers can further save system power by changing the operating mode of
 their supply regulator to be more efficient when the consumers operating state
@@ -135,9 +143,9 @@ Regulator operating mode can be changed indirectly or directly.
 Indirect operating mode control.
 --------------------------------
 Consumer drivers can request a change in their supply regulator operating mode
-by calling :-
+by calling::
 
-int regulator_set_load(struct regulator *regulator, int load_uA);
+	int regulator_set_load(struct regulator *regulator, int load_uA);
 
 This will cause the core to recalculate the total load on the regulator (based
 on all its consumers) and change operating mode (if necessary and permitted)
@@ -153,12 +161,13 @@ consumers.
 
 Direct operating mode control.
 ------------------------------
+
 Bespoke or tightly coupled drivers may want to directly control regulator
 operating mode depending on their operating point. This can be achieved by
-calling :-
+calling::
 
-int regulator_set_mode(struct regulator *regulator, unsigned int mode);
-unsigned int regulator_get_mode(struct regulator *regulator);
+	int regulator_set_mode(struct regulator *regulator, unsigned int mode);
+	unsigned int regulator_get_mode(struct regulator *regulator);
 
 Direct mode will only be used by consumers that *know* about the regulator and
 are not sharing the regulator with other consumers.
@@ -166,24 +175,26 @@ are not sharing the regulator with other consumers.
 
 6. Regulator Events
 ===================
+
 Regulators can notify consumers of external events. Events could be received by
 consumers under regulator stress or failure conditions.
 
-Consumers can register interest in regulator events by calling :-
+Consumers can register interest in regulator events by calling::
 
-int regulator_register_notifier(struct regulator *regulator,
-			      struct notifier_block *nb);
+	int regulator_register_notifier(struct regulator *regulator,
+					struct notifier_block *nb);
 
-Consumers can unregister interest by calling :-
+Consumers can unregister interest by calling::
 
-int regulator_unregister_notifier(struct regulator *regulator,
-				struct notifier_block *nb);
+	int regulator_unregister_notifier(struct regulator *regulator,
+					  struct notifier_block *nb);
 
 Regulators use the kernel notifier framework to send event to their interested
 consumers.
 
 7. Regulator Direct Register Access
 ===================================
+
 Some kinds of power management hardware or firmware are designed such that
 they need to do low-level hardware access to regulators, with no involvement
 from the kernel. Examples of such devices are:
@@ -199,20 +210,20 @@ to it. The regulator framework provides the following helpers for querying
 these details.
 
 Bus-specific details, like I2C addresses or transfer rates are handled by the
-regmap framework. To get the regulator's regmap (if supported), use :-
+regmap framework. To get the regulator's regmap (if supported), use::
 
-struct regmap *regulator_get_regmap(struct regulator *regulator);
+	struct regmap *regulator_get_regmap(struct regulator *regulator);
 
 To obtain the hardware register offset and bitmask for the regulator's voltage
-selector register, use :-
+selector register, use::
 
-int regulator_get_hardware_vsel_register(struct regulator *regulator,
-					 unsigned *vsel_reg,
-					 unsigned *vsel_mask);
+	int regulator_get_hardware_vsel_register(struct regulator *regulator,
+						 unsigned *vsel_reg,
+						 unsigned *vsel_mask);
 
 To convert a regulator framework voltage selector code (used by
 regulator_list_voltage) to a hardware-specific voltage selector that can be
-directly written to the voltage selector register, use :-
+directly written to the voltage selector register, use::
 
-int regulator_list_hardware_vsel(struct regulator *regulator,
-				 unsigned selector);
+	int regulator_list_hardware_vsel(struct regulator *regulator,
+					 unsigned selector);
diff --git a/Documentation/power/regulator/design.txt b/Documentation/power/regulator/design.rst
similarity index 86%
rename from Documentation/power/regulator/design.txt
rename to Documentation/power/regulator/design.rst
index fdd919b96830..3b09c6841dc4 100644
--- a/Documentation/power/regulator/design.txt
+++ b/Documentation/power/regulator/design.rst
@@ -1,3 +1,4 @@
+==========================
 Regulator API design notes
 ==========================
 
@@ -14,7 +15,9 @@ Safety
    have different power requirements, and not all components with power
    requirements are visible to software.
 
-  => The API should make no changes to the hardware state unless it has
+.. note::
+
+     The API should make no changes to the hardware state unless it has
      specific knowledge that these changes are safe to perform on this
      particular system.
 
@@ -28,6 +31,8 @@ Consumer use cases
  - Many of the power supplies in the system will be shared between many
    different consumers.
 
-  => The consumer API should be structured so that these use cases are
+.. note::
+
+     The consumer API should be structured so that these use cases are
      very easy to handle and so that consumers will work with shared
      supplies without any additional effort.
diff --git a/Documentation/power/regulator/machine.txt b/Documentation/power/regulator/machine.rst
similarity index 75%
rename from Documentation/power/regulator/machine.txt
rename to Documentation/power/regulator/machine.rst
index eff4dcaaa252..22fffefaa3ad 100644
--- a/Documentation/power/regulator/machine.txt
+++ b/Documentation/power/regulator/machine.rst
@@ -1,10 +1,11 @@
+==================================
 Regulator Machine Driver Interface
-===================================
+==================================
 
 The regulator machine driver interface is intended for board/machine specific
 initialisation code to configure the regulator subsystem.
 
-Consider the following machine :-
+Consider the following machine::
 
   Regulator-1 -+-> Regulator-2 --> [Consumer A @ 1.8 - 2.0V]
                |
@@ -13,31 +14,31 @@ Consider the following machine :-
 The drivers for consumers A & B must be mapped to the correct regulator in
 order to control their power supplies. This mapping can be achieved in machine
 initialisation code by creating a struct regulator_consumer_supply for
-each regulator.
+each regulator::
 
-struct regulator_consumer_supply {
+  struct regulator_consumer_supply {
 	const char *dev_name;	/* consumer dev_name() */
 	const char *supply;	/* consumer supply - e.g. "vcc" */
-};
+  };
 
-e.g. for the machine above
+e.g. for the machine above::
 
-static struct regulator_consumer_supply regulator1_consumers[] = {
+  static struct regulator_consumer_supply regulator1_consumers[] = {
 	REGULATOR_SUPPLY("Vcc", "consumer B"),
-};
+  };
 
-static struct regulator_consumer_supply regulator2_consumers[] = {
+  static struct regulator_consumer_supply regulator2_consumers[] = {
 	REGULATOR_SUPPLY("Vcc", "consumer A"),
-};
+  };
 
 This maps Regulator-1 to the 'Vcc' supply for Consumer B and maps Regulator-2
 to the 'Vcc' supply for Consumer A.
 
 Constraints can now be registered by defining a struct regulator_init_data
 for each regulator power domain. This structure also maps the consumers
-to their supply regulators :-
+to their supply regulators::
 
-static struct regulator_init_data regulator1_data = {
+  static struct regulator_init_data regulator1_data = {
 	.constraints = {
 		.name = "Regulator-1",
 		.min_uV = 3300000,
@@ -46,7 +47,7 @@ static struct regulator_init_data regulator1_data = {
 	},
 	.num_consumer_supplies = ARRAY_SIZE(regulator1_consumers),
 	.consumer_supplies = regulator1_consumers,
-};
+  };
 
 The name field should be set to something that is usefully descriptive
 for the board for configuration of supplies for other regulators and
@@ -57,9 +58,9 @@ name is provided then the subsystem will choose one.
 Regulator-1 supplies power to Regulator-2. This relationship must be registered
 with the core so that Regulator-1 is also enabled when Consumer A enables its
 supply (Regulator-2). The supply regulator is set by the supply_regulator
-field below and co:-
+field below and co::
 
-static struct regulator_init_data regulator2_data = {
+  static struct regulator_init_data regulator2_data = {
 	.supply_regulator = "Regulator-1",
 	.constraints = {
 		.min_uV = 1800000,
@@ -69,11 +70,11 @@ static struct regulator_init_data regulator2_data = {
 	},
 	.num_consumer_supplies = ARRAY_SIZE(regulator2_consumers),
 	.consumer_supplies = regulator2_consumers,
-};
+  };
 
-Finally the regulator devices must be registered in the usual manner.
+Finally the regulator devices must be registered in the usual manner::
 
-static struct platform_device regulator_devices[] = {
+  static struct platform_device regulator_devices[] = {
 	{
 		.name = "regulator",
 		.id = DCDC_1,
@@ -88,9 +89,9 @@ static struct platform_device regulator_devices[] = {
 			.platform_data = &regulator2_data,
 		},
 	},
-};
-/* register regulator 1 device */
-platform_device_register(&regulator_devices[0]);
+  };
+  /* register regulator 1 device */
+  platform_device_register(&regulator_devices[0]);
 
-/* register regulator 2 device */
-platform_device_register(&regulator_devices[1]);
+  /* register regulator 2 device */
+  platform_device_register(&regulator_devices[1]);
diff --git a/Documentation/power/regulator/overview.txt b/Documentation/power/regulator/overview.rst
similarity index 79%
rename from Documentation/power/regulator/overview.txt
rename to Documentation/power/regulator/overview.rst
index 721b4739ec32..ee494c70a7c4 100644
--- a/Documentation/power/regulator/overview.txt
+++ b/Documentation/power/regulator/overview.rst
@@ -1,3 +1,4 @@
+=============================================
 Linux voltage and current regulator framework
 =============================================
 
@@ -13,26 +14,30 @@ regulators (where voltage output is controllable) and current sinks (where
 current limit is controllable).
 
 (C) 2008  Wolfson Microelectronics PLC.
+
 Author: Liam Girdwood <lrg@slimlogic.co.uk>
 
 
 Nomenclature
 ============
 
-Some terms used in this document:-
+Some terms used in this document:
 
-  o Regulator    - Electronic device that supplies power to other devices.
+  - Regulator
+                 - Electronic device that supplies power to other devices.
                    Most regulators can enable and disable their output while
                    some can control their output voltage and or current.
 
                    Input Voltage -> Regulator -> Output Voltage
 
 
-  o PMIC         - Power Management IC. An IC that contains numerous regulators
-                   and often contains other subsystems.
+  - PMIC
+                 - Power Management IC. An IC that contains numerous
+                   regulators and often contains other subsystems.
 
 
-  o Consumer     - Electronic device that is supplied power by a regulator.
+  - Consumer
+                 - Electronic device that is supplied power by a regulator.
                    Consumers can be classified into two types:-
 
                    Static: consumer does not change its supply voltage or
@@ -44,46 +49,48 @@ Some terms used in this document:-
                    current limit to meet operation demands.
 
 
-  o Power Domain - Electronic circuit that is supplied its input power by the
+  - Power Domain
+                 - Electronic circuit that is supplied its input power by the
                    output power of a regulator, switch or by another power
                    domain.
 
-                   The supply regulator may be behind a switch(s). i.e.
+                   The supply regulator may be behind a switch(s). i.e.::
 
-                   Regulator -+-> Switch-1 -+-> Switch-2 --> [Consumer A]
-                              |             |
-                              |             +-> [Consumer B], [Consumer C]
-                              |
-                              +-> [Consumer D], [Consumer E]
+                     Regulator -+-> Switch-1 -+-> Switch-2 --> [Consumer A]
+                                |             |
+                                |             +-> [Consumer B], [Consumer C]
+                                |
+                                +-> [Consumer D], [Consumer E]
 
                    That is one regulator and three power domains:
 
-                   Domain 1: Switch-1, Consumers D & E.
-                   Domain 2: Switch-2, Consumers B & C.
-                   Domain 3: Consumer A.
+                   - Domain 1: Switch-1, Consumers D & E.
+                   - Domain 2: Switch-2, Consumers B & C.
+                   - Domain 3: Consumer A.
 
                    and this represents a "supplies" relationship:
 
                    Domain-1 --> Domain-2 --> Domain-3.
 
                    A power domain may have regulators that are supplied power
-                   by other regulators. i.e.
+                   by other regulators. i.e.::
 
-                   Regulator-1 -+-> Regulator-2 -+-> [Consumer A]
-                                |
-                                +-> [Consumer B]
+                     Regulator-1 -+-> Regulator-2 -+-> [Consumer A]
+                                  |
+                                  +-> [Consumer B]
 
                    This gives us two regulators and two power domains:
 
-                   Domain 1: Regulator-2, Consumer B.
-                   Domain 2: Consumer A.
+                   - Domain 1: Regulator-2, Consumer B.
+                   - Domain 2: Consumer A.
 
                    and a "supplies" relationship:
 
                    Domain-1 --> Domain-2
 
 
-  o Constraints  - Constraints are used to define power levels for performance
+  - Constraints
+                 - Constraints are used to define power levels for performance
                    and hardware protection. Constraints exist at three levels:
 
                    Regulator Level: This is defined by the regulator hardware
@@ -141,7 +148,7 @@ relevant to non SoC devices and is split into the following four interfaces:-
       limit. This also compiles out if not in use so drivers can be reused in
       systems with no regulator based power control.
 
-        See Documentation/power/regulator/consumer.txt
+        See Documentation/power/regulator/consumer.rst
 
    2. Regulator driver interface.
 
@@ -149,7 +156,7 @@ relevant to non SoC devices and is split into the following four interfaces:-
       operations to the core. It also has a notifier call chain for propagating
       regulator events to clients.
 
-        See Documentation/power/regulator/regulator.txt
+        See Documentation/power/regulator/regulator.rst
 
    3. Machine interface.
 
@@ -160,7 +167,7 @@ relevant to non SoC devices and is split into the following four interfaces:-
       allows the creation of a regulator tree whereby some regulators are
       supplied by others (similar to a clock tree).
 
-        See Documentation/power/regulator/machine.txt
+        See Documentation/power/regulator/machine.rst
 
    4. Userspace ABI.
 
diff --git a/Documentation/power/regulator/regulator.txt b/Documentation/power/regulator/regulator.rst
similarity index 49%
rename from Documentation/power/regulator/regulator.txt
rename to Documentation/power/regulator/regulator.rst
index b17e5833ce21..794b3256fbb9 100644
--- a/Documentation/power/regulator/regulator.txt
+++ b/Documentation/power/regulator/regulator.rst
@@ -1,3 +1,4 @@
+==========================
 Regulator Driver Interface
 ==========================
 
@@ -8,23 +9,24 @@ regulator drivers to register their services with the core framework.
 Registration
 ============
 
-Drivers can register a regulator by calling :-
+Drivers can register a regulator by calling::
 
-struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
-					 const struct regulator_config *config);
+  struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
+					   const struct regulator_config *config);
 
 This will register the regulator's capabilities and operations to the regulator
 core.
 
-Regulators can be unregistered by calling :-
+Regulators can be unregistered by calling::
 
-void regulator_unregister(struct regulator_dev *rdev);
+  void regulator_unregister(struct regulator_dev *rdev);
 
 
 Regulator Events
 ================
+
 Regulators can send events (e.g. overtemperature, undervoltage, etc) to
-consumer drivers by calling :-
+consumer drivers by calling::
 
-int regulator_notifier_call_chain(struct regulator_dev *rdev,
-				  unsigned long event, void *data);
+  int regulator_notifier_call_chain(struct regulator_dev *rdev,
+				    unsigned long event, void *data);
diff --git a/Documentation/power/runtime_pm.txt b/Documentation/power/runtime_pm.rst
similarity index 89%
rename from Documentation/power/runtime_pm.txt
rename to Documentation/power/runtime_pm.rst
index 937e33c46211..2c2ec99b5088 100644
--- a/Documentation/power/runtime_pm.txt
+++ b/Documentation/power/runtime_pm.rst
@@ -1,10 +1,15 @@
+==================================================
 Runtime Power Management Framework for I/O Devices
+==================================================
 
 (C) 2009-2011 Rafael J. Wysocki <rjw@sisk.pl>, Novell Inc.
+
 (C) 2010 Alan Stern <stern@rowland.harvard.edu>
+
 (C) 2014 Intel Corp., Rafael J. Wysocki <rafael.j.wysocki@intel.com>
 
 1. Introduction
+===============
 
 Support for runtime power management (runtime PM) of I/O devices is provided
 at the power management core (PM core) level by means of:
@@ -33,16 +38,17 @@ fields of 'struct dev_pm_info' and the core helper functions provided for
 runtime PM are described below.
 
 2. Device Runtime PM Callbacks
+==============================
 
-There are three device runtime PM callbacks defined in 'struct dev_pm_ops':
+There are three device runtime PM callbacks defined in 'struct dev_pm_ops'::
 
-struct dev_pm_ops {
+  struct dev_pm_ops {
 	...
 	int (*runtime_suspend)(struct device *dev);
 	int (*runtime_resume)(struct device *dev);
 	int (*runtime_idle)(struct device *dev);
 	...
-};
+  };
 
 The ->runtime_suspend(), ->runtime_resume() and ->runtime_idle() callbacks
 are executed by the PM core for the device's subsystem that may be either of
@@ -112,7 +118,7 @@ low-power state during the execution of the suspend callback, it is expected
 that remote wakeup will be enabled for the device.  Generally, remote wakeup
 should be enabled for all input devices put into low-power states at run time.
 
-The subsystem-level resume callback, if present, is _entirely_ _responsible_ for
+The subsystem-level resume callback, if present, is **entirely responsible** for
 handling the resume of the device as appropriate, which may, but need not
 include executing the device driver's own ->runtime_resume() callback (from the
 PM core's point of view it is not necessary to implement a ->runtime_resume()
@@ -197,95 +203,96 @@ rules:
     except for scheduled autosuspends.
 
 3. Runtime PM Device Fields
+===========================
 
 The following device runtime PM fields are present in 'struct dev_pm_info', as
 defined in include/linux/pm.h:
 
-  struct timer_list suspend_timer;
+  `struct timer_list suspend_timer;`
     - timer used for scheduling (delayed) suspend and autosuspend requests
 
-  unsigned long timer_expires;
+  `unsigned long timer_expires;`
     - timer expiration time, in jiffies (if this is different from zero, the
       timer is running and will expire at that time, otherwise the timer is not
       running)
 
-  struct work_struct work;
+  `struct work_struct work;`
     - work structure used for queuing up requests (i.e. work items in pm_wq)
 
-  wait_queue_head_t wait_queue;
+  `wait_queue_head_t wait_queue;`
     - wait queue used if any of the helper functions needs to wait for another
       one to complete
 
-  spinlock_t lock;
+  `spinlock_t lock;`
     - lock used for synchronization
 
-  atomic_t usage_count;
+  `atomic_t usage_count;`
     - the usage counter of the device
 
-  atomic_t child_count;
+  `atomic_t child_count;`
     - the count of 'active' children of the device
 
-  unsigned int ignore_children;
+  `unsigned int ignore_children;`
     - if set, the value of child_count is ignored (but still updated)
 
-  unsigned int disable_depth;
+  `unsigned int disable_depth;`
     - used for disabling the helper functions (they work normally if this is
       equal to zero); the initial value of it is 1 (i.e. runtime PM is
       initially disabled for all devices)
 
-  int runtime_error;
+  `int runtime_error;`
     - if set, there was a fatal error (one of the callbacks returned error code
       as described in Section 2), so the helper functions will not work until
       this flag is cleared; this is the error code returned by the failing
       callback
 
-  unsigned int idle_notification;
+  `unsigned int idle_notification;`
     - if set, ->runtime_idle() is being executed
 
-  unsigned int request_pending;
+  `unsigned int request_pending;`
     - if set, there's a pending request (i.e. a work item queued up into pm_wq)
 
-  enum rpm_request request;
+  `enum rpm_request request;`
     - type of request that's pending (valid if request_pending is set)
 
-  unsigned int deferred_resume;
+  `unsigned int deferred_resume;`
     - set if ->runtime_resume() is about to be run while ->runtime_suspend() is
       being executed for that device and it is not practical to wait for the
       suspend to complete; means "start a resume as soon as you've suspended"
 
-  enum rpm_status runtime_status;
+  `enum rpm_status runtime_status;`
     - the runtime PM status of the device; this field's initial value is
       RPM_SUSPENDED, which means that each device is initially regarded by the
       PM core as 'suspended', regardless of its real hardware status
 
-  unsigned int runtime_auto;
+  `unsigned int runtime_auto;`
     - if set, indicates that the user space has allowed the device driver to
       power manage the device at run time via the /sys/devices/.../power/control
-      interface; it may only be modified with the help of the pm_runtime_allow()
+      `interface;` it may only be modified with the help of the pm_runtime_allow()
       and pm_runtime_forbid() helper functions
 
-  unsigned int no_callbacks;
+  `unsigned int no_callbacks;`
     - indicates that the device does not use the runtime PM callbacks (see
       Section 8); it may be modified only by the pm_runtime_no_callbacks()
       helper function
 
-  unsigned int irq_safe;
+  `unsigned int irq_safe;`
     - indicates that the ->runtime_suspend() and ->runtime_resume() callbacks
       will be invoked with the spinlock held and interrupts disabled
 
-  unsigned int use_autosuspend;
+  `unsigned int use_autosuspend;`
     - indicates that the device's driver supports delayed autosuspend (see
       Section 9); it may be modified only by the
       pm_runtime{_dont}_use_autosuspend() helper functions
 
-  unsigned int timer_autosuspends;
+  `unsigned int timer_autosuspends;`
     - indicates that the PM core should attempt to carry out an autosuspend
       when the timer expires rather than a normal suspend
 
-  int autosuspend_delay;
+  `int autosuspend_delay;`
     - the delay time (in milliseconds) to be used for autosuspend
 
-  unsigned long last_busy;
+  `unsigned long last_busy;`
     - the time (in jiffies) when the pm_runtime_mark_last_busy() helper
       function was last called for this device; used in calculating inactivity
       periods for autosuspend
@@ -293,37 +300,38 @@ defined in include/linux/pm.h:
 All of the above fields are members of the 'power' member of 'struct device'.
 
 4. Runtime PM Device Helper Functions
+=====================================
 
 The following runtime PM helper functions are defined in
 drivers/base/power/runtime.c and include/linux/pm_runtime.h:
 
-  void pm_runtime_init(struct device *dev);
+  `void pm_runtime_init(struct device *dev);`
     - initialize the device runtime PM fields in 'struct dev_pm_info'
 
-  void pm_runtime_remove(struct device *dev);
+  `void pm_runtime_remove(struct device *dev);`
     - make sure that the runtime PM of the device will be disabled after
       removing the device from device hierarchy
 
-  int pm_runtime_idle(struct device *dev);
+  `int pm_runtime_idle(struct device *dev);`
     - execute the subsystem-level idle callback for the device; returns an
       error code on failure, where -EINPROGRESS means that ->runtime_idle() is
       already being executed; if there is no callback or the callback returns 0
       then run pm_runtime_autosuspend(dev) and return its result
 
-  int pm_runtime_suspend(struct device *dev);
+  `int pm_runtime_suspend(struct device *dev);`
     - execute the subsystem-level suspend callback for the device; returns 0 on
       success, 1 if the device's runtime PM status was already 'suspended', or
       error code on failure, where -EAGAIN or -EBUSY means it is safe to attempt
       to suspend the device again in future and -EACCES means that
       'power.disable_depth' is different from 0
 
-  int pm_runtime_autosuspend(struct device *dev);
+  `int pm_runtime_autosuspend(struct device *dev);`
     - same as pm_runtime_suspend() except that the autosuspend delay is taken
-      into account; if pm_runtime_autosuspend_expiration() says the delay has
+      `into account;` if pm_runtime_autosuspend_expiration() says the delay has
       not yet expired then an autosuspend is scheduled for the appropriate time
       and 0 is returned
 
-  int pm_runtime_resume(struct device *dev);
+  `int pm_runtime_resume(struct device *dev);`
     - execute the subsystem-level resume callback for the device; returns 0 on
       success, 1 if the device's runtime PM status was already 'active' or
       error code on failure, where -EAGAIN means it may be safe to attempt to
@@ -331,17 +339,17 @@ drivers/base/power/runtime.c and include/linux/pm_runtime.h:
       checked additionally, and -EACCES means that 'power.disable_depth' is
       different from 0
 
-  int pm_request_idle(struct device *dev);
+  `int pm_request_idle(struct device *dev);`
     - submit a request to execute the subsystem-level idle callback for the
       device (the request is represented by a work item in pm_wq); returns 0 on
       success or error code if the request has not been queued up
 
-  int pm_request_autosuspend(struct device *dev);
+  `int pm_request_autosuspend(struct device *dev);`
     - schedule the execution of the subsystem-level suspend callback for the
       device when the autosuspend delay has expired; if the delay has already
       expired then the work item is queued up immediately
 
-  int pm_schedule_suspend(struct device *dev, unsigned int delay);
+  `int pm_schedule_suspend(struct device *dev, unsigned int delay);`
     - schedule the execution of the subsystem-level suspend callback for the
       device in future, where 'delay' is the time to wait before queuing up a
       suspend work item in pm_wq, in milliseconds (if 'delay' is zero, the work
@@ -351,58 +359,58 @@ drivers/base/power/runtime.c and include/linux/pm_runtime.h:
       ->runtime_suspend() is already scheduled and not yet expired, the new
       value of 'delay' will be used as the time to wait
 
-  int pm_request_resume(struct device *dev);
+  `int pm_request_resume(struct device *dev);`
     - submit a request to execute the subsystem-level resume callback for the
       device (the request is represented by a work item in pm_wq); returns 0 on
       success, 1 if the device's runtime PM status was already 'active', or
       error code if the request hasn't been queued up
 
-  void pm_runtime_get_noresume(struct device *dev);
+  `void pm_runtime_get_noresume(struct device *dev);`
     - increment the device's usage counter
 
-  int pm_runtime_get(struct device *dev);
+  `int pm_runtime_get(struct device *dev);`
     - increment the device's usage counter, run pm_request_resume(dev) and
       return its result
 
-  int pm_runtime_get_sync(struct device *dev);
+  `int pm_runtime_get_sync(struct device *dev);`
     - increment the device's usage counter, run pm_runtime_resume(dev) and
       return its result
 
-  int pm_runtime_get_if_in_use(struct device *dev);
+  `int pm_runtime_get_if_in_use(struct device *dev);`
     - return -EINVAL if 'power.disable_depth' is nonzero; otherwise, if the
       runtime PM status is RPM_ACTIVE and the runtime PM usage counter is
       nonzero, increment the counter and return 1; otherwise return 0 without
       changing the counter
 
-  void pm_runtime_put_noidle(struct device *dev);
+  `void pm_runtime_put_noidle(struct device *dev);`
     - decrement the device's usage counter
 
-  int pm_runtime_put(struct device *dev);
+  `int pm_runtime_put(struct device *dev);`
     - decrement the device's usage counter; if the result is 0 then run
       pm_request_idle(dev) and return its result
 
-  int pm_runtime_put_autosuspend(struct device *dev);
+  `int pm_runtime_put_autosuspend(struct device *dev);`
     - decrement the device's usage counter; if the result is 0 then run
       pm_request_autosuspend(dev) and return its result
 
-  int pm_runtime_put_sync(struct device *dev);
+  `int pm_runtime_put_sync(struct device *dev);`
     - decrement the device's usage counter; if the result is 0 then run
       pm_runtime_idle(dev) and return its result
 
-  int pm_runtime_put_sync_suspend(struct device *dev);
+  `int pm_runtime_put_sync_suspend(struct device *dev);`
     - decrement the device's usage counter; if the result is 0 then run
       pm_runtime_suspend(dev) and return its result
 
-  int pm_runtime_put_sync_autosuspend(struct device *dev);
+  `int pm_runtime_put_sync_autosuspend(struct device *dev);`
     - decrement the device's usage counter; if the result is 0 then run
       pm_runtime_autosuspend(dev) and return its result
 
-  void pm_runtime_enable(struct device *dev);
+  `void pm_runtime_enable(struct device *dev);`
     - decrement the device's 'power.disable_depth' field; if that field is equal
       to zero, the runtime PM helper functions can execute subsystem-level
       callbacks described in Section 2 for the device
 
-  int pm_runtime_disable(struct device *dev);
+  `int pm_runtime_disable(struct device *dev);`
     - increment the device's 'power.disable_depth' field (if the value of that
       field was previously zero, this prevents subsystem-level runtime PM
       callbacks from being run for the device), make sure that all of the
@@ -411,7 +419,7 @@ drivers/base/power/runtime.c and include/linux/pm_runtime.h:
       necessary to execute the subsystem-level resume callback for the device
       to satisfy that request, otherwise 0 is returned
 
-  int pm_runtime_barrier(struct device *dev);
+  `int pm_runtime_barrier(struct device *dev);`
     - check if there's a resume request pending for the device and resume it
       (synchronously) in that case, cancel any other pending runtime PM requests
       regarding it and wait for all runtime PM operations on it in progress to
@@ -419,10 +427,10 @@ drivers/base/power/runtime.c and include/linux/pm_runtime.h:
       necessary to execute the subsystem-level resume callback for the device to
       satisfy that request, otherwise 0 is returned
 
-  void pm_suspend_ignore_children(struct device *dev, bool enable);
+  `void pm_suspend_ignore_children(struct device *dev, bool enable);`
     - set/unset the power.ignore_children flag of the device
 
-  int pm_runtime_set_active(struct device *dev);
+  `int pm_runtime_set_active(struct device *dev);`
     - clear the device's 'power.runtime_error' flag, set the device's runtime
       PM status to 'active' and update its parent's counter of 'active'
       children as appropriate (it is only valid to use this function if
@@ -430,61 +438,61 @@ drivers/base/power/runtime.c and include/linux/pm_runtime.h:
       zero); it will fail and return error code if the device has a parent
       which is not active and the 'power.ignore_children' flag of which is unset
 
-  void pm_runtime_set_suspended(struct device *dev);
+  `void pm_runtime_set_suspended(struct device *dev);`
     - clear the device's 'power.runtime_error' flag, set the device's runtime
       PM status to 'suspended' and update its parent's counter of 'active'
       children as appropriate (it is only valid to use this function if
       'power.runtime_error' is set or 'power.disable_depth' is greater than
       zero)
 
-  bool pm_runtime_active(struct device *dev);
+  `bool pm_runtime_active(struct device *dev);`
     - return true if the device's runtime PM status is 'active' or its
       'power.disable_depth' field is not equal to zero, or false otherwise
 
-  bool pm_runtime_suspended(struct device *dev);
+  `bool pm_runtime_suspended(struct device *dev);`
     - return true if the device's runtime PM status is 'suspended' and its
       'power.disable_depth' field is equal to zero, or false otherwise
 
-  bool pm_runtime_status_suspended(struct device *dev);
+  `bool pm_runtime_status_suspended(struct device *dev);`
     - return true if the device's runtime PM status is 'suspended'
 
-  void pm_runtime_allow(struct device *dev);
+  `void pm_runtime_allow(struct device *dev);`
     - set the power.runtime_auto flag for the device and decrease its usage
       counter (used by the /sys/devices/.../power/control interface to
       effectively allow the device to be power managed at run time)
 
-  void pm_runtime_forbid(struct device *dev);
+  `void pm_runtime_forbid(struct device *dev);`
     - unset the power.runtime_auto flag for the device and increase its usage
       counter (used by the /sys/devices/.../power/control interface to
       effectively prevent the device from being power managed at run time)
 
-  void pm_runtime_no_callbacks(struct device *dev);
+  `void pm_runtime_no_callbacks(struct device *dev);`
     - set the power.no_callbacks flag for the device and remove the runtime
       PM attributes from /sys/devices/.../power (or prevent them from being
       added when the device is registered)
 
-  void pm_runtime_irq_safe(struct device *dev);
+  `void pm_runtime_irq_safe(struct device *dev);`
     - set the power.irq_safe flag for the device, causing the runtime-PM
       callbacks to be invoked with interrupts off
 
-  bool pm_runtime_is_irq_safe(struct device *dev);
+  `bool pm_runtime_is_irq_safe(struct device *dev);`
     - return true if power.irq_safe flag was set for the device, causing
       the runtime-PM callbacks to be invoked with interrupts off
 
-  void pm_runtime_mark_last_busy(struct device *dev);
+  `void pm_runtime_mark_last_busy(struct device *dev);`
     - set the power.last_busy field to the current time
 
-  void pm_runtime_use_autosuspend(struct device *dev);
+  `void pm_runtime_use_autosuspend(struct device *dev);`
     - set the power.use_autosuspend flag, enabling autosuspend delays; call
       pm_runtime_get_sync if the flag was previously cleared and
       power.autosuspend_delay is negative
 
-  void pm_runtime_dont_use_autosuspend(struct device *dev);
+  `void pm_runtime_dont_use_autosuspend(struct device *dev);`
     - clear the power.use_autosuspend flag, disabling autosuspend delays;
       decrement the device's usage counter if the flag was previously set and
       power.autosuspend_delay is negative; call pm_runtime_idle
 
-  void pm_runtime_set_autosuspend_delay(struct device *dev, int delay);
+  `void pm_runtime_set_autosuspend_delay(struct device *dev, int delay);`
     - set the power.autosuspend_delay value to 'delay' (expressed in
       milliseconds); if 'delay' is negative then runtime suspends are
       prevented; if power.use_autosuspend is set, pm_runtime_get_sync may be
@@ -493,7 +501,7 @@ drivers/base/power/runtime.c and include/linux/pm_runtime.h:
       changed to or from a negative value; if power.use_autosuspend is clear,
       pm_runtime_idle is called
 
-  unsigned long pm_runtime_autosuspend_expiration(struct device *dev);
+  `unsigned long pm_runtime_autosuspend_expiration(struct device *dev);`
     - calculate the time when the current autosuspend delay period will expire,
       based on power.last_busy and power.autosuspend_delay; if the delay time
       is 1000 ms or larger then the expiration time is rounded up to the
@@ -503,36 +511,37 @@ drivers/base/power/runtime.c and include/linux/pm_runtime.h:
 
 It is safe to execute the following helper functions from interrupt context:
 
-pm_request_idle()
-pm_request_autosuspend()
-pm_schedule_suspend()
-pm_request_resume()
-pm_runtime_get_noresume()
-pm_runtime_get()
-pm_runtime_put_noidle()
-pm_runtime_put()
-pm_runtime_put_autosuspend()
-pm_runtime_enable()
-pm_suspend_ignore_children()
-pm_runtime_set_active()
-pm_runtime_set_suspended()
-pm_runtime_suspended()
-pm_runtime_mark_last_busy()
-pm_runtime_autosuspend_expiration()
+- pm_request_idle()
+- pm_request_autosuspend()
+- pm_schedule_suspend()
+- pm_request_resume()
+- pm_runtime_get_noresume()
+- pm_runtime_get()
+- pm_runtime_put_noidle()
+- pm_runtime_put()
+- pm_runtime_put_autosuspend()
+- pm_runtime_enable()
+- pm_suspend_ignore_children()
+- pm_runtime_set_active()
+- pm_runtime_set_suspended()
+- pm_runtime_suspended()
+- pm_runtime_mark_last_busy()
+- pm_runtime_autosuspend_expiration()
 
 If pm_runtime_irq_safe() has been called for a device then the following helper
 functions may also be used in interrupt context:
 
-pm_runtime_idle()
-pm_runtime_suspend()
-pm_runtime_autosuspend()
-pm_runtime_resume()
-pm_runtime_get_sync()
-pm_runtime_put_sync()
-pm_runtime_put_sync_suspend()
-pm_runtime_put_sync_autosuspend()
+- pm_runtime_idle()
+- pm_runtime_suspend()
+- pm_runtime_autosuspend()
+- pm_runtime_resume()
+- pm_runtime_get_sync()
+- pm_runtime_put_sync()
+- pm_runtime_put_sync_suspend()
+- pm_runtime_put_sync_autosuspend()
 
 5. Runtime PM Initialization, Device Probing and Removal
+========================================================
 
 Initially, the runtime PM is disabled for all devices, which means that the
 majority of the runtime PM helper functions described in Section 4 will return
@@ -608,6 +617,7 @@ manage the device at run time, the driver may confuse it by using
 pm_runtime_forbid() this way.
 
 6. Runtime PM and System Sleep
+==============================
 
 Runtime PM and system sleep (i.e., system suspend and hibernation, also known
 as suspend-to-RAM and suspend-to-disk) interact with each other in a couple of
@@ -647,9 +657,9 @@ brought back to full power during resume, then its runtime PM status will have
 to be updated to reflect the actual post-system sleep status.  The way to do
 this is:
 
-	pm_runtime_disable(dev);
-	pm_runtime_set_active(dev);
-	pm_runtime_enable(dev);
+	 - pm_runtime_disable(dev);
+	 - pm_runtime_set_active(dev);
+	 - pm_runtime_enable(dev);
 
 The PM core always increments the runtime usage counter before calling the
 ->suspend() callback and decrements it after calling the ->resume() callback.
@@ -705,66 +715,66 @@ Subsystems may wish to conserve code space by using the set of generic power
 management callbacks provided by the PM core, defined in
 driver/base/power/generic_ops.c:
 
-  int pm_generic_runtime_suspend(struct device *dev);
+  `int pm_generic_runtime_suspend(struct device *dev);`
     - invoke the ->runtime_suspend() callback provided by the driver of this
       device and return its result, or return 0 if not defined
 
-  int pm_generic_runtime_resume(struct device *dev);
+  `int pm_generic_runtime_resume(struct device *dev);`
     - invoke the ->runtime_resume() callback provided by the driver of this
       device and return its result, or return 0 if not defined
 
-  int pm_generic_suspend(struct device *dev);
+  `int pm_generic_suspend(struct device *dev);`
     - if the device has not been suspended at run time, invoke the ->suspend()
       callback provided by its driver and return its result, or return 0 if not
       defined
 
-  int pm_generic_suspend_noirq(struct device *dev);
+  `int pm_generic_suspend_noirq(struct device *dev);`
     - if pm_runtime_suspended(dev) returns "false", invoke the ->suspend_noirq()
       callback provided by the device's driver and return its result, or return
       0 if not defined
 
-  int pm_generic_resume(struct device *dev);
+  `int pm_generic_resume(struct device *dev);`
     - invoke the ->resume() callback provided by the driver of this device and,
       if successful, change the device's runtime PM status to 'active'
 
-  int pm_generic_resume_noirq(struct device *dev);
+  `int pm_generic_resume_noirq(struct device *dev);`
     - invoke the ->resume_noirq() callback provided by the driver of this device
 
-  int pm_generic_freeze(struct device *dev);
+  `int pm_generic_freeze(struct device *dev);`
     - if the device has not been suspended at run time, invoke the ->freeze()
       callback provided by its driver and return its result, or return 0 if not
       defined
 
-  int pm_generic_freeze_noirq(struct device *dev);
+  `int pm_generic_freeze_noirq(struct device *dev);`
     - if pm_runtime_suspended(dev) returns "false", invoke the ->freeze_noirq()
       callback provided by the device's driver and return its result, or return
       0 if not defined
 
-  int pm_generic_thaw(struct device *dev);
+  `int pm_generic_thaw(struct device *dev);`
     - if the device has not been suspended at run time, invoke the ->thaw()
       callback provided by its driver and return its result, or return 0 if not
       defined
 
-  int pm_generic_thaw_noirq(struct device *dev);
+  `int pm_generic_thaw_noirq(struct device *dev);`
     - if pm_runtime_suspended(dev) returns "false", invoke the ->thaw_noirq()
       callback provided by the device's driver and return its result, or return
       0 if not defined
 
-  int pm_generic_poweroff(struct device *dev);
+  `int pm_generic_poweroff(struct device *dev);`
     - if the device has not been suspended at run time, invoke the ->poweroff()
       callback provided by its driver and return its result, or return 0 if not
       defined
 
-  int pm_generic_poweroff_noirq(struct device *dev);
+  `int pm_generic_poweroff_noirq(struct device *dev);`
     - if pm_runtime_suspended(dev) returns "false", run the ->poweroff_noirq()
       callback provided by the device's driver and return its result, or return
       0 if not defined
 
-  int pm_generic_restore(struct device *dev);
+  `int pm_generic_restore(struct device *dev);`
     - invoke the ->restore() callback provided by the driver of this device and,
       if successful, change the device's runtime PM status to 'active'
 
-  int pm_generic_restore_noirq(struct device *dev);
+  `int pm_generic_restore_noirq(struct device *dev);`
     - invoke the ->restore_noirq() callback provided by the device's driver
 
 These functions are the defaults used by the PM core, if a subsystem doesn't
@@ -781,6 +791,7 @@ UNIVERSAL_DEV_PM_OPS macro defined in include/linux/pm.h (possibly setting its
 last argument to NULL).
 
 8. "No-Callback" Devices
+========================
 
 Some "devices" are only logical sub-devices of their parent and cannot be
 power-managed on their own.  (The prototype example is a USB interface.  Entire
@@ -807,6 +818,7 @@ parent must take responsibility for telling the device's driver when the
 parent's power state changes.
 
 9. Autosuspend, or automatically-delayed suspends
+=================================================
 
 Changing a device's power state isn't free; it requires both time and energy.
 A device should be put in a low-power state only when there's some reason to
@@ -832,8 +844,8 @@ registration the length should be controlled by user space, using the
 
 In order to use autosuspend, subsystems or drivers must call
 pm_runtime_use_autosuspend() (preferably before registering the device), and
-thereafter they should use the various *_autosuspend() helper functions instead
-of the non-autosuspend counterparts:
+thereafter they should use the various `*_autosuspend()` helper functions
+instead of the non-autosuspend counterparts::
 
 	Instead of: pm_runtime_suspend    use: pm_runtime_autosuspend;
 	Instead of: pm_schedule_suspend   use: pm_request_autosuspend;
@@ -858,7 +870,7 @@ The implementation is well suited for asynchronous use in interrupt contexts.
 However such use inevitably involves races, because the PM core can't
 synchronize ->runtime_suspend() callbacks with the arrival of I/O requests.
 This synchronization must be handled by the driver, using its private lock.
-Here is a schematic pseudo-code example:
+Here is a schematic pseudo-code example::
 
 	foo_read_or_write(struct foo_priv *foo, void *data)
 	{
diff --git a/Documentation/power/s2ram.txt b/Documentation/power/s2ram.rst
similarity index 92%
rename from Documentation/power/s2ram.txt
rename to Documentation/power/s2ram.rst
index 4685aee197fd..d739aa7c742c 100644
--- a/Documentation/power/s2ram.txt
+++ b/Documentation/power/s2ram.rst
@@ -1,7 +1,9 @@
-			How to get s2ram working
-			~~~~~~~~~~~~~~~~~~~~~~~~
-			2006 Linus Torvalds
-			2006 Pavel Machek
+========================
+How to get s2ram working
+========================
+
+2006 Linus Torvalds
+2006 Pavel Machek
 
 1) Check suspend.sf.net, program s2ram there has long whitelist of
    "known ok" machines, along with tricks to use on each one.
@@ -12,8 +14,8 @@
 
 3) You can use Linus' TRACE_RESUME infrastructure, described below.
 
-		      Using TRACE_RESUME
-		      ~~~~~~~~~~~~~~~~~~
+Using TRACE_RESUME
+~~~~~~~~~~~~~~~~~~
 
 I've been working at making the machines I have able to STR, and almost
 always it's a driver that is buggy. Thank God for the suspend/resume
@@ -27,7 +29,7 @@ machine that doesn't boot) is:
 
  - enable PM_DEBUG, and PM_TRACE
 
- - use a script like this:
+ - use a script like this::
 
 	#!/bin/sh
 	sync
@@ -38,7 +40,7 @@ machine that doesn't boot) is:
 
  - if it doesn't come back up (which is usually the problem), reboot by
    holding the power button down, and look at the dmesg output for things
-   like
+   like::
 
 	Magic number: 4:156:725
 	hash matches drivers/base/power/resume.c:28
@@ -52,7 +54,7 @@ machine that doesn't boot) is:
    If no device matches the hash (or any matches appear to be false positives),
    the culprit may be a device from a loadable kernel module that is not loaded
    until after the hash is checked. You can check the hash against the current
-   devices again after more modules are loaded using sysfs:
+   devices again after more modules are loaded using sysfs::
 
 	cat /sys/power/pm_trace_dev_match
 
diff --git a/Documentation/power/suspend-and-cpuhotplug.txt b/Documentation/power/suspend-and-cpuhotplug.rst
similarity index 90%
rename from Documentation/power/suspend-and-cpuhotplug.txt
rename to Documentation/power/suspend-and-cpuhotplug.rst
index a8751b8df10e..9df664f5423a 100644
--- a/Documentation/power/suspend-and-cpuhotplug.txt
+++ b/Documentation/power/suspend-and-cpuhotplug.rst
@@ -1,10 +1,15 @@
+====================================================================
 Interaction of Suspend code (S3) with the CPU hotplug infrastructure
+====================================================================
 
-     (C) 2011 - 2014 Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
+(C) 2011 - 2014 Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
 
 
-I. How does the regular CPU hotplug code differ from how the Suspend-to-RAM
-   infrastructure uses it internally? And where do they share common code?
+I. Differences between CPU hotplug and Suspend-to-RAM
+======================================================
+
+How does the regular CPU hotplug code differ from how the Suspend-to-RAM
+infrastructure uses it internally? And where do they share common code?
 
 Well, a picture is worth a thousand words... So ASCII art follows :-)
 
@@ -16,13 +21,13 @@ of describing where they take different paths and where they share code.
 What happens when regular CPU hotplug and Suspend-to-RAM race with each other
 is not depicted here.]
 
-On a high level, the suspend-resume cycle goes like this:
+On a high level, the suspend-resume cycle goes like this::
 
-|Freeze| -> |Disable nonboot| -> |Do suspend| -> |Enable nonboot| -> |Thaw |
-|tasks |    |     cpus      |    |          |    |     cpus     |    |tasks|
+  |Freeze| -> |Disable nonboot| -> |Do suspend| -> |Enable nonboot| -> |Thaw |
+  |tasks |    |     cpus      |    |          |    |     cpus     |    |tasks|
 
 
-More details follow:
+More details follow::
 
                                 Suspend call path
                                 -----------------
@@ -87,7 +92,9 @@ More details follow:
 
 Resuming back is likewise, with the counterparts being (in the order of
 execution during resume):
-* enable_nonboot_cpus() which involves:
+
+* enable_nonboot_cpus() which involves::
+
    |  Acquire cpu_add_remove_lock
    |  Decrease cpu_hotplug_disabled, thereby enabling regular cpu hotplug
    |  Call _cpu_up() [for all those cpus in the frozen_cpus mask, in a loop]
@@ -101,7 +108,7 @@ execution during resume):
 
 It is to be noted here that the system_transition_mutex lock is acquired at the very
 beginning, when we are just starting out to suspend, and then released only
-after the entire cycle is complete (i.e., suspend + resume).
+after the entire cycle is complete (i.e., suspend + resume)::
 
 
 
@@ -152,16 +159,16 @@ with the 'tasks_frozen' argument set to 1.
 
 
 Important files and functions/entry points:
-------------------------------------------
+-------------------------------------------
 
-kernel/power/process.c : freeze_processes(), thaw_processes()
-kernel/power/suspend.c : suspend_prepare(), suspend_enter(), suspend_finish()
-kernel/cpu.c: cpu_[up|down](), _cpu_[up|down](), [disable|enable]_nonboot_cpus()
+- kernel/power/process.c : freeze_processes(), thaw_processes()
+- kernel/power/suspend.c : suspend_prepare(), suspend_enter(), suspend_finish()
+- kernel/cpu.c: cpu_[up|down](), _cpu_[up|down](), [disable|enable]_nonboot_cpus()
 
 
 
 II. What are the issues involved in CPU hotplug?
-    -------------------------------------------
+------------------------------------------------
 
 There are some interesting situations involving CPU hotplug and microcode
 update on the CPUs, as discussed below:
@@ -243,8 +250,11 @@ d. Handling microcode update during suspend/hibernate:
    cycles).
 
 
-III. Are there any known problems when regular CPU hotplug and suspend race
-     with each other?
+III. Known problems
+===================
+
+Are there any known problems when regular CPU hotplug and suspend race
+with each other?
 
 Yes, they are listed below:
 
diff --git a/Documentation/power/suspend-and-interrupts.txt b/Documentation/power/suspend-and-interrupts.rst
similarity index 98%
rename from Documentation/power/suspend-and-interrupts.txt
rename to Documentation/power/suspend-and-interrupts.rst
index 8afb29a8604a..4cda6617709a 100644
--- a/Documentation/power/suspend-and-interrupts.txt
+++ b/Documentation/power/suspend-and-interrupts.rst
@@ -1,4 +1,6 @@
+====================================
 System Suspend and Device Interrupts
+====================================
 
 Copyright (C) 2014 Intel Corp.
 Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
diff --git a/Documentation/power/swsusp-and-swap-files.txt b/Documentation/power/swsusp-and-swap-files.rst
similarity index 83%
rename from Documentation/power/swsusp-and-swap-files.txt
rename to Documentation/power/swsusp-and-swap-files.rst
index f281886de490..a33a2919dbe4 100644
--- a/Documentation/power/swsusp-and-swap-files.txt
+++ b/Documentation/power/swsusp-and-swap-files.rst
@@ -1,4 +1,7 @@
+===============================================
 Using swap files with software suspend (swsusp)
+===============================================
+
 	(C) 2006 Rafael J. Wysocki <rjw@sisk.pl>
 
 The Linux kernel handles swap files almost in the same way as it handles swap
@@ -21,20 +24,20 @@ units.
 
 In order to use a swap file with swsusp, you need to:
 
-1) Create the swap file and make it active, eg.
+1) Create the swap file and make it active, eg.::
 
-# dd if=/dev/zero of=<swap_file_path> bs=1024 count=<swap_file_size_in_k>
-# mkswap <swap_file_path>
-# swapon <swap_file_path>
+    # dd if=/dev/zero of=<swap_file_path> bs=1024 count=<swap_file_size_in_k>
+    # mkswap <swap_file_path>
+    # swapon <swap_file_path>
 
 2) Use an application that will bmap the swap file with the help of the
 FIBMAP ioctl and determine the location of the file's swap header, as the
 offset, in <PAGE_SIZE> units, from the beginning of the partition which
 holds the swap file.
 
-3) Add the following parameters to the kernel command line:
+3) Add the following parameters to the kernel command line::
 
-resume=<swap_file_partition> resume_offset=<swap_file_offset>
+    resume=<swap_file_partition> resume_offset=<swap_file_offset>
 
 where <swap_file_partition> is the partition on which the swap file is located
 and <swap_file_offset> is the offset of the swap header determined by the
@@ -46,7 +49,7 @@ OR
 
 Use a userland suspend application that will set the partition and offset
 with the help of the SNAPSHOT_SET_SWAP_AREA ioctl described in
-Documentation/power/userland-swsusp.txt (this is the only method to suspend
+Documentation/power/userland-swsusp.rst (this is the only method to suspend
 to a swap file allowing the resume to be initiated from an initrd or initramfs
 image).
 
diff --git a/Documentation/power/swsusp-dmcrypt.txt b/Documentation/power/swsusp-dmcrypt.rst
similarity index 67%
rename from Documentation/power/swsusp-dmcrypt.txt
rename to Documentation/power/swsusp-dmcrypt.rst
index b802fbfd95ef..426df59172cd 100644
--- a/Documentation/power/swsusp-dmcrypt.txt
+++ b/Documentation/power/swsusp-dmcrypt.rst
@@ -1,13 +1,15 @@
+=======================================
+How to use dm-crypt and swsusp together
+=======================================
+
 Author: Andreas Steinmetz <ast@domdv.de>
 
 
-How to use dm-crypt and swsusp together:
-========================================
 
 Some prerequisites:
 You know how dm-crypt works. If not, visit the following web page:
 http://www.saout.de/misc/dm-crypt/
-You have read Documentation/power/swsusp.txt and understand it.
+You have read Documentation/power/swsusp.rst and understand it.
 You did read Documentation/admin-guide/initrd.rst and know how an initrd works.
 You know how to create or how to modify an initrd.
 
@@ -29,23 +31,23 @@ a way that the swap device you suspend to/resume from has
 always the same major/minor within the initrd as well as
 within your running system. The easiest way to achieve this is
 to always set up this swap device first with dmsetup, so that
-it will always look like the following:
+it will always look like the following::
 
-brw-------  1 root root 254, 0 Jul 28 13:37 /dev/mapper/swap0
+  brw-------  1 root root 254, 0 Jul 28 13:37 /dev/mapper/swap0
 
 Now set up your kernel to use /dev/mapper/swap0 as the default
-resume partition, so your kernel .config contains:
+resume partition, so your kernel .config contains::
 
-CONFIG_PM_STD_PARTITION="/dev/mapper/swap0"
+  CONFIG_PM_STD_PARTITION="/dev/mapper/swap0"
 
 Prepare your boot loader to use the initrd you will create or
 modify. For lilo the simplest setup looks like the following
-lines:
+lines::
 
-image=/boot/vmlinuz
-initrd=/boot/initrd.gz
-label=linux
-append="root=/dev/ram0 init=/linuxrc rw"
+  image=/boot/vmlinuz
+  initrd=/boot/initrd.gz
+  label=linux
+  append="root=/dev/ram0 init=/linuxrc rw"
 
 Finally you need to create or modify your initrd. Lets assume
 you create an initrd that reads the required dm-crypt setup
@@ -53,66 +55,66 @@ from a pcmcia flash disk card. The card is formatted with an ext2
 fs which resides on /dev/hde1 when the card is inserted. The
 card contains at least the encrypted swap setup in a file
 named "swapkey". /etc/fstab of your initrd contains something
-like the following:
+like the following::
 
-/dev/hda1   /mnt    ext3      ro                            0 0
-none        /proc   proc      defaults,noatime,nodiratime   0 0
-none        /sys    sysfs     defaults,noatime,nodiratime   0 0
+  /dev/hda1   /mnt    ext3      ro                            0 0
+  none        /proc   proc      defaults,noatime,nodiratime   0 0
+  none        /sys    sysfs     defaults,noatime,nodiratime   0 0
 
 /dev/hda1 contains an unencrypted mini system that sets up all
 of your crypto devices, again by reading the setup from the
 pcmcia flash disk. What follows now is a /linuxrc for your
 initrd that allows you to resume from encrypted swap and that
 continues boot with your mini system on /dev/hda1 if resume
-does not happen:
+does not happen::
 
-#!/bin/sh
-PATH=/sbin:/bin:/usr/sbin:/usr/bin
-mount /proc
-mount /sys
-mapped=0
-noresume=`grep -c noresume /proc/cmdline`
-if [ "$*" != "" ]
-then
-  noresume=1
-fi
-dmesg -n 1
-/sbin/cardmgr -q
-for i in 1 2 3 4 5 6 7 8 9 0
-do
-  if [ -f /proc/ide/hde/media ]
+  #!/bin/sh
+  PATH=/sbin:/bin:/usr/sbin:/usr/bin
+  mount /proc
+  mount /sys
+  mapped=0
+  noresume=`grep -c noresume /proc/cmdline`
+  if [ "$*" != "" ]
   then
+    noresume=1
+  fi
+  dmesg -n 1
+  /sbin/cardmgr -q
+  for i in 1 2 3 4 5 6 7 8 9 0
+  do
+    if [ -f /proc/ide/hde/media ]
+    then
+      usleep 500000
+      mount -t ext2 -o ro /dev/hde1 /mnt
+      if [ -f /mnt/swapkey ]
+      then
+        dmsetup create swap0 /mnt/swapkey > /dev/null 2>&1 && mapped=1
+      fi
+      umount /mnt
+      break
+    fi
     usleep 500000
-    mount -t ext2 -o ro /dev/hde1 /mnt
-    if [ -f /mnt/swapkey ]
+  done
+  killproc /sbin/cardmgr
+  dmesg -n 6
+  if [ $mapped = 1 ]
+  then
+    if [ $noresume != 0 ]
     then
-      dmsetup create swap0 /mnt/swapkey > /dev/null 2>&1 && mapped=1
+      mkswap /dev/mapper/swap0 > /dev/null 2>&1
     fi
-    umount /mnt
-    break
+    echo 254:0 > /sys/power/resume
+    dmsetup remove swap0
   fi
-  usleep 500000
-done
-killproc /sbin/cardmgr
-dmesg -n 6
-if [ $mapped = 1 ]
-then
-  if [ $noresume != 0 ]
-  then
-    mkswap /dev/mapper/swap0 > /dev/null 2>&1
-  fi
-  echo 254:0 > /sys/power/resume
-  dmsetup remove swap0
-fi
-umount /sys
-mount /mnt
-umount /proc
-cd /mnt
-pivot_root . mnt
-mount /proc
-umount -l /mnt
-umount /proc
-exec chroot . /sbin/init $* < dev/console > dev/console 2>&1
+  umount /sys
+  mount /mnt
+  umount /proc
+  cd /mnt
+  pivot_root . mnt
+  mount /proc
+  umount -l /mnt
+  umount /proc
+  exec chroot . /sbin/init $* < dev/console > dev/console 2>&1
 
 Please don't mind the weird loop above, busybox's msh doesn't know
 the let statement. Now, what is happening in the script?
diff --git a/Documentation/power/swsusp.txt b/Documentation/power/swsusp.rst
similarity index 20%
rename from Documentation/power/swsusp.txt
rename to Documentation/power/swsusp.rst
index 236d1fb13640..d000312f6965 100644
--- a/Documentation/power/swsusp.txt
+++ b/Documentation/power/swsusp.rst
@@ -1,68 +1,76 @@
+============
+Swap suspend
+============
+
 Some warnings, first.
 
- * BIG FAT WARNING *********************************************************
- *
- * If you touch anything on disk between suspend and resume...
- *				...kiss your data goodbye.
- *
- * If you do resume from initrd after your filesystems are mounted...
- *				...bye bye root partition.
- *			[this is actually same case as above]
- *
- * If you have unsupported (*) devices using DMA, you may have some
- * problems. If your disk driver does not support suspend... (IDE does),
- * it may cause some problems, too. If you change kernel command line
- * between suspend and resume, it may do something wrong. If you change
- * your hardware while system is suspended... well, it was not good idea;
- * but it will probably only crash.
- *
- * (*) suspend/resume support is needed to make it safe.
- *
- * If you have any filesystems on USB devices mounted before software suspend,
- * they won't be accessible after resume and you may lose data, as though
- * you have unplugged the USB devices with mounted filesystems on them;
- * see the FAQ below for details.  (This is not true for more traditional
- * power states like "standby", which normally don't turn USB off.)
+.. warning::
+
+   **BIG FAT WARNING**
+
+   If you touch anything on disk between suspend and resume...
+				...kiss your data goodbye.
+
+   If you do resume from initrd after your filesystems are mounted...
+				...bye bye root partition.
+
+			[this is actually same case as above]
+
+   If you have unsupported ( ) devices using DMA, you may have some
+   problems. If your disk driver does not support suspend... (IDE does),
+   it may cause some problems, too. If you change kernel command line
+   between suspend and resume, it may do something wrong. If you change
+   your hardware while system is suspended... well, it was not good idea;
+   but it will probably only crash.
+
+   ( ) suspend/resume support is needed to make it safe.
+
+   If you have any filesystems on USB devices mounted before software suspend,
+   they won't be accessible after resume and you may lose data, as though
+   you have unplugged the USB devices with mounted filesystems on them;
+   see the FAQ below for details.  (This is not true for more traditional
+   power states like "standby", which normally don't turn USB off.)
 
 Swap partition:
-You need to append resume=/dev/your_swap_partition to kernel command
-line or specify it using /sys/power/resume.
+  You need to append resume=/dev/your_swap_partition to kernel command
+  line or specify it using /sys/power/resume.
 
 Swap file:
-If using a swapfile you can also specify a resume offset using
-resume_offset=<number> on the kernel command line or specify it
-in /sys/power/resume_offset.
+  If using a swapfile you can also specify a resume offset using
+  resume_offset=<number> on the kernel command line or specify it
+  in /sys/power/resume_offset.
 
-After preparing then you suspend by
+After preparing then you suspend by::
 
-echo shutdown > /sys/power/disk; echo disk > /sys/power/state
+	echo shutdown > /sys/power/disk; echo disk > /sys/power/state
 
-. If you feel ACPI works pretty well on your system, you might try
+- If you feel ACPI works pretty well on your system, you might try::
 
-echo platform > /sys/power/disk; echo disk > /sys/power/state
+	echo platform > /sys/power/disk; echo disk > /sys/power/state
 
-. If you would like to write hibernation image to swap and then suspend
-to RAM (provided your platform supports it), you can try
+- If you would like to write hibernation image to swap and then suspend
+  to RAM (provided your platform supports it), you can try::
 
-echo suspend > /sys/power/disk; echo disk > /sys/power/state
+	echo suspend > /sys/power/disk; echo disk > /sys/power/state
 
-. If you have SATA disks, you'll need recent kernels with SATA suspend
-support. For suspend and resume to work, make sure your disk drivers
-are built into kernel -- not modules. [There's way to make
-suspend/resume with modular disk drivers, see FAQ, but you probably
-should not do that.]
+- If you have SATA disks, you'll need recent kernels with SATA suspend
+  support. For suspend and resume to work, make sure your disk drivers
+  are built into kernel -- not modules. [There's way to make
+  suspend/resume with modular disk drivers, see FAQ, but you probably
+  should not do that.]
 
-If you want to limit the suspend image size to N bytes, do
+If you want to limit the suspend image size to N bytes, do::
 
-echo N > /sys/power/image_size
+	echo N > /sys/power/image_size
 
 before suspend (it is limited to around 2/5 of available RAM by default).
 
-. The resume process checks for the presence of the resume device,
-if found, it then checks the contents for the hibernation image signature.
-If both are found, it resumes the hibernation image.
+- The resume process checks for the presence of the resume device,
+  if found, it then checks the contents for the hibernation image signature.
+  If both are found, it resumes the hibernation image.
+
+- The resume process may be triggered in two ways:
 
-. The resume process may be triggered in two ways:
   1) During lateinit:  If resume=/dev/your_swap_partition is specified on
      the kernel command line, lateinit runs the resume process.  If the
      resume device has not been probed yet, the resume process fails and
@@ -73,26 +81,28 @@ If both are found, it resumes the hibernation image.
      read-only) otherwise data may be corrupted.
 
 Article about goals and implementation of Software Suspend for Linux
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+====================================================================
+
 Author: Gábor Kuti
 Last revised: 2003-10-20 by Pavel Machek
 
 Idea and goals to achieve
+-------------------------
 
 Nowadays it is common in several laptops that they have a suspend button. It
 saves the state of the machine to a filesystem or to a partition and switches
 to standby mode. Later resuming the machine the saved state is loaded back to
 ram and the machine can continue its work. It has two real benefits. First we
 save ourselves the time machine goes down and later boots up, energy costs
-are real high when running from batteries. The other gain is that we don't have to
-interrupt our programs so processes that are calculating something for a long
+are real high when running from batteries. The other gain is that we don't have
+to interrupt our programs so processes that are calculating something for a long
 time shouldn't need to be written interruptible.
 
 swsusp saves the state of the machine into active swaps and then reboots or
 powerdowns.  You must explicitly specify the swap partition to resume from with
-``resume='' kernel option. If signature is found it loads and restores saved
-state. If the option ``noresume'' is specified as a boot parameter, it skips
-the resuming.  If the option ``hibernate=nocompress'' is specified as a boot
+`resume=` kernel option. If signature is found it loads and restores saved
+state. If the option `noresume` is specified as a boot parameter, it skips
+the resuming.  If the option `hibernate=nocompress` is specified as a boot
 parameter, it saves hibernation image without compression.
 
 In the meantime while the system is suspended you should not add/remove any
@@ -104,151 +114,173 @@ Sleep states summary
 There are three different interfaces you can use, /proc/acpi should
 work like this:
 
-In a really perfect world:
-echo 1 > /proc/acpi/sleep       # for standby
-echo 2 > /proc/acpi/sleep       # for suspend to ram
-echo 3 > /proc/acpi/sleep       # for suspend to ram, but with more power conservative
-echo 4 > /proc/acpi/sleep       # for suspend to disk
-echo 5 > /proc/acpi/sleep       # for shutdown unfriendly the system
+In a really perfect world::
 
-and perhaps
-echo 4b > /proc/acpi/sleep      # for suspend to disk via s4bios
+  echo 1 > /proc/acpi/sleep       # for standby
+  echo 2 > /proc/acpi/sleep       # for suspend to ram
+  echo 3 > /proc/acpi/sleep       # for suspend to ram, but with more power conservative
+  echo 4 > /proc/acpi/sleep       # for suspend to disk
+  echo 5 > /proc/acpi/sleep       # for shutdown unfriendly the system
+
+and perhaps::
+
+  echo 4b > /proc/acpi/sleep      # for suspend to disk via s4bios
 
 Frequently Asked Questions
 ==========================
 
-Q: well, suspending a server is IMHO a really stupid thing,
-but... (Diego Zuccato):
+Q:
+  well, suspending a server is IMHO a really stupid thing,
+  but... (Diego Zuccato):
 
-A: You bought new UPS for your server. How do you install it without
-bringing machine down? Suspend to disk, rearrange power cables,
-resume.
-
-You have your server on UPS. Power died, and UPS is indicating 30
-seconds to failure. What do you do? Suspend to disk.
+A:
+  You bought new UPS for your server. How do you install it without
+  bringing machine down? Suspend to disk, rearrange power cables,
+  resume.
 
+  You have your server on UPS. Power died, and UPS is indicating 30
+  seconds to failure. What do you do? Suspend to disk.
 
-Q: Maybe I'm missing something, but why don't the regular I/O paths work?
 
-A: We do use the regular I/O paths. However we cannot restore the data
-to its original location as we load it. That would create an
-inconsistent kernel state which would certainly result in an oops.
-Instead, we load the image into unused memory and then atomically copy
-it back to it original location. This implies, of course, a maximum
-image size of half the amount of memory.
+Q:
+  Maybe I'm missing something, but why don't the regular I/O paths work?
 
-There are two solutions to this:
+A:
+  We do use the regular I/O paths. However we cannot restore the data
+  to its original location as we load it. That would create an
+  inconsistent kernel state which would certainly result in an oops.
+  Instead, we load the image into unused memory and then atomically copy
+  it back to it original location. This implies, of course, a maximum
+  image size of half the amount of memory.
 
-* require half of memory to be free during suspend. That way you can
-read "new" data onto free spots, then cli and copy
+  There are two solutions to this:
 
-* assume we had special "polling" ide driver that only uses memory
-between 0-640KB. That way, I'd have to make sure that 0-640KB is free
-during suspending, but otherwise it would work...
+  * require half of memory to be free during suspend. That way you can
+    read "new" data onto free spots, then cli and copy
 
-suspend2 shares this fundamental limitation, but does not include user
-data and disk caches into "used memory" by saving them in
-advance. That means that the limitation goes away in practice.
+  * assume we had special "polling" ide driver that only uses memory
+    between 0-640KB. That way, I'd have to make sure that 0-640KB is free
+    during suspending, but otherwise it would work...
 
-Q: Does linux support ACPI S4?
+  suspend2 shares this fundamental limitation, but does not include user
+  data and disk caches into "used memory" by saving them in
+  advance. That means that the limitation goes away in practice.
 
-A: Yes. That's what echo platform > /sys/power/disk does.
+Q:
+  Does linux support ACPI S4?
 
-Q: What is 'suspend2'?
+A:
+  Yes. That's what echo platform > /sys/power/disk does.
 
-A: suspend2 is 'Software Suspend 2', a forked implementation of
-suspend-to-disk which is available as separate patches for 2.4 and 2.6
-kernels from swsusp.sourceforge.net. It includes support for SMP, 4GB
-highmem and preemption. It also has a extensible architecture that
-allows for arbitrary transformations on the image (compression,
-encryption) and arbitrary backends for writing the image (eg to swap
-or an NFS share[Work In Progress]). Questions regarding suspend2
-should be sent to the mailing list available through the suspend2
-website, and not to the Linux Kernel Mailing List. We are working
-toward merging suspend2 into the mainline kernel.
+Q:
+  What is 'suspend2'?
 
-Q: What is the freezing of tasks and why are we using it?
+A:
+  suspend2 is 'Software Suspend 2', a forked implementation of
+  suspend-to-disk which is available as separate patches for 2.4 and 2.6
+  kernels from swsusp.sourceforge.net. It includes support for SMP, 4GB
+  highmem and preemption. It also has a extensible architecture that
+  allows for arbitrary transformations on the image (compression,
+  encryption) and arbitrary backends for writing the image (eg to swap
+  or an NFS share[Work In Progress]). Questions regarding suspend2
+  should be sent to the mailing list available through the suspend2
+  website, and not to the Linux Kernel Mailing List. We are working
+  toward merging suspend2 into the mainline kernel.
+
+Q:
+  What is the freezing of tasks and why are we using it?
 
-A: The freezing of tasks is a mechanism by which user space processes and some
-kernel threads are controlled during hibernation or system-wide suspend (on some
-architectures).  See freezing-of-tasks.txt for details.
+A:
+  The freezing of tasks is a mechanism by which user space processes and some
+  kernel threads are controlled during hibernation or system-wide suspend (on some
+  architectures).  See freezing-of-tasks.txt for details.
 
-Q: What is the difference between "platform" and "shutdown"?
+Q:
+  What is the difference between "platform" and "shutdown"?
 
 A:
+  shutdown:
+	save state in linux, then tell bios to powerdown
 
-shutdown: save state in linux, then tell bios to powerdown
+  platform:
+	save state in linux, then tell bios to powerdown and blink
+        "suspended led"
 
-platform: save state in linux, then tell bios to powerdown and blink
-          "suspended led"
+  "platform" is actually right thing to do where supported, but
+  "shutdown" is most reliable (except on ACPI systems).
 
-"platform" is actually right thing to do where supported, but
-"shutdown" is most reliable (except on ACPI systems).
+Q:
+  I do not understand why you have such strong objections to idea of
+  selective suspend.
 
-Q: I do not understand why you have such strong objections to idea of
-selective suspend.
+A:
+  Do selective suspend during runtime power management, that's okay. But
+  it's useless for suspend-to-disk. (And I do not see how you could use
+  it for suspend-to-ram, I hope you do not want that).
 
-A: Do selective suspend during runtime power management, that's okay. But
-it's useless for suspend-to-disk. (And I do not see how you could use
-it for suspend-to-ram, I hope you do not want that).
+  Lets see, so you suggest to
 
-Lets see, so you suggest to
+  * SUSPEND all but swap device and parents
+  * Snapshot
+  * Write image to disk
+  * SUSPEND swap device and parents
+  * Powerdown
 
-* SUSPEND all but swap device and parents
-* Snapshot
-* Write image to disk
-* SUSPEND swap device and parents
-* Powerdown
+  Oh no, that does not work, if swap device or its parents uses DMA,
+  you've corrupted data. You'd have to do
 
-Oh no, that does not work, if swap device or its parents uses DMA,
-you've corrupted data. You'd have to do
+  * SUSPEND all but swap device and parents
+  * FREEZE swap device and parents
+  * Snapshot
+  * UNFREEZE swap device and parents
+  * Write
+  * SUSPEND swap device and parents
 
-* SUSPEND all but swap device and parents
-* FREEZE swap device and parents
-* Snapshot
-* UNFREEZE swap device and parents
-* Write
-* SUSPEND swap device and parents
+  Which means that you still need that FREEZE state, and you get more
+  complicated code. (And I have not yet introduce details like system
+  devices).
 
-Which means that you still need that FREEZE state, and you get more
-complicated code. (And I have not yet introduce details like system
-devices).
+Q:
+  There don't seem to be any generally useful behavioral
+  distinctions between SUSPEND and FREEZE.
 
-Q: There don't seem to be any generally useful behavioral
-distinctions between SUSPEND and FREEZE.
+A:
+  Doing SUSPEND when you are asked to do FREEZE is always correct,
+  but it may be unnecessarily slow. If you want your driver to stay simple,
+  slowness may not matter to you. It can always be fixed later.
 
-A: Doing SUSPEND when you are asked to do FREEZE is always correct,
-but it may be unnecessarily slow. If you want your driver to stay simple,
-slowness may not matter to you. It can always be fixed later.
+  For devices like disk it does matter, you do not want to spindown for
+  FREEZE.
 
-For devices like disk it does matter, you do not want to spindown for
-FREEZE.
+Q:
+  After resuming, system is paging heavily, leading to very bad interactivity.
 
-Q: After resuming, system is paging heavily, leading to very bad interactivity.
+A:
+  Try running::
 
-A: Try running
+    cat /proc/[0-9]*/maps | grep / | sed 's:.* /:/:' | sort -u | while read file
+    do
+      test -f "$file" && cat "$file" > /dev/null
+    done
 
-cat /proc/[0-9]*/maps | grep / | sed 's:.* /:/:' | sort -u | while read file
-do
-  test -f "$file" && cat "$file" > /dev/null
-done
+  after resume. swapoff -a; swapon -a may also be useful.
 
-after resume. swapoff -a; swapon -a may also be useful.
+Q:
+  What happens to devices during swsusp? They seem to be resumed
+  during system suspend?
 
-Q: What happens to devices during swsusp? They seem to be resumed
-during system suspend?
+A:
+  That's correct. We need to resume them if we want to write image to
+  disk. Whole sequence goes like
 
-A: That's correct. We need to resume them if we want to write image to
-disk. Whole sequence goes like
+      **Suspend part**
 
-      Suspend part
-      ~~~~~~~~~~~~
       running system, user asks for suspend-to-disk
 
       user processes are stopped
 
       suspend(PMSG_FREEZE): devices are frozen so that they don't interfere
-      		      with state snapshot
+      with state snapshot
 
       state snapshot: copy of whole used memory is taken with interrupts disabled
 
@@ -260,18 +292,19 @@ disk. Whole sequence goes like
 
       turn the power off
 
-      Resume part
-      ~~~~~~~~~~~
+      **Resume part**
+
       (is actually pretty similar)
 
       running system, user asks for suspend-to-disk
 
-      user processes are stopped (in common case there are none, but with resume-from-initrd, no one knows)
+      user processes are stopped (in common case there are none,
+      but with resume-from-initrd, no one knows)
 
       read image from disk
 
       suspend(PMSG_FREEZE): devices are frozen so that they don't interfere
-      		      with image restoration
+      with image restoration
 
       image restoration: rewrite memory with image
 
@@ -279,87 +312,103 @@ disk. Whole sequence goes like
 
       thaw all user processes
 
-Q: What is this 'Encrypt suspend image' for?
-
-A: First of all: it is not a replacement for dm-crypt encrypted swap.
-It cannot protect your computer while it is suspended. Instead it does
-protect from leaking sensitive data after resume from suspend.
-
-Think of the following: you suspend while an application is running
-that keeps sensitive data in memory. The application itself prevents
-the data from being swapped out. Suspend, however, must write these
-data to swap to be able to resume later on. Without suspend encryption
-your sensitive data are then stored in plaintext on disk.  This means
-that after resume your sensitive data are accessible to all
-applications having direct access to the swap device which was used
-for suspend. If you don't need swap after resume these data can remain
-on disk virtually forever. Thus it can happen that your system gets
-broken in weeks later and sensitive data which you thought were
-encrypted and protected are retrieved and stolen from the swap device.
-To prevent this situation you should use 'Encrypt suspend image'.
-
-During suspend a temporary key is created and this key is used to
-encrypt the data written to disk. When, during resume, the data was
-read back into memory the temporary key is destroyed which simply
-means that all data written to disk during suspend are then
-inaccessible so they can't be stolen later on.  The only thing that
-you must then take care of is that you call 'mkswap' for the swap
-partition used for suspend as early as possible during regular
-boot. This asserts that any temporary key from an oopsed suspend or
-from a failed or aborted resume is erased from the swap device.
-
-As a rule of thumb use encrypted swap to protect your data while your
-system is shut down or suspended. Additionally use the encrypted
-suspend image to prevent sensitive data from being stolen after
-resume.
-
-Q: Can I suspend to a swap file?
-
-A: Generally, yes, you can.  However, it requires you to use the "resume=" and
-"resume_offset=" kernel command line parameters, so the resume from a swap file
-cannot be initiated from an initrd or initramfs image.  See
-swsusp-and-swap-files.txt for details.
-
-Q: Is there a maximum system RAM size that is supported by swsusp?
-
-A: It should work okay with highmem.
-
-Q: Does swsusp (to disk) use only one swap partition or can it use
-multiple swap partitions (aggregate them into one logical space)?
-
-A: Only one swap partition, sorry.
-
-Q: If my application(s) causes lots of memory & swap space to be used
-(over half of the total system RAM), is it correct that it is likely
-to be useless to try to suspend to disk while that app is running?
-
-A: No, it should work okay, as long as your app does not mlock()
-it. Just prepare big enough swap partition.
-
-Q: What information is useful for debugging suspend-to-disk problems?
-
-A: Well, last messages on the screen are always useful. If something
-is broken, it is usually some kernel driver, therefore trying with as
-little as possible modules loaded helps a lot. I also prefer people to
-suspend from console, preferably without X running. Booting with
-init=/bin/bash, then swapon and starting suspend sequence manually
-usually does the trick. Then it is good idea to try with latest
-vanilla kernel.
-
-Q: How can distributions ship a swsusp-supporting kernel with modular
-disk drivers (especially SATA)?
-
-A: Well, it can be done, load the drivers, then do echo into
-/sys/power/resume file from initrd. Be sure not to mount
-anything, not even read-only mount, or you are going to lose your
-data.
-
-Q: How do I make suspend more verbose?
-
-A: If you want to see any non-error kernel messages on the virtual
-terminal the kernel switches to during suspend, you have to set the
-kernel console loglevel to at least 4 (KERN_WARNING), for example by
-doing
+Q:
+  What is this 'Encrypt suspend image' for?
+
+A:
+  First of all: it is not a replacement for dm-crypt encrypted swap.
+  It cannot protect your computer while it is suspended. Instead it does
+  protect from leaking sensitive data after resume from suspend.
+
+  Think of the following: you suspend while an application is running
+  that keeps sensitive data in memory. The application itself prevents
+  the data from being swapped out. Suspend, however, must write these
+  data to swap to be able to resume later on. Without suspend encryption
+  your sensitive data are then stored in plaintext on disk.  This means
+  that after resume your sensitive data are accessible to all
+  applications having direct access to the swap device which was used
+  for suspend. If you don't need swap after resume these data can remain
+  on disk virtually forever. Thus it can happen that your system gets
+  broken in weeks later and sensitive data which you thought were
+  encrypted and protected are retrieved and stolen from the swap device.
+  To prevent this situation you should use 'Encrypt suspend image'.
+
+  During suspend a temporary key is created and this key is used to
+  encrypt the data written to disk. When, during resume, the data was
+  read back into memory the temporary key is destroyed which simply
+  means that all data written to disk during suspend are then
+  inaccessible so they can't be stolen later on.  The only thing that
+  you must then take care of is that you call 'mkswap' for the swap
+  partition used for suspend as early as possible during regular
+  boot. This asserts that any temporary key from an oopsed suspend or
+  from a failed or aborted resume is erased from the swap device.
+
+  As a rule of thumb use encrypted swap to protect your data while your
+  system is shut down or suspended. Additionally use the encrypted
+  suspend image to prevent sensitive data from being stolen after
+  resume.
+
+Q:
+  Can I suspend to a swap file?
+
+A:
+  Generally, yes, you can.  However, it requires you to use the "resume=" and
+  "resume_offset=" kernel command line parameters, so the resume from a swap file
+  cannot be initiated from an initrd or initramfs image.  See
+  swsusp-and-swap-files.txt for details.
+
+Q:
+  Is there a maximum system RAM size that is supported by swsusp?
+
+A:
+  It should work okay with highmem.
+
+Q:
+  Does swsusp (to disk) use only one swap partition or can it use
+  multiple swap partitions (aggregate them into one logical space)?
+
+A:
+  Only one swap partition, sorry.
+
+Q:
+  If my application(s) causes lots of memory & swap space to be used
+  (over half of the total system RAM), is it correct that it is likely
+  to be useless to try to suspend to disk while that app is running?
+
+A:
+  No, it should work okay, as long as your app does not mlock()
+  it. Just prepare big enough swap partition.
+
+Q:
+  What information is useful for debugging suspend-to-disk problems?
+
+A:
+  Well, last messages on the screen are always useful. If something
+  is broken, it is usually some kernel driver, therefore trying with as
+  little as possible modules loaded helps a lot. I also prefer people to
+  suspend from console, preferably without X running. Booting with
+  init=/bin/bash, then swapon and starting suspend sequence manually
+  usually does the trick. Then it is good idea to try with latest
+  vanilla kernel.
+
+Q:
+  How can distributions ship a swsusp-supporting kernel with modular
+  disk drivers (especially SATA)?
+
+A:
+  Well, it can be done, load the drivers, then do echo into
+  /sys/power/resume file from initrd. Be sure not to mount
+  anything, not even read-only mount, or you are going to lose your
+  data.
+
+Q:
+  How do I make suspend more verbose?
+
+A:
+  If you want to see any non-error kernel messages on the virtual
+  terminal the kernel switches to during suspend, you have to set the
+  kernel console loglevel to at least 4 (KERN_WARNING), for example by
+  doing::
 
 	# save the old loglevel
 	read LOGLEVEL DUMMY < /proc/sys/kernel/printk
@@ -387,60 +436,66 @@ doing
 	echo $LOGLEVEL > /proc/sys/kernel/printk
 	exit $RET
 
-Q: Is this true that if I have a mounted filesystem on a USB device and
-I suspend to disk, I can lose data unless the filesystem has been mounted
-with "sync"?
-
-A: That's right ... if you disconnect that device, you may lose data.
-In fact, even with "-o sync" you can lose data if your programs have
-information in buffers they haven't written out to a disk you disconnect,
-or if you disconnect before the device finished saving data you wrote.
-
-Software suspend normally powers down USB controllers, which is equivalent
-to disconnecting all USB devices attached to your system.
-
-Your system might well support low-power modes for its USB controllers
-while the system is asleep, maintaining the connection, using true sleep
-modes like "suspend-to-RAM" or "standby".  (Don't write "disk" to the
-/sys/power/state file; write "standby" or "mem".)  We've not seen any
-hardware that can use these modes through software suspend, although in
-theory some systems might support "platform" modes that won't break the
-USB connections.
-
-Remember that it's always a bad idea to unplug a disk drive containing a
-mounted filesystem.  That's true even when your system is asleep!  The
-safest thing is to unmount all filesystems on removable media (such USB,
-Firewire, CompactFlash, MMC, external SATA, or even IDE hotplug bays)
-before suspending; then remount them after resuming.
-
-There is a work-around for this problem.  For more information, see
-Documentation/driver-api/usb/persist.rst.
-
-Q: Can I suspend-to-disk using a swap partition under LVM?
-
-A: Yes and No.  You can suspend successfully, but the kernel will not be able
-to resume on its own.  You need an initramfs that can recognize the resume
-situation, activate the logical volume containing the swap volume (but not
-touch any filesystems!), and eventually call
-
-echo -n "$major:$minor" > /sys/power/resume
-
-where $major and $minor are the respective major and minor device numbers of
-the swap volume.
-
-uswsusp works with LVM, too.  See http://suspend.sourceforge.net/
-
-Q: I upgraded the kernel from 2.6.15 to 2.6.16. Both kernels were
-compiled with the similar configuration files. Anyway I found that
-suspend to disk (and resume) is much slower on 2.6.16 compared to
-2.6.15. Any idea for why that might happen or how can I speed it up?
-
-A: This is because the size of the suspend image is now greater than
-for 2.6.15 (by saving more data we can get more responsive system
-after resume).
-
-There's the /sys/power/image_size knob that controls the size of the
-image.  If you set it to 0 (eg. by echo 0 > /sys/power/image_size as
-root), the 2.6.15 behavior should be restored.  If it is still too
-slow, take a look at suspend.sf.net -- userland suspend is faster and
-supports LZF compression to speed it up further.
+Q:
+  Is this true that if I have a mounted filesystem on a USB device and
+  I suspend to disk, I can lose data unless the filesystem has been mounted
+  with "sync"?
+
+A:
+  That's right ... if you disconnect that device, you may lose data.
+  In fact, even with "-o sync" you can lose data if your programs have
+  information in buffers they haven't written out to a disk you disconnect,
+  or if you disconnect before the device finished saving data you wrote.
+
+  Software suspend normally powers down USB controllers, which is equivalent
+  to disconnecting all USB devices attached to your system.
+
+  Your system might well support low-power modes for its USB controllers
+  while the system is asleep, maintaining the connection, using true sleep
+  modes like "suspend-to-RAM" or "standby".  (Don't write "disk" to the
+  /sys/power/state file; write "standby" or "mem".)  We've not seen any
+  hardware that can use these modes through software suspend, although in
+  theory some systems might support "platform" modes that won't break the
+  USB connections.
+
+  Remember that it's always a bad idea to unplug a disk drive containing a
+  mounted filesystem.  That's true even when your system is asleep!  The
+  safest thing is to unmount all filesystems on removable media (such USB,
+  Firewire, CompactFlash, MMC, external SATA, or even IDE hotplug bays)
+  before suspending; then remount them after resuming.
+
+  There is a work-around for this problem.  For more information, see
+  Documentation/driver-api/usb/persist.rst.
+
+Q:
+  Can I suspend-to-disk using a swap partition under LVM?
+
+A:
+  Yes and No.  You can suspend successfully, but the kernel will not be able
+  to resume on its own.  You need an initramfs that can recognize the resume
+  situation, activate the logical volume containing the swap volume (but not
+  touch any filesystems!), and eventually call::
+
+    echo -n "$major:$minor" > /sys/power/resume
+
+  where $major and $minor are the respective major and minor device numbers of
+  the swap volume.
+
+  uswsusp works with LVM, too.  See http://suspend.sourceforge.net/
+
+Q:
+  I upgraded the kernel from 2.6.15 to 2.6.16. Both kernels were
+  compiled with the similar configuration files. Anyway I found that
+  suspend to disk (and resume) is much slower on 2.6.16 compared to
+  2.6.15. Any idea for why that might happen or how can I speed it up?
+
+A:
+  This is because the size of the suspend image is now greater than
+  for 2.6.15 (by saving more data we can get more responsive system
+  after resume).
+
+  There's the /sys/power/image_size knob that controls the size of the
+  image.  If you set it to 0 (eg. by echo 0 > /sys/power/image_size as
+  root), the 2.6.15 behavior should be restored.  If it is still too
+  slow, take a look at suspend.sf.net -- userland suspend is faster and
+  supports LZF compression to speed it up further.
diff --git a/Documentation/power/tricks.txt b/Documentation/power/tricks.rst
similarity index 93%
rename from Documentation/power/tricks.txt
rename to Documentation/power/tricks.rst
index a1b8f7249f4c..ca787f142c3f 100644
--- a/Documentation/power/tricks.txt
+++ b/Documentation/power/tricks.rst
@@ -1,5 +1,7 @@
-	swsusp/S3 tricks
-	~~~~~~~~~~~~~~~~
+================
+swsusp/S3 tricks
+================
+
 Pavel Machek <pavel@ucw.cz>
 
 If you want to trick swsusp/S3 into working, you might want to try:
diff --git a/Documentation/power/userland-swsusp.txt b/Documentation/power/userland-swsusp.rst
similarity index 85%
rename from Documentation/power/userland-swsusp.txt
rename to Documentation/power/userland-swsusp.rst
index bbfcd1bbedc5..a0fa51bb1a4d 100644
--- a/Documentation/power/userland-swsusp.txt
+++ b/Documentation/power/userland-swsusp.rst
@@ -1,4 +1,7 @@
+=====================================================
 Documentation for userland software suspend interface
+=====================================================
+
 	(C) 2006 Rafael J. Wysocki <rjw@sisk.pl>
 
 First, the warnings at the beginning of swsusp.txt still apply.
@@ -30,13 +33,16 @@ called.
 
 The ioctl() commands recognized by the device are:
 
-SNAPSHOT_FREEZE - freeze user space processes (the current process is
+SNAPSHOT_FREEZE
+	freeze user space processes (the current process is
 	not frozen); this is required for SNAPSHOT_CREATE_IMAGE
 	and SNAPSHOT_ATOMIC_RESTORE to succeed
 
-SNAPSHOT_UNFREEZE - thaw user space processes frozen by SNAPSHOT_FREEZE
+SNAPSHOT_UNFREEZE
+	thaw user space processes frozen by SNAPSHOT_FREEZE
 
-SNAPSHOT_CREATE_IMAGE - create a snapshot of the system memory; the
+SNAPSHOT_CREATE_IMAGE
+	create a snapshot of the system memory; the
 	last argument of ioctl() should be a pointer to an int variable,
 	the value of which will indicate whether the call returned after
 	creating the snapshot (1) or after restoring the system memory state
@@ -45,48 +51,59 @@ SNAPSHOT_CREATE_IMAGE - create a snapshot of the system memory; the
 	has been created the read() operation can be used to transfer
 	it out of the kernel
 
-SNAPSHOT_ATOMIC_RESTORE - restore the system memory state from the
+SNAPSHOT_ATOMIC_RESTORE
+	restore the system memory state from the
 	uploaded snapshot image; before calling it you should transfer
 	the system memory snapshot back to the kernel using the write()
 	operation; this call will not succeed if the snapshot
 	image is not available to the kernel
 
-SNAPSHOT_FREE - free memory allocated for the snapshot image
+SNAPSHOT_FREE
+	free memory allocated for the snapshot image
 
-SNAPSHOT_PREF_IMAGE_SIZE - set the preferred maximum size of the image
+SNAPSHOT_PREF_IMAGE_SIZE
+	set the preferred maximum size of the image
 	(the kernel will do its best to ensure the image size will not exceed
 	this number, but if it turns out to be impossible, the kernel will
 	create the smallest image possible)
 
-SNAPSHOT_GET_IMAGE_SIZE - return the actual size of the hibernation image
+SNAPSHOT_GET_IMAGE_SIZE
+	return the actual size of the hibernation image
 
-SNAPSHOT_AVAIL_SWAP_SIZE - return the amount of available swap in bytes (the
+SNAPSHOT_AVAIL_SWAP_SIZE
+	return the amount of available swap in bytes (the
 	last argument should be a pointer to an unsigned int variable that will
 	contain the result if the call is successful).
 
-SNAPSHOT_ALLOC_SWAP_PAGE - allocate a swap page from the resume partition
+SNAPSHOT_ALLOC_SWAP_PAGE
+	allocate a swap page from the resume partition
 	(the last argument should be a pointer to a loff_t variable that
 	will contain the swap page offset if the call is successful)
 
-SNAPSHOT_FREE_SWAP_PAGES - free all swap pages allocated by
+SNAPSHOT_FREE_SWAP_PAGES
+	free all swap pages allocated by
 	SNAPSHOT_ALLOC_SWAP_PAGE
 
-SNAPSHOT_SET_SWAP_AREA - set the resume partition and the offset (in <PAGE_SIZE>
+SNAPSHOT_SET_SWAP_AREA
+	set the resume partition and the offset (in <PAGE_SIZE>
 	units) from the beginning of the partition at which the swap header is
 	located (the last ioctl() argument should point to a struct
 	resume_swap_area, as defined in kernel/power/suspend_ioctls.h,
 	containing the resume device specification and the offset); for swap
 	partitions the offset is always 0, but it is different from zero for
-	swap files (see Documentation/power/swsusp-and-swap-files.txt for
+	swap files (see Documentation/power/swsusp-and-swap-files.rst for
 	details).
 
-SNAPSHOT_PLATFORM_SUPPORT - enable/disable the hibernation platform support,
+SNAPSHOT_PLATFORM_SUPPORT
+	enable/disable the hibernation platform support,
 	depending on the argument value (enable, if the argument is nonzero)
 
-SNAPSHOT_POWER_OFF - make the kernel transition the system to the hibernation
+SNAPSHOT_POWER_OFF
+	make the kernel transition the system to the hibernation
 	state (eg. ACPI S4) using the platform (eg. ACPI) driver
 
-SNAPSHOT_S2RAM - suspend to RAM; using this call causes the kernel to
+SNAPSHOT_S2RAM
+	suspend to RAM; using this call causes the kernel to
 	immediately enter the suspend-to-RAM state, so this call must always
 	be preceded by the SNAPSHOT_FREEZE call and it is also necessary
 	to use the SNAPSHOT_UNFREEZE call after the system wakes up.  This call
@@ -98,10 +115,11 @@ SNAPSHOT_S2RAM - suspend to RAM; using this call causes the kernel to
 
 The device's read() operation can be used to transfer the snapshot image from
 the kernel.  It has the following limitations:
+
 - you cannot read() more than one virtual memory page at a time
 - read()s across page boundaries are impossible (ie. if you read() 1/2 of
-	a page in the previous call, you will only be able to read()
-	_at_ _most_ 1/2 of the page in the next call)
+  a page in the previous call, you will only be able to read()
+  **at most** 1/2 of the page in the next call)
 
 The device's write() operation is used for uploading the system memory snapshot
 into the kernel.  It has the same limitations as the read() operation.
@@ -143,8 +161,10 @@ preferably using mlockall(), before calling SNAPSHOT_FREEZE.
 The suspending utility MUST check the value stored by SNAPSHOT_CREATE_IMAGE
 in the memory location pointed to by the last argument of ioctl() and proceed
 in accordance with it:
+
 1. 	If the value is 1 (ie. the system memory snapshot has just been
 	created and the system is ready for saving it):
+
 	(a)	The suspending utility MUST NOT close the snapshot device
 		_unless_ the whole suspend procedure is to be cancelled, in
 		which case, if the snapshot image has already been saved, the
@@ -158,6 +178,7 @@ in accordance with it:
 		called.  However, it MAY mount a file system that was not
 		mounted at that time and perform some operations on it (eg.
 		use it for saving the image).
+
 2.	If the value is 0 (ie. the system state has just been restored from
 	the snapshot image), the suspending utility MUST close the snapshot
 	device.  Afterwards it will be treated as a regular userland process,
diff --git a/Documentation/power/video.txt b/Documentation/power/video.rst
similarity index 56%
rename from Documentation/power/video.txt
rename to Documentation/power/video.rst
index 3e6272bc4472..337a2ba9f32f 100644
--- a/Documentation/power/video.txt
+++ b/Documentation/power/video.rst
@@ -1,7 +1,8 @@
+===========================
+Video issues with S3 resume
+===========================
 
-		Video issues with S3 resume
-		~~~~~~~~~~~~~~~~~~~~~~~~~~~
-		  2003-2006, Pavel Machek
+2003-2006, Pavel Machek
 
 During S3 resume, hardware needs to be reinitialized. For most
 devices, this is easy, and kernel driver knows how to do
@@ -41,37 +42,37 @@ There are a few types of systems where video works after S3 resume:
 (1) systems where video state is preserved over S3.
 
 (2) systems where it is possible to call the video BIOS during S3
-  resume. Unfortunately, it is not correct to call the video BIOS at
-  that point, but it happens to work on some machines. Use
-  acpi_sleep=s3_bios.
+    resume. Unfortunately, it is not correct to call the video BIOS at
+    that point, but it happens to work on some machines. Use
+    acpi_sleep=s3_bios.
 
 (3) systems that initialize video card into vga text mode and where
-  the BIOS works well enough to be able to set video mode. Use
-  acpi_sleep=s3_mode on these.
+    the BIOS works well enough to be able to set video mode. Use
+    acpi_sleep=s3_mode on these.
 
 (4) on some systems s3_bios kicks video into text mode, and
-  acpi_sleep=s3_bios,s3_mode is needed.
+    acpi_sleep=s3_bios,s3_mode is needed.
 
 (5) radeon systems, where X can soft-boot your video card. You'll need
-  a new enough X, and a plain text console (no vesafb or radeonfb). See
-  http://www.doesi.gmxhome.de/linux/tm800s3/s3.html for more information.
-  Alternatively, you should use vbetool (6) instead.
+    a new enough X, and a plain text console (no vesafb or radeonfb). See
+    http://www.doesi.gmxhome.de/linux/tm800s3/s3.html for more information.
+    Alternatively, you should use vbetool (6) instead.
 
 (6) other radeon systems, where vbetool is enough to bring system back
-  to life. It needs text console to be working. Do vbetool vbestate
-  save > /tmp/delme; echo 3 > /proc/acpi/sleep; vbetool post; vbetool
-  vbestate restore < /tmp/delme; setfont <whatever>, and your video
-  should work.
+    to life. It needs text console to be working. Do vbetool vbestate
+    save > /tmp/delme; echo 3 > /proc/acpi/sleep; vbetool post; vbetool
+    vbestate restore < /tmp/delme; setfont <whatever>, and your video
+    should work.
 
 (7) on some systems, it is possible to boot most of kernel, and then
-  POSTing bios works. Ole Rohne has patch to do just that at
-  http://dev.gentoo.org/~marineam/patch-radeonfb-2.6.11-rc2-mm2.
+    POSTing bios works. Ole Rohne has patch to do just that at
+    http://dev.gentoo.org/~marineam/patch-radeonfb-2.6.11-rc2-mm2.
 
-(8) on some systems, you can use the video_post utility and or 
-  do echo 3 > /sys/power/state  && /usr/sbin/video_post - which will 
-  initialize the display in console mode. If you are in X, you can switch
-  to a virtual terminal and back to X using  CTRL+ALT+F1 - CTRL+ALT+F7 to get
-  the display working in graphical mode again.
+(8) on some systems, you can use the video_post utility and or
+    do echo 3 > /sys/power/state  && /usr/sbin/video_post - which will
+    initialize the display in console mode. If you are in X, you can switch
+    to a virtual terminal and back to X using  CTRL+ALT+F1 - CTRL+ALT+F7 to get
+    the display working in graphical mode again.
 
 Now, if you pass acpi_sleep=something, and it does not work with your
 bios, you'll get a hard crash during resume. Be careful. Also it is
@@ -87,99 +88,126 @@ chance of working.
 
 Table of known working notebooks:
 
+
+=============================== ===============================================
 Model                           hack (or "how to do it")
-------------------------------------------------------------------------------
+=============================== ===============================================
 Acer Aspire 1406LC		ole's late BIOS init (7), turn off DRI
 Acer TM 230			s3_bios (2)
 Acer TM 242FX			vbetool (6)
 Acer TM C110			video_post (8)
-Acer TM C300                    vga=normal (only suspend on console, not in X), vbetool (6) or video_post (8)
+Acer TM C300                    vga=normal (only suspend on console, not in X),
+				vbetool (6) or video_post (8)
 Acer TM 4052LCi		        s3_bios (2)
 Acer TM 636Lci			s3_bios,s3_mode (4)
-Acer TM 650 (Radeon M7)		vga=normal plus boot-radeon (5) gets text console back
-Acer TM 660			??? (*)
-Acer TM 800			vga=normal, X patches, see webpage (5) or vbetool (6)
-Acer TM 803			vga=normal, X patches, see webpage (5) or vbetool (6)
+Acer TM 650 (Radeon M7)		vga=normal plus boot-radeon (5) gets text
+				console back
+Acer TM 660			??? [#f1]_
+Acer TM 800			vga=normal, X patches, see webpage (5)
+				or vbetool (6)
+Acer TM 803			vga=normal, X patches, see webpage (5)
+				or vbetool (6)
 Acer TM 803LCi			vga=normal, vbetool (6)
 Arima W730a			vbetool needed (6)
-Asus L2400D                     s3_mode (3)(***) (S1 also works OK)
+Asus L2400D                     s3_mode (3) [#f2]_ (S1 also works OK)
 Asus L3350M (SiS 740)           (6)
 Asus L3800C (Radeon M7)		s3_bios (2) (S1 also works OK)
-Asus M6887Ne			vga=normal, s3_bios (2), use radeon driver instead of fglrx in x.org
+Asus M6887Ne			vga=normal, s3_bios (2), use radeon driver
+				instead of fglrx in x.org
 Athlon64 desktop prototype	s3_bios (2)
-Compal CL-50			??? (*)
+Compal CL-50			??? [#f1]_
 Compaq Armada E500 - P3-700     none (1) (S1 also works OK)
 Compaq Evo N620c		vga=normal, s3_bios (2)
 Dell 600m, ATI R250 Lf		none (1), but needs xorg-x11-6.8.1.902-1
 Dell D600, ATI RV250            vga=normal and X, or try vbestate (6)
-Dell D610			vga=normal and X (possibly vbestate (6) too, but not tested)
-Dell Inspiron 4000		??? (*)
-Dell Inspiron 500m		??? (*)
+Dell D610			vga=normal and X (possibly vbestate (6) too,
+				but not tested)
+Dell Inspiron 4000		??? [#f1]_
+Dell Inspiron 500m		??? [#f1]_
 Dell Inspiron 510m		???
 Dell Inspiron 5150		vbetool needed (6)
-Dell Inspiron 600m		??? (*)
-Dell Inspiron 8200		??? (*)
-Dell Inspiron 8500		??? (*)
-Dell Inspiron 8600		??? (*)
-eMachines athlon64 machines	vbetool needed (6) (someone please get me model #s)
-HP NC6000			s3_bios, may not use radeonfb (2); or vbetool (6)
-HP NX7000			??? (*)
-HP Pavilion ZD7000		vbetool post needed, need open-source nv driver for X
+Dell Inspiron 600m		??? [#f1]_
+Dell Inspiron 8200		??? [#f1]_
+Dell Inspiron 8500		??? [#f1]_
+Dell Inspiron 8600		??? [#f1]_
+eMachines athlon64 machines	vbetool needed (6) (someone please get
+				me model #s)
+HP NC6000			s3_bios, may not use radeonfb (2);
+				or vbetool (6)
+HP NX7000			??? [#f1]_
+HP Pavilion ZD7000		vbetool post needed, need open-source nv
+				driver for X
 HP Omnibook XE3	athlon version	none (1)
 HP Omnibook XE3GC		none (1), video is S3 Savage/IX-MV
 HP Omnibook XE3L-GF		vbetool (6)
 HP Omnibook 5150		none (1), (S1 also works OK)
-IBM TP T20, model 2647-44G	none (1), video is S3 Inc. 86C270-294 Savage/IX-MV, vesafb gets "interesting" but X work.
-IBM TP A31 / Type 2652-M5G      s3_mode (3) [works ok with BIOS 1.04 2002-08-23, but not at all with BIOS 1.11 2004-11-05 :-(]
+IBM TP T20, model 2647-44G	none (1), video is S3 Inc. 86C270-294
+				Savage/IX-MV, vesafb gets "interesting"
+				but X work.
+IBM TP A31 / Type 2652-M5G      s3_mode (3) [works ok with
+				BIOS 1.04 2002-08-23, but not at all with
+				BIOS 1.11 2004-11-05 :-(]
 IBM TP R32 / Type 2658-MMG      none (1)
-IBM TP R40 2722B3G		??? (*)
+IBM TP R40 2722B3G		??? [#f1]_
 IBM TP R50p / Type 1832-22U     s3_bios (2)
 IBM TP R51			none (1)
-IBM TP T30	236681A		??? (*)
+IBM TP T30	236681A		??? [#f1]_
 IBM TP T40 / Type 2373-MU4      none (1)
 IBM TP T40p			none (1)
 IBM TP R40p			s3_bios (2)
 IBM TP T41p			s3_bios (2), switch to X after resume
 IBM TP T42			s3_bios (2)
 IBM ThinkPad T42p (2373-GTG)	s3_bios (2)
-IBM TP X20			??? (*)
+IBM TP X20			??? [#f1]_
 IBM TP X30			s3_bios, s3_mode (4)
-IBM TP X31 / Type 2672-XXH      none (1), use radeontool (http://fdd.com/software/radeon/) to turn off backlight.
-IBM TP X32			none (1), but backlight is on and video is trashed after long suspend. s3_bios,s3_mode (4) works too. Perhaps that gets better results?
+IBM TP X31 / Type 2672-XXH      none (1), use radeontool
+				(http://fdd.com/software/radeon/) to
+				turn off backlight.
+IBM TP X32			none (1), but backlight is on and video is
+				trashed after long suspend. s3_bios,
+				s3_mode (4) works too. Perhaps that gets
+				better results?
 IBM Thinkpad X40 Type 2371-7JG  s3_bios,s3_mode (4)
-IBM TP 600e			none(1), but a switch to console and back to X is needed
-Medion MD4220			??? (*)
+IBM TP 600e			none(1), but a switch to console and
+				back to X is needed
+Medion MD4220			??? [#f1]_
 Samsung P35			vbetool needed (6)
 Sharp PC-AR10 (ATI rage)	none (1), backlight does not switch off
 Sony Vaio PCG-C1VRX/K		s3_bios (2)
-Sony Vaio PCG-F403		??? (*)
+Sony Vaio PCG-F403		??? [#f1]_
 Sony Vaio PCG-GRT995MP		none (1), works with 'nv' X driver
-Sony Vaio PCG-GR7/K		none (1), but needs radeonfb, use radeontool (http://fdd.com/software/radeon/) to turn off backlight.
-Sony Vaio PCG-N505SN		??? (*)
+Sony Vaio PCG-GR7/K		none (1), but needs radeonfb, use
+				radeontool (http://fdd.com/software/radeon/)
+				to turn off backlight.
+Sony Vaio PCG-N505SN		??? [#f1]_
 Sony Vaio vgn-s260		X or boot-radeon can init it (5)
-Sony Vaio vgn-S580BH		vga=normal, but suspend from X. Console will be blank unless you return to X.
+Sony Vaio vgn-S580BH		vga=normal, but suspend from X. Console will
+				be blank unless you return to X.
 Sony Vaio vgn-FS115B		s3_bios (2),s3_mode (4)
 Toshiba Libretto L5		none (1)
 Toshiba Libretto 100CT/110CT    vbetool (6)
 Toshiba Portege 3020CT		s3_mode (3)
 Toshiba Satellite 4030CDT	s3_mode (3) (S1 also works OK)
 Toshiba Satellite 4080XCDT      s3_mode (3) (S1 also works OK)
-Toshiba Satellite 4090XCDT      ??? (*)
-Toshiba Satellite P10-554       s3_bios,s3_mode (4)(****)
+Toshiba Satellite 4090XCDT      ??? [#f1]_
+Toshiba Satellite P10-554       s3_bios,s3_mode (4)[#f3]_
 Toshiba M30                     (2) xor X with nvidia driver using internal AGP
-Uniwill 244IIO			??? (*)
+Uniwill 244IIO			??? [#f1]_
+=============================== ===============================================
 
 Known working desktop systems
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
+=================== ============================= ========================
 Mainboard	    Graphics card                 hack (or "how to do it")
-------------------------------------------------------------------------------
+=================== ============================= ========================
 Asus A7V8X	    nVidia RIVA TNT2 model 64	  s3_bios,s3_mode (4)
+=================== ============================= ========================
 
 
-(*) from https://wiki.ubuntu.com/HoaryPMResults, not sure
-    which options to use. If you know, please tell me.
+.. [#f1] from https://wiki.ubuntu.com/HoaryPMResults, not sure
+         which options to use. If you know, please tell me.
 
-(***) To be tested with a newer kernel.
+.. [#f2] To be tested with a newer kernel.
 
-(****) Not with SMP kernel, UP only.
+.. [#f3] Not with SMP kernel, UP only.
diff --git a/Documentation/process/submitting-drivers.rst b/Documentation/process/submitting-drivers.rst
index 58bc047e7b95..1acaa14903d6 100644
--- a/Documentation/process/submitting-drivers.rst
+++ b/Documentation/process/submitting-drivers.rst
@@ -117,7 +117,7 @@ PM support:
 		implemented") error.  You should also try to make sure that your
 		driver uses as little power as possible when it's not doing
 		anything.  For the driver testing instructions see
-		Documentation/power/drivers-testing.txt and for a relatively
+		Documentation/power/drivers-testing.rst and for a relatively
 		complete overview of the power management issues related to
 		drivers see :ref:`Documentation/driver-api/pm/devices.rst <driverapi_pm_devices>`.
 
diff --git a/Documentation/scheduler/sched-energy.txt b/Documentation/scheduler/sched-energy.txt
index 197d81f4b836..d97207b9accb 100644
--- a/Documentation/scheduler/sched-energy.txt
+++ b/Documentation/scheduler/sched-energy.txt
@@ -22,7 +22,7 @@ the highest.
 
 The actual EM used by EAS is _not_ maintained by the scheduler, but by a
 dedicated framework. For details about this framework and what it provides,
-please refer to its documentation (see Documentation/power/energy-model.txt).
+please refer to its documentation (see Documentation/power/energy-model.rst).
 
 
 2. Background and Terminology
@@ -81,7 +81,7 @@ through the arch_scale_cpu_capacity() callback.
 
 The rest of platform knowledge used by EAS is directly read from the Energy
 Model (EM) framework. The EM of a platform is composed of a power cost table
-per 'performance domain' in the system (see Documentation/power/energy-model.txt
+per 'performance domain' in the system (see Documentation/power/energy-model.rst
 for futher details about performance domains).
 
 The scheduler manages references to the EM objects in the topology code when the
@@ -352,7 +352,7 @@ could be amended in the future if proven otherwise.
 EAS uses the EM of a platform to estimate the impact of scheduling decisions on
 energy. So, your platform must provide power cost tables to the EM framework in
 order to make EAS start. To do so, please refer to documentation of the
-independent EM framework in Documentation/power/energy-model.txt.
+independent EM framework in Documentation/power/energy-model.rst.
 
 Please also note that the scheduling domains need to be re-built after the
 EM has been registered in order to start EAS.
diff --git a/Documentation/trace/coresight-cpu-debug.txt b/Documentation/trace/coresight-cpu-debug.txt
index f07e38094b40..1a660a39e3c0 100644
--- a/Documentation/trace/coresight-cpu-debug.txt
+++ b/Documentation/trace/coresight-cpu-debug.txt
@@ -151,7 +151,7 @@ At the runtime you can disable idle states with below methods:
 
 It is possible to disable CPU idle states by way of the PM QoS
 subsystem, more specifically by using the "/dev/cpu_dma_latency"
-interface (see Documentation/power/pm_qos_interface.txt for more
+interface (see Documentation/power/pm_qos_interface.rst for more
 details).  As specified in the PM QoS documentation the requested
 parameter will stay in effect until the file descriptor is released.
 For example:
diff --git a/Documentation/translations/zh_CN/process/submitting-drivers.rst b/Documentation/translations/zh_CN/process/submitting-drivers.rst
index 72c6cd935821..f1c3906c69a8 100644
--- a/Documentation/translations/zh_CN/process/submitting-drivers.rst
+++ b/Documentation/translations/zh_CN/process/submitting-drivers.rst
@@ -97,7 +97,7 @@ Linux 2.6:
 		函数定义成返回 -ENOSYS（功能未实现）错误。你还应该尝试确
 		保你的驱动在什么都不干的情况下将耗电降到最低。要获得驱动
 		程序测试的指导，请参阅
-		Documentation/power/drivers-testing.txt。有关驱动程序电
+		Documentation/power/drivers-testing.rst。有关驱动程序电
 		源管理问题相对全面的概述，请参阅
 		Documentation/driver-api/pm/devices.rst。
 
diff --git a/MAINTAINERS b/MAINTAINERS
index cc11aea722c8..65448dae1467 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6478,7 +6478,7 @@ M:	"Rafael J. Wysocki" <rjw@rjwysocki.net>
 M:	Pavel Machek <pavel@ucw.cz>
 L:	linux-pm@vger.kernel.org
 S:	Supported
-F:	Documentation/power/freezing-of-tasks.txt
+F:	Documentation/power/freezing-of-tasks.rst
 F:	include/linux/freezer.h
 F:	kernel/freezer.c
 
@@ -11804,7 +11804,7 @@ S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/vireshk/pm.git
 F:	drivers/opp/
 F:	include/linux/pm_opp.h
-F:	Documentation/power/opp.txt
+F:	Documentation/power/opp.rst
 F:	Documentation/devicetree/bindings/opp/
 
 OPL4 DRIVER
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 2057254c6c8a..420d488822b4 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2447,7 +2447,7 @@ menuconfig APM
 	  machines with more than one CPU.
 
 	  In order to use APM, you will need supporting software. For location
-	  and more information, read <file:Documentation/power/apm-acpi.txt>
+	  and more information, read <file:Documentation/power/apm-acpi.rst>
 	  and the Battery Powered Linux mini-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index dfe4b11ee423..79072c44a873 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1069,7 +1069,7 @@ struct skl_wm_params {
  * to be disabled. This shouldn't happen and we'll print some error messages in
  * case it happens.
  *
- * For more, read the Documentation/power/runtime_pm.txt.
+ * For more, read the Documentation/power/runtime_pm.rst.
  */
 struct i915_runtime_pm {
 	atomic_t wakeref_count;
diff --git a/drivers/opp/Kconfig b/drivers/opp/Kconfig
index fe54d349d2e1..35dfc7e80f92 100644
--- a/drivers/opp/Kconfig
+++ b/drivers/opp/Kconfig
@@ -11,4 +11,4 @@ config PM_OPP
 	  OPP layer organizes the data internally using device pointers
 	  representing individual voltage domains and provides SOC
 	  implementations a ready to use framework to manage OPPs.
-	  For more information, read <file:Documentation/power/opp.txt>
+	  For more information, read <file:Documentation/power/opp.rst>
diff --git a/drivers/power/supply/power_supply_core.c b/drivers/power/supply/power_supply_core.c
index 136e8f64848a..b55cdfe22a2e 100644
--- a/drivers/power/supply/power_supply_core.c
+++ b/drivers/power/supply/power_supply_core.c
@@ -606,7 +606,7 @@ int power_supply_get_battery_info(struct power_supply *psy,
 
 	/* The property and field names below must correspond to elements
 	 * in enum power_supply_property. For reasoning, see
-	 * Documentation/power/power_supply_class.txt.
+	 * Documentation/power/power_supply_class.rst.
 	 */
 
 	of_property_read_u32(battery_np, "energy-full-design-microwatt-hours",
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index c7eef32e7739..5b8328a99b2a 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -52,7 +52,7 @@
  *                irq line disabled until the threaded handler has been run.
  * IRQF_NO_SUSPEND - Do not disable this IRQ during suspend.  Does not guarantee
  *                   that this interrupt will wake the system from a suspended
- *                   state.  See Documentation/power/suspend-and-interrupts.txt
+ *                   state.  See Documentation/power/suspend-and-interrupts.rst
  * IRQF_FORCE_RESUME - Force enable it on resume even if IRQF_NO_SUSPEND is set
  * IRQF_NO_THREAD - Interrupt cannot be threaded
  * IRQF_EARLY_RESUME - Resume IRQ early during syscore instead of at device
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 44d254548ca7..41c5673aba2f 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -808,7 +808,7 @@ struct module;
  * @suspend_late: Put device into low power state.
  * @resume_early: Wake device from low power state.
  * @resume:	Wake device from low power state.
- *		(Please see Documentation/power/pci.txt for descriptions
+ *		(Please see Documentation/power/pci.rst for descriptions
  *		of PCI Power Management and the related functions.)
  * @shutdown:	Hook into reboot_notifier_list (kernel/sys.c).
  *		Intended to stop any idling DMA operations.
diff --git a/include/linux/pm.h b/include/linux/pm.h
index 345d74a727e3..220e2008467d 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -271,7 +271,7 @@ typedef struct pm_message {
  * actions to be performed by a device driver's callbacks generally depend on
  * the platform and subsystem the device belongs to.
  *
- * Refer to Documentation/power/runtime_pm.txt for more information about the
+ * Refer to Documentation/power/runtime_pm.rst for more information about the
  * role of the @runtime_suspend(), @runtime_resume() and @runtime_idle()
  * callbacks in device runtime power management.
  */
diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index ff8592ddedee..d3667b4075c1 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -66,7 +66,7 @@ config HIBERNATION
 	  need to run mkswap against the swap partition used for the suspend.
 
 	  It also works with swap files to a limited extent (for details see
-	  <file:Documentation/power/swsusp-and-swap-files.txt>).
+	  <file:Documentation/power/swsusp-and-swap-files.rst>).
 
 	  Right now you may boot without resuming and resume later but in the
 	  meantime you cannot use the swap partition(s)/file(s) involved in
@@ -75,7 +75,7 @@ config HIBERNATION
 	  MOUNT any journaled filesystems mounted before the suspend or they
 	  will get corrupted in a nasty way.
 
-	  For more information take a look at <file:Documentation/power/swsusp.txt>.
+	  For more information take a look at <file:Documentation/power/swsusp.rst>.
 
 config ARCH_SAVE_PAGE_KEYS
 	bool
@@ -256,7 +256,7 @@ config APM_EMULATION
 	  notification of APM "events" (e.g. battery status change).
 
 	  In order to use APM, you will need supporting software. For location
-	  and more information, read <file:Documentation/power/apm-acpi.txt>
+	  and more information, read <file:Documentation/power/apm-acpi.rst>
 	  and the Battery Powered Linux mini-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index 6310ddede220..cc70f5932773 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -166,7 +166,7 @@ config CFG80211_DEFAULT_PS
 
 	  If this causes your applications to misbehave you should fix your
 	  applications instead -- they need to register their network
-	  latency requirement, see Documentation/power/pm_qos_interface.txt.
+	  latency requirement, see Documentation/power/pm_qos_interface.rst.
 
 config CFG80211_DEBUGFS
 	bool "cfg80211 DebugFS entries"
-- 
2.21.0

