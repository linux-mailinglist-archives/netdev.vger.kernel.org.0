Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9387C1C60CE
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 21:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728609AbgEETJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 15:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726350AbgEETJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 15:09:56 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2DD8C061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 12:09:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6B569127FE1C4;
        Tue,  5 May 2020 12:09:55 -0700 (PDT)
Date:   Tue, 05 May 2020 12:09:54 -0700 (PDT)
Message-Id: <20200505.120954.1746513318250596738.davem@davemloft.net>
To:     netdev@vger.kernel.org
CC:     yuehaibing@huawei.com, xiyou.wangcong@gmail.com
Subject: [PATCH] sch_choke: Remove classid from choke_skb_cb.
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 May 2020 12:09:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Suggested by Cong Wang.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/sched/sch_choke.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/sched/sch_choke.c b/net/sched/sch_choke.c
index 2d350c734375..59ff466ec7cb 100644
--- a/net/sched/sch_choke.c
+++ b/net/sched/sch_choke.c
@@ -131,7 +131,6 @@ static void choke_drop_by_idx(struct Qdisc *sch, unsigned int idx,
 }
 
 struct choke_skb_cb {
-	u16			classid;
 	u8			keys_valid;
 	struct			flow_keys_digest keys;
 };
-- 
2.26.2

