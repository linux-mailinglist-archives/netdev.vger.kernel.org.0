Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB225AFAF1
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 06:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiIGEEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 00:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiIGEEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 00:04:21 -0400
Received: from bg4.exmail.qq.com (bg4.exmail.qq.com [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C5D86FD9;
        Tue,  6 Sep 2022 21:04:18 -0700 (PDT)
X-QQ-mid: bizesmtp83t1662523434tn9akgch
Received: from localhost.localdomain ( [182.148.14.0])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 07 Sep 2022 12:03:52 +0800 (CST)
X-QQ-SSF: 01000000000000D0F000000A0000000
X-QQ-FEAT: St3bwald4oqh1Kr8Tob8iSU8cQS6xZjxAhy52bRyavXfUvJCnDSoBsyxQUtR/
        LmhTF6agA7Z//Cgm7KN0J5jaK68uxL9vQutZhpjbgExV28yxQ+J6DKlBQ3NtWooroMR+zI9
        rbxAOFbwuAl4WvdaQbDS9phDKk7uxAiit+9PHd1Fmdwa3DmxrwpIAUSSnpnp73kxrkxC6M5
        XxNHjJ1tE2zlOzTjNcz3PhXBNi7HAIlGhbD9PwxpHscecUnQ7oiT6g5Y/UKob8O3xJy5C1b
        UDxFEPPGjpCorHEMDjE1l4c1Yzx55cX57X4VOH1XvqHL6yXnDc5tTQ4ZxYJl7fhMs3tMzS6
        L1bsXuFac5xWn0lhdtEILaO4zDTQEsMkqAndy94ydr+kaZ3PKdiw5Ks1romHQ==
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     pshelar@ovn.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] net: openvswitch: fix repeated words in comments
Date:   Wed,  7 Sep 2022 12:03:46 +0800
Message-Id: <20220907040346.55169-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr4
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,RCVD_IN_PBL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete the redundant word 'is'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 net/openvswitch/flow_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index 4c09cf8a0ab2..4a07ab094a84 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -3304,7 +3304,7 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
 
 			/* Disallow subsequent L2.5+ set actions and mpls_pop
 			 * actions once the last MPLS label in the packet is
-			 * is popped as there is no check here to ensure that
+			 * popped as there is no check here to ensure that
 			 * the new eth type is valid and thus set actions could
 			 * write off the end of the packet or otherwise corrupt
 			 * it.
-- 
2.36.1

