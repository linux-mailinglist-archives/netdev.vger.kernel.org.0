Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E93A11DD4C5
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729392AbgEURrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:47:48 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:38320 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728961AbgEURrr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:47:47 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04LHleWn018533;
        Thu, 21 May 2020 12:47:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1590083260;
        bh=W7VdXvJ1bJSYxANNMUlbEw5VMMcgdV+4t6nd72fBXgc=;
        h=From:To:CC:Subject:Date;
        b=sL3s4iKI+4MzZ864t4gNSLn3uXLHvifMch1HP1XeYj7iOWeODZdYt0G4jjkYnSbWb
         VsKqn8n67hjv8tTQGxShkBPwWgad0SDCMNH7jEw8KcpGDsiVaTbllJVPvUqDuDAown
         Adb6RgquUJQULqLUQ9VyXRe1QzDLeIRpIp2Jngso=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04LHldYc115837
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 21 May 2020 12:47:39 -0500
Received: from DFLE114.ent.ti.com (10.64.6.35) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 21
 May 2020 12:47:39 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 21 May 2020 12:47:39 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04LHldOu081106;
        Thu, 21 May 2020 12:47:39 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v3 0/2] DP83869 Enhancements
Date:   Thu, 21 May 2020 12:47:36 -0500
Message-ID: <20200521174738.3151-1-dmurphy@ti.com>
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

These are improvements to the DP83869 Ethernet PHY driver.  OP-mode and port
mirroring may be strapped on the device but the software only retrives these
settings from the device tree.  Reading the straps and initializing the
associated stored variables so when setting the PHY up and down the PHY's
configuration values will be retained.

Dan Murphy (2):
  net: phy: dp83869: Update port-mirroring to read straps
  net: phy: dp83869: Set opmode from straps

 drivers/net/phy/dp83869.c | 36 ++++++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

-- 
2.26.2

