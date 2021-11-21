Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B61345847A
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 16:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237989AbhKUPfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 10:35:16 -0500
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:50328 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237755AbhKUPfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 10:35:14 -0500
Received: from pop-os.home ([86.243.171.122])
        by smtp.orange.fr with ESMTPA
        id oop3mFNsgf6fnoop4mxGDI; Sun, 21 Nov 2021 16:32:08 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 21 Nov 2021 16:32:08 +0100
X-ME-IP: 86.243.171.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     santosh.shilimkar@oracle.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] rds: Fix a typo in a comment
Date:   Sun, 21 Nov 2021 16:32:04 +0100
Message-Id: <006364d427b54c8796dd1a896b527cd09865bba1.1637508662.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/cold/could/

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 net/rds/send.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/send.c b/net/rds/send.c
index 53444397de66..0c5504068e3c 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -272,7 +272,7 @@ int rds_send_xmit(struct rds_conn_path *cp)
 
 			/* Unfortunately, the way Infiniband deals with
 			 * RDMA to a bad MR key is by moving the entire
-			 * queue pair to error state. We cold possibly
+			 * queue pair to error state. We could possibly
 			 * recover from that, but right now we drop the
 			 * connection.
 			 * Therefore, we never retransmit messages with RDMA ops.
-- 
2.30.2

