Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4E3F1FF164
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 14:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729611AbgFRMME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 08:12:04 -0400
Received: from gloria.sntech.de ([185.11.138.130]:53400 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729503AbgFRMLu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 08:11:50 -0400
Received: from ip5f5aa64a.dynamic.kabel-deutschland.de ([95.90.166.74] helo=phil.lan)
        by gloria.sntech.de with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <heiko@sntech.de>)
        id 1jltOQ-0007op-CH; Thu, 18 Jun 2020 14:11:42 +0200
From:   Heiko Stuebner <heiko@sntech.de>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     robh+dt@kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, heiko@sntech.de,
        christoph.muellner@theobroma-systems.com,
        Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
Subject: [PATCH v5 2/3] dt-bindings: net: mscc-vsc8531: add optional clock properties
Date:   Thu, 18 Jun 2020 14:11:38 +0200
Message-Id: <20200618121139.1703762-3-heiko@sntech.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200618121139.1703762-1-heiko@sntech.de>
References: <20200618121139.1703762-1-heiko@sntech.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiko Stuebner <heiko.stuebner@theobroma-systems.com>

Some mscc ethernet phys have a configurable clock output, so describe the
generic properties to access them in devicetrees.

Signed-off-by: Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
---
 Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt b/Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt
index 5ff37c68c941..67625ba27f53 100644
--- a/Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt
+++ b/Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt
@@ -1,6 +1,8 @@
 * Microsemi - vsc8531 Giga bit ethernet phy
 
 Optional properties:
+- clock-output-names	: Name for the exposed clock output
+- #clock-cells		: should be 0
 - vsc8531,vddmac	: The vddmac in mV. Allowed values is listed
 			  in the first row of Table 1 (below).
 			  This property is only used in combination
-- 
2.26.2

