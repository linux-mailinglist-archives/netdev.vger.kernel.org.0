Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5655127B04F
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 16:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbgI1Ovs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 10:51:48 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:46054 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbgI1Ovr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 10:51:47 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 08SEpfcq056342;
        Mon, 28 Sep 2020 09:51:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1601304701;
        bh=FYsYgfdUfkCM21ZQGEi/GashHZ6P3nUYJMgbxNTRUJw=;
        h=From:To:CC:Subject:Date;
        b=tZD79WUlP/M79ETuLDZaEu8C3MugD1VImQI7PlyBIrwgntyf5HXqnyhAlchNwgTPo
         MwNzdOF0xruHYxqI9Ff+Wb8IokcMFRFqgQesJ0cjALmYQ/56PWczP5SsCEnva9UWR7
         UddSPiwZbuWgoFbpbjckWK7PFn5MH8f6lknrSfL0=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 08SEpfIB034827
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 28 Sep 2020 09:51:41 -0500
Received: from DFLE112.ent.ti.com (10.64.6.33) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 28
 Sep 2020 09:51:41 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 28 Sep 2020 09:51:41 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 08SEpfXe085712;
        Mon, 28 Sep 2020 09:51:41 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>
CC:     <mkubecek@suse.cz>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [RESEND PATCH net-next v5 0/2] DP83869 WoL and Speed optimization
Date:   Mon, 28 Sep 2020 09:51:33 -0500
Message-ID: <20200928145135.20847-1-dmurphy@ti.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello

Add the WoL and Speed Optimization (aka downshift) support for the DP83869
Ethernet PHY.

Dan

Dan Murphy (2):
  net: phy: dp83869: support Wake on LAN
  net: phy: dp83869: Add speed optimization feature

 drivers/net/phy/dp83869.c | 292 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 292 insertions(+)

-- 
2.28.0.585.ge1cfff676549

