Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C24519ABA
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 11:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbfEJJgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 05:36:04 -0400
Received: from smtp-out.xnet.cz ([178.217.244.18]:33048 "EHLO smtp-out.xnet.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727053AbfEJJfs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 May 2019 05:35:48 -0400
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id 8FA07434A;
        Fri, 10 May 2019 11:35:45 +0200 (CEST)
Received: by meh.true.cz (OpenSMTPD) with ESMTP id f025ad17;
        Fri, 10 May 2019 11:35:43 +0200 (CEST)
From:   =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Rob Herring <robh@kernel.org>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH net 2/5] dt-bindings: doc: net: remove Linux API references
Date:   Fri, 10 May 2019 11:35:15 +0200
Message-Id: <1557480918-9627-3-git-send-email-ynezz@true.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1557480918-9627-1-git-send-email-ynezz@true.cz>
References: <1557480918-9627-1-git-send-email-ynezz@true.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit 687e3d5550c7 ("dt-bindings: doc: reflect new NVMEM
of_get_mac_address behaviour") I've kept or added references to Linux
of_get_mac_address API which is unwanted so this patch fixes that by
removing those references.

Fixes: 687e3d5550c7 ("dt-bindings: doc: reflect new NVMEM of_get_mac_address behaviour")
Suggested-by: Rob Herring <robh@kernel.org>
Signed-off-by: Petr Štetiar <ynezz@true.cz>
---
 Documentation/devicetree/bindings/net/keystone-netcp.txt         | 6 +++---
 Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/keystone-netcp.txt b/Documentation/devicetree/bindings/net/keystone-netcp.txt
index 3a65aabc76a2..6262c2f293b0 100644
--- a/Documentation/devicetree/bindings/net/keystone-netcp.txt
+++ b/Documentation/devicetree/bindings/net/keystone-netcp.txt
@@ -139,9 +139,9 @@ Optional properties:
 			sub-module attached to this interface.
 
 The MAC address will be determined using the optional properties defined in
-ethernet.txt, as provided by the of_get_mac_address API and only if efuse-mac
-is set to 0. If any of the optional MAC address properties are not present,
-then the driver will use random MAC address.
+ethernet.txt and only if efuse-mac is set to 0. If all of the optional MAC
+address properties are not present, then the driver will use a random MAC
+address.
 
 Example binding:
 
diff --git a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt
index 74665502f4cf..7e675dafc256 100644
--- a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt
+++ b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt
@@ -16,8 +16,8 @@ Optional properties:
 - ieee80211-freq-limit: See ieee80211.txt
 - mediatek,mtd-eeprom: Specify a MTD partition + offset containing EEPROM data
 
-The driver is using of_get_mac_address API, so the MAC address can be as well
-be set with corresponding optional properties defined in net/ethernet.txt.
+The MAC address can as well be set with corresponding optional properties
+defined in net/ethernet.txt.
 
 Optional nodes:
 - led: Properties for a connected LED
-- 
1.9.1

