Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16E0E43DBBF
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 09:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbhJ1HQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 03:16:57 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:55395 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229626AbhJ1HQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 03:16:57 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R621e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UtzN78p_1635405268;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0UtzN78p_1635405268)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 28 Oct 2021 15:14:29 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     kgraul@linux.ibm.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, jacob.qi@linux.alibaba.com,
        xuanzhuo@linux.alibaba.com, guwen@linux.alibaba.com,
        dust.li@linux.alibaba.com
Subject: [PATCH net v2 2/2] net/smc: Correct spelling mistake to TCPF_SYN_RECV
Date:   Thu, 28 Oct 2021 15:13:47 +0800
Message-Id: <20211028071344.11168-3-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211028071344.11168-1-tonylu@linux.alibaba.com>
References: <20211028071344.11168-1-tonylu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wen Gu <guwen@linux.alibaba.com>

There should use TCPF_SYN_RECV instead of TCP_SYN_RECV.

Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
---

v1->v2:
- fix wrong email address.

---
 net/smc/af_smc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index c038efc23ce3..78b663dbfa1f 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1057,7 +1057,7 @@ static void smc_connect_work(struct work_struct *work)
 	if (smc->clcsock->sk->sk_err) {
 		smc->sk.sk_err = smc->clcsock->sk->sk_err;
 	} else if ((1 << smc->clcsock->sk->sk_state) &
-					(TCPF_SYN_SENT | TCP_SYN_RECV)) {
+					(TCPF_SYN_SENT | TCPF_SYN_RECV)) {
 		rc = sk_stream_wait_connect(smc->clcsock->sk, &timeo);
 		if ((rc == -EPIPE) &&
 		    ((1 << smc->clcsock->sk->sk_state) &
-- 
2.19.1.6.gb485710b

