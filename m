Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60C9034A550
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 11:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbhCZKLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 06:11:00 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:14914 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbhCZKK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 06:10:28 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4F6Hk735R7zkgYq;
        Fri, 26 Mar 2021 18:08:47 +0800 (CST)
Received: from huawei.com (10.175.103.91) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.498.0; Fri, 26 Mar 2021
 18:10:24 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>
Subject: [PATCH -next 1/3] net: llc: Correct some function names in header
Date:   Fri, 26 Mar 2021 18:13:48 +0800
Message-ID: <20210326101350.2519614-2-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210326101350.2519614-1-yangyingliang@huawei.com>
References: <20210326101350.2519614-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following make W=1 kernel build warning:

 net/llc/llc_c_ev.c:622: warning: expecting prototype for conn_ev_qlfy_last_frame_eq_1(). Prototype was for llc_conn_ev_qlfy_last_frame_eq_1() instead
 net/llc/llc_c_ev.c:636: warning: expecting prototype for conn_ev_qlfy_last_frame_eq_0(). Prototype was for llc_conn_ev_qlfy_last_frame_eq_0() instead

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 net/llc/llc_c_ev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/llc/llc_c_ev.c b/net/llc/llc_c_ev.c
index 523fdd1cf781..d6627a80cb45 100644
--- a/net/llc/llc_c_ev.c
+++ b/net/llc/llc_c_ev.c
@@ -608,7 +608,7 @@ int llc_conn_ev_qlfy_p_flag_eq_1(struct sock *sk, struct sk_buff *skb)
 }
 
 /**
- *	conn_ev_qlfy_last_frame_eq_1 - checks if frame is last in tx window
+ *	llc_conn_ev_qlfy_last_frame_eq_1 - checks if frame is last in tx window
  *	@sk: current connection structure.
  *	@skb: current event.
  *
@@ -624,7 +624,7 @@ int llc_conn_ev_qlfy_last_frame_eq_1(struct sock *sk, struct sk_buff *skb)
 }
 
 /**
- *	conn_ev_qlfy_last_frame_eq_0 - checks if frame isn't last in tx window
+ *	llc_conn_ev_qlfy_last_frame_eq_0 - checks if frame isn't last in tx window
  *	@sk: current connection structure.
  *	@skb: current event.
  *
-- 
2.25.1

