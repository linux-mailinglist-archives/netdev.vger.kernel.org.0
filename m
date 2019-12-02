Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 824EF10EB75
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 15:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727433AbfLBOTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 09:19:24 -0500
Received: from fourcot.fr ([217.70.191.14]:56338 "EHLO olfflo.fourcot.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727401AbfLBOTX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Dec 2019 09:19:23 -0500
X-Greylist: delayed 448 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Dec 2019 09:19:23 EST
From:   Victorien Molle <victorien.molle@wifirst.fr>
To:     netdev@vger.kernel.org
Cc:     Victorien Molle <victorien.molle@wifirst.fr>,
        Florent Fourcot <florent.fourcot@wifirst.fr>
Subject: [PATCH] sch_cake: Add missing NLA policy entry TCA_CAKE_SPLIT_GSO
Date:   Mon,  2 Dec 2019 15:11:38 +0100
Message-Id: <20191202141138.26194-1-victorien.molle@wifirst.fr>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This field has never been checked since introduction in mainline kernel

Signed-off-by: Victorien Molle <victorien.molle@wifirst.fr>
Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>
Fixes: 2db6dc2662ba "sch_cake: Make gso-splitting configurable from userspace"
---
 net/sched/sch_cake.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 53a80bc6b13a..e0f40400f679 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -2184,6 +2184,7 @@ static const struct nla_policy cake_policy[TCA_CAKE_MAX + 1] = {
 	[TCA_CAKE_MPU]		 = { .type = NLA_U32 },
 	[TCA_CAKE_INGRESS]	 = { .type = NLA_U32 },
 	[TCA_CAKE_ACK_FILTER]	 = { .type = NLA_U32 },
+	[TCA_CAKE_SPLIT_GSO]	 = { .type = NLA_U32 },
 	[TCA_CAKE_FWMARK]	 = { .type = NLA_U32 },
 };
 
-- 
2.24.0

