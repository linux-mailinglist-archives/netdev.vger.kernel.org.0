Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6B7591F40
	for <lists+netdev@lfdr.de>; Sun, 14 Aug 2022 11:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbiHNJXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Aug 2022 05:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiHNJXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Aug 2022 05:23:45 -0400
Received: from bg5.exmail.qq.com (bg4.exmail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C82627E;
        Sun, 14 Aug 2022 02:23:37 -0700 (PDT)
X-QQ-mid: bizesmtp65t1660468986tsgpy7mu
Received: from localhost.localdomain ( [182.148.12.144])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sun, 14 Aug 2022 17:23:05 +0800 (CST)
X-QQ-SSF: 01000000000000B0D000B00A0000000
X-QQ-FEAT: 9fp+MOMfZT2r1rJiY0K4FZJbHcfWJR7q94C4QXh3GJBYonAzGT7CHd6nyVBpe
        ZDB1GcTdg+2lFprv12UvHjr0fOyncaXksRsmbyhk7ciHxv6+uRGJAL3nLKtuwcVW4ziJkDL
        kvnhJEXKD+A7d6F5jL+CqulAiC71ZtKc3rECBbKAHctQhwJp71i1wO+XOAeE8xX+pSJ05L6
        KvdLT4zncnNeY4Fyn2oHXhu06rl40cKyplmySB/ybrxppqLHDI+4FUQ6WMD+/0LTVEcwhAp
        GA+zozuvQswcfVPec7KuxTqXJXs4FUl6mqeLg5ZSHXLpiIdnmFuFPxC0u5Bb9Xogl7KTmOF
        /j3Q7hn9300JJAYwzFsoR+aHSpNJS2X7iP4uriH
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     paulus@samba.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     linux-ppp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] net/ppp: fix repeated words in comments
Date:   Sun, 14 Aug 2022 17:22:55 +0800
Message-Id: <20220814092255.53629-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr4
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 Delete the redundant word 'the'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/ppp/ppp_generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 4a365f15533e..942c7e7372d9 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -2969,7 +2969,7 @@ ppp_unregister_channel(struct ppp_channel *chan)
 
 	/*
 	 * This ensures that we have returned from any calls into the
-	 * the channel's start_xmit or ioctl routine before we proceed.
+	 * channel's start_xmit or ioctl routine before we proceed.
 	 */
 	down_write(&pch->chan_sem);
 	spin_lock_bh(&pch->downl);
-- 
2.36.1

