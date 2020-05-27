Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5E91E4AE9
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 18:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729999AbgE0Qtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 12:49:47 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:47260 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728067AbgE0Qtr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 12:49:47 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04RGne3t104888;
        Wed, 27 May 2020 11:49:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1590598180;
        bh=+orVkdrpm42KPb/u5OPot2y6lpiRhwvF/BS4zRx0eQY=;
        h=From:To:CC:Subject:Date;
        b=itrOtIMKQCjJHn1Xa4Z0oEvQL+qhnDL0l3TcADboTmw7NdQ933Tz7k3hrYvdKozTr
         rZ2pK2UnuO1vPcqBDv+xpus44Tttm6jeC4rScf8RD3/Ud5+SmSeggOMDwotnOqxeM1
         lIhVRN/rsSk3tSL4TNtL1OpGKNxqpL/pvh6dTEZo=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04RGnep2121105
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 27 May 2020 11:49:40 -0500
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 27
 May 2020 11:49:40 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 27 May 2020 11:49:40 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04RGneER049223;
        Wed, 27 May 2020 11:49:40 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <robh@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v4 0/4] RGMII Internal delay common property
Date:   Wed, 27 May 2020 11:49:30 -0500
Message-ID: <20200527164934.28651-1-dmurphy@ti.com>
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

 .../bindings/net/ethernet-controller.yaml     | 14 ++++
 .../devicetree/bindings/net/ti,dp83869.yaml   | 16 ++++
 drivers/net/phy/dp83869.c                     | 82 ++++++++++++++++++-
 drivers/net/phy/phy_device.c                  | 51 ++++++++++++
 include/linux/phy.h                           |  2 +
 5 files changed, 162 insertions(+), 3 deletions(-)

-- 
2.26.2

