Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16EDC1EC04D
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 18:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbgFBQpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 12:45:39 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:56462 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbgFBQpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 12:45:39 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 052GjTqp021845;
        Tue, 2 Jun 2020 11:45:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1591116329;
        bh=FkD8MfXarrMT52/8HocMxQ3RjzaE8Cf7SRdZEsk5RS8=;
        h=From:To:CC:Subject:Date;
        b=uMmpehXCTVESUmMieJmjsoGYuYT1V82+xJExzq2XaqKTCRbUxKWX6aesCxqcRVi4g
         ewAIKf42ln3Q+6Y+CyinvEDWdQKkXXYaQhvAfQuZLphIHbu7HyzI/7kHgHjwR4gWeO
         d3cEQadF1EtNjx+XhQVqpd+X6jAKP5WVvzzuUYqA=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 052GjTRr118087
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 2 Jun 2020 11:45:29 -0500
Received: from DFLE106.ent.ti.com (10.64.6.27) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 2 Jun
 2020 11:45:28 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 2 Jun 2020 11:45:28 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 052GjSse105213;
        Tue, 2 Jun 2020 11:45:28 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <robh@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v5 0/4] RGMII Internal delay common property
Date:   Tue, 2 Jun 2020 11:45:18 -0500
Message-ID: <20200602164522.3276-1-dmurphy@ti.com>
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

 .../devicetree/bindings/net/ethernet-phy.yaml | 13 +++
 .../devicetree/bindings/net/ti,dp83869.yaml   | 16 +++-
 drivers/net/phy/dp83869.c                     | 82 ++++++++++++++++++-
 drivers/net/phy/phy_device.c                  | 51 ++++++++++++
 include/linux/phy.h                           |  2 +
 5 files changed, 160 insertions(+), 4 deletions(-)

-- 
2.26.2

