Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43F061EE319
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 13:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgFDLOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 07:14:22 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:43710 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbgFDLOV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 07:14:21 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 054BECJh117018;
        Thu, 4 Jun 2020 06:14:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1591269252;
        bh=XwPye/lXt4xwD158SWEeAIdpmucSTrF0pqrdUf2BvTI=;
        h=From:To:CC:Subject:Date;
        b=lFoXN+fC3TDWkKHblozftAgdjC26t/rBwnF4lm3XvypSEQWJJBSWIl8licVgCjITV
         Ajev7e85B3vighDES54zGkGRyQ9S0F9+i+B1qc8C9s26apkZv/cFt3ovmGk/Hra8wq
         r8XVJ7niPCI/HlAndmJaP2b9qpm7pzFc48a2SY3Y=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 054BECLu117133
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 4 Jun 2020 06:14:12 -0500
Received: from DLEE100.ent.ti.com (157.170.170.30) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 4 Jun
 2020 06:14:12 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 4 Jun 2020 06:14:12 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 054BEBrg061694;
        Thu, 4 Jun 2020 06:14:11 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <robh@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v6 0/4] RGMII Internal delay common property
Date:   Thu, 4 Jun 2020 06:14:06 -0500
Message-ID: <20200604111410.17918-1-dmurphy@ti.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello

The RGMII internal delay is a common setting found in most RGMII capable PHY
devices.  It was found that many vendor specific device tree properties exist
to do the same function. This creates a common property to be used for PHY's
that have tunable internal delays for the Rx and Tx paths.

Dan Murphy (4):
  dt-bindings: net: Add tx and rx internal delays
  net: phy: Add a helper to return the index for of the internal delay
  dt-bindings: net: Add RGMII internal delay for DP83869
  net: dp83869: Add RGMII internal delay configuration

 .../devicetree/bindings/net/ethernet-phy.yaml | 13 ++++
 .../devicetree/bindings/net/ti,dp83869.yaml   | 16 ++++-
 drivers/net/phy/dp83869.c                     | 53 ++++++++++++++-
 drivers/net/phy/phy_device.c                  | 68 +++++++++++++++++++
 include/linux/phy.h                           |  4 ++
 5 files changed, 150 insertions(+), 4 deletions(-)

-- 
2.26.2

