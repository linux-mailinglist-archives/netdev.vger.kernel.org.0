Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1313B5B92DF
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 05:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbiIODFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 23:05:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbiIODE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 23:04:58 -0400
Received: from bg4.exmail.qq.com (bg4.exmail.qq.com [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA608DEAC;
        Wed, 14 Sep 2022 20:04:53 -0700 (PDT)
X-QQ-mid: bizesmtp91t1663211076tb7b2oju
Received: from localhost.localdomain ( [125.70.163.64])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 15 Sep 2022 11:04:34 +0800 (CST)
X-QQ-SSF: 01000000000000E0G000000A0000000
X-QQ-FEAT: +Fw3Sd5mYDUkX6DJ5ZqqH/iEztTkWmHnrm8bwtLY8K4MEdqWfmaUtja/2Ejig
        3tmPAXsRh0vT8IzGwIirS41QDMwnJF+P4C3R1qu3on4/IT+yDiZGh0DHUzK5Wv0sEWSzE7N
        6ShLEgDDC7SpcG6vG/89d6DPJXubTEtaTWT40CCWMwKbviFy9H3jr806Sservzytkm2PQEy
        y268angtlV+2Ncg3xmI933K1VVDhZop7vpdL1UBp4+qd0kDngx11kPu38sLFL6qgUfkWo/1
        wpOPQbkAFZ5NJe5gEPUhbWZYrbplBrCwJMC7MdNc6xCYMmdwsoAxg4zUr8/9hn/Ztk+Fu+k
        9b9t1MgkfFSueSCxj8BvQa7nEyDckYOqXIRKYX7bY/I1G+0j0LNLXlgxWN/ZG5giNgOfo+i
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     loic.poulain@linaro.org, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] wifi: wcn36xx: fix repeated words in comments
Date:   Thu, 15 Sep 2022 11:04:28 +0800
Message-Id: <20220915030428.38510-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr4
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,RCVD_IN_PBL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete the redundant word 'that'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/wireless/ath/wcn36xx/hal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/hal.h b/drivers/net/wireless/ath/wcn36xx/hal.h
index f1a43fd1d957..d3a9d00e65e1 100644
--- a/drivers/net/wireless/ath/wcn36xx/hal.h
+++ b/drivers/net/wireless/ath/wcn36xx/hal.h
@@ -2677,7 +2677,7 @@ struct ani_global_security_stats {
 	 * management information base (MIB) object is enabled */
 	u32 rx_wep_unencrypted_frm_cnt;
 
-	/* The number of received MSDU packets that that the 802.11 station
+	/* The number of received MSDU packets that the 802.11 station
 	 * discarded because of MIC failures */
 	u32 rx_mic_fail_cnt;
 
-- 
2.36.1

