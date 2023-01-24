Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 666BA67A10B
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 19:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbjAXSRg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 13:17:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbjAXSRe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 13:17:34 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 122244C6E6;
        Tue, 24 Jan 2023 10:17:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=sGkPrI9T/JW6jnSg9wDuqsLtaD2yspPjDXYdbyVMsxI=; b=4ygpDxXafniLv9bX62broNnGvL
        5wvEnJ1kr5M2yB91imIHIzMLAncnNPOXpt9+ASgeV2ctyFcArNn9+6TmG1v4i8ZRiYyZHWGPe7eWo
        oqkf8K8EMsIiYGvgh9SiVh+R8TdUSaszLQ6olS17PTcMDg03jJNy4+i+2qMne8vvhOsvUkVmmTG4H
        AGEdYNlxdFiBckGnfb5HKvvnvKCRUwwOvGw47uzq3/STOozfro18L5y1HaZ3BOUNTCjWZBxIu2SP6
        Fcxr+VGw/6NFkKPU0JtTKtSoIvxrWvm8rCHC9VZljXG2SXi+RXVbkJkstvGN/HmeBkGnZtC4IydaZ
        xmzR6szQ==;
Received: from [2601:1c2:d80:3110::9307] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pKNrJ-004vl4-BA; Tue, 24 Jan 2023 18:17:25 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH net-next] net: Kconfig: fix spellos
Date:   Tue, 24 Jan 2023 10:17:24 -0800
Message-Id: <20230124181724.18166-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix spelling in net/ Kconfig files.
(reported by codespell)

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Jiri Pirko <jiri@resnulli.us>
---
 net/netfilter/ipset/Kconfig |    2 +-
 net/sched/Kconfig           |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -- a/net/netfilter/ipset/Kconfig b/net/netfilter/ipset/Kconfig
--- a/net/netfilter/ipset/Kconfig
+++ b/net/netfilter/ipset/Kconfig
@@ -30,7 +30,7 @@ config IP_SET_BITMAP_IP
 	depends on IP_SET
 	help
 	  This option adds the bitmap:ip set type support, by which one
-	  can store IPv4 addresses (or network addresse) from a range.
+	  can store IPv4 addresses (or network addresses) from a range.
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
diff -- a/net/sched/Kconfig b/net/sched/Kconfig
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -337,7 +337,7 @@ config NET_SCH_FQ
 	  Say Y here if you want to use the FQ packet scheduling algorithm.
 
 	  FQ does flow separation, and is able to respect pacing requirements
-	  set by TCP stack into sk->sk_pacing_rate (for localy generated
+	  set by TCP stack into sk->sk_pacing_rate (for locally generated
 	  traffic)
 
 	  To compile this driver as a module, choose M here: the module
