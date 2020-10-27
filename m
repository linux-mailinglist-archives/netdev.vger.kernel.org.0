Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48E4829AD92
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 14:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1752385AbgJ0NlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 09:41:22 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:6004 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2900799AbgJ0NlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 09:41:21 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CLCXh47XrzhcGc;
        Tue, 27 Oct 2020 21:41:24 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Tue, 27 Oct 2020
 21:41:14 +0800
From:   Zhang Qilong <zhangqilong3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>
Subject: [PATCH -next] net/mac8390: discard unnecessary breaks
Date:   Tue, 27 Oct 2020 21:51:59 +0800
Message-ID: <20201027135159.71444-1-zhangqilong3@huawei.com>
X-Mailer: git-send-email 2.26.0.106.g9fadedd
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'break' is unnecessary because of previous 'return',
and we could discard it.

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
---
 drivers/net/ethernet/8390/mac8390.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/ethernet/8390/mac8390.c b/drivers/net/ethernet/8390/mac8390.c
index d60a86aa8aa8..9aac7119d382 100644
--- a/drivers/net/ethernet/8390/mac8390.c
+++ b/drivers/net/ethernet/8390/mac8390.c
@@ -175,7 +175,6 @@ static enum mac8390_type mac8390_ident(struct nubus_rsrc *fres)
 		default:
 			return MAC8390_APPLE;
 		}
-		break;
 
 	case NUBUS_DRSW_APPLE:
 		switch (fres->dr_hw) {
@@ -186,11 +185,9 @@ static enum mac8390_type mac8390_ident(struct nubus_rsrc *fres)
 		default:
 			return MAC8390_APPLE;
 		}
-		break;
 
 	case NUBUS_DRSW_ASANTE:
 		return MAC8390_ASANTE;
-		break;
 
 	case NUBUS_DRSW_TECHWORKS:
 	case NUBUS_DRSW_DAYNA2:
@@ -199,11 +196,9 @@ static enum mac8390_type mac8390_ident(struct nubus_rsrc *fres)
 			return MAC8390_CABLETRON;
 		else
 			return MAC8390_APPLE;
-		break;
 
 	case NUBUS_DRSW_FARALLON:
 		return MAC8390_FARALLON;
-		break;
 
 	case NUBUS_DRSW_KINETICS:
 		switch (fres->dr_hw) {
@@ -212,7 +207,6 @@ static enum mac8390_type mac8390_ident(struct nubus_rsrc *fres)
 		default:
 			return MAC8390_KINETICS;
 		}
-		break;
 
 	case NUBUS_DRSW_DAYNA:
 		/*
@@ -224,7 +218,6 @@ static enum mac8390_type mac8390_ident(struct nubus_rsrc *fres)
 			return MAC8390_NONE;
 		else
 			return MAC8390_DAYNA;
-		break;
 	}
 	return MAC8390_NONE;
 }
-- 
2.17.1

