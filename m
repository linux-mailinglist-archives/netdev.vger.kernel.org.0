Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3D601377AE
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 21:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728811AbgAJUHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 15:07:08 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:52942 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727956AbgAJUG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 15:06:57 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 00AK6ruf029361;
        Fri, 10 Jan 2020 14:06:53 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1578686813;
        bh=IozzdMrUb4R/XgtgWkkP2e/bkoIR5wH6wv0MqRF3Mj8=;
        h=From:To:CC:Subject:Date;
        b=Q5B1JoM3zXz2VPmPolv26JEI3VcEYMW/XO0Go/+cY1zNxC0H0W/No6/QgkyPznNVV
         OjfSClNT7xi3byUTiA7e5e72qSzRMu7UXpgEV2xe0AcdiKQcI2j1Clp/MsxNqADgVY
         Sl7xoWl0pNqnMO6U6EVxbE3ACEnpRzNwcAEMVXKg=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 00AK6rBV043511
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 10 Jan 2020 14:06:53 -0600
Received: from DLEE102.ent.ti.com (157.170.170.32) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 10
 Jan 2020 14:06:52 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 10 Jan 2020 14:06:52 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 00AK6qDM033635;
        Fri, 10 Jan 2020 14:06:52 -0600
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH netdev v2 0/2] DP83822 and DP83TC811 Fixes
Date:   Fri, 10 Jan 2020 14:03:55 -0600
Message-ID: <20200110200357.26232-1-dmurphy@ti.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello

Two fixes on net/phy/Kconfig for the TI ethernet PHYs.
First fixed the typo in the Kconfig for the DP83TC811 where it incorretly stated
that the support was for a DP83TC822 which does not exist.

Second fix was to update the DP83822 Kconfig entry to indicate support for the
DP83825 devices in the description and the prompt.

Dan

Dan Murphy (2):
  net: phy: DP83TC811: Fix typo in Kconfig
  net: phy: DP83822: Update Kconfig with DP83825I support

 drivers/net/phy/Kconfig | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

-- 
2.23.0

