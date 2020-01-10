Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1CCA137664
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 19:51:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728508AbgAJSuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 13:50:03 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:44552 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728023AbgAJSuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 13:50:03 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 00AInvol001020;
        Fri, 10 Jan 2020 12:49:57 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1578682197;
        bh=QiEc6ArfHTptUPBAOFU+sNACtfbr+yuOmaOUK9D+QHU=;
        h=From:To:CC:Subject:Date;
        b=QReFX7tZTkU+LO6egnmoHiCM4kOa/mQastNOShU+FwqpuzuBEzgLQAVPEkSaVqweJ
         MlPKKDownzOLkZ4urudUjZ5Z0Y5aqa0fSpluyJAdhGQnRNpJ8tEwV/4nLx87tFZEPC
         GgwGEEvUt4NF6w4MBFEYOqdSIY/fPNDLBN8s1uX0=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 00AInvFb082403
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 10 Jan 2020 12:49:57 -0600
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 10
 Jan 2020 12:49:56 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 10 Jan 2020 12:49:56 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 00AInuFc088619;
        Fri, 10 Jan 2020 12:49:56 -0600
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH 0/4] TI DP8382x Phy support update
Date:   Fri, 10 Jan 2020 12:46:58 -0600
Message-ID: <20200110184702.14330-1-dmurphy@ti.com>
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

These patches update and fix some issue found in the TI ethernet PHY drivers.
In adding new support for newer PHYs I found missing items and typos that are
now addressed in this series.

Additional support for the following
DP83825CM, DP83825CS, DP83825S, DP83826C and DP83826NC.

Dan

Dan Murphy (4):
  net: phy: DP83TC811: Fix typo in Kconfig
  net: phy: DP83822: Update Kconfig with DP83825I support
  phy: dp83826: Add phy IDs for DP83826N and 826NC
  net: phy: DP83822: Add support for additional DP83825 devices

 drivers/net/phy/Kconfig   |  9 +++++----
 drivers/net/phy/dp83822.c | 18 ++++++++++++++++--
 2 files changed, 21 insertions(+), 6 deletions(-)

-- 
2.23.0

