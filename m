Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 465B31BB07C
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 23:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgD0V1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 17:27:35 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:40030 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbgD0V1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 17:27:33 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 03RLRB8f030240;
        Mon, 27 Apr 2020 16:27:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588022831;
        bh=pWFC6a9Qbh3sjq2KJ7mhohvd+9WakZ3k6mQesnzqtvQ=;
        h=From:To:CC:Subject:Date;
        b=RO3v5GTg/Ir5sDZX0+sX7N7jZbfrVoyzJkaCbtqp1DOkKCP3wjULxpyF18DwbP0Wx
         n392R/5HQW0Izw11NncVdDSJvR6hjQOzEzF3FRhuoMjcQA3QoY7IiMjQMnt8SI3Sk6
         Y0ongCDjxm6ygsAntpdJ2C6p4xu8Ml9G+B0+BLQE=
Received: from DLEE111.ent.ti.com (dlee111.ent.ti.com [157.170.170.22])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 03RLRBTO002506;
        Mon, 27 Apr 2020 16:27:11 -0500
Received: from DLEE115.ent.ti.com (157.170.170.26) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 27
 Apr 2020 16:27:10 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 27 Apr 2020 16:27:10 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 03RLRAod048636;
        Mon, 27 Apr 2020 16:27:10 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>
CC:     <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <afd@ti.com>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net v2 0/2] WoL fixes for DP83822 and DP83tc811
Date:   Mon, 27 Apr 2020 16:21:10 -0500
Message-ID: <20200427212112.25368-1-dmurphy@ti.com>
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

