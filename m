Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC58144CBD
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 09:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729019AbgAVICI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 03:02:08 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:39220 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbgAVICI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 03:02:08 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 00M81iXB096342;
        Wed, 22 Jan 2020 02:01:44 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1579680104;
        bh=6IDBUxOmtTdvVpWE+GGfcIBsvqixex6LMLwXZYg8ZYE=;
        h=From:To:CC:Subject:Date;
        b=Kx8VuYQue/C30SrIRA+lvNTcVT02F0tlajt7YFrt3Cj7/89MvjAzF5skEL6TL7pSc
         oDHjmwLSGEpTUztOaadrjUIh4Qjh0QgPLourQe3nLGe8/Wbuhk+0mrj6i1xZQ8M0CQ
         bf/JPvzj83H86TrDf3ZBOl9TDMPcDjyxEhSOm6cY=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 00M81hkk079051
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 22 Jan 2020 02:01:44 -0600
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Wed, 22
 Jan 2020 02:01:43 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Wed, 22 Jan 2020 02:01:43 -0600
Received: from a0230074-OptiPlex-7010.india.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 00M81ctm007984;
        Wed, 22 Jan 2020 02:01:39 -0600
From:   Faiz Abbas <faiz_abbas@ti.com>
To:     <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-can@vger.kernel.org>
CC:     <catalin.marinas@arm.com>, <mark.rutland@arm.com>,
        <robh+dt@kernel.org>, <davem@davemloft.net>, <mkl@pengutronix.de>,
        <wg@grandegger.com>, <sriram.dash@samsung.com>, <dmurphy@ti.com>,
        <faiz_abbas@ti.com>, <nm@ti.com>, <t-kristo@ti.com>
Subject: [PATCH 0/3] Add Support for MCAN in AM654x-idk
Date:   Wed, 22 Jan 2020 13:33:07 +0530
Message-ID: <20200122080310.24653-1-faiz_abbas@ti.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds driver patches to support MCAN in TI's AM654x-idk.

Faiz Abbas (3):
  dt-bindings: net: can: m_can: Add Documentation for stb-gpios
  can: m_can: m_can_platform: Add support for enabling transceiver
    through the STB line
  arm64: defconfig: Add Support for Bosch M_CAN controllers

 Documentation/devicetree/bindings/net/can/m_can.txt |  2 ++
 arch/arm64/configs/defconfig                        |  3 +++
 drivers/net/can/m_can/m_can_platform.c              | 12 ++++++++++++
 3 files changed, 17 insertions(+)

-- 
2.19.2

