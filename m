Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE9AF2F166A
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 14:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731093AbhAKNIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 08:08:54 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:43244 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731071AbhAKNIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 08:08:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1610370530; x=1641906530;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=SZdfnr5UG13cVDMwC8iTHnUXXEdughCiI8OHKTE/Eno=;
  b=OOqEIrpur3+E4RlDMLBMON9QSWFKKj42yUKRkRsSh461VJyTFd6yABGx
   3w4qiXr43WQf4Zv1XRQSVXCM071Q3310CgjOhVCVX2MRqSnguSufU6K7s
   kKO61sV+HI/+ZUxlCMn0jecSqTYe/+U7HgLnfDFlxxomcDOZznD6DKwII
   ZTWtWbETmXKoZ/jdH/cUTgUmxWR0rES0CKyTkzusai4sUJlyPLdbxgKzY
   8A6+rou1qdqmkf5iYmWhFVaR9ry1OBRf1oKZIv97D+z8S2Ezw8RhAuJ3Q
   vPlcqohHXvRH5chLuMiIDTAx/fApfNMRO1sTEj+cKziUDDEetIVWaQVNd
   g==;
IronPort-SDR: s4OBNZPLmmFt6n5nBH+TBuZ7RxSoNm1OcBjhxNOphcfDj+i1qVE/0tTPX9Kyxx28bghgB+mJRF
 muHXbGJaJ2mFvPGZatWdL9Fc2D7iaFCo4XKthi8CdOoUobz0k7lfazued87cbkwXMfkYjHsiCs
 S4gRadzTdbA629CAoBqoy9nDCdkSKujK0PfMv9z4nXJthIkouAszhEq4pmAckvezXrINOEC+2Q
 TACpoNn18/zyYjnkVWm8t4AjpCxejU6LPPi+EwWy9qZp+zeT9YuCEhoW/uxmT1CBCz/SNYTY5f
 ZM8=
X-IronPort-AV: E=Sophos;i="5.79,338,1602572400"; 
   d="scan'208";a="105520718"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Jan 2021 06:07:35 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 11 Jan 2021 06:07:34 -0700
Received: from soft-dev2.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Mon, 11 Jan 2021 06:07:32 -0700
From:   Bjarni Jonasson <bjarni.jonasson@microchip.com>
To:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        "Heiner Kallweit" <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>
Subject: [PATCH v1 0/2] Add 100 base-x mode
Date:   Mon, 11 Jan 2021 14:06:55 +0100
Message-ID: <20210111130657.10703-1-bjarni.jonasson@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding support for 100 base-x in phylink.
The Sparx5 switch supports 100 base-x pcs (IEEE 802.3 Clause 24) 4b5b encoded.
These patches adds phylink support for that mode.

Tested in Sparx5, using sfp modules:
Axcen 100fx AXFE-1314-0521 
Cisco GLC-FE-100LX
HP SFP 100FX J9054C
Excom SFP-SX-M1002

Bjarni Jonasson (2):
  net: phy: Add 100 base-x mode
  sfp: add support for 100 base-x SFPs

 drivers/net/phy/sfp-bus.c | 9 +++++++++
 include/linux/phy.h       | 4 ++++
 2 files changed, 13 insertions(+)

-- 
2.17.1

