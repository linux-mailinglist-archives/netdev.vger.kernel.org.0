Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F250E15F2A3
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 19:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730390AbgBNPuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 10:50:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:54034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730375AbgBNPuK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 10:50:10 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F60824691;
        Fri, 14 Feb 2020 15:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695409;
        bh=OHflqUrzlm8/xx/dM//1K4Fu0XHAEpTzk5pVqK1KuwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pMmuEBmu0BG4wZHgr3zBeANTv3Qfx1WAkF5JXC1qO/7wInl5427zFGC1/LjQdpcUH
         MR/+w+v0N/F1/iIQsnS+9qm8f3wWhkHFQMCuldkoc2U1YGa1/dQXze2DXQbvJFP0aB
         M1m4Vx7OD+zP62Y+bqPNpm2eQgcDT19K82shQs+0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Baruch Siach <baruch@tkos.co.il>,
        Denis Odintsov <d.odintsov@traviangames.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 057/542] arm64: dts: marvell: clearfog-gt-8k: fix switch cpu port node
Date:   Fri, 14 Feb 2020 10:40:49 -0500
Message-Id: <20200214154854.6746-57-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baruch Siach <baruch@tkos.co.il>

[ Upstream commit 62bba54d99407aedfe9b0a02e72e23c06e2b0116 ]

Explicitly set the switch cpu (upstream) port phy-mode and managed
properties. This fixes the Marvell 88E6141 switch serdes configuration
with the recently enabled phylink layer.

Fixes: a6120833272c ("arm64: dts: add support for SolidRun Clearfog GT 8K")
Reported-by: Denis Odintsov <d.odintsov@traviangames.com>
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts b/arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts
index bd881497b8729..a211a046b2f2f 100644
--- a/arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts
+++ b/arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts
@@ -408,6 +408,8 @@
 				reg = <5>;
 				label = "cpu";
 				ethernet = <&cp1_eth2>;
+				phy-mode = "2500base-x";
+				managed = "in-band-status";
 			};
 		};
 
-- 
2.20.1

