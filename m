Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A26DA341E31
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 14:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbhCSN3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 09:29:39 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:29461 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbhCSN3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 09:29:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1616160563; x=1647696563;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=+zHv1gzwLorPkoDPPvt3dNEZsfjgJVs7BawU9Py445g=;
  b=ZigNP/Gi2WdnEXYas0KeMsRV1dlV9mDWqmx8v/7tZf/2RjEPF2PJCD2z
   udTJHFXD+VhkfAFRj4f2KNZ+uMpvp7L05Zuah4Vbnat5LQGhaoKHh8euv
   4RWfIWlTukMBbcvk05LkJC+ARd7dyzfGdUEGVgJmQq8qyxjE3avY5dAFj
   mbgRUSI1iNmVJGRJcL9pPdmio0xFQnInE4eVXTWGR0PmiAAfK7pl0lATC
   ppvHgLE/vuRCJAsBKRwKeE0qLXc3dPVp5mxoEhvrUIaOPmZFwvuA3bXoM
   8wLmmeT0MtTpk8ES49tQIBZ6QS3HMiL1vJ9W/TbVT0KHC/CZB0SQoOm7L
   w==;
IronPort-SDR: 0Q+AeAthdPW4RYlD2gAKQK2273rLWFkZfuBwyN2tGPff5KAFfJb29VslTcSExX2ZR5Qe6WAFzS
 b8sDIKRWpVjoyplI03tCRUTnJwR3PdNAmebnXIw054wrHqOn/oSeq/tkVprujts5pk21QJ7FOt
 urZgyHz6cH6z5nPB0Ml4a3iuZ6jzFEMK1fPo3RTqLaeuuka/LIhmi0x27mN10jS7jdbwtxCXG8
 EXYoOb1JIDsehy+l6j7iCMrVlXrXMDwUcEnu0nXWNVMaRsVuCqsTtQ2z2dXCBJdVrWxVNI/xSg
 5qA=
X-IronPort-AV: E=Sophos;i="5.81,261,1610434800"; 
   d="scan'208";a="110624518"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Mar 2021 06:29:23 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 19 Mar 2021 06:29:16 -0700
Received: from soft-dev2.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Fri, 19 Mar 2021 06:29:13 -0700
From:   Bjarni Jonasson <bjarni.jonasson@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Vladimir Oltean" <vladimir.oltean@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Michael Walle <michael@walle.cc>
CC:     Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>
Subject: [PATCH net-next v2 0/3] Fixes applied to VCS8584 family
Date:   Fri, 19 Mar 2021 14:29:02 +0100
Message-ID: <20210319132905.9846-1-bjarni.jonasson@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Three different fixes applied to VSC8584 family:
1. LCPLL reset
2. Serdes calibration
3. Coma mode disabled

The same fixes has already been applied to VSC8514
and most of the functionality can be reused for the VSC8584.

v1 -> v2:
  Preserved reversed christmas tree

Bjarni Jonasson (3):
  net: phy: mscc: Applying LCPLL reset to VSC8584
  net: phy: mscc: improved serdes calibration applied to VSC8584
  net: phy: mscc: coma mode disabled for VSC8584

 drivers/net/phy/mscc/mscc_main.c | 217 +++++++++++++++++++++++--------
 1 file changed, 161 insertions(+), 56 deletions(-)

-- 
2.17.1

