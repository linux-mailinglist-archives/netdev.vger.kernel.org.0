Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35A16560074
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 14:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233360AbiF2Mza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 08:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232912AbiF2MzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 08:55:25 -0400
X-Greylist: delayed 16340 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 29 Jun 2022 05:55:19 PDT
Received: from smtpbg.qq.com (unknown [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF1C92CDF5;
        Wed, 29 Jun 2022 05:55:19 -0700 (PDT)
X-QQ-mid: bizesmtp63t1656507291tfsra6c3
Received: from localhost.localdomain ( [182.148.13.66])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 29 Jun 2022 20:54:48 +0800 (CST)
X-QQ-SSF: 0100000000200060C000C00A0000000
X-QQ-FEAT: xoS364mEyr00dFkTgfgNEjTaoF4BmwMd0CJyYGBO7nG8ghAnd04j3/n2cv+cO
        +wrHSkmNl3aNXNDMUN9e99ldFJgDUvmcmwIum6NyP7X+i7FA2jTKQgYpOj1j2xucTNyzgq9
        vJ+a+sqnYHuHkHuVwBM+t0a84XnxTAmTKfj5HULnf06+gYoYZcSdnwY4mNWYeRGnM8A8GCc
        vh/IbEXoGhH0LRkuVKYm3yPADPKbfXfhn0qV5DS6pd0H9QfkVKG8lMCOfIoAJLxSsgiXlAs
        zymwHrzeUglHsXnFQiGDwlavaWfVsO1+oTK+ZcFZZc+n+R+qtGp6p4X6mipXeSaZV2tMPN1
        npWneCq5Y4KttdBBdg=
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     pantelis.antoniou@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] freescale/fs_enet:fix repeated words in comments
Date:   Wed, 29 Jun 2022 20:54:41 +0800
Message-Id: <20220629125441.62420-1-yuanjilin@cdjrlc.com>
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

Delete the redundant word 'a'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/ethernet/freescale/fs_enet/fs_enet.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fs_enet/fs_enet.h b/drivers/net/ethernet/freescale/fs_enet/fs_enet.h
index 5ff2634bee2f..cb419aef8d1b 100644
--- a/drivers/net/ethernet/freescale/fs_enet/fs_enet.h
+++ b/drivers/net/ethernet/freescale/fs_enet/fs_enet.h
@@ -201,7 +201,7 @@ void fs_enet_platform_cleanup(void);
 
 /* access macros */
 #if defined(CONFIG_CPM1)
-/* for a a CPM1 __raw_xxx's are sufficient */
+/* for a CPM1 __raw_xxx's are sufficient */
 #define __cbd_out32(addr, x)	__raw_writel(x, addr)
 #define __cbd_out16(addr, x)	__raw_writew(x, addr)
 #define __cbd_in32(addr)	__raw_readl(addr)
-- 
2.36.1

