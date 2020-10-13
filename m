Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2ED628C86A
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 07:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388714AbgJMF5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 01:57:22 -0400
Received: from mail-m964.mail.126.com ([123.126.96.4]:32980 "EHLO
        mail-m964.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388373AbgJMF5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 01:57:22 -0400
X-Greylist: delayed 1816 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Oct 2020 01:57:21 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=6qfOPwNXt5VhUp+2sc
        xGXWX2LVukP0fYKhl6n7IX400=; b=e4bTN6VOEPvEr8qV+ZUDLtP1KrWt1b8LlX
        WAGBbEgoCFv5/R6ZklE4DCPi4iVnTwyA8no810lTn3Q81mKL4CaASpZdgpFuSq1R
        YAeFJK/SBzxLvmUG0VoaKPsDARQ6a+ceMYhmdsJ1MmEAvwVz3ffsb2y5go/ugYTL
        9MyTEu5o0=
Received: from localhost.localdomain (unknown [222.128.172.145])
        by smtp9 (Coremail) with SMTP id NeRpCgC3cD6cOoVfOvsHLg--.23012S4;
        Tue, 13 Oct 2020 13:26:53 +0800 (CST)
From:   zhang kai <zhangkaiheb@126.com>
To:     netdev@vger.kernel.org, stephen@networkplumber.org,
        edumazet@google.com
Cc:     "zhangkaiheb@126.com" <zhangkaiheb@126.com>
Subject: [PATCH] tc: fq: clarify the length of orphan_mask.
Date:   Tue, 13 Oct 2020 05:26:40 +0000
Message-Id: <20201013052640.31112-1-zhangkaiheb@126.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: NeRpCgC3cD6cOoVfOvsHLg--.23012S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrtF4fuF1ruw45Zw15WFyDJrb_yoWxurX_ZF
        1Iqw48uw43tF92kw15Cwn3tr17Aa10qws5u3srAr1DZF18tFWqgFZF9a4jqw4ru39rAFWx
        K34DArZ0y3sI9jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRiE_MPUUUUU==
X-Originating-IP: [222.128.172.145]
X-CM-SenderInfo: x2kd0wxndlxvbe6rjloofrz/1tbiFx28-lpD-7o8NQAAsd
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "zhangkaiheb@126.com" <zhangkaiheb@126.com>

Signed-off-by: kai zhang <zhangkaiheb@126.com>
---
 tc/q_fq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tc/q_fq.c b/tc/q_fq.c
index 98d1bf40..b10d01e9 100644
--- a/tc/q_fq.c
+++ b/tc/q_fq.c
@@ -253,7 +253,7 @@ static int fq_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 			  &refill_delay, sizeof(refill_delay));
 	if (set_orphan_mask)
 		addattr_l(n, 1024, TCA_FQ_ORPHAN_MASK,
-			  &orphan_mask, sizeof(refill_delay));
+			  &orphan_mask, sizeof(orphan_mask));
 	if (set_ce_threshold)
 		addattr_l(n, 1024, TCA_FQ_CE_THRESHOLD,
 			  &ce_threshold, sizeof(ce_threshold));
-- 
2.17.1

