Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B62B030A4E1
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 11:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233019AbhBAKDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 05:03:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233009AbhBAKDg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 05:03:36 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D45F0C061797;
        Mon,  1 Feb 2021 02:02:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=fdKIVx24GymoqMQrx5hQK9PTn9IKYCcOrSnM24L/ylo=; b=oJglRTJAPZuHahZ2zawS2mq2V8
        8Px+KYMt4viAX6nWB/pEfxbEbIR0nIqDCMpTNUkHBgQP52sPoM8M+gTxZgwpbcJA+eM18bYNhs6jT
        DNUGu/wTGcbOtCUDEIValj6phRiDjAmbB3ZxUb/4dI4Z4BOp3wY0AS96+NIyJDtbmnKnTi6FRoIpg
        OddARo6C2K61gv3/uilnccjwpnYiD0oeQYkGFg/dQYnmvRuKrY2uDkKEesAo2ApYtLCmjHLSZMuqq
        ZBCYqoLC36W+QZy63N5L9JLuiboEhuB9Tfj9p70AfVnjnfn6/b3Wqp3pKP+f/PdVLQDuYD41NZAjZ
        0luMwijQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:41434 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1l6W2G-00039W-6o; Mon, 01 Feb 2021 10:02:20 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1l6W2G-0002Ga-0O; Mon, 01 Feb 2021 10:02:20 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH RESEND] dt-bindings: ethernet-controller: fix fixed-link
 specification
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1l6W2G-0002Ga-0O@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Mon, 01 Feb 2021 10:02:20 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The original fixed-link.txt allowed a pause property for fixed link.
This has been missed in the conversion to yaml format.

Fixes: 9d3de3c58347 ("dt-bindings: net: Add YAML schemas for the generic Ethernet options")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---

Resending now that kernel.org is fixed.

 .../devicetree/bindings/net/ethernet-controller.yaml         | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index fdf709817218..39147d33e8c7 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -206,6 +206,11 @@ title: Ethernet Controller Generic Binding
                 Indicates that full-duplex is used. When absent, half
                 duplex is assumed.
 
+            pause:
+              $ref: /schemas/types.yaml#definitions/flag
+              description:
+                Indicates that pause should be enabled.
+
             asym-pause:
               $ref: /schemas/types.yaml#definitions/flag
               description:
-- 
2.20.1

