Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B018E2FED0F
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 15:39:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728446AbhAUOiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 09:38:13 -0500
Received: from mail.wangsu.com ([123.103.51.227]:59303 "EHLO wangsu.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731359AbhAUOdj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 09:33:39 -0500
Received: from 137.localdomain (unknown [59.61.78.232])
        by app2 (Coremail) with SMTP id 4zNnewAHD69VkAlgh4cAAA--.27S2;
        Thu, 21 Jan 2021 22:31:50 +0800 (CST)
From:   Pengcheng Yang <yangpc@wangsu.com>
To:     edumazet@google.com, ycheng@google.com, ncardwell@google.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Pengcheng Yang <yangpc@wangsu.com>
Subject: [PATCH net-next] tcp: remove unused ICSK_TIME_EARLY_RETRANS
Date:   Thu, 21 Jan 2021 22:31:13 +0800
Message-Id: <1611239473-27304-1-git-send-email-yangpc@wangsu.com>
X-Mailer: git-send-email 1.8.3.1
X-CM-TRANSID: 4zNnewAHD69VkAlgh4cAAA--.27S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Kryruw4xuw1rZw43CrW5Awb_yoW8Xr1UpF
        WftrZ2gFWDJF4UCFy5Ja1kAFyxJw1UXrW8CFW2vwsIk3W2vws5XF4rXwn8tF17ArZ2kr4x
        XFZ7WrZ3Cry5Cw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyC1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l8cAvFVAK
        0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4
        x0Y4vE2Ix0cI8IcVCY1x0267AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28E
        F7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F4
        0EFcxC0VAKzVAqx4xG6I80ewAv7VCjz48v1sIEY20_Gr4lYx0Ec7CjxVAajcxG14v26r1j
        6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI
        8I648v4I1lc2xSY4AK67AK6ry5MxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY20_
        Gr4l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
        xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0
        cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
        AvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF
        7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0Jj4sjbUUUUU=
X-CM-SenderInfo: p1dqw1nf6zt0xjvxhudrp/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the early retransmit has been removed by
commit bec41a11dd3d ("tcp: remove early retransmit"),
we also remove the unused ICSK_TIME_EARLY_RETRANS macro.

Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
---
 include/net/inet_connection_sock.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index 7338b38..e9490ef 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -138,7 +138,6 @@ struct inet_connection_sock {
 #define ICSK_TIME_RETRANS	1	/* Retransmit timer */
 #define ICSK_TIME_DACK		2	/* Delayed ack timer */
 #define ICSK_TIME_PROBE0	3	/* Zero window probe timer */
-#define ICSK_TIME_EARLY_RETRANS 4	/* Early retransmit timer */
 #define ICSK_TIME_LOSS_PROBE	5	/* Tail loss probe timer */
 #define ICSK_TIME_REO_TIMEOUT	6	/* Reordering timer */
 
@@ -224,8 +223,7 @@ static inline void inet_csk_reset_xmit_timer(struct sock *sk, const int what,
 	}
 
 	if (what == ICSK_TIME_RETRANS || what == ICSK_TIME_PROBE0 ||
-	    what == ICSK_TIME_EARLY_RETRANS || what == ICSK_TIME_LOSS_PROBE ||
-	    what == ICSK_TIME_REO_TIMEOUT) {
+	    what == ICSK_TIME_LOSS_PROBE || what == ICSK_TIME_REO_TIMEOUT) {
 		icsk->icsk_pending = what;
 		icsk->icsk_timeout = jiffies + when;
 		sk_reset_timer(sk, &icsk->icsk_retransmit_timer, icsk->icsk_timeout);
-- 
1.8.3.1

