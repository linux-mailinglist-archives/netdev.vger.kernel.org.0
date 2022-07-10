Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5A9656CCE7
	for <lists+netdev@lfdr.de>; Sun, 10 Jul 2022 06:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbiGJEei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 00:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiGJEeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 00:34:37 -0400
Received: from smtpbg.qq.com (biz-43-154-54-12.mail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A76611145F;
        Sat,  9 Jul 2022 21:34:32 -0700 (PDT)
X-QQ-mid: bizesmtp66t1657427654tyba4nv9
Received: from localhost.localdomain ( [182.148.15.109])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sun, 10 Jul 2022 12:34:11 +0800 (CST)
X-QQ-SSF: 01000000002000B0C000C00A0000000
X-QQ-FEAT: BYjrFJkuRRd+wl4E6Z47xa6NTp1+QyC6Ef9V2qKYyzNW6zZe6omfGzPHk9z6j
        U5RDKqKPEsVC/wF6KeL2UpDNAitKEUDL8HqJ7NLNPo03rBcSSpFSEI7mYNVmlc6ztaEFfzc
        svk4SLzMmIUEnPV91TJjIqWLTaPIWvdUJQNkPhlaDZRytByctbGydoecyONNhFiSlR+5BDk
        LypQt9+cGxN5jYBJGNn+7Hm1iS9xNrLPEvvurwGqbjwvFvtCFMJIibK/fsaExpGYnaoYVsh
        529g2V6FYWNj52dlNUJ/l3xzZGiDbEBkolHujA+OVLLwGkiKhzyioFQt8j/YkQ/q7Xo3Gyf
        zUqBqdIpw7yxikHxPfh9INhj8+icibh0k5lOqOHay2wrCVOmPE=
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] wifi: wl1251: fix repeated words in comments
Date:   Sun, 10 Jul 2022 12:34:05 +0800
Message-Id: <20220710043405.38304-1-yuanjilin@cdjrlc.com>
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

 Delete the redundant word 'the'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/wireless/ti/wl1251/acx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl1251/acx.h b/drivers/net/wireless/ti/wl1251/acx.h
index 1da6ba95d3d4..1da6ab664e41 100644
--- a/drivers/net/wireless/ti/wl1251/acx.h
+++ b/drivers/net/wireless/ti/wl1251/acx.h
@@ -1229,7 +1229,7 @@ struct wl1251_acx_arp_filter {
 	u8 address[16];	/* The IP address used to filter ARP packets.
 			   ARP packets that do not match this address are
 			   dropped. When the IP Version is 4, the last 12
-			   bytes of the the address are ignored. */
+			   bytes of the address are ignored. */
 } __attribute__((packed));
 
 struct wl1251_acx_ac_cfg {
-- 
2.36.1

