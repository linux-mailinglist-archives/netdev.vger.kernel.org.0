Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F081A13AE94
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 17:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729273AbgANQJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 11:09:39 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:40702 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727102AbgANQJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 11:09:38 -0500
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 94EADC0624;
        Tue, 14 Jan 2020 16:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1579018177; bh=J145tdWmmuWUgjzVVhs0iS89opFX/TcApLpKRx6zF0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=O0lPhaS3S3fIYCpNoRDZbPPk5SQAh4yMdUpnXVr/ZGzKQTPr6CjUTy/9O4SEDB+ML
         CALgAhGxO6TuCsXJgPuLpkgBwu2+NN+cNlDP3Km1DFXFEcZQ+1P8Hg58qufkc5g2WT
         MkgowU8Fhd/V/RZ3nVrd82Iam6PqeGGQ7Xh2NfzZ8/bZmCo8PE0v9nxJafSENhcp2y
         nKoxWIaOU5VnvH+n/gDcSQrf2rxD+ydl2a/QQiK3fnzV3qLezqdIu3oo5l2xrW7TSz
         4Krlyzo7TIOuHdM2l6zH3ZiEwSytOVzLM29URCY7+JN1iHuA6+Tz8rY4CRIavX+kVk
         TWfbMuvWEfnfQ==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 3BAE1A0073;
        Tue, 14 Jan 2020 16:09:35 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        devicetree@vger.kernel.org, linux-snps-arc@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 4/4] ARC: [plat-axs10x]: Add missing multicast filter number to GMAC node
Date:   Tue, 14 Jan 2020 17:09:24 +0100
Message-Id: <b1abebaf6ac9a0176b82e179944a455fbf1d7a15.1579017787.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1579017787.git.Jose.Abreu@synopsys.com>
References: <cover.1579017787.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1579017787.git.Jose.Abreu@synopsys.com>
References: <cover.1579017787.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a missing property to GMAC node so that multicast filtering works
correctly.

Fixes: 556cc1c5f528 ("ARC: [axs101] Add support for AXS101 SDP (software development platform)")
Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

---
Cc: Alexey Brodkin <abrodkin@synopsys.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: devicetree@vger.kernel.org
Cc: linux-snps-arc@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arc/boot/dts/axs10x_mb.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arc/boot/dts/axs10x_mb.dtsi b/arch/arc/boot/dts/axs10x_mb.dtsi
index f9a5c9ddcae7..1d109b06e7d8 100644
--- a/arch/arc/boot/dts/axs10x_mb.dtsi
+++ b/arch/arc/boot/dts/axs10x_mb.dtsi
@@ -78,6 +78,7 @@
 			interrupt-names = "macirq";
 			phy-mode = "rgmii";
 			snps,pbl = < 32 >;
+			snps,multicast-filter-bins = <256>;
 			clocks = <&apbclk>;
 			clock-names = "stmmaceth";
 			max-speed = <100>;
-- 
2.7.4

