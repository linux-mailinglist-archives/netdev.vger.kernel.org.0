Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67D6B323B8E
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 12:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235149AbhBXLwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 06:52:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235121AbhBXLwo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 06:52:44 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1518DC06174A;
        Wed, 24 Feb 2021 03:52:04 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id y202so1708856iof.1;
        Wed, 24 Feb 2021 03:52:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o65TUS3eViNoH1/o8q9/8liYwdZx2oTvg/nkERWMHtU=;
        b=nkOH4+uQQYtUnFA/AuqMEmpTHZsJVuTfAbOLZm+yFHKbfIcMd9Q12EyiB4af8SMX8e
         318DgJ5x4F/Qp7G0KArHL9+uK53+yvVBRCiBe1M8ovPfxeUUyJkkUmM1zyXW+taC1dYB
         a6wcg/BibceaW73Gnui/Bsr3WAJELrtcgHiJtPcYnANOnQdnmiZyguKM5NaLhY9Ku+dI
         xsVYdc3wANU12JQBZTQOQe8IfKzs9MjNv8wfrk39DpVPsaF5ed6egsa8yO4Zbc7Lk1EP
         P/3HKZHkX+H0wzPgtWM+3w7LCQFokhfZyV1hP98VPjxPENTMDuRnmeWNsk36obAb/COT
         CPsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o65TUS3eViNoH1/o8q9/8liYwdZx2oTvg/nkERWMHtU=;
        b=cfozAv7mzAfje8i8gf1fr/BTWXGimsecRSw9O4So31K91rl8kaE7eSbTPwM7rzht+L
         SPRrHVFjcTzLy1cSh4CNDGWfg9NxEz2xAvUn+9C+ORAyRtGJZ9tskt/kMI9pwpBN1qgU
         kcwMt/dNvSFC0brPAIPNd2G1VzkAw4By90JV2X/quN21KscTHbaTZnEvuXYHEQ1sOo+u
         dC0KoTtP465gXzn39nrtQeI5sBRlC69IY5Aeoa2Frn2FDbnoHcZWjwFj6jl7It+qdbKa
         gfpYAz2d40CrAVlCgKi/HRFNHHEZrBLO7McU21wBtO82Qq+LnR1seyiuDnBv5q3/Z45p
         57Qg==
X-Gm-Message-State: AOAM532L0mKURUHBNFGtMzcHEiEJ6q02KBXrJ2L0KMOkjP+XA1rVlgga
        zvUXJk8yqAPDoq4fda34TNCFpRGQAcEBYA==
X-Google-Smtp-Source: ABdhPJwxsG+6DFP2AY8TOGhSVHWhZRB9tbSGSvDBlHSP+At4BssZ9j6vHDBhbIf9XPi99a5YdcEH8Q==
X-Received: by 2002:a6b:c997:: with SMTP id z145mr2945563iof.36.1614167523184;
        Wed, 24 Feb 2021 03:52:03 -0800 (PST)
Received: from aford-IdeaCentre-A730.lan ([2601:448:8400:9e8:de9c:d296:189b:385a])
        by smtp.gmail.com with ESMTPSA id l16sm1500001ils.11.2021.02.24.03.52.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 03:52:02 -0800 (PST)
From:   Adam Ford <aford173@gmail.com>
To:     netdev@vger.kernel.org
Cc:     aford@beaconembedded.com, Adam Ford <aford173@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V3 2/5] ARM: dts: renesas: Add fck to etheravb-rcar-gen2 clock-names list
Date:   Wed, 24 Feb 2021 05:51:42 -0600
Message-Id: <20210224115146.9131-2-aford173@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210224115146.9131-1-aford173@gmail.com>
References: <20210224115146.9131-1-aford173@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bindings have been updated to support two clocks, but the
original clock now requires the name fck.  Add a clock-names
list in the device tree with fck in it.

Signed-off-by: Adam Ford <aford173@gmail.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
V3:  No Change
V2:  No Change

diff --git a/arch/arm/boot/dts/r8a7742.dtsi b/arch/arm/boot/dts/r8a7742.dtsi
index 6a78c813057b..6b922f664fcd 100644
--- a/arch/arm/boot/dts/r8a7742.dtsi
+++ b/arch/arm/boot/dts/r8a7742.dtsi
@@ -750,6 +750,7 @@ avb: ethernet@e6800000 {
 			reg = <0 0xe6800000 0 0x800>, <0 0xee0e8000 0 0x4000>;
 			interrupts = <GIC_SPI 163 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&cpg CPG_MOD 812>;
+			clock-names = "fck";
 			power-domains = <&sysc R8A7742_PD_ALWAYS_ON>;
 			resets = <&cpg 812>;
 			#address-cells = <1>;
diff --git a/arch/arm/boot/dts/r8a7743.dtsi b/arch/arm/boot/dts/r8a7743.dtsi
index f444e418f408..084bf3e039cf 100644
--- a/arch/arm/boot/dts/r8a7743.dtsi
+++ b/arch/arm/boot/dts/r8a7743.dtsi
@@ -702,6 +702,7 @@ avb: ethernet@e6800000 {
 			reg = <0 0xe6800000 0 0x800>, <0 0xee0e8000 0 0x4000>;
 			interrupts = <GIC_SPI 163 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&cpg CPG_MOD 812>;
+			clock-names = "fck";
 			power-domains = <&sysc R8A7743_PD_ALWAYS_ON>;
 			resets = <&cpg 812>;
 			#address-cells = <1>;
diff --git a/arch/arm/boot/dts/r8a7744.dtsi b/arch/arm/boot/dts/r8a7744.dtsi
index 0442aad4f9db..d01eba99ceb0 100644
--- a/arch/arm/boot/dts/r8a7744.dtsi
+++ b/arch/arm/boot/dts/r8a7744.dtsi
@@ -702,6 +702,7 @@ avb: ethernet@e6800000 {
 			reg = <0 0xe6800000 0 0x800>, <0 0xee0e8000 0 0x4000>;
 			interrupts = <GIC_SPI 163 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&cpg CPG_MOD 812>;
+			clock-names = "fck";
 			power-domains = <&sysc R8A7744_PD_ALWAYS_ON>;
 			resets = <&cpg 812>;
 			#address-cells = <1>;
diff --git a/arch/arm/boot/dts/r8a7745.dtsi b/arch/arm/boot/dts/r8a7745.dtsi
index 0f14ac22921d..d0d45a369047 100644
--- a/arch/arm/boot/dts/r8a7745.dtsi
+++ b/arch/arm/boot/dts/r8a7745.dtsi
@@ -645,6 +645,7 @@ avb: ethernet@e6800000 {
 			reg = <0 0xe6800000 0 0x800>, <0 0xee0e8000 0 0x4000>;
 			interrupts = <GIC_SPI 163 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&cpg CPG_MOD 812>;
+			clock-names = "fck";
 			power-domains = <&sysc R8A7745_PD_ALWAYS_ON>;
 			resets = <&cpg 812>;
 			#address-cells = <1>;
diff --git a/arch/arm/boot/dts/r8a77470.dtsi b/arch/arm/boot/dts/r8a77470.dtsi
index 691b1a131c87..ae90a001d663 100644
--- a/arch/arm/boot/dts/r8a77470.dtsi
+++ b/arch/arm/boot/dts/r8a77470.dtsi
@@ -537,6 +537,7 @@ avb: ethernet@e6800000 {
 			reg = <0 0xe6800000 0 0x800>, <0 0xee0e8000 0 0x4000>;
 			interrupts = <GIC_SPI 163 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&cpg CPG_MOD 812>;
+			clock-names = "fck";
 			power-domains = <&sysc R8A77470_PD_ALWAYS_ON>;
 			resets = <&cpg 812>;
 			#address-cells = <1>;
diff --git a/arch/arm/boot/dts/r8a7790.dtsi b/arch/arm/boot/dts/r8a7790.dtsi
index b0569b4ea5c8..af9cd3324f4c 100644
--- a/arch/arm/boot/dts/r8a7790.dtsi
+++ b/arch/arm/boot/dts/r8a7790.dtsi
@@ -768,6 +768,7 @@ avb: ethernet@e6800000 {
 			reg = <0 0xe6800000 0 0x800>, <0 0xee0e8000 0 0x4000>;
 			interrupts = <GIC_SPI 163 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&cpg CPG_MOD 812>;
+			clock-names = "fck";
 			power-domains = <&sysc R8A7790_PD_ALWAYS_ON>;
 			resets = <&cpg 812>;
 			#address-cells = <1>;
diff --git a/arch/arm/boot/dts/r8a7791.dtsi b/arch/arm/boot/dts/r8a7791.dtsi
index 87f0d6dc3e5a..2354af7fa83f 100644
--- a/arch/arm/boot/dts/r8a7791.dtsi
+++ b/arch/arm/boot/dts/r8a7791.dtsi
@@ -728,6 +728,7 @@ avb: ethernet@e6800000 {
 			reg = <0 0xe6800000 0 0x800>, <0 0xee0e8000 0 0x4000>;
 			interrupts = <GIC_SPI 163 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&cpg CPG_MOD 812>;
+			clock-names = "fck";
 			power-domains = <&sysc R8A7791_PD_ALWAYS_ON>;
 			resets = <&cpg 812>;
 			#address-cells = <1>;
diff --git a/arch/arm/boot/dts/r8a7792.dtsi b/arch/arm/boot/dts/r8a7792.dtsi
index f5b299bfcb23..60c184ab1b49 100644
--- a/arch/arm/boot/dts/r8a7792.dtsi
+++ b/arch/arm/boot/dts/r8a7792.dtsi
@@ -537,6 +537,7 @@ avb: ethernet@e6800000 {
 			reg = <0 0xe6800000 0 0x800>, <0 0xee0e8000 0 0x4000>;
 			interrupts = <GIC_SPI 163 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&cpg CPG_MOD 812>;
+			clock-names = "fck";
 			power-domains = <&sysc R8A7792_PD_ALWAYS_ON>;
 			resets = <&cpg 812>;
 			#address-cells = <1>;
diff --git a/arch/arm/boot/dts/r8a7794.dtsi b/arch/arm/boot/dts/r8a7794.dtsi
index cd5e2904068a..18cc6f6b588d 100644
--- a/arch/arm/boot/dts/r8a7794.dtsi
+++ b/arch/arm/boot/dts/r8a7794.dtsi
@@ -598,6 +598,7 @@ avb: ethernet@e6800000 {
 			reg = <0 0xe6800000 0 0x800>, <0 0xee0e8000 0 0x4000>;
 			interrupts = <GIC_SPI 163 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&cpg CPG_MOD 812>;
+			clock-names = "fck";
 			power-domains = <&sysc R8A7794_PD_ALWAYS_ON>;
 			resets = <&cpg 812>;
 			#address-cells = <1>;
-- 
2.25.1

