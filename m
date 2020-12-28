Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4BD72E6C45
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 00:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730140AbgL1Wzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 17:55:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729523AbgL1Vc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 16:32:59 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3739C061796;
        Mon, 28 Dec 2020 13:32:18 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id e7so6842975ile.7;
        Mon, 28 Dec 2020 13:32:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I4DDSn9wPiLEmglGWQm1erF8kwYYtU07mE4RIoz6iRM=;
        b=bG95tLBme9mt1RnQBa4/mAK1bUCQ3biu2jxvBcAM0AlDh7FIaTx8dCJJ6dqVkl+ZOM
         HFwx524Y2yjPreGvY/MrE5slisRBo5khGRm6lcYutDYzcGR0J3DIqPkpFPfq9d/15Qp+
         I4WwpvV+R/4i9LP3lczjDu9RL3yNRoBbNc1Nl34L98P/8kJ86cS/hAdayd2fo3xRUltx
         a9N5UHPu6+PgtIRlqNGZFUnr/mfz3iqJncjggXlEiFkeMsgVB92Vmvxm9glxaZrfFJro
         hFgQGNB7WrKq8QioWbrkCc2M73j627v1uRFkOkmvw9qzvxQ3hmmhtldT4c9E9HJYWfSo
         Mn/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I4DDSn9wPiLEmglGWQm1erF8kwYYtU07mE4RIoz6iRM=;
        b=D1zK5XMVoDoeEFmyuN43KukK4XTOeoUbvoz057Zhd7skf4RtyPTYSRKkwEgrm+Vfs4
         HHuGxamsW4O64erFiuN3ZWOH8hdehhQDFcK365ekR06CrNrwetASdzio5PoUXo7oIKQ7
         2of8md9D+3btotgIZtJUlMTUGKRH1AMfrNJLQwJ/RELc5l0EnqXD+BV3+I6Iv9hrdTCN
         ZiPpvbmgVt63ifKwLbsXKV93Ldgc6SyDy8UEjwCNRYHOXSaYyw75xyGU/EbF0mO+NK8u
         HQZQTPAu3vmWiFAHcOdm5T2uU/bavx80bVZg3ZTbD908RrBDKJkvN7NpqPtZgLsR3d5c
         NWnw==
X-Gm-Message-State: AOAM532sch72WmRJkS9I44fyJrnLpyMGuM+/DhtuVvdgGhaTkvMxhSlv
        6DGSJ/kMmtMB5zoh+HyHRonPYQVYtp+xjA==
X-Google-Smtp-Source: ABdhPJw8pIWNUlEtF67/WuPFkxddbH5Fm/Fsz6fL91jsf8tLNJvkjZPsxIhdCyqqM5zD3FHvDGda3g==
X-Received: by 2002:a05:6e02:1b8a:: with SMTP id h10mr46136439ili.141.1609191137899;
        Mon, 28 Dec 2020 13:32:17 -0800 (PST)
Received: from aford-IdeaCentre-A730.lan ([2601:448:8400:9e8:f45d:df49:9a4c:4914])
        by smtp.gmail.com with ESMTPSA id r10sm27671275ilo.34.2020.12.28.13.32.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Dec 2020 13:32:17 -0800 (PST)
From:   Adam Ford <aford173@gmail.com>
To:     linux-renesas-soc@vger.kernel.org
Cc:     aford@beaconembedded.com, Adam Ford <aford173@gmail.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] ARM: dts: renesas: Add fck to etheravb-rcar-gen2 clock-names list
Date:   Mon, 28 Dec 2020 15:31:18 -0600
Message-Id: <20201228213121.2331449-2-aford173@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201228213121.2331449-1-aford173@gmail.com>
References: <20201228213121.2331449-1-aford173@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bindings have been updated to support two clocks, but the
original clock now requires the name fck.  Add a clock-names
list in the device tree with fck in it.

Signed-off-by: Adam Ford <aford173@gmail.com>
---
 arch/arm/boot/dts/r8a7742.dtsi  | 1 +
 arch/arm/boot/dts/r8a7743.dtsi  | 1 +
 arch/arm/boot/dts/r8a7744.dtsi  | 1 +
 arch/arm/boot/dts/r8a7745.dtsi  | 1 +
 arch/arm/boot/dts/r8a77470.dtsi | 1 +
 arch/arm/boot/dts/r8a7790.dtsi  | 1 +
 arch/arm/boot/dts/r8a7791.dtsi  | 1 +
 arch/arm/boot/dts/r8a7792.dtsi  | 1 +
 arch/arm/boot/dts/r8a7794.dtsi  | 1 +
 9 files changed, 9 insertions(+)

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

