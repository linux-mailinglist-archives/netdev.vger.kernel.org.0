Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0490F1DE6C7
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 14:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729668AbgEVMZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 08:25:47 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:46606 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729377AbgEVMZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 08:25:45 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04MCPbtB069714;
        Fri, 22 May 2020 07:25:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1590150337;
        bh=nY3Cdh1xvxTLtcQWq69MuPPZphUihk4XkAyW4FxqRXM=;
        h=From:To:CC:Subject:Date;
        b=xCCkaXUJaV5yHTOApbH/JsRrclHfTpZdiV9sk5XJJ6HK6WAKshLV3xsAv2pQUq0wX
         9JNDvXLBneqEJsfz5KW0qFINMdxr7Zwa9Yzz5WjxwjZwfx845c9MgYA7TnzBLGkacA
         m4vWjgqF5zrRJHn3vOrdes/pZ9IOI34yzbdfpSpU=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04MCPbo9096427;
        Fri, 22 May 2020 07:25:37 -0500
Received: from DLEE106.ent.ti.com (157.170.170.36) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 22
 May 2020 07:25:36 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 22 May 2020 07:25:36 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04MCPaSr006917;
        Fri, 22 May 2020 07:25:36 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <robh@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v2 0/4] RGMII Internal delay common property
Date:   Fri, 22 May 2020 07:25:30 -0500
Message-ID: <20200522122534.3353-1-dmurphy@ti.com>
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

 .../bindings/net/ethernet-controller.yaml     |  14 +++
 .../devicetree/bindings/net/ti,dp83869.yaml   |  16 +++
 drivers/net/phy/dp83869.c                     | 101 ++++++++++++++++++
 drivers/net/phy/phy_device.c                  |  45 ++++++++
 include/linux/phy.h                           |   2 +
 5 files changed, 178 insertions(+)

-- 
2.26.2

