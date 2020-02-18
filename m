Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10B5E162C07
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 18:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbgBRRNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 12:13:44 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:34869 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727727AbgBRRNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 12:13:42 -0500
Received: by mail-ot1-f65.google.com with SMTP id r16so20278718otd.2;
        Tue, 18 Feb 2020 09:13:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FoqaseM22NqKzdP6diWbwHzzLAglDjPvVApnWfidhno=;
        b=cVH/YljX8Fkq2glbR+L1DlM9yhbPK0scnU/5LTLA5XkubLGU8P23KmW/yU8PSbXXuT
         kEz/+jI7IYaGu1/kI1WHtiMHqBAxM+jG4gvzaplsQrjJv5snxsdW69BsvD1o1K+udpSp
         1i+tilKQsTu1Yqgem8z+zPgmy8GYDcMLgdNb2Za90ouceJT9W9EVMRL4JSPYDjJX0KKe
         XDMk3WnKcPmOXCDCnYOPqi4AMUZ7hO6/u9WYvu9TeC624hz8W06GnxqpYKYLVSXpoDtZ
         Qau8/bQlxCkcpqlqt6XY6qL0UEVdjtK3iQYXP+J3xcpChDmddLuFbgzrZTa7mBd/XezD
         Nw0Q==
X-Gm-Message-State: APjAAAU/Bo3DNEb119gvRHV8oWRbfH0a9rj1BfKSzYyN9+v515fXluYZ
        XVHIKwobc9LDb0NXKoSlaw==
X-Google-Smtp-Source: APXvYqw4vgSmdpsSYxMVMymSrQmGp8BN32RULVNjVRuf9KGXenrEyhdhKj6dTUd1/cfRh69w0KzQXA==
X-Received: by 2002:a9d:de9:: with SMTP id 96mr16562460ots.222.1582046020074;
        Tue, 18 Feb 2020 09:13:40 -0800 (PST)
Received: from xps15.herring.priv (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.googlemail.com with ESMTPSA id y25sm1545755oto.27.2020.02.18.09.13.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 09:13:39 -0800 (PST)
From:   Rob Herring <robh@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        soc@kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Robert Richter <rrichter@marvell.com>,
        Jon Loeliger <jdl@jdl.com>, Alexander Graf <graf@amazon.com>,
        Matthias Brugger <mbrugger@suse.com>,
        Mark Langsdorf <mlangsdo@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org,
        James Morse <james.morse@arm.com>,
        Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
        kvm@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        netdev@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Robin Murphy <robin.murphy@arm.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Will Deacon <will@kernel.org>
Subject: [RFC PATCH 10/11] ARM: dts: Remove Calxeda platforms
Date:   Tue, 18 Feb 2020 11:13:20 -0600
Message-Id: <20200218171321.30990-11-robh@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200218171321.30990-1-robh@kernel.org>
References: <20200218171321.30990-1-robh@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cc: devicetree@vger.kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
---
 arch/arm/boot/dts/Makefile        |   3 -
 arch/arm/boot/dts/ecx-2000.dts    | 103 -------------
 arch/arm/boot/dts/ecx-common.dtsi | 230 ------------------------------
 arch/arm/boot/dts/highbank.dts    | 161 ---------------------
 4 files changed, 497 deletions(-)
 delete mode 100644 arch/arm/boot/dts/ecx-2000.dts
 delete mode 100644 arch/arm/boot/dts/ecx-common.dtsi
 delete mode 100644 arch/arm/boot/dts/highbank.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index d6546d2676b9..a78da2e25966 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -224,9 +224,6 @@ dtb-$(CONFIG_ARCH_GEMINI) += \
 	gemini-wbd222.dtb
 dtb-$(CONFIG_ARCH_HI3xxx) += \
 	hi3620-hi4511.dtb
-dtb-$(CONFIG_ARCH_HIGHBANK) += \
-	highbank.dtb \
-	ecx-2000.dtb
 dtb-$(CONFIG_ARCH_HIP01) += \
 	hip01-ca9x2.dtb
 dtb-$(CONFIG_ARCH_HIP04) += \
diff --git a/arch/arm/boot/dts/ecx-2000.dts b/arch/arm/boot/dts/ecx-2000.dts
deleted file mode 100644
index 5651ae6dc969..000000000000
--- a/arch/arm/boot/dts/ecx-2000.dts
+++ /dev/null
@@ -1,103 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Copyright 2011-2012 Calxeda, Inc.
- */
-
-/dts-v1/;
-
-/* First 4KB has pen for secondary cores. */
-/memreserve/ 0x00000000 0x0001000;
-
-/ {
-	model = "Calxeda ECX-2000";
-	compatible = "calxeda,ecx-2000";
-	#address-cells = <2>;
-	#size-cells = <2>;
-	clock-ranges;
-
-	cpus {
-		#address-cells = <1>;
-		#size-cells = <0>;
-
-		cpu@0 {
-			compatible = "arm,cortex-a15";
-			device_type = "cpu";
-			reg = <0>;
-			clocks = <&a9pll>;
-			clock-names = "cpu";
-		};
-
-		cpu@1 {
-			compatible = "arm,cortex-a15";
-			device_type = "cpu";
-			reg = <1>;
-			clocks = <&a9pll>;
-			clock-names = "cpu";
-		};
-
-		cpu@2 {
-			compatible = "arm,cortex-a15";
-			device_type = "cpu";
-			reg = <2>;
-			clocks = <&a9pll>;
-			clock-names = "cpu";
-		};
-
-		cpu@3 {
-			compatible = "arm,cortex-a15";
-			device_type = "cpu";
-			reg = <3>;
-			clocks = <&a9pll>;
-			clock-names = "cpu";
-		};
-	};
-
-	memory@0 {
-		name = "memory";
-		device_type = "memory";
-		reg = <0x00000000 0x00000000 0x00000000 0xff800000>;
-	};
-
-	memory@200000000 {
-		name = "memory";
-		device_type = "memory";
-		reg = <0x00000002 0x00000000 0x00000003 0x00000000>;
-	};
-
-	soc {
-		ranges = <0x00000000 0x00000000 0x00000000 0xffffffff>;
-
-		timer {
-			compatible = "arm,cortex-a15-timer", "arm,armv7-timer"; 			interrupts = <1 13 0xf08>,
-				<1 14 0xf08>,
-				<1 11 0xf08>,
-				<1 10 0xf08>;
-		};
-
-		memory-controller@fff00000 {
-			compatible = "calxeda,ecx-2000-ddr-ctrl";
-			reg = <0xfff00000 0x1000>;
-			interrupts = <0 91 4>;
-		};
-
-		intc: interrupt-controller@fff11000 {
-			compatible = "arm,cortex-a15-gic";
-			#interrupt-cells = <3>;
-			#size-cells = <0>;
-			#address-cells = <1>;
-			interrupt-controller;
-			interrupts = <1 9 0xf04>;
-			reg = <0xfff11000 0x1000>,
-			      <0xfff12000 0x2000>,
-			      <0xfff14000 0x2000>,
-			      <0xfff16000 0x2000>;
-		};
-
-		pmu {
-			compatible = "arm,cortex-a9-pmu";
-			interrupts = <0 76 4  0 75 4  0 74 4  0 73 4>;
-		};
-	};
-};
-
-/include/ "ecx-common.dtsi"
diff --git a/arch/arm/boot/dts/ecx-common.dtsi b/arch/arm/boot/dts/ecx-common.dtsi
deleted file mode 100644
index 66ee1d34f72b..000000000000
--- a/arch/arm/boot/dts/ecx-common.dtsi
+++ /dev/null
@@ -1,230 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Copyright 2011-2012 Calxeda, Inc.
- */
-
-/ {
-	chosen {
-		bootargs = "console=ttyAMA0";
-	};
-
-	psci {
-		compatible	= "arm,psci";
-		method		= "smc";
-		cpu_suspend	= <0x84000002>;
-		cpu_off		= <0x84000004>;
-		cpu_on		= <0x84000006>;
-	};
-
-	soc {
-		#address-cells = <1>;
-		#size-cells = <1>;
-		compatible = "simple-bus";
-		interrupt-parent = <&intc>;
-
-		sata@ffe08000 {
-			compatible = "calxeda,hb-ahci";
-			reg = <0xffe08000 0x10000>;
-			interrupts = <0 83 4>;
-			dma-coherent;
-			calxeda,port-phys = <&combophy5 0 &combophy0 0
-					     &combophy0 1 &combophy0 2
-					     &combophy0 3>;
-			calxeda,sgpio-gpio =<&gpioh 5 1 &gpioh 6 1 &gpioh 7 1>;
-			calxeda,led-order = <4 0 1 2 3>;
-		};
-
-		sdhci@ffe0e000 {
-			compatible = "calxeda,hb-sdhci";
-			reg = <0xffe0e000 0x1000>;
-			interrupts = <0 90 4>;
-			clocks = <&eclk>;
-			status = "disabled";
-		};
-
-		ipc@fff20000 {
-			compatible = "arm,pl320", "arm,primecell";
-			reg = <0xfff20000 0x1000>;
-			interrupts = <0 7 4>;
-			clocks = <&pclk>;
-			clock-names = "apb_pclk";
-		};
-
-		gpioe: gpio@fff30000 {
-			#gpio-cells = <2>;
-			compatible = "arm,pl061", "arm,primecell";
-			gpio-controller;
-			reg = <0xfff30000 0x1000>;
-			interrupts = <0 14 4>;
-			clocks = <&pclk>;
-			clock-names = "apb_pclk";
-			status = "disabled";
-		};
-
-		gpiof: gpio@fff31000 {
-			#gpio-cells = <2>;
-			compatible = "arm,pl061", "arm,primecell";
-			gpio-controller;
-			reg = <0xfff31000 0x1000>;
-			interrupts = <0 15 4>;
-			clocks = <&pclk>;
-			clock-names = "apb_pclk";
-			status = "disabled";
-		};
-
-		gpiog: gpio@fff32000 {
-			#gpio-cells = <2>;
-			compatible = "arm,pl061", "arm,primecell";
-			gpio-controller;
-			reg = <0xfff32000 0x1000>;
-			interrupts = <0 16 4>;
-			clocks = <&pclk>;
-			clock-names = "apb_pclk";
-			status = "disabled";
-		};
-
-		gpioh: gpio@fff33000 {
-			#gpio-cells = <2>;
-			compatible = "arm,pl061", "arm,primecell";
-			gpio-controller;
-			reg = <0xfff33000 0x1000>;
-			interrupts = <0 17 4>;
-			clocks = <&pclk>;
-			clock-names = "apb_pclk";
-			status = "disabled";
-		};
-
-		timer@fff34000 {
-			compatible = "arm,sp804", "arm,primecell";
-			reg = <0xfff34000 0x1000>;
-			interrupts = <0 18 4>;
-			clocks = <&pclk>;
-			clock-names = "apb_pclk";
-		};
-
-		rtc@fff35000 {
-			compatible = "arm,pl031", "arm,primecell";
-			reg = <0xfff35000 0x1000>;
-			interrupts = <0 19 4>;
-			clocks = <&pclk>;
-			clock-names = "apb_pclk";
-		};
-
-		serial@fff36000 {
-			compatible = "arm,pl011", "arm,primecell";
-			reg = <0xfff36000 0x1000>;
-			interrupts = <0 20 4>;
-			clocks = <&pclk>;
-			clock-names = "apb_pclk";
-		};
-
-		smic@fff3a000 {
-			compatible = "ipmi-smic";
-			device_type = "ipmi";
-			reg = <0xfff3a000 0x1000>;
-			interrupts = <0 24 4>;
-			reg-size = <4>;
-			reg-spacing = <4>;
-		};
-
-		sregs@fff3c000 {
-			compatible = "calxeda,hb-sregs";
-			reg = <0xfff3c000 0x1000>;
-
-			clocks {
-				#address-cells = <1>;
-				#size-cells = <0>;
-
-				osc: oscillator {
-					#clock-cells = <0>;
-					compatible = "fixed-clock";
-					clock-frequency = <33333000>;
-				};
-
-				ddrpll: ddrpll {
-					#clock-cells = <0>;
-					compatible = "calxeda,hb-pll-clock";
-					clocks = <&osc>;
-					reg = <0x108>;
-				};
-
-				a9pll: a9pll {
-					#clock-cells = <0>;
-					compatible = "calxeda,hb-pll-clock";
-					clocks = <&osc>;
-					reg = <0x100>;
-				};
-
-				a9periphclk: a9periphclk {
-					#clock-cells = <0>;
-					compatible = "calxeda,hb-a9periph-clock";
-					clocks = <&a9pll>;
-					reg = <0x104>;
-				};
-
-				a9bclk: a9bclk {
-					#clock-cells = <0>;
-					compatible = "calxeda,hb-a9bus-clock";
-					clocks = <&a9pll>;
-					reg = <0x104>;
-				};
-
-				emmcpll: emmcpll {
-					#clock-cells = <0>;
-					compatible = "calxeda,hb-pll-clock";
-					clocks = <&osc>;
-					reg = <0x10C>;
-				};
-
-				eclk: eclk {
-					#clock-cells = <0>;
-					compatible = "calxeda,hb-emmc-clock";
-					clocks = <&emmcpll>;
-					reg = <0x114>;
-				};
-
-				pclk: pclk {
-					#clock-cells = <0>;
-					compatible = "fixed-clock";
-					clock-frequency = <150000000>;
-				};
-			};
-		};
-
-		dma@fff3d000 {
-			compatible = "arm,pl330", "arm,primecell";
-			reg = <0xfff3d000 0x1000>;
-			interrupts = <0 92 4>;
-			clocks = <&pclk>;
-			clock-names = "apb_pclk";
-		};
-
-		ethernet@fff50000 {
-			compatible = "calxeda,hb-xgmac";
-			reg = <0xfff50000 0x1000>;
-			interrupts = <0 77 4  0 78 4  0 79 4>;
-			dma-coherent;
-		};
-
-		ethernet@fff51000 {
-			compatible = "calxeda,hb-xgmac";
-			reg = <0xfff51000 0x1000>;
-			interrupts = <0 80 4  0 81 4  0 82 4>;
-			dma-coherent;
-		};
-
-		combophy0: combo-phy@fff58000 {
-			compatible = "calxeda,hb-combophy";
-			#phy-cells = <1>;
-			reg = <0xfff58000 0x1000>;
-			phydev = <5>;
-		};
-
-		combophy5: combo-phy@fff5d000 {
-			compatible = "calxeda,hb-combophy";
-			#phy-cells = <1>;
-			reg = <0xfff5d000 0x1000>;
-			phydev = <31>;
-		};
-	};
-};
diff --git a/arch/arm/boot/dts/highbank.dts b/arch/arm/boot/dts/highbank.dts
deleted file mode 100644
index f4e4dca6f7e7..000000000000
--- a/arch/arm/boot/dts/highbank.dts
+++ /dev/null
@@ -1,161 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Copyright 2011-2012 Calxeda, Inc.
- */
-
-/dts-v1/;
-
-/* First 4KB has pen for secondary cores. */
-/memreserve/ 0x00000000 0x0001000;
-
-/ {
-	model = "Calxeda Highbank";
-	compatible = "calxeda,highbank";
-	#address-cells = <1>;
-	#size-cells = <1>;
-	clock-ranges;
-
-	cpus {
-		#address-cells = <1>;
-		#size-cells = <0>;
-
-		cpu@900 {
-			compatible = "arm,cortex-a9";
-			device_type = "cpu";
-			reg = <0x900>;
-			next-level-cache = <&L2>;
-			clocks = <&a9pll>;
-			clock-names = "cpu";
-			operating-points = <
-				/* kHz    ignored */
-				 1300000  1000000
-				 1200000  1000000
-				 1100000  1000000
-				  800000  1000000
-				  400000  1000000
-				  200000  1000000
-			>;
-			clock-latency = <100000>;
-		};
-
-		cpu@901 {
-			compatible = "arm,cortex-a9";
-			device_type = "cpu";
-			reg = <0x901>;
-			next-level-cache = <&L2>;
-			clocks = <&a9pll>;
-			clock-names = "cpu";
-			operating-points = <
-				/* kHz    ignored */
-				 1300000  1000000
-				 1200000  1000000
-				 1100000  1000000
-				  800000  1000000
-				  400000  1000000
-				  200000  1000000
-			>;
-			clock-latency = <100000>;
-		};
-
-		cpu@902 {
-			compatible = "arm,cortex-a9";
-			device_type = "cpu";
-			reg = <0x902>;
-			next-level-cache = <&L2>;
-			clocks = <&a9pll>;
-			clock-names = "cpu";
-			operating-points = <
-				/* kHz    ignored */
-				 1300000  1000000
-				 1200000  1000000
-				 1100000  1000000
-				  800000  1000000
-				  400000  1000000
-				  200000  1000000
-			>;
-			clock-latency = <100000>;
-		};
-
-		cpu@903 {
-			compatible = "arm,cortex-a9";
-			device_type = "cpu";
-			reg = <0x903>;
-			next-level-cache = <&L2>;
-			clocks = <&a9pll>;
-			clock-names = "cpu";
-			operating-points = <
-				/* kHz    ignored */
-				 1300000  1000000
-				 1200000  1000000
-				 1100000  1000000
-				  800000  1000000
-				  400000  1000000
-				  200000  1000000
-			>;
-			clock-latency = <100000>;
-		};
-	};
-
-	memory {
-		name = "memory";
-		device_type = "memory";
-		reg = <0x00000000 0xff900000>;
-	};
-
-	soc {
-		ranges = <0x00000000 0x00000000 0xffffffff>;
-
-		memory-controller@fff00000 {
-			compatible = "calxeda,hb-ddr-ctrl";
-			reg = <0xfff00000 0x1000>;
-			interrupts = <0 91 4>;
-		};
-
-		timer@fff10600 {
-			compatible = "arm,cortex-a9-twd-timer";
-			reg = <0xfff10600 0x20>;
-			interrupts = <1 13 0xf01>;
-			clocks = <&a9periphclk>;
-		};
-
-		watchdog@fff10620 {
-			compatible = "arm,cortex-a9-twd-wdt";
-			reg = <0xfff10620 0x20>;
-			interrupts = <1 14 0xf01>;
-			clocks = <&a9periphclk>;
-		};
-
-		intc: interrupt-controller@fff11000 {
-			compatible = "arm,cortex-a9-gic";
-			#interrupt-cells = <3>;
-			#size-cells = <0>;
-			#address-cells = <1>;
-			interrupt-controller;
-			reg = <0xfff11000 0x1000>,
-			      <0xfff10100 0x100>;
-		};
-
-		L2: l2-cache {
-			compatible = "arm,pl310-cache";
-			reg = <0xfff12000 0x1000>;
-			interrupts = <0 70 4>;
-			cache-unified;
-			cache-level = <2>;
-		};
-
-		pmu {
-			compatible = "arm,cortex-a9-pmu";
-			interrupts = <0 76 4  0 75 4  0 74 4  0 73 4>;
-		};
-
-
-		sregs@fff3c200 {
-			compatible = "calxeda,hb-sregs-l2-ecc";
-			reg = <0xfff3c200 0x100>;
-			interrupts = <0 71 4  0 72 4>;
-		};
-
-	};
-};
-
-/include/ "ecx-common.dtsi"
-- 
2.20.1

