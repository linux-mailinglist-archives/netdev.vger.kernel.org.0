Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8104939406D
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 11:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236260AbhE1J6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 05:58:15 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:2395 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236185AbhE1J6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 05:58:14 -0400
Received: from dggeml751-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Fs0Nq2lZTz65Yq;
        Fri, 28 May 2021 17:52:59 +0800 (CST)
Received: from dggpeml500023.china.huawei.com (7.185.36.114) by
 dggeml751-chm.china.huawei.com (10.1.199.150) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 28 May 2021 17:56:38 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 28 May 2021 17:56:38 +0800
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
To:     <b.a.t.m.a.n@lists.open-mesh.org>, <netdev@vger.kernel.org>
CC:     Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <a@unstable.cc>,
        Sven Eckelmann <sven@narfation.org>
Subject: [PATCH] batman-adv: Remove the repeated declaration
Date:   Fri, 28 May 2021 17:56:25 +0800
Message-ID: <1622195785-55920-1-git-send-email-zhangshaokun@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function 'batadv_bla_claim_dump' is declared twice, so remove the
repeated declaration.

Cc: Marek Lindner <mareklindner@neomailbox.ch>
Cc: Simon Wunderlich <sw@simonwunderlich.de>
Cc: Antonio Quartulli <a@unstable.cc>
Cc: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
---
 net/batman-adv/bridge_loop_avoidance.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/batman-adv/bridge_loop_avoidance.h b/net/batman-adv/bridge_loop_avoidance.h
index 5c22955bb9d5..8673a265995f 100644
--- a/net/batman-adv/bridge_loop_avoidance.h
+++ b/net/batman-adv/bridge_loop_avoidance.h
@@ -52,7 +52,6 @@ void batadv_bla_update_orig_address(struct batadv_priv *bat_priv,
 void batadv_bla_status_update(struct net_device *net_dev);
 int batadv_bla_init(struct batadv_priv *bat_priv);
 void batadv_bla_free(struct batadv_priv *bat_priv);
-int batadv_bla_claim_dump(struct sk_buff *msg, struct netlink_callback *cb);
 #ifdef CONFIG_BATMAN_ADV_DAT
 bool batadv_bla_check_claim(struct batadv_priv *bat_priv, u8 *addr,
 			    unsigned short vid);
-- 
2.7.4

