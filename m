Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71BC93450F3
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:38:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232098AbhCVUh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:37:57 -0400
Received: from mx3.wp.pl ([212.77.101.9]:16425 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231565AbhCVUhn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 16:37:43 -0400
Received: (wp-smtpd smtp.wp.pl 20356 invoked from network); 22 Mar 2021 21:37:41 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1616445462; bh=o94tkwrqVWEmgKEXCHzrLb0JlcxwSS/Fe4MA+Z0KhV0=;
          h=From:To:Cc:Subject;
          b=C+NEBhkE10X90SjiNJVqb8+fj29E8SUF4zlDOwgnOUupKQ9seEAnplYLN4R+LORMF
           ysLF6s9gozG1TRasensqIKrwLrojLbF/xkZbMXte4wpqKsHcti0LlQ6r8t44aCJYvI
           6nLt+F/fhelJt9eEkQVbhv/as2xN6EZYSyy2QFqM=
Received: from riviera.nat.ds.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.1])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <hauke@hauke-m.de>; 22 Mar 2021 21:37:41 +0100
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     hauke@hauke-m.de, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, linux@armlinux.org.uk, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: [PATCH v4 3/3] dt-bindings: net: dsa: lantiq: add xRx300 and xRX330 switch bindings
Date:   Mon, 22 Mar 2021 21:37:17 +0100
Message-Id: <20210322203717.20616-4-olek2@wp.pl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210322203717.20616-1-olek2@wp.pl>
References: <20210322203717.20616-1-olek2@wp.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-DKIM-Status: good (id: wp.pl)                                      
X-WP-MailID: f6e22edb542e4ae8ec30c62ce8667e97
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0100004 [Ubcg]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add compatible string for xRX300 and xRX330 SoCs.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 Documentation/devicetree/bindings/net/dsa/lantiq-gswip.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/lantiq-gswip.txt b/Documentation/devicetree/bindings/net/dsa/lantiq-gswip.txt
index 886cbe8ffb38..e3829d3e480e 100644
--- a/Documentation/devicetree/bindings/net/dsa/lantiq-gswip.txt
+++ b/Documentation/devicetree/bindings/net/dsa/lantiq-gswip.txt
@@ -5,6 +5,10 @@ Required properties for GSWIP core:
 
 - compatible	: "lantiq,xrx200-gswip" for the embedded GSWIP in the
 		  xRX200 SoC
+		  "lantiq,xrx300-gswip" for the embedded GSWIP in the
+		  xRX300 SoC
+		  "lantiq,xrx330-gswip" for the embedded GSWIP in the
+		  xRX330 SoC
 - reg		: memory range of the GSWIP core registers
 		: memory range of the GSWIP MDIO registers
 		: memory range of the GSWIP MII registers
-- 
2.20.1

