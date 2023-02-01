Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D59D7686DCE
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 19:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231671AbjBASUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 13:20:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbjBASUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 13:20:25 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB23D7BE70
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 10:20:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 46FE8CE24FB
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 18:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EB10C4339E;
        Wed,  1 Feb 2023 18:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675275620;
        bh=iuCAXphA+Ztxgb55lHpbghEawiR+hqZM1dQXu+LJlVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f+618TMSzvqzMxG0evwL/SB+3gmNo/KDja/mt3DVrG5cmMbNiAvMbjm4+sator2G9
         vVJmBz3MAXH6UTFPDsRsTvPz2WKHspJYnkFJ/e1wlJ6drwNSF1yJeH2zQM8NtPA7hc
         BJcDQBlCUnBxbAEy2A555Il0HZZ9k68RSOZFhKCt2TYSRPzlvMRAlUfOiMYY0udhxo
         +rvTIWk4ZZpRcv/oWUPoj42bNCapvKTNJePJKQTwtQdBLBkIJRubjGI/AVW7MYSJFz
         zJIqRj6sztIrVGBXJ1SGXggYET5vQAp6YSmVukGKm42xlsp5Vsd2tKE/sHbuJInwf1
         YKuMiP0qoreVw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, Vlad Yasevich <vyasevich@gmail.com>,
        Xin Long <lucien.xin@gmail.com>
Subject: [PATCH net 4/4] MAINTAINERS: update SCTP maintainers
Date:   Wed,  1 Feb 2023 10:20:14 -0800
Message-Id: <20230201182014.2362044-5-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230201182014.2362044-1-kuba@kernel.org>
References: <20230201182014.2362044-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vlad has stepped away from SCTP related duties.
Move him to CREDITS and add Xin Long.

Subsystem SCTP PROTOCOL
  Changes 237 / 629 (37%)
  Last activity: 2022-12-12
  Vlad Yasevich <vyasevich@gmail.com>:
  Neil Horman <nhorman@tuxdriver.com>:
    Author 20a785aa52c8 2020-05-19 00:00:00 4
    Tags 20a785aa52c8 2020-05-19 00:00:00 84
  Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>:
    Author 557fb5862c92 2021-07-28 00:00:00 41
    Tags da05cecc4939 2022-12-12 00:00:00 197
  Top reviewers:
    [15]: lucien.xin@gmail.com
  INACTIVE MAINTAINER Vlad Yasevich <vyasevich@gmail.com>

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
Cc: nhorman@tuxdriver.com
Cc: marcelo.leitner@gmail.com
Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: Xin Long <lucien.xin@gmail.com>
---
 CREDITS     | 4 ++++
 MAINTAINERS | 2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/CREDITS b/CREDITS
index a440474a7206..5f5d70c9c038 100644
--- a/CREDITS
+++ b/CREDITS
@@ -4183,6 +4183,10 @@ S: B-1206 Jingmao Guojigongyu
 S: 16 Baliqiao Nanjie, Beijing 101100
 S: People's Repulic of China
 
+N: Vlad Yasevich
+E: vyasevich@gmail.com
+D: SCTP protocol maintainer.
+
 N: Aviad Yehezkel
 E: aviadye@nvidia.com
 D: Kernel TLS implementation and offload support.
diff --git a/MAINTAINERS b/MAINTAINERS
index f11d5386d1ad..6f22075603cc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18679,9 +18679,9 @@ F:	drivers/target/
 F:	include/target/
 
 SCTP PROTOCOL
-M:	Vlad Yasevich <vyasevich@gmail.com>
 M:	Neil Horman <nhorman@tuxdriver.com>
 M:	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
+M:	Xin Long <lucien.xin@gmail.com>
 L:	linux-sctp@vger.kernel.org
 S:	Maintained
 W:	http://lksctp.sourceforge.net
-- 
2.39.1

