Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 931B8153AD7
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 23:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbgBEWTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 17:19:37 -0500
Received: from nautica.notk.org ([91.121.71.147]:48300 "EHLO nautica.notk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727116AbgBEWTg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Feb 2020 17:19:36 -0500
Received: by nautica.notk.org (Postfix, from userid 1001)
        id 63E25C009; Wed,  5 Feb 2020 23:19:35 +0100 (CET)
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     v9fs-developer@lists.sourceforge.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Dominique Martinet <dominique.martinet@cea.fr>
Subject: [PATCH] net/9p: remove unused p9_req_t aux field
Date:   Wed,  5 Feb 2020 23:19:12 +0100
Message-Id: <1580941152-12973-1-git-send-email-asmadeus@codewreck.org>
X-Mailer: git-send-email 1.7.10.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dominique Martinet <dominique.martinet@cea.fr>

The p9_req_t field 'aux' has not been used in a very long time,
remove leftover field declaration

Signed-off-by: Dominique Martinet <dominique.martinet@cea.fr>
---
This has been sitting on my tree for a while, let's get some cleanup
in for next cycle!

 include/net/9p/client.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/net/9p/client.h b/include/net/9p/client.h
index acc60d8a3b3b..d32569755138 100644
--- a/include/net/9p/client.h
+++ b/include/net/9p/client.h
@@ -73,7 +73,6 @@ enum p9_req_status_t {
  * @wq: wait_queue for the client to block on for this request
  * @tc: the request fcall structure
  * @rc: the response fcall structure
- * @aux: transport specific data (provided for trans_fd migration)
  * @req_list: link for higher level objects to chain requests
  */
 struct p9_req_t {
@@ -83,7 +82,6 @@ struct p9_req_t {
 	wait_queue_head_t wq;
 	struct p9_fcall tc;
 	struct p9_fcall rc;
-	void *aux;
 	struct list_head req_list;
 };
 
-- 
2.24.1

