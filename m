Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5392E56CC98
	for <lists+netdev@lfdr.de>; Sun, 10 Jul 2022 06:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiGJELm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 00:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiGJELl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 00:11:41 -0400
Received: from smtpbg.qq.com (biz-43-154-54-12.mail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7470212D2B;
        Sat,  9 Jul 2022 21:11:36 -0700 (PDT)
X-QQ-mid: bizesmtp77t1657426231tnuffod5
Received: from localhost.localdomain ( [182.148.15.109])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sun, 10 Jul 2022 12:10:12 +0800 (CST)
X-QQ-SSF: 01000000002000B0C000B00A0000000
X-QQ-FEAT: oxgq2YVMtX9MQTofHkQKgiDEHM7Bgjj+t/NFgLdd7CEME+1B/eNaBqi1ws05s
        YNvpzpCRPLk8iav88zBeDfnOm3jF5xFQo++nca7E+BF3CWdmUE68NlmjyXHaiwD+hLNXWsb
        9DaEl+0kJFavTRVQjU7ByHCQpAatXO4iLCqERkZyFNe32newUVyPNHz098fLcYQo82eGJAW
        2ICYIepIh7XIwWLsshdLOzMIyCIpFG441jZiybS6V5M+mj+0rZCMts2zaejQ6h6CWGmWSYD
        HpMXfZ7PG7W47GnQ1ASZ5OaZVRPDo0wFTnh1pt98yCIMs1BDXF+vvF5pPcqVY7zubtiPEeq
        JjbFWpNLUDLAgXyUxEQokvahLKqLw==
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     imitsyanko@quantenna.com, geomatsi@gmail.co, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] wifi: qtnfmac: fix repeated words in comments
Date:   Sun, 10 Jul 2022 12:10:05 +0800
Message-Id: <20220710041005.10950-1-yuanjilin@cdjrlc.com>
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
 drivers/net/wireless/quantenna/qtnfmac/qlink.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
index 2dda4c5d7427..674461fa7fb3 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -1721,8 +1721,8 @@ enum qlink_chan_stat {
  * @time_on: amount of time radio operated on that channel.
  * @time_tx: amount of time radio spent transmitting on the channel.
  * @time_rx: amount of time radio spent receiving on the channel.
- * @cca_busy: amount of time the the primary channel was busy.
- * @cca_busy_ext: amount of time the the secondary channel was busy.
+ * @cca_busy: amount of time the primary channel was busy.
+ * @cca_busy_ext: amount of time the secondary channel was busy.
  * @time_scan: amount of radio spent scanning on the channel.
  * @chan_noise: channel noise.
  */
-- 
2.36.1

