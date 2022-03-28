Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C74E44E962C
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 14:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240864AbiC1MFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 08:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236940AbiC1MFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 08:05:33 -0400
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A711C10D;
        Mon, 28 Mar 2022 05:03:51 -0700 (PDT)
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4KRrvV0xw9z9sSS;
        Mon, 28 Mar 2022 14:03:50 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id mfpM4CKHYgi1; Mon, 28 Mar 2022 14:03:50 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4KRrvV02fJz9sS2;
        Mon, 28 Mar 2022 14:03:50 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id E1AE78B774;
        Mon, 28 Mar 2022 14:03:49 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id MgrrJHZN3a_P; Mon, 28 Mar 2022 14:03:49 +0200 (CEST)
Received: from PO20335.IDSI0.si.c-s.fr (unknown [172.25.230.108])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id B6F0F8B763;
        Mon, 28 Mar 2022 14:03:49 +0200 (CEST)
Received: from PO20335.IDSI0.si.c-s.fr (localhost [127.0.0.1])
        by PO20335.IDSI0.si.c-s.fr (8.17.1/8.16.1) with ESMTPS id 22SC3Zcv101576
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 14:03:35 +0200
Received: (from chleroy@localhost)
        by PO20335.IDSI0.si.c-s.fr (8.17.1/8.17.1/Submit) id 22SC3Zt6101574;
        Mon, 28 Mar 2022 14:03:35 +0200
X-Authentication-Warning: PO20335.IDSI0.si.c-s.fr: chleroy set sender to christophe.leroy@csgroup.eu using -f
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Paolo Abeni <pabeni@redhat.com>,
        "Toke Hoiland-Jorgensen" <toke@toke.dk>
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        cake@lists.bufferbloat.net
Subject: [PATCH net-next] sch_cake: Take into account guideline DEF/DGSIC/36 from French Administration
Date:   Mon, 28 Mar 2022 14:03:24 +0200
Message-Id: <356a242a964fabbdf876a18c7640eb6ead6d0e6b.1648468695.git.christophe.leroy@csgroup.eu>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1648469002; l=3970; s=20211009; h=from:subject:message-id; bh=75ZCbmpZ80bUhHxXSdf4GpKIzWiERVR/QGymj1/HGQo=; b=Fs903hJX2Cs+qgU3qX+Py8DrjakQWxDT+D60UGyUYwRrYfyRDj6afp/qaD/70uRZ0cKSYgmx1xjq A93LoYRrC5XR7J3/rP/1hI5OaB7/kpadZQBoW5pbBonw7UUV37nW
X-Developer-Key: i=christophe.leroy@csgroup.eu; a=ed25519; pk=HIzTzUj91asvincQGOFx6+ZF5AoUuP9GdOtQChs7Mm0=
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

French Administration has written a guideline that defines additional
DSCP values for use in its networks.

Add new CAKE diffserv tables to take those new values into account
and add CONFIG_NET_SCH_CAKE_DGSIC to select those tables instead of
the default ones.

The document is available at
https://www.bo.sga.defense.gouv.fr/texte/signe/264219/N%C2%B0%2036/DEF/DGSIC.pdf
or https://www.bo.sga.defense.gouv.fr/texte/264219/N%C2%B0%2036/DEF/DGSIC.html

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
 net/sched/Kconfig    | 11 +++++++++++
 net/sched/sch_cake.c | 42 +++++++++++++++++++++++++++++++++++++++---
 2 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index 1e8ab4749c6c..b99f247404e0 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -331,6 +331,17 @@ config NET_SCH_CAKE
 
 	  If unsure, say N.
 
+config NET_SCH_CAKE_DGSIC
+	bool "CAKE: Follow French Administration's guideline DEF/DGSIC/36"
+	depends on NET_SCH_CAKE
+	help
+	  Say Y here if you want to use the Common Applications Kept Enhanced
+	  (CAKE) queue management algorithm in an environment that requires to
+	  take into account additional DSCP values defined by the French
+	  Administration in the guideline document identified DEF/DGSIC/36,
+	  available at
+	  https://www.bo.sga.defense.gouv.fr/texte/signe/264219/N%C2%B0%2036/DEF/DGSIC.pdf
+
 config NET_SCH_FQ
 	tristate "Fair Queue"
 	help
diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index a43a58a73d09..3d9af3a68c05 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -322,6 +322,17 @@ static const u8 diffserv8[] = {
 	7, 2, 2, 2, 2, 2, 2, 2,
 };
 
+static const u8 diffserv8_dgsic[] = {
+	2, 0, 1, 2, 4, 2, 2, 2,
+	1, 1, 1, 2, 1, 1, 1, 2,
+	5, 4, 4, 2, 4, 4, 4, 2,
+	3, 3, 3, 2, 3, 3, 3, 2,
+	6, 3, 3, 2, 3, 3, 3, 2,
+	6, 6, 6, 2, 6, 6, 6, 2,
+	7, 2, 2, 2, 2, 2, 2, 2,
+	7, 2, 2, 2, 2, 2, 2, 2,
+};
+
 static const u8 diffserv4[] = {
 	0, 1, 0, 0, 2, 0, 0, 0,
 	1, 0, 0, 0, 0, 0, 0, 0,
@@ -333,6 +344,17 @@ static const u8 diffserv4[] = {
 	3, 0, 0, 0, 0, 0, 0, 0,
 };
 
+static const u8 diffserv4_dgsic[] = {
+	0, 1, 0, 0, 2, 0, 0, 0,
+	1, 0, 0, 0, 0, 0, 0, 0,
+	2, 2, 2, 0, 2, 2, 2, 0,
+	2, 2, 2, 0, 2, 2, 2, 0,
+	3, 2, 2, 0, 2, 2, 2, 0,
+	3, 3, 3, 0, 3, 3, 3, 0,
+	3, 0, 0, 0, 0, 0, 0, 0,
+	3, 0, 0, 0, 0, 0, 0, 0,
+};
+
 static const u8 diffserv3[] = {
 	0, 1, 0, 0, 2, 0, 0, 0,
 	1, 0, 0, 0, 0, 0, 0, 0,
@@ -344,6 +366,17 @@ static const u8 diffserv3[] = {
 	2, 0, 0, 0, 0, 0, 0, 0,
 };
 
+static const u8 diffserv3_dgsic[] = {
+	0, 1, 0, 0, 2, 0, 0, 0,
+	1, 0, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0,
+	0, 2, 2, 0, 2, 2, 2, 0,
+	2, 0, 0, 0, 0, 0, 0, 0,
+	2, 0, 0, 0, 0, 0, 0, 0,
+};
+
 static const u8 besteffort[] = {
 	0, 0, 0, 0, 0, 0, 0, 0,
 	0, 0, 0, 0, 0, 0, 0, 0,
@@ -2409,7 +2442,8 @@ static int cake_config_diffserv8(struct Qdisc *sch)
 	q->tin_cnt = 8;
 
 	/* codepoint to class mapping */
-	q->tin_index = diffserv8;
+	q->tin_index = IS_ENABLED(CONFIG_NET_SCH_CAKE_DGSIC) ? diffserv8_dgsic :
+							       diffserv8;
 	q->tin_order = normal_order;
 
 	/* class characteristics */
@@ -2452,7 +2486,8 @@ static int cake_config_diffserv4(struct Qdisc *sch)
 	q->tin_cnt = 4;
 
 	/* codepoint to class mapping */
-	q->tin_index = diffserv4;
+	q->tin_index = IS_ENABLED(CONFIG_NET_SCH_CAKE_DGSIC) ? diffserv4_dgsic :
+							       diffserv4;
 	q->tin_order = bulk_order;
 
 	/* class characteristics */
@@ -2489,7 +2524,8 @@ static int cake_config_diffserv3(struct Qdisc *sch)
 	q->tin_cnt = 3;
 
 	/* codepoint to class mapping */
-	q->tin_index = diffserv3;
+	q->tin_index = IS_ENABLED(CONFIG_NET_SCH_CAKE_DGSIC) ? diffserv3_dgsic :
+							       diffserv3;
 	q->tin_order = bulk_order;
 
 	/* class characteristics */
-- 
2.35.1

