Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32B833A5824
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 13:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbhFMMAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 08:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231691AbhFMMAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Jun 2021 08:00:48 -0400
Received: from mxout012.mail.hostpoint.ch (mxout012.mail.hostpoint.ch [IPv6:2a00:d70:0:e::312])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E887C061574;
        Sun, 13 Jun 2021 04:58:46 -0700 (PDT)
Received: from [10.0.2.44] (helo=asmtp014.mail.hostpoint.ch)
        by mxout012.mail.hostpoint.ch with esmtp (Exim 4.94.2 (FreeBSD))
        (envelope-from <code@reto-schneider.ch>)
        id 1lsOlF-0001z5-Sq; Sun, 13 Jun 2021 13:58:41 +0200
Received: from [2a02:168:6182:1:d747:8127:5b7a:4266] (helo=eleanor.home.reto-schneider.ch)
        by asmtp014.mail.hostpoint.ch with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2 (FreeBSD))
        (envelope-from <code@reto-schneider.ch>)
        id 1lsOlF-0008UX-Qz; Sun, 13 Jun 2021 13:58:41 +0200
X-Authenticated-Sender-Id: reto-schneider@reto-schneider.ch
From:   Reto Schneider <code@reto-schneider.ch>
To:     devicetree@vger.kernel.org, linux-mediatek@lists.infradead.org,
        netdev@vger.kernel.org
Cc:     Stefan Roese <sr@denx.de>,
        Reto Schneider <reto.schneider@husqvarnagroup.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 1/2] dt-bindings: net: mediatek: Support custom ifname
Date:   Sun, 13 Jun 2021 13:58:18 +0200
Message-Id: <20210613115820.1525478-1-code@reto-schneider.ch>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Reto Schneider <reto.schneider@husqvarnagroup.com>

The (optional) label property allows to specify customized interfaces
names.

The motivation behind this change is to allow embedded devices to keep
their first switch port be named "eth0", even when switching to the DSA
architecture. In order to do so, it must be possible to name the MAC
interface differently from eth0.

Signed-off-by: Reto Schneider <reto.schneider@husqvarnagroup.com>
---

 Documentation/devicetree/bindings/net/mediatek-net.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/mediatek-net.txt b/Documentation/devicetree/bindings/net/mediatek-net.txt
index 72d03e07cf7c..93e35f239a0a 100644
--- a/Documentation/devicetree/bindings/net/mediatek-net.txt
+++ b/Documentation/devicetree/bindings/net/mediatek-net.txt
@@ -51,6 +51,9 @@ Required properties:
 	is equal to 0 and the MAC uses fixed-link to connect
 	with internal switch such as MT7530.
 
+Optional properties:
+- label: Name of interface, defaults to ethX if missing
+
 Example:
 
 eth: ethernet@1b100000 {
@@ -76,6 +79,7 @@ eth: ethernet@1b100000 {
 		compatible = "mediatek,eth-mac";
 		reg = <0>;
 		phy-handle = <&phy0>;
+		label = "mac1";
 	};
 
 	gmac2: mac@1 {
-- 
2.30.2

