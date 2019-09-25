Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7B52BE0C0
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 17:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438531AbfIYPCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 11:02:40 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:39671 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731142AbfIYPCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 11:02:39 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 25 Sep 2019 18:02:36 +0300
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (reg-r-vrt-019-180.mtr.labs.mlnx [10.213.19.180])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x8PF2aVY009894;
        Wed, 25 Sep 2019 18:02:36 +0300
From:   Paul Blakey <paulb@mellanox.com>
To:     Pravin Shelar <pshelar@ovn.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@netronome.com>,
        Or Gerlitz <gerlitz.or@gmail.com>
Cc:     Paul Blakey <paulb@mellanox.com>
Subject: [PATCH net v2] net/sched: Set default of CONFIG_NET_TC_SKB_EXT to N
Date:   Wed, 25 Sep 2019 18:02:35 +0300
Message-Id: <1569423755-1544-1-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This a new feature, it is preferred that it defaults to N.
We will probe the feature support from userspace before actually using it.

Fixes: 95a7233c452a ('net: openvswitch: Set OvS recirc_id from tc chain index')
Signed-off-by: Paul Blakey <paulb@mellanox.com>
---
Changelog:
	v1->v2: Changed target to net.

 net/sched/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index b3faafe..4bb10b7 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -966,7 +966,6 @@ config NET_IFE_SKBTCINDEX
 config NET_TC_SKB_EXT
 	bool "TC recirculation support"
 	depends on NET_CLS_ACT
-	default y if NET_CLS_ACT
 	select SKB_EXTENSIONS
 
 	help
-- 
1.8.3.1

