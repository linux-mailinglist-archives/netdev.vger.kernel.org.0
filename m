Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24EAE1B7022
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 10:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbgDXI5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 04:57:38 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:53082 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726324AbgDXI5h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 04:57:37 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 349BF444E3346517C4EF;
        Fri, 24 Apr 2020 16:57:27 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Fri, 24 Apr 2020
 16:57:18 +0800
From:   Zheng Bin <zhengbin13@huawei.com>
To:     <irusskikh@marvell.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH -next] net: atlantic: Remove unneeded semicolon
Date:   Fri, 24 Apr 2020 17:04:28 +0800
Message-ID: <20200424090428.93485-1-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.26.0.106.g9fadedd
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes coccicheck warning:

drivers/net/ethernet/aquantia/atlantic/aq_macsec.c:404:2-3: Unneeded semicolon
drivers/net/ethernet/aquantia/atlantic/aq_macsec.c:420:2-3: Unneeded semicolon

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_macsec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
index 0b3e234a54aa..91870ceaf3fe 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
@@ -401,7 +401,7 @@ static u32 aq_sc_idx_max(const enum aq_macsec_sc_sa sc_sa)
 		break;
 	default:
 		break;
-	};
+	}

 	return result;
 }
@@ -417,7 +417,7 @@ static u32 aq_to_hw_sc_idx(const u32 sc_idx, const enum aq_macsec_sc_sa sc_sa)
 		return sc_idx;
 	default:
 		WARN_ONCE(true, "Invalid sc_sa");
-	};
+	}

 	return sc_idx;
 }
--
2.26.0.106.g9fadedd

