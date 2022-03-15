Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4F3C4D9554
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 08:32:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345463AbiCOHdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 03:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345469AbiCOHdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 03:33:40 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 01F954B416;
        Tue, 15 Mar 2022 00:32:28 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.48:41014.619685907
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-202.80.192.38 (unknown [172.18.0.48])
        by chinatelecom.cn (HERMES) with SMTP id D9BD528008B;
        Tue, 15 Mar 2022 15:32:24 +0800 (CST)
X-189-SAVE-TO-SEND: +sunshouxin@chinatelecom.cn
Received: from  ([172.18.0.48])
        by app0024 with ESMTP id ff7b1ef8804345e58971ca2e54764d69 for j.vosburgh@gmail.com;
        Tue, 15 Mar 2022 15:32:27 CST
X-Transaction-ID: ff7b1ef8804345e58971ca2e54764d69
X-Real-From: sunshouxin@chinatelecom.cn
X-Receive-IP: 172.18.0.48
X-MEDUSA-Status: 0
Sender: sunshouxin@chinatelecom.cn
From:   Sun Shouxin <sunshouxin@chinatelecom.cn>
To:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, oliver@neukum.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        huyd12@chinatelecom.cn, sunshouxin@chinatelecom.cn
Subject: [PATCH v2 4/4] net: usb:Refactor ndisc_send_na
Date:   Tue, 15 Mar 2022 03:30:08 -0400
Message-Id: <20220315073008.17441-5-sunshouxin@chinatelecom.cn>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220315073008.17441-1-sunshouxin@chinatelecom.cn>
References: <20220315073008.17441-1-sunshouxin@chinatelecom.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor ndisc_send_na in struct ipv6_stub.

Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
---
 drivers/net/usb/cdc_mbim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/cdc_mbim.c b/drivers/net/usb/cdc_mbim.c
index c89639381eca..70f4327dbd2a 100644
--- a/drivers/net/usb/cdc_mbim.c
+++ b/drivers/net/usb/cdc_mbim.c
@@ -347,7 +347,7 @@ static void do_neigh_solicit(struct usbnet *dev, u8 *buf, u16 tci)
 				 is_router /* router */,
 				 true /* solicited */,
 				 false /* override */,
-				 true /* inc_opt */);
+				 true /* inc_opt */, NULL);
 out:
 	dev_put(netdev);
 }
-- 
2.27.0

