Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87E72E1E9D
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 16:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392387AbfJWOug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 10:50:36 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:39778 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392389AbfJWOug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 10:50:36 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id x9NEoT2R081469;
        Wed, 23 Oct 2019 09:50:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1571842229;
        bh=A1IGF9qKXjmCDeZXKptrYPmlaSRwZk2PBdiReliMkS0=;
        h=From:To:CC:Subject:Date;
        b=bi7ckL0WR7LMKgc7F14aAJmlsvepyonxuPH/kGlALyoJJXCBunwC+aF8BE0wCSO3U
         2Wq8op54gA4J/e1SAGAs8e6ePMX84XWcPpp44QdxK0O5rkAG8PxptCqOV0VfsLcOwB
         6QcA5a05ybHttIHeUKWIvySgnXulLH52T3KfzLC8=
Received: from DLEE111.ent.ti.com (dlee111.ent.ti.com [157.170.170.22])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id x9NEoSE3108472;
        Wed, 23 Oct 2019 09:50:29 -0500
Received: from DLEE111.ent.ti.com (157.170.170.22) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Wed, 23
 Oct 2019 09:50:18 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Wed, 23 Oct 2019 09:50:18 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id x9NEoRnm130277;
        Wed, 23 Oct 2019 09:50:28 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH 0/2] net: phy: dp83867: enable robust auto-mdix
Date:   Wed, 23 Oct 2019 17:48:44 +0300
Message-ID: <20191023144846.1381-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

Patch 1 - improves link detection when dp83867 PHY is configured in manual mode
by enabling CFG3[9] Robust Auto-MDIX option.

Patch 2 - is minor optimization.

Grygorii Strashko (2):
  net: phy: dp83867: enable robust auto-mdix
  net: phy: dp83867: move dt parsing to probe

 drivers/net/phy/dp83867.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

-- 
2.17.1

