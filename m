Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4EA71EFFA9
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 20:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgFESKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 14:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbgFESKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 14:10:10 -0400
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E10A4C08C5C2;
        Fri,  5 Jun 2020 11:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
         s=the; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject
        :To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=uX7WkPPY5DHynO/kH95BbeRu3QRcHZ3RT6LKeg6R+k0=; b=LxfpePMGvwk9Hyci3o22CrWB8f
        e7a+sb2Wmh8g0jqcKTPAywOHbaxyy0yxzEQwFJ5tS50zNMRIrz8wn6tID27Nwr23Hs8cZrFUBCpiK
        2qv2iFaR1gTfIHmdg4YOY/RojDX8uvWUsCuoobdK/oZ0yXNspTJMvKM/qM0QQ0N8UBLpZoZTZKBVT
        3eN3/rBYXEPvkepqKXVEnTvKTn2ztfISyMilYPUK/ZOj7EBzOXaWzRNOcsjjcfHkOX7JYVBAdY0Vc
        fPGdcFgmdjAcHsD59cxaqZt8fGpalQdiJpJMFaVWvOik+JC2qZbIgpSDq4tXxpK8tjM3DusiBHZyo
        3SsKK73g==;
Received: from [2001:4d48:ad59:1409:4::2] (helo=youmian.o362.us)
        by the.earth.li with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <noodles@earth.li>)
        id 1jhGn8-0003Cr-ST; Fri, 05 Jun 2020 19:10:06 +0100
Date:   Fri, 5 Jun 2020 19:10:02 +0100
From:   Jonathan McDowell <noodles@earth.li>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org
Subject: [PATCH 1/2] dt-bindings: net: dsa: qca8k: document SGMII properties
Message-ID: <ca767d2dd00280f7c0826c133d1ff6f262b6736d.1591380105.git.noodles@earth.li>
References: <cover.1591380105.git.noodles@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1591380105.git.noodles@earth.li>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch documents the qca8k's SGMII related properties that allow
configuration of the SGMII port.

Signed-off-by: Jonathan McDowell <noodles@earth.li>
---
 Documentation/devicetree/bindings/net/dsa/qca8k.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
index ccbc6d89325d..9e7d74a248ad 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
@@ -11,7 +11,11 @@ Required properties:
 
 Optional properties:
 
+- disable-serdes-autoneg: Boolean, disables auto-negotiation on the SerDes
 - reset-gpios: GPIO to be used to reset the whole device
+- sgmii-delay: Boolean, presence delays SGMII clock by 2ns
+- sgmii-mode: String, operation mode of the SGMII interface.
+  Supported values are: "basex", "mac", "phy".
 
 Subnodes:
 
-- 
2.20.1

