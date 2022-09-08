Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24C105B1D88
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 14:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbiIHMpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 08:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232033AbiIHMpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 08:45:22 -0400
Received: from bg4.exmail.qq.com (bg4.exmail.qq.com [43.154.221.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F055D61D45;
        Thu,  8 Sep 2022 05:45:19 -0700 (PDT)
X-QQ-mid: bizesmtp72t1662641103tv02ayuu
Received: from localhost.localdomain ( [182.148.14.0])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 08 Sep 2022 20:45:01 +0800 (CST)
X-QQ-SSF: 0100000000200090C000B00A0000000
X-QQ-FEAT: D6RqbDSxuq6ySMTO2xWIpTDRUWT9OUBRbljcE9flaM/y4cUplwilnVgJC31FL
        ugO3wXfw9MxwT1hvk7WMugtnfylctS9Ve91NyfyQdpWELI+qiAyEpVZ9AEcqCd9VUA7R/9w
        AAhA3N7qj/+hjk+YDAaL0mjporUsPJshQHvUdvwZ1MAo4cdNGYPDPrzPSoGn64wmiXwNpAg
        u5/12eF2Ws3+UeozsIp37JcoP/DloGcPQ6gCxDiyKiuDJOJg33siMGvBzkldOFhn7MQhCPf
        lcmxi6rDNsWMtnphfupBh0tp9PqGj7teIDSDpPShNY2LoqdQgGX6/Q7uyyy9NIB3GaxDWp9
        npIUv1FvY2iBnXABbsLPqXTWIFkvSsLpAXyPyjvz9ZSbY2/Ldg=
X-QQ-GoodBg: 0
From:   wangjianli <wangjianli@cdjrlc.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wangjianli <wangjianli@cdjrlc.com>
Subject: [PATCH] sfc/siena: fix repeated words in comments
Date:   Thu,  8 Sep 2022 20:44:54 +0800
Message-Id: <20220908124454.23465-1-wangjianli@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr7
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete the redundant word 'in'.

Signed-off-by: wangjianli <wangjianli@cdjrlc.com>
---
 drivers/net/ethernet/sfc/siena/bitfield.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/siena/bitfield.h b/drivers/net/ethernet/sfc/siena/bitfield.h
index 1f981dfe4bdc..0b502d1c3c9e 100644
--- a/drivers/net/ethernet/sfc/siena/bitfield.h
+++ b/drivers/net/ethernet/sfc/siena/bitfield.h
@@ -117,7 +117,7 @@ typedef union efx_oword {
  *
  *   ( element ) << 4
  *
- * The result will contain the relevant bits filled in in the range
+ * The result will contain the relevant bits filled in the range
  * [0,high-low), with garbage in bits [high-low+1,...).
  */
 #define EFX_EXTRACT_NATIVE(native_element, min, max, low, high)		\
-- 
2.36.1

