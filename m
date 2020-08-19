Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A78D224930F
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 04:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbgHSCv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 22:51:57 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:54444 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726632AbgHSCv4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 22:51:56 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 1A2B7CC76AF6B949AB7F;
        Wed, 19 Aug 2020 10:51:54 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Wed, 19 Aug 2020
 10:51:52 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <trond.myklebust@hammerspace.com>, <anna.schumaker@netapp.com>,
        <bfields@fieldses.org>, <chuck.lever@oracle.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-nfs@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] SUNRPC: remove duplicate include
Date:   Wed, 19 Aug 2020 10:49:43 +0800
Message-ID: <20200819024943.26850-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove linux/sunrpc/auth_gss.h which is included more than once

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 net/sunrpc/auth_gss/trace.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/sunrpc/auth_gss/trace.c b/net/sunrpc/auth_gss/trace.c
index d26036a57443..76685abba60f 100644
--- a/net/sunrpc/auth_gss/trace.c
+++ b/net/sunrpc/auth_gss/trace.c
@@ -9,7 +9,6 @@
 #include <linux/sunrpc/svc_xprt.h>
 #include <linux/sunrpc/auth_gss.h>
 #include <linux/sunrpc/gss_err.h>
-#include <linux/sunrpc/auth_gss.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/rpcgss.h>
-- 
2.17.1

