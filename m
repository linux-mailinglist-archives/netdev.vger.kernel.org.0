Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 325561BC4B6
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 18:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728674AbgD1QLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 12:11:05 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:49480 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728390AbgD1QKD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 12:10:03 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 03SG9rBr098703;
        Tue, 28 Apr 2020 11:09:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588090193;
        bh=pWFC6a9Qbh3sjq2KJ7mhohvd+9WakZ3k6mQesnzqtvQ=;
        h=From:To:CC:Subject:Date;
        b=TAGQ4Ja/+a7NjRlrjtI5XymI0r5iSuhqG46wjHEwddNEg1PBp32y4/Qy9JVjb5Wsn
         NknEMLZETtpAXq9F2wUDXMd+d7zmjGaWedumnk9wK6YhMxH/ETowxX7oq6/gHa8NYv
         JyxvwzTgPKv6+3Hlwsu7Qsjd7VScCWhiduPUGIYo=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 03SG9rYL068216
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 28 Apr 2020 11:09:53 -0500
Received: from DLEE112.ent.ti.com (157.170.170.23) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 28
 Apr 2020 11:09:52 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 28 Apr 2020 11:09:52 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 03SG9qsK068720;
        Tue, 28 Apr 2020 11:09:52 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>
CC:     <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <afd@ti.com>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net v3 0/2]  WoL fixes for DP83822 and DP83tc811
Date:   Tue, 28 Apr 2020 11:03:52 -0500
Message-ID: <20200428160354.2879-1-dmurphy@ti.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello

The WoL feature for each device was enabled during boot or when the PHY was
brought up which may be undesired.  These patches disable the WoL in the
config_init.  The disabling and enabling of the WoL is now done though the
set_wol call.

Dan

Dan Murphy (2):
  net: phy: DP83822: Fix WoL in config init to be disabled
  net: phy: DP83TC811: Fix WoL in config init to be disabled

 drivers/net/phy/dp83822.c   | 30 ++++++++++++++----------------
 drivers/net/phy/dp83tc811.c | 21 ++++++++++++---------
 2 files changed, 26 insertions(+), 25 deletions(-)

-- 
2.25.1

