Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95CE258FBAA
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 13:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235080AbiHKLyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 07:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235083AbiHKLx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 07:53:58 -0400
Received: from bg5.exmail.qq.com (bg4.exmail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B84559674E;
        Thu, 11 Aug 2022 04:53:52 -0700 (PDT)
X-QQ-mid: bizesmtp77t1660218799t37k9zmw
Received: from localhost.localdomain ( [182.148.14.53])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 11 Aug 2022 19:53:18 +0800 (CST)
X-QQ-SSF: 01000000002000G0V000B00A0000020
X-QQ-FEAT: ao4JQgu0M3+2bE3cuklzVLziN8/qCFBU7ahU98L8PAg+MyOXGe3xBQxGM0W7+
        h7LAkW6bnjBgsDaNIAd2KWAcss9oc73ZwfEl8hwoGNQS3daO8MstEX3TGxnWyENk0/5uTUy
        whRKOPwBCYfiegYk5YVx/E+Kp6nmXoxX3H6kMIiXO9SlXRweuwAD7XuYTx/7ahqTZ3JHdP4
        X/v5om49BRIdjK8rHdOcf/c1OqG6BMnubqxbDY2fmZZMWskelfcOWe9HmLswfiNE+5HpfKc
        Dd6kwUCKzH2U6S3wkRBOM5VaUaz7UtWUMVkrWyVxp5/q95+f2VyxPzc+d6F2RJABDPGZzNt
        cDadImY0McNP9+ObPt9cixVY2bEZAPnxSFIo/diFFU1EeT/vvo=
X-QQ-GoodBg: 0
From:   Jason Wang <wangborong@cdjrlc.com>
To:     edumazet@google.com
Cc:     elder@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Wang <wangborong@cdjrlc.com>
Subject: [PATCH] net: ipa: Fix comment typo
Date:   Thu, 11 Aug 2022 19:52:59 +0800
Message-Id: <20220811115259.64225-1-wangborong@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr6
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The double `is' is duplicated in the comment, remove one.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
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

