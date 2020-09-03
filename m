Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4CF525C4B4
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 17:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729558AbgICPOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 11:14:22 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:39824 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728629AbgICLnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 07:43:15 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 083Bh1FO127186;
        Thu, 3 Sep 2020 06:43:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1599133381;
        bh=EAbt1qPh14EomVGd85mBXEAKdAVjaqQGm+uYE8j3Roo=;
        h=From:To:CC:Subject:Date;
        b=ssN6UsZBbmBZz/pml+3gOmPfg+qk/t99T6v8Xyd0hYR3b5X4XAsVblZpRpN2uRu+p
         oEvZnJsdQYvhY6HYABlWsCvRe6X5Big2UpfvQoZrVaj2iH/mLxZ0vP1XPGE8cTiY6v
         EhtK6l3VHKRiHfsyoEBXcGjdv6qW8xAgwsvC2k6Y=
Received: from DFLE111.ent.ti.com (dfle111.ent.ti.com [10.64.6.32])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 083Bh1du047253
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 3 Sep 2020 06:43:01 -0500
Received: from DFLE114.ent.ti.com (10.64.6.35) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 3 Sep
 2020 06:43:00 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 3 Sep 2020 06:43:00 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 083Bh08N075354;
        Thu, 3 Sep 2020 06:43:00 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v3 0/3] DP83869 Feature additions
Date:   Thu, 3 Sep 2020 06:42:56 -0500
Message-ID: <20200903114259.14013-1-dmurphy@ti.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello

Adding features to the DP83869 PHY.  These features are also supported in other
TI PHYs like the DP83867 and DP83822.

Fiber Advertisement:
The DP83869 supports a 100Base-FX connection. When this mode is selected the
driver needs to advertise that this PHY supports fiber.

WoL:
The PHY also supports Wake on Lan feature with SecureOn password.

Downshift:
Speed optimization or AKA downshift is also supported by this PHY.

Dan

Dan Murphy (3):
  net: dp83869: Add ability to advertise Fiber connection
  net: phy: dp83869: support Wake on LAN
  net: dp83869: Add speed optimization feature

 drivers/net/phy/dp83869.c | 280 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 280 insertions(+)

-- 
2.28.0

