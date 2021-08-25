Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE1473F6FA6
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 08:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239157AbhHYGgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 02:36:36 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:15210 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239308AbhHYGga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 02:36:30 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GvbnS67spz1DDGf;
        Wed, 25 Aug 2021 14:35:08 +0800 (CST)
Received: from dggpeml500023.china.huawei.com (7.185.36.114) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 25 Aug 2021 14:35:41 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 25 Aug 2021 14:35:41 +0800
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
To:     <netdev@vger.kernel.org>
CC:     Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] mctp: Remove the repeated declaration
Date:   Wed, 25 Aug 2021 14:34:31 +0800
Message-ID: <1629873271-63348-1-git-send-email-zhangshaokun@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function 'mctp_dev_get_rtnl' is declared twice, so remove the
repeated declaration.

Cc: Jeremy Kerr <jk@codeconstruct.com.au>
Cc: Matt Johnston <matt@codeconstruct.com.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
---
 include/net/mctpdevice.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/net/mctpdevice.h b/include/net/mctpdevice.h
index 57e773ff08bb..71a11012fac7 100644
--- a/include/net/mctpdevice.h
+++ b/include/net/mctpdevice.h
@@ -31,6 +31,5 @@ struct mctp_dev {
 
 struct mctp_dev *mctp_dev_get_rtnl(const struct net_device *dev);
 struct mctp_dev *__mctp_dev_get(const struct net_device *dev);
-struct mctp_dev *mctp_dev_get_rtnl(const struct net_device *dev);
 
 #endif /* __NET_MCTPDEVICE_H */
-- 
2.7.4

