Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD0B27B035
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 16:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgI1Oqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 10:46:38 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:43496 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbgI1Oqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 10:46:38 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 08SEkT8v052758;
        Mon, 28 Sep 2020 09:46:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1601304389;
        bh=RKAU7cJ3uCiQXDzLCh3ir+TLGvUZfpks/Ta+DOTy05Y=;
        h=From:To:CC:Subject:Date;
        b=IGuc9ygfVhKeIpptSxEhZrVq1Qxy/LQ3BTZgYOcTmnjs/6/lT5amsRH/nrCwM8og1
         PmvZoNb2GrhZcxTJfCL80VcbqJpOksg+n4jRfLUNmR9XGmcw2XnkiepU7cRE7jtk3p
         yojYcpPppkZZ04NZWLUVhHT7DBl06zxbBwE046iA=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 08SEkTAk005942;
        Mon, 28 Sep 2020 09:46:29 -0500
Received: from DLEE111.ent.ti.com (157.170.170.22) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 28
 Sep 2020 09:46:29 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 28 Sep 2020 09:46:29 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 08SEkTDL100666;
        Mon, 28 Sep 2020 09:46:29 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>
CC:     <mkubecek@suse.cz>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v5 0/2] DP83869 WoL and Speed optimization
Date:   Mon, 28 Sep 2020 09:46:21 -0500
Message-ID: <20200928144623.19842-1-dmurphy@ti.com>
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

 arch/arm/configs/ti_sdk_omap2_debug_defconfig | 2335 +++++++++++++++++
 drivers/net/phy/dp83869.c                     |  292 +++
 2 files changed, 2627 insertions(+)
 create mode 100644 arch/arm/configs/ti_sdk_omap2_debug_defconfig

-- 
2.28.0.585.ge1cfff676549

