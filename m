Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5729E443
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 11:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728988AbfH0JbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 05:31:22 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:35609 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfH0JbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 05:31:22 -0400
Received-SPF: Pass (esa4.microchip.iphmx.com: domain of
  Razvan.Stefanescu@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Razvan.Stefanescu@microchip.com";
  x-sender="Razvan.Stefanescu@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa4.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Razvan.Stefanescu@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa4.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Razvan.Stefanescu@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: F/85ZCE1lm/jNNZ8/t7b1Tq3uz2vKdhhTlm6orUiWGP+yqpl3/7dYEUrx+mBiuDD8T9J45IMNb
 ndUMIVtESF4MOuduzBUcKLZNPLOvNLPKdm+343YKSW6Bq47MqlM0vv9jDV/gtjZpLsk7QaYCxE
 V9ijEtb6Y6eFPxzNo3ExVc3MoWUQTm8gWxWCQFtu4+cWIHLFt4EKBPrTomvtniaX1wnNFM4bjK
 GIEiF4TJb2RuVUQiQdDuCpLWJxLA3dr52AskUTKlcL0/wlttLNkdw+06ixJ8WqH4PuB6AIou7U
 q80=
X-IronPort-AV: E=Sophos;i="5.64,436,1559545200"; 
   d="scan'208";a="45737824"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Aug 2019 02:31:21 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 27 Aug 2019 02:31:20 -0700
Received: from rob-ult-m50855.microchip.com (10.10.85.251) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Tue, 27 Aug 2019 02:31:18 -0700
From:   Razvan Stefanescu <razvan.stefanescu@microchip.com>
To:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Razvan Stefanescu" <razvan.stefanescu@microchip.com>
Subject: [PATCH 0/4] net: dsa: microchip: add KSZ8563 support
Date:   Tue, 27 Aug 2019 12:31:06 +0300
Message-ID: <20190827093110.14957-1-razvan.stefanescu@microchip.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds compatiblity strings for the KSZ8563 switch and
also adds two small fixes to the ksz9477 driver.

Razvan Stefanescu (4):
  dt-bindings: net: dsa: document additional Microchip KSZ8563 switch
  net: dsa: microchip: add KSZ8563 compatibility string
  net: dsa: microchip: fix interrupt mask
  net: dsa: microchip: avoid hard-codded port count

 Documentation/devicetree/bindings/net/dsa/ksz.txt | 1 +
 drivers/net/dsa/microchip/ksz9477.c               | 2 +-
 drivers/net/dsa/microchip/ksz9477_reg.h           | 2 +-
 drivers/net/dsa/microchip/ksz9477_spi.c           | 1 +
 4 files changed, 4 insertions(+), 2 deletions(-)

-- 
2.20.1

