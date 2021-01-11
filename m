Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCEF2F0ABC
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 02:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbhAKBWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 20:22:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:54450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726362AbhAKBWs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Jan 2021 20:22:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95BF4223E8;
        Mon, 11 Jan 2021 01:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610328127;
        bh=u+KNq1S7Fuv2h4OWa1gQKdmrPhjey5U3+Hi0pRNsIRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u7vlWXFLYThyDwc20t4pEVoVOGVeAqGWCDFIWnwHT+Ys5PYwVtkwm40spzz4V3iJt
         +KrCjH2oV29mIkKnWnlp+HHpFQc3EZpbol36oNp2hyEAMiA2E6AUp9E4IIxHKxDgcx
         XoKVSp4AloWEU7P6I86pGpK4iQGz3hbYmlDmMOxbmlPcfnQaz7kIwWwR9Km27tYfRD
         wOWIP5xblb1Uwn67vIIy6EgsZgN1LcU44dHt3hOTQpZ45ve3LQHPVRAVEuoG31LjQR
         rDd3WKHm88jiP/epD504PrLrOfwITZRV3VyLmnszkwqjTmfF6Xoq7NGRGlzVB3c8zR
         wd1Ix7ca4iXwQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     pavana.sharma@digi.com, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org, lkp@intel.com,
        davem@davemloft.net, ashkan.boldaji@digi.com, andrew@lunn.ch,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        olteanv@gmail.com,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH net-next v14 1/6] dt-bindings: net: Add 5GBASER phy interface
Date:   Mon, 11 Jan 2021 02:21:51 +0100
Message-Id: <20210111012156.27799-2-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210111012156.27799-1-kabel@kernel.org>
References: <20210111012156.27799-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavana Sharma <pavana.sharma@digi.com>

Add 5gbase-r PHY interface mode.

Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Marek Behún <kabel@kernel.org>
Acked-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/net/ethernet-controller.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index 0965f6515f9e..5507ae3c478d 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -89,6 +89,7 @@ properties:
       - trgmii
       - 1000base-x
       - 2500base-x
+      - 5gbase-r
       - rxaui
       - xaui
 
-- 
2.26.2

