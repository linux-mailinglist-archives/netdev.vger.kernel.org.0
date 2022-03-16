Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88BDF4DACE8
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 09:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354717AbiCPIxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 04:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354708AbiCPIxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 04:53:24 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6754C65153;
        Wed, 16 Mar 2022 01:52:10 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.188:37546.597671551
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-202.80.192.39 (unknown [172.18.0.188])
        by chinatelecom.cn (HERMES) with SMTP id B0F0F2800DD;
        Wed, 16 Mar 2022 16:52:06 +0800 (CST)
X-189-SAVE-TO-SEND: +sunshouxin@chinatelecom.cn
Received: from  ([172.18.0.188])
        by app0023 with ESMTP id 65dd90137f5b432bb1e7f422a4efec21 for j.vosburgh@gmail.com;
        Wed, 16 Mar 2022 16:52:09 CST
X-Transaction-ID: 65dd90137f5b432bb1e7f422a4efec21
X-Real-From: sunshouxin@chinatelecom.cn
X-Receive-IP: 172.18.0.188
X-MEDUSA-Status: 0
Sender: sunshouxin@chinatelecom.cn
From:   Sun Shouxin <sunshouxin@chinatelecom.cn>
To:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, oliver@neukum.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        huyd12@chinatelecom.cn, sunshouxin@chinatelecom.cn
Subject: [PATCH v3 4/4] net: usb:Refactor ndisc_send_na
Date:   Wed, 16 Mar 2022 04:49:58 -0400
Message-Id: <20220316084958.21169-5-sunshouxin@chinatelecom.cn>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220316084958.21169-1-sunshouxin@chinatelecom.cn>
References: <20220316084958.21169-1-sunshouxin@chinatelecom.cn>
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

