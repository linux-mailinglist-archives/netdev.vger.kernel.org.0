Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96A4D8D1F8
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 13:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfHNLSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 07:18:39 -0400
Received: from mx2.mailbox.org ([80.241.60.215]:23018 "EHLO mx2.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbfHNLSi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 07:18:38 -0400
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mx2.mailbox.org (Postfix) with ESMTPS id C92DFA15A8;
        Wed, 14 Aug 2019 13:18:36 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter02.heinlein-hosting.de (spamfilter02.heinlein-hosting.de [80.241.56.116]) (amavisd-new, port 10030)
        with ESMTP id zknpcz6dtABp; Wed, 14 Aug 2019 13:18:26 +0200 (CEST)
From:   Stefan Roese <sr@denx.de>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Sean Wang <sean.wang@mediatek.com>,
        John Crispin <john@phrozen.org>, devicetree@vger.kernel.org,
        Rob Herring <robh@kernel.org>
Subject: [PATCH net-next 1/4 v2] dt-bindings: net: mediatek: Add support for MediaTek MT7628/88 SoC
Date:   Wed, 14 Aug 2019 13:18:22 +0200
Message-Id: <20190814111825.10855-1-sr@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add compatible for the ethernet IP core on MT7628/88 SoCs. Its
compatible with the older Ralink Rt5350F SoC. And OpenWrt already
uses this compatible string for the MT76x8.

Signed-off-by: Stefan Roese <sr@denx.de>
Cc: René van Dorst <opensource@vdorst.com>
Cc: Daniel Golle <daniel@makrotopia.org>
Cc: Sean Wang <sean.wang@mediatek.com>
Cc: John Crispin <john@phrozen.org>
Cc: devicetree@vger.kernel.org
Cc: Rob Herring <robh@kernel.org>
---
v2:
- New patch - bindings description moved to separate patch

Documentation/devicetree/bindings/net/mediatek-net.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/mediatek-net.txt b/Documentation/devicetree/bindings/net/mediatek-net.txt
index 770ff98d4524..72d03e07cf7c 100644
--- a/Documentation/devicetree/bindings/net/mediatek-net.txt
+++ b/Documentation/devicetree/bindings/net/mediatek-net.txt
@@ -12,6 +12,7 @@ Required properties:
 		"mediatek,mt7623-eth", "mediatek,mt2701-eth": for MT7623 SoC
 		"mediatek,mt7622-eth": for MT7622 SoC
 		"mediatek,mt7629-eth": for MT7629 SoC
+		"ralink,rt5350-eth": for Ralink Rt5350F and MT7628/88 SoC
 - reg: Address and length of the register set for the device
 - interrupts: Should contain the three frame engines interrupts in numeric
 	order. These are fe_int0, fe_int1 and fe_int2.
-- 
2.22.1

