Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 087A7BDE94
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 15:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405840AbfIYNJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 09:09:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39733 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388199AbfIYNJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 09:09:37 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iD72w-0002wK-EE; Wed, 25 Sep 2019 13:09:30 +0000
From:   Colin King <colin.king@canonical.com>
To:     "J . Bruce Fields" <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sunrpc: clean up indentation issue
Date:   Wed, 25 Sep 2019 14:09:30 +0100
Message-Id: <20190925130930.13076-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are statements that are indented incorrectly, remove the
extraneous spacing.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/sunrpc/svc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 220b79988000..d11b70552c33 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -1233,8 +1233,8 @@ svc_generic_init_request(struct svc_rqst *rqstp,
 
 	if (rqstp->rq_vers >= progp->pg_nvers )
 		goto err_bad_vers;
-	  versp = progp->pg_vers[rqstp->rq_vers];
-	  if (!versp)
+	versp = progp->pg_vers[rqstp->rq_vers];
+	if (!versp)
 		goto err_bad_vers;
 
 	/*
-- 
2.20.1

