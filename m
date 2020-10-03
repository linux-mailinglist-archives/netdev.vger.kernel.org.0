Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D71AC282322
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 11:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725778AbgJCJa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 05:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbgJCJa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 05:30:57 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509B1C0613D0
        for <netdev@vger.kernel.org>; Sat,  3 Oct 2020 02:30:57 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601717455;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WMLNcM9/6cpREh5eAmpbTj5sxshmpYHfMRwfKZG651k=;
        b=HDlPy5bHW+X9VtMsZbkOdyaIcwRBEzf0hwRQoUfT97zQdep4MQmlxUzRw8mzm/xf7mfY+j
        lQpKw99y+MEfIkWNiEfSlP4c8GHDBXhYFEwuegbrDhsks78+OqKWQaUgU/qxgEEy7WY5wg
        xX2oUheitcuq73ebQdXzfjD2QuT+1hJWxrjFVRH+jL0HexJfsMEik2yX9GDW0dNu6T6DnS
        B6UCTdSJhXMV+/uG9bIphlxDxxNDTLETzGGRqkEBZQMmwpHVbzy3KwtVY8G2pfwjzggtfS
        9xHR1OdWdiaypMQwqKPr84RKbdAYF5xSMEo0vB0Oq+PzbydR9YQ5un+EAU0sDA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601717455;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WMLNcM9/6cpREh5eAmpbTj5sxshmpYHfMRwfKZG651k=;
        b=m2FB0qKexvY09Tpw127WGBGvhEgzqFR/m0eMDGkWe08027ouHd/Ke+/XkbIyF8E6BLoFX9
        c+z4O+XDOfvj2zBg==
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next 2/2] dt-bindings: net: dsa: b53: Fix full duplex in example
Date:   Sat,  3 Oct 2020 11:30:51 +0200
Message-Id: <20201003093051.7242-2-kurt@linutronix.de>
In-Reply-To: <20201003093051.7242-1-kurt@linutronix.de>
References: <20201003093051.7242-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no such property as duplex-full. It's called full-duplex. Leading to
reduced speed when using the example as base for a real device tree.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 Documentation/devicetree/bindings/net/dsa/b53.txt | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/b53.txt b/Documentation/devicetree/bindings/net/dsa/b53.txt
index 3bb4e1086913..f1487a751b1a 100644
--- a/Documentation/devicetree/bindings/net/dsa/b53.txt
+++ b/Documentation/devicetree/bindings/net/dsa/b53.txt
@@ -95,7 +95,7 @@ Ethernet switch connected via MDIO to the host, CPU port wired to eth0:
 
 		fixed-link {
 			speed = <1000>;
-			duplex-full;
+			full-duplex;
 		};
 	};
 
@@ -129,7 +129,7 @@ Ethernet switch connected via MDIO to the host, CPU port wired to eth0:
 					label = "cable-modem";
 					fixed-link {
 						speed = <1000>;
-						duplex-full;
+						full-duplex;
 					};
 					phy-mode = "rgmii-txid";
 				};
@@ -139,7 +139,7 @@ Ethernet switch connected via MDIO to the host, CPU port wired to eth0:
 					label = "cpu";
 					fixed-link {
 						speed = <1000>;
-						duplex-full;
+						full-duplex;
 					};
 					phy-mode = "rgmii-txid";
 					ethernet = <&eth0>;
-- 
2.20.1

