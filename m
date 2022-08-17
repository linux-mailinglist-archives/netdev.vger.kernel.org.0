Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDE305966D8
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 03:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238372AbiHQBir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 21:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238243AbiHQBih (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 21:38:37 -0400
Received: from bg5.exmail.qq.com (bg4.exmail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2323312746;
        Tue, 16 Aug 2022 18:38:30 -0700 (PDT)
X-QQ-mid: bizesmtp84t1660700140tqrou117
Received: from harry-jrlc.. ( [182.148.12.144])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 17 Aug 2022 09:35:31 +0800 (CST)
X-QQ-SSF: 0100000000000060D000000A0000020
X-QQ-FEAT: G46xFj+wOV8gq2KsCsec865LlWF+eTeq4g1VXYFGr7CJgYAfWGuW/aH1av9g5
        xHeP7pN7GKla1MLgHvqnGT7ROAgz/BQ972Id7Kv9pUbOQTpRcnB8Ot6VlfyFkbM8ZBYS+DG
        OFqR6m+JmMBZq/Ni+TJBaau7sM2YzVzfFNfn08W4WhKJykS9y1SONfje0NgGiFAxiUv0JKc
        m/wFJecgQfqWqI2JtJ33bfM6CRkBH1LvL8c/iodHlI/l/ZbDT20nEqnVy1Qf0w12sevrZ6p
        F3i/HZpp67Yd8qwznNtNGiRGcitwPiPeV2mSX7zmKRU4TfRjJy9Ew1YoOq/KGE8ozPOaF2H
        IcCYaomwBuoao+uLrOPKfJl5I02xqla4KWU7R+We7SmHHyMIZYxc+4dUDLtmA==
X-QQ-GoodBg: 0
From:   Xin Gao <gaoxin@cdjrlc.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     sdf@google.com, tj@kernel.org, daniel@iogearbox.net,
        ast@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xin Gao <gaoxin@cdjrlc.com>
Subject: [PATCH] core: Variable type completion
Date:   Wed, 17 Aug 2022 09:35:29 +0800
Message-Id: <20220817013529.10535-1-gaoxin@cdjrlc.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr6
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'unsigned int' is better than 'unsigned'.

Signed-off-by: Xin Gao <gaoxin@cdjrlc.com>
---
 net/core/netclassid_cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/netclassid_cgroup.c b/net/core/netclassid_cgroup.c
index 1a6a86693b74..d6a70aeaa503 100644
--- a/net/core/netclassid_cgroup.c
+++ b/net/core/netclassid_cgroup.c
@@ -66,7 +66,7 @@ struct update_classid_context {
 
 #define UPDATE_CLASSID_BATCH 1000
 
-static int update_classid_sock(const void *v, struct file *file, unsigned n)
+static int update_classid_sock(const void *v, struct file *file, unsigned int n)
 {
 	struct update_classid_context *ctx = (void *)v;
 	struct socket *sock = sock_from_file(file);
-- 
2.30.2

