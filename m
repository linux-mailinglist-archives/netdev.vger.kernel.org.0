Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 843A169DBEE
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 09:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233695AbjBUIaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 03:30:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233543AbjBUIay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 03:30:54 -0500
Received: from unicom146.biz-email.net (unicom146.biz-email.net [210.51.26.146])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 430CD233CF;
        Tue, 21 Feb 2023 00:30:52 -0800 (PST)
Received: from ([60.208.111.195])
        by unicom146.biz-email.net ((D)) with ASMTP (SSL) id RCA00143;
        Tue, 21 Feb 2023 16:30:43 +0800
Received: from localhost.localdomain (10.200.104.97) by
 jtjnmail201607.home.langchao.com (10.100.2.7) with Microsoft SMTP Server id
 15.1.2507.21; Tue, 21 Feb 2023 16:30:44 +0800
From:   Bo Liu <liubo03@inspur.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <linux@rempel-privat.de>, <bagasdotme@gmail.com>, <andrew@lunn.ch>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Bo Liu <liubo03@inspur.com>
Subject: [PATCH] ethtool: pse-pd: Fix double word in comments
Date:   Tue, 21 Feb 2023 03:30:36 -0500
Message-ID: <20230221083036.2414-1-liubo03@inspur.com>
X-Mailer: git-send-email 2.18.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.200.104.97]
tUid:   20232211630430a827ac965e3560e8f957e8964e96f77
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the repeated word "for" in comments.

Signed-off-by: Bo Liu <liubo03@inspur.com>
---
 net/ethtool/pse-pd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/pse-pd.c b/net/ethtool/pse-pd.c
index a5b607b0a652..530b8b99e6df 100644
--- a/net/ethtool/pse-pd.c
+++ b/net/ethtool/pse-pd.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 //
-// ethtool interface for for Ethernet PSE (Power Sourcing Equipment)
+// ethtool interface for Ethernet PSE (Power Sourcing Equipment)
 // and PD (Powered Device)
 //
 // Copyright (c) 2022 Pengutronix, Oleksij Rempel <kernel@pengutronix.de>
-- 
2.27.0

