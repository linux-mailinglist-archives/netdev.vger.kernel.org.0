Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0CFF2776AF
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 18:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727353AbgIXQ1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 12:27:23 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:37484 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbgIXQ1W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 12:27:22 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 08OGRDpD089144;
        Thu, 24 Sep 2020 11:27:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1600964833;
        bh=4Q3CyoqtJO8AKENo6GVo6YheNISKLUd1oQPIyIsHMhI=;
        h=From:To:CC:Subject:Date;
        b=Qih9bck52RVy83K26xqw5J67iuyIjr/3+MqteBcPsk3+wM7n6mcoBM24KnjIw9J8K
         OxC3I15IUKiAj1nCoeVxKVzXAmiT5KrnDpQMnRpHW4epzFKndaGmIVyCOrYc6DX+gz
         AKU/Qcqaa/f2HVe68W/A8Jp5NS5BBUfPfeLcCn7w=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 08OGRDcG059717
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 24 Sep 2020 11:27:13 -0500
Received: from DLEE107.ent.ti.com (157.170.170.37) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 24
 Sep 2020 11:27:13 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 24 Sep 2020 11:27:13 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 08OGRDGK072758;
        Thu, 24 Sep 2020 11:27:13 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>
CC:     <mkubecek@suse.cz>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v4 0/2] DP83869 WoL and Speed optimization
Date:   Thu, 24 Sep 2020 11:27:05 -0500
Message-ID: <20200924162707.14093-1-dmurphy@ti.com>
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
2.28.0

