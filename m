Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 113F9113107
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 18:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbfLDRpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 12:45:46 -0500
Received: from lelv0142.ext.ti.com ([198.47.23.249]:49950 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727033AbfLDRpq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 12:45:46 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id xB4Hjap8077764;
        Wed, 4 Dec 2019 11:45:36 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1575481536;
        bh=QEMrw5/Z9z3JNqDZq8b18WA934p6CJvirSUEPVYw+dA=;
        h=From:To:CC:Subject:Date;
        b=eyN1hPzpRNUszDrsknKMKRK6Aty/IACTlByrKDqO2LKN74HOXo6gBSbSkGhLNv91l
         56bxGuQ3OET6OKgsAfxi5VEmJQxN371DLnU6Jq6bh+JoPrWAlC8azBAd34ISNvTJwC
         AVxh15Axi9pPHjUgjgQU8BqCILbqyMzUoANJoqBQ=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xB4HjaQr113249
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 4 Dec 2019 11:45:36 -0600
Received: from DFLE107.ent.ti.com (10.64.6.28) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Wed, 4 Dec
 2019 11:45:36 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Wed, 4 Dec 2019 11:45:36 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id xB4HjZMT019571;
        Wed, 4 Dec 2019 11:45:36 -0600
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     Randy Dunlap <rdunlap@infradead.org>, <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Tony Lindgren <tony@atomide.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH 0/2] net: ethernet: ti: cpsw_switchdev: fix unmet direct dependencies detected for NET_SWITCHDEV
Date:   Wed, 4 Dec 2019 19:45:31 +0200
Message-ID: <20191204174533.32207-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes Kconfig warning with CONFIG_COMPILE_TEST=y reported by
Randy Dunlap <rdunlap@infradead.org> [1]

[1] https://lkml.org/lkml/2019/12/3/1373

Grygorii Strashko (2):
  net: ethernet: ti: cpsw_switchdev: fix unmet direct dependencies
    detected for NET_SWITCHDEV
  arm: omap2plus_defconfig: enable NET_SWITCHDEV

 arch/arm/configs/omap2plus_defconfig | 3 ++-
 drivers/net/ethernet/ti/Kconfig      | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

-- 
2.17.1

