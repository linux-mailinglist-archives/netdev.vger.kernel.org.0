Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7402045B106
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 02:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232864AbhKXBOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 20:14:44 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:27288 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232758AbhKXBOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 20:14:41 -0500
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HzNJ03dXGzbhyQ;
        Wed, 24 Nov 2021 09:11:28 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 24 Nov 2021 09:11:30 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 24 Nov 2021 09:11:29 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 3/4] net: hns3: debugfs add drop packet statistics of multicast and broadcast for igu
Date:   Wed, 24 Nov 2021 09:06:53 +0800
Message-ID: <20211124010654.6753-4-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211124010654.6753-1-huangguangbin2@huawei.com>
References: <20211124010654.6753-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jie Wang <wangjie125@huawei.com>

Currently, there is no way to get drop packet number of multicast and
broadcast in IGU hardware module, it is not convenient to find problem
when multicast packet or broadcast packet is dropped in IGU, so this
patch adds statistics for them in debugfs.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h    | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h
index c526591a7240..5b6018204f92 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h
@@ -321,10 +321,10 @@ static const struct hclge_dbg_dfx_message hclge_dbg_igu_egu_reg[] = {
 	{true,	"IGU_RX_OUT_UDP0_PKT"},
 
 	{true,	"IGU_RX_IN_UDP0_PKT"},
-	{false, "Reserved"},
-	{false, "Reserved"},
-	{false, "Reserved"},
-	{false, "Reserved"},
+	{true,	"IGU_MC_CAR_DROP_PKT_L"},
+	{true,	"IGU_MC_CAR_DROP_PKT_H"},
+	{true,	"IGU_BC_CAR_DROP_PKT_L"},
+	{true,	"IGU_BC_CAR_DROP_PKT_H"},
 	{false, "Reserved"},
 
 	{true,	"IGU_RX_OVERSIZE_PKT_L"},
-- 
2.33.0

