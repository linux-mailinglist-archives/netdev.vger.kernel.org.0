Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AAB957BEC8
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 21:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236920AbiGTTnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 15:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236528AbiGTTnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 15:43:50 -0400
Received: from smtpbg.qq.com (biz-43-154-54-12.mail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86B068DC4;
        Wed, 20 Jul 2022 12:43:45 -0700 (PDT)
X-QQ-mid: bizesmtp87t1658346178tf9ar22l
Received: from harry-jrlc.. ( [125.70.163.183])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 21 Jul 2022 03:42:47 +0800 (CST)
X-QQ-SSF: 0100000000200030C000C00A0000020
X-QQ-FEAT: KfdWLgjtJHZnYfL4/TlHXincVqdrjmUZX2CfrZIoxIJUb1Jv+GS1V2tXzXOhM
        pG3EYQNNGq5dwwe6bTd4pSDIPh1YWU0zyyojJMYm2PDPw63PAnN57bsM3V1b8sIlbGAhnmM
        FErGUxHooWzuzh3CD3yakhRpmzOI+gNlsgkv8C6l1JbsBUYAUCdDpes7rdacyok/hOhWXsi
        YDcgdvB0mH/R5A1XgK+NxmTEocQGcvK/+4IUxvdgGW4NhZc7M0Q967n44AVs4FWV+p3ryjE
        E0N6I4dvX3YNvZLCriaKGfTSZGh3YTTFgbVL4bZIwGvJ9BoT4aWmkTbWwFMtrEZ7ZEwbGiH
        rSxXrSNPWL0bAHxYcaMByIYmEO6AgMmGXc7ile2SGkjo6AXrJVLWqPlM6Sivw==
X-QQ-GoodBg: 0
From:   Xin Gao <gaoxin@cdjrlc.com>
To:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xin Gao <gaoxin@cdjrlc.com>
Subject: [PATCH] b43:do not initialise statics to 0.
Date:   Thu, 21 Jul 2022 03:42:45 +0800
Message-Id: <20220720194245.8442-1-gaoxin@cdjrlc.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr6
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,RDNS_DYNAMIC,
        SPF_PASS,T_SPF_HELO_TEMPERROR autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

do not initialise statics to 0.

Signed-off-by: Xin Gao <gaoxin@cdjrlc.com>
---
 drivers/net/wireless/broadcom/b43/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/b43/main.c b/drivers/net/wireless/broadcom/b43/main.c
index 17bcec5f3ff7..5e233d0e06c0 100644
--- a/drivers/net/wireless/broadcom/b43/main.c
+++ b/drivers/net/wireless/broadcom/b43/main.c
@@ -105,7 +105,7 @@ int b43_modparam_verbose = B43_VERBOSITY_DEFAULT;
 module_param_named(verbose, b43_modparam_verbose, int, 0644);
 MODULE_PARM_DESC(verbose, "Log message verbosity: 0=error, 1=warn, 2=info(default), 3=debug");
 
-static int b43_modparam_pio = 0;
+static int b43_modparam_pio;
 module_param_named(pio, b43_modparam_pio, int, 0644);
 MODULE_PARM_DESC(pio, "Use PIO accesses by default: 0=DMA, 1=PIO");
 
-- 
2.30.2

