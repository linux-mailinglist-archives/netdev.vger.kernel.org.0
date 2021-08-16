Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B71E33ECC9B
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 04:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231573AbhHPCTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Aug 2021 22:19:48 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:17019 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbhHPCTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Aug 2021 22:19:47 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GnyS41rgyzb2Jk;
        Mon, 16 Aug 2021 10:15:32 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 16 Aug 2021 10:19:14 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 16 Aug 2021 10:19:14 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <amitc@mellanox.com>,
        <idosch@idosch.org>, <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH RESEND V2 net-next 2/4] ethtool: add two link extended substates of bad signal integrity
Date:   Mon, 16 Aug 2021 10:15:27 +0800
Message-ID: <1629080129-46507-3-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1629080129-46507-1-git-send-email-huangguangbin2@huawei.com>
References: <1629080129-46507-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ETHTOOL_LINK_EXT_SUBSTATE_BSI_SERDES_REFERENCE_CLOCK_LOST means the input
external clock signal for SerDes is too weak or lost.

ETHTOOL_LINK_EXT_SUBSTATE_BSI_SERDES_ALOS means the received signal for
SerDes is too weak because analog loss of signal.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 include/uapi/linux/ethtool.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 67aa7134b301..b6db6590baf0 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -639,6 +639,8 @@ enum ethtool_link_ext_substate_link_logical_mismatch {
 enum ethtool_link_ext_substate_bad_signal_integrity {
 	ETHTOOL_LINK_EXT_SUBSTATE_BSI_LARGE_NUMBER_OF_PHYSICAL_ERRORS = 1,
 	ETHTOOL_LINK_EXT_SUBSTATE_BSI_UNSUPPORTED_RATE,
+	ETHTOOL_LINK_EXT_SUBSTATE_BSI_SERDES_REFERENCE_CLOCK_LOST,
+	ETHTOOL_LINK_EXT_SUBSTATE_BSI_SERDES_ALOS,
 };
 
 /* More information in addition to ETHTOOL_LINK_EXT_STATE_CABLE_ISSUE. */
-- 
2.8.1

