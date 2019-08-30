Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C717A3197
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 09:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728335AbfH3HwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 03:52:14 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:11873 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728191AbfH3HwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 03:52:12 -0400
Received-SPF: Pass (esa2.microchip.iphmx.com: domain of
  Razvan.Stefanescu@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Razvan.Stefanescu@microchip.com";
  x-sender="Razvan.Stefanescu@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa2.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Razvan.Stefanescu@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa2.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Razvan.Stefanescu@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: AkT+FMWxh1pWp+czqHmW91p5RGNGhmRxcNYFVW3aFIoS7uC2SQvovFaNdrmMwGVDFBR4oQuP6A
 WrTSZnDHpgOeeXDs1j3iaeJlEN6GeF74i0VCS+u18zG4tMxW7J2rhbia4C9upl/jHd6rMe/848
 oxfSCrkWjH5+EGWL+ZMNUiowlcffpgJlo78jKkwJm9jCmK+CF8DTe0u+sH+8hnCH6wkIIlmAaX
 FTaIPHWJ8UhbPPbL4mWhiblpzy/237CqtYmju4JuhmNr1lDwMG2hl1yTc4gZbjKGOQHy1FRcQi
 I6A=
X-IronPort-AV: E=Sophos;i="5.64,446,1559545200"; 
   d="scan'208";a="47133033"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Aug 2019 00:52:11 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 30 Aug 2019 00:52:11 -0700
Received: from rob-ult-m50855.microchip.com (10.10.85.251) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Fri, 30 Aug 2019 00:52:09 -0700
From:   Razvan Stefanescu <razvan.stefanescu@microchip.com>
To:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Razvan Stefanescu" <razvan.stefanescu@microchip.com>
Subject: [PATCH v2 1/2] dt-bindings: net: dsa: document additional Microchip KSZ8563 switch
Date:   Fri, 30 Aug 2019 10:52:01 +0300
Message-ID: <20190830075202.20740-2-razvan.stefanescu@microchip.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190830075202.20740-1-razvan.stefanescu@microchip.com>
References: <20190830075202.20740-1-razvan.stefanescu@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is a 3-Port 10/100 Ethernet Switch with 1588v2 PTP.

Signed-off-by: Razvan Stefanescu <razvan.stefanescu@microchip.com>
---
Changelog
v2: no update

 Documentation/devicetree/bindings/net/dsa/ksz.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/ksz.txt b/Documentation/devicetree/bindings/net/dsa/ksz.txt
index 5e8429b6f9ca..95e91e84151c 100644
--- a/Documentation/devicetree/bindings/net/dsa/ksz.txt
+++ b/Documentation/devicetree/bindings/net/dsa/ksz.txt
@@ -15,6 +15,7 @@ Required properties:
   - "microchip,ksz8565"
   - "microchip,ksz9893"
   - "microchip,ksz9563"
+  - "microchip,ksz8563"
 
 Optional properties:
 
-- 
2.20.1

