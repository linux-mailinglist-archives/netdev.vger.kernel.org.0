Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D74DA21CC0E
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 01:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728836AbgGLXPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 19:15:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59648 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728617AbgGLXPc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Jul 2020 19:15:32 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1julBu-004mQM-D0; Mon, 13 Jul 2020 01:15:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH net-next 15/20] net: sched: kerneldoc fixes
Date:   Mon, 13 Jul 2020 01:15:11 +0200
Message-Id: <20200712231516.1139335-16-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200712231516.1139335-1-andrew@lunn.ch>
References: <20200712231516.1139335-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simple fixes which require no deep knowledge of the code.

Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/sched/em_canid.c | 1 +
 net/sched/ematch.c   | 3 +--
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sched/em_canid.c b/net/sched/em_canid.c
index b9a94fdf9397..5ea84decec19 100644
--- a/net/sched/em_canid.c
+++ b/net/sched/em_canid.c
@@ -40,6 +40,7 @@ struct canid_match {
 
 /**
  * em_canid_get_id() - Extracts Can ID out of the sk_buff structure.
+ * @skb: buffer to extract Can ID from
  */
 static canid_t em_canid_get_id(struct sk_buff *skb)
 {
diff --git a/net/sched/ematch.c b/net/sched/ematch.c
index dd3b8c11a2e0..f885bea5b452 100644
--- a/net/sched/ematch.c
+++ b/net/sched/ematch.c
@@ -389,7 +389,6 @@ EXPORT_SYMBOL(tcf_em_tree_validate);
 /**
  * tcf_em_tree_destroy - destroy an ematch tree
  *
- * @tp: classifier kind handle
  * @tree: ematch tree to be deleted
  *
  * This functions destroys an ematch tree previously created by
@@ -425,7 +424,7 @@ EXPORT_SYMBOL(tcf_em_tree_destroy);
  * tcf_em_tree_dump - dump ematch tree into a rtnl message
  *
  * @skb: skb holding the rtnl message
- * @t: ematch tree to be dumped
+ * @tree: ematch tree to be dumped
  * @tlv: TLV type to be used to encapsulate the tree
  *
  * This function dumps a ematch tree into a rtnl message. It is valid to
-- 
2.27.0.rc2

