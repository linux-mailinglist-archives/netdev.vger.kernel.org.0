Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC391DD4F8
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730318AbgEURsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:48:45 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:38410 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730247AbgEURsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:48:40 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04LHmZPv018701;
        Thu, 21 May 2020 12:48:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1590083315;
        bh=nY3Cdh1xvxTLtcQWq69MuPPZphUihk4XkAyW4FxqRXM=;
        h=From:To:CC:Subject:Date;
        b=hDajppMwp/uSIyJ4WcEX/o7efCUGaSAcMFgqHea8K5aFcz7ZPE2JhyQW5/P5TfwXo
         fLQb0Wh3kB7GBVW/W/OMZu8DwWYKiiWJ7GcW8mfvOxZI4DwTNbzmYsNeT8VQwQ4GR1
         BD+AIy9L20y48ioCWjQ78OvmoZ7azBgpoDIl7yUw=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04LHmZZp090442
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 21 May 2020 12:48:35 -0500
Received: from DLEE108.ent.ti.com (157.170.170.38) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 21
 May 2020 12:48:34 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 21 May 2020 12:48:35 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04LHmYmi058988;
        Thu, 21 May 2020 12:48:34 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <robh@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [RFC PATCH net-next 0/4] RGMII Internal delay common property
Date:   Thu, 21 May 2020 12:48:30 -0500
Message-ID: <20200521174834.3234-1-dmurphy@ti.com>
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

