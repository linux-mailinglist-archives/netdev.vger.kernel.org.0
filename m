Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF93215EEF5
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 18:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389517AbgBNQDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 11:03:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:49750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389506AbgBNQC7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 11:02:59 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B6C82067D;
        Fri, 14 Feb 2020 16:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696178;
        bh=OHflqUrzlm8/xx/dM//1K4Fu0XHAEpTzk5pVqK1KuwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aZZOM1wJt5ohdqLRxlbs4WvPFNJv/l+YujhCLnyGTW4EZKWdPQlKyuukrr8uHr59s
         q7/oQJMQT9H5S6iabdtVOIvNh82F8XlwN2Aa/Qjwun6zSC3LyoQYUVUoF+7gqGa7iU
         n8auVwvzC6sArF+/8GXh+kDi2fPrx/R4+ibBHMMY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Baruch Siach <baruch@tkos.co.il>,
        Denis Odintsov <d.odintsov@traviangames.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 050/459] arm64: dts: marvell: clearfog-gt-8k: fix switch cpu port node
Date:   Fri, 14 Feb 2020 10:55:00 -0500
Message-Id: <20200214160149.11681-50-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
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

