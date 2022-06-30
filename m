Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 364B25613B0
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 09:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232991AbiF3Hwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 03:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233597AbiF3Hwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 03:52:35 -0400
Received: from smtpbg.qq.com (unknown [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B8D3F314;
        Thu, 30 Jun 2022 00:52:30 -0700 (PDT)
X-QQ-mid: bizesmtp86t1656575526tvn9rh9i
Received: from localhost.localdomain ( [182.148.13.66])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 30 Jun 2022 15:52:03 +0800 (CST)
X-QQ-SSF: 0100000000200070C000B00A0000000
X-QQ-FEAT: 3uawQE1sH+082I/m9dTggk/2Vl6B63L6A6cnIejRi6ix6XCisCPgOsSZYnRtn
        k0z8IM6BDMwLf21oWwSPclDrTHXHmpoCODME2rXZlhK7liMTmK9GgHNIl7akgLjbPlPXZtX
        0W+nj4NON8A8T6fZL8nzcXBfvv+FoaOTNeiUJC6j18SJzLgZ0hvfdz+WOj6GDcDYxMBucxp
        e98jfVfRc72S6sS2bJ9f4oTX6fG8D/4uRe9c4jUMvhpIyrpdGoC3IIKNqtT+PMrR7EuF30n
        11z2f4kJZIYISJqT778pMzTKRag2/83jvLiXZcQ8h/cadSVseyjBN02wXgdOqcWFRmAaOS2
        sg+eLGKAAYFroqJAJU=
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] ethernet/natsemi: fix repeated words in comments
Date:   Thu, 30 Jun 2022 15:51:56 +0800
Message-Id: <20220630075156.61577-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr4
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete the redundant word 'in'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/ethernet/natsemi/natsemi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/natsemi/natsemi.c b/drivers/net/ethernet/natsemi/natsemi.c
index 50bca486a244..9aae7f1eb5d2 100644
--- a/drivers/net/ethernet/natsemi/natsemi.c
+++ b/drivers/net/ethernet/natsemi/natsemi.c
@@ -158,7 +158,7 @@ MODULE_PARM_DESC(full_duplex, "DP8381x full duplex setting(s) (1)");
 I. Board Compatibility
 
 This driver is designed for National Semiconductor DP83815 PCI Ethernet NIC.
-It also works with other chips in in the DP83810 series.
+It also works with other chips in the DP83810 series.
 
 II. Board-specific settings
 
-- 
2.36.1

