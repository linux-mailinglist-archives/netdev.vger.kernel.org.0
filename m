Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8D4556BD87
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 18:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238721AbiGHP0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 11:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238099AbiGHP0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 11:26:10 -0400
Received: from smtpbg.qq.com (biz-43-154-54-12.mail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A455B606AB
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 08:26:05 -0700 (PDT)
X-QQ-mid: bizesmtp77t1657293935t51f2e2b
Received: from localhost.localdomain ( [182.148.15.249])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 08 Jul 2022 23:25:32 +0800 (CST)
X-QQ-SSF: 01000000002000B0C000B00A0000000
X-QQ-FEAT: +HVWQWZs/U1R4RPSubX3NUroQvP4G74J3AXjhp8IsbGYlxddmT13EH9KS8XJQ
        8xtgN5TMDvUhAtmf/Brzh79VwB/X3kl3gwV7oVzzUDL3sHKzBJvjdbqcIJHIdXhxrIrluau
        J4EFIFVUXJftuJTb/jgSvN7vV0V7s0u02bAs2zIaYTtnk1QdHDwwDtzQGYpqKGLpplYSZ3/
        0r7JT+I6D+F+O5CLwzeI5YvyRT8yeRr6taExdK7yvGwdsisdubkHiGeeaYBPaNR+Xk3VgOq
        hWtSqTRNCkZu4edAB7dM+O2VzRpiy5gJ7pYG47hdYW+1p3SZTyQmocKwJFJXYcZVoR+1SSo
        By2ZYFqdavK1MCLq+CCwGQDHb3sG1ZbEAj6597DZn9w/LqnY58=
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     elder@kernel.org, netdev@vger.kernel.org,
        inux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] net/ipa: fix repeated words in comments
Date:   Fri,  8 Jul 2022 23:25:26 +0800
Message-Id: <20220708152526.60349-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr4
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,RDNS_DYNAMIC,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 Delete the redundant word 'is'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/ipa/ipa_reg.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index a5b355384d4a..6f35438cda89 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -48,7 +48,7 @@ struct ipa;
  *
  * The offset of registers related to resource types is computed by a macro
  * that is supplied a parameter "rt".  The "rt" represents a resource type,
- * which is is a member of the ipa_resource_type_src enumerated type for
+ * which is a member of the ipa_resource_type_src enumerated type for
  * source endpoint resources or the ipa_resource_type_dst enumerated type
  * for destination endpoint resources.
  *
-- 
2.36.1

