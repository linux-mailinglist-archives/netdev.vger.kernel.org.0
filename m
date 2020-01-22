Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5171458E4
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 16:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727893AbgAVPiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 10:38:23 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:34142 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgAVPiM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 10:38:12 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 00MFc64N053401;
        Wed, 22 Jan 2020 09:38:06 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1579707486;
        bh=gptPn5JV0Z9r0tllS+JsI3igBFadtomuQS48o3mt75o=;
        h=From:To:CC:Subject:Date;
        b=MRr4wQvgeZTvo2zA937SdJ4I1Rur0kKWbAWWDJ3f6R/JFCcVzuxCbGjCOZQFS73pW
         DJdRitcbHxA8oE8VptSWWfqdMSbAzzGMojvXpUHEizqf+jx7IKWQht3O0pdXxUiZO8
         lkC1/nxYoXf2Y9UNSFK3weA+dOFh4sCwYPbqEKJw=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 00MFc65d108189
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 22 Jan 2020 09:38:06 -0600
Received: from DLEE104.ent.ti.com (157.170.170.34) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Wed, 22
 Jan 2020 09:38:05 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Wed, 22 Jan 2020 09:38:05 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 00MFc5EU062026;
        Wed, 22 Jan 2020 09:38:05 -0600
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <bunk@kernel.org>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next 0/2] Add PHY IDs for DP83825/6
Date:   Wed, 22 Jan 2020 09:34:53 -0600
Message-ID: <20200122153455.8777-1-dmurphy@ti.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello

Adding new PHY IDs for the DP83825 and DP83826 TI Ethernet PHYs to the DP83822
PHY driver.

Dan

Dan Murphy (2):
  phy: dp83826: Add phy IDs for DP83826N and 826NC
  net: phy: DP83822: Add support for additional DP83825 devices

 drivers/net/phy/Kconfig   |  5 +++--
 drivers/net/phy/dp83822.c | 18 ++++++++++++++++--
 2 files changed, 19 insertions(+), 4 deletions(-)

-- 
2.25.0

