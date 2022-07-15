Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30FF1575F78
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 12:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbiGOKic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 06:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiGOKib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 06:38:31 -0400
Received: from syslogsrv (unknown [217.20.186.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C40753BB;
        Fri, 15 Jul 2022 03:38:30 -0700 (PDT)
Received: from fg200.ow.s ([172.20.254.44] helo=localhost.localdomain)
        by syslogsrv with esmtp (Exim 4.90_1)
        (envelope-from <maksym.glubokiy@plvision.eu>)
        id 1oCIi1-00013Q-G9; Fri, 15 Jul 2022 13:38:09 +0300
From:   Maksym Glubokiy <maksym.glubokiy@plvision.eu>
To:     Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Joe Perches <joe@perches.com>
Cc:     Maksym Glubokiy <maksym.glubokiy@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2] net: prestera: acl: fix code formatting
Date:   Fri, 15 Jul 2022 13:38:06 +0300
Message-Id: <20220715103806.7108-1-maksym.glubokiy@plvision.eu>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FSL_HELO_NON_FQDN_1,
        HELO_NO_DOMAIN,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make the code look better.

Signed-off-by: Maksym Glubokiy <maksym.glubokiy@plvision.eu>
---
v2:
 - remove changes to the copyright line

 drivers/net/ethernet/marvell/prestera/prestera_flower.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flower.c b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
index 92c6ace125e0..b3526962eac8 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_flower.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
@@ -138,7 +138,8 @@ static int prestera_flower_parse_actions(struct prestera_flow_block *block,
 static int prestera_flower_parse_meta(struct prestera_acl_rule *rule,
 				      struct flow_cls_offload *f,
 				      struct prestera_flow_block *block)
-{	struct flow_rule *f_rule = flow_cls_offload_flow_rule(f);
+{
+	struct flow_rule *f_rule = flow_cls_offload_flow_rule(f);
 	struct prestera_acl_match *r_match = &rule->re_key.match;
 	struct prestera_port *port;
 	struct net_device *ingress_dev;
@@ -178,13 +179,13 @@ static int prestera_flower_parse_meta(struct prestera_acl_rule *rule,
 	rule_match_set(r_match->mask, SYS_DEV, mask);
 
 	return 0;
-
 }
 
 static int prestera_flower_parse(struct prestera_flow_block *block,
 				 struct prestera_acl_rule *rule,
 				 struct flow_cls_offload *f)
-{	struct flow_rule *f_rule = flow_cls_offload_flow_rule(f);
+{
+	struct flow_rule *f_rule = flow_cls_offload_flow_rule(f);
 	struct flow_dissector *dissector = f_rule->match.dissector;
 	struct prestera_acl_match *r_match = &rule->re_key.match;
 	__be16 n_proto_mask = 0;
@@ -421,7 +422,6 @@ void prestera_flower_destroy(struct prestera_flow_block *block,
 		prestera_acl_rule_destroy(rule);
 	}
 	prestera_acl_ruleset_put(ruleset);
-
 }
 
 int prestera_flower_tmplt_create(struct prestera_flow_block *block,
-- 
2.25.1

