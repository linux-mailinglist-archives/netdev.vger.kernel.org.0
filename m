Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56D8131D0E8
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 20:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbhBPTWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 14:22:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:51978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229577AbhBPTWB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 14:22:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9802364E85;
        Tue, 16 Feb 2021 19:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613503280;
        bh=x7C+xNyA1dFyqXI65UWTk3st0xVyfG8AtkemF+t8OAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Iz6/mkOJzulqwlXn3iKe7C1rhnM26NLHXeWdVg5Z9Fl0rNJOy5Bq40zFFSolhlrUO
         wTzRLhO4/w5Ey730GlwnZM8ktDuh3zLYrRceVYrZkuQ1HA9wSJnaYZ0q6OBj+IEz/n
         afXOn3IhlDn2BY9eix+gfIcR1xpOlroVjHDz8ilUt8CB64nizmCckOQG+YrV6mu345
         CORG/GiVxyCbH5JsHYdA0yvoNFQkkkj82epPHy+AyK+kYl0bxTdJXJWD91fx4lfbV7
         0wzt+zQoMrhL/aRbg2BKEEEOfb/ayEz/88RrYAdPZZcu3ZHtrp6kNUHmLVPNLgvICJ
         ra+xY3sAL26Rg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        davem@davemloft.net, kuba@kernel.org
Cc:     pavana.sharma@digi.com, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, lkp@intel.com, ashkan.boldaji@digi.com,
        andrew@lunn.ch, Chris Packham <chris.packham@alliedtelesis.co.nz>,
        olteanv@gmail.com, Rob Herring <robh@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 1/4] dt-bindings: net: Add 5GBASER phy interface
Date:   Tue, 16 Feb 2021 20:20:52 +0100
Message-Id: <20210216192055.7078-2-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210216192055.7078-1-kabel@kernel.org>
References: <20210216192055.7078-1-kabel@kernel.org>
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 Documentation/devicetree/bindings/net/ethernet-controller.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index dac4aadb6e2e..f599c1d9c961 100644
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

