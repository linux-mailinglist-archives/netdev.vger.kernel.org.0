Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58037596240
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 20:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235798AbiHPSPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 14:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236658AbiHPSPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 14:15:17 -0400
Received: from bg5.exmail.qq.com (bg4.exmail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A715E81B3B;
        Tue, 16 Aug 2022 11:15:13 -0700 (PDT)
X-QQ-mid: bizesmtp70t1660673453tihgsg97
Received: from harry-jrlc.. ( [182.148.12.144])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 17 Aug 2022 02:10:41 +0800 (CST)
X-QQ-SSF: 0100000000000060D000B00A0000020
X-QQ-FEAT: uUYRqJkYwO4LXC4etf4sAwy1jbvjPR2mWSdsI42K9XsGqZ7rQjgiYligQVWQz
        pTS2YMVG8hWrSoPWTnkhiPqAnxFsFkon+oB6IR2OcpcZXoPPLqmm98lJUJsh8YocT1LYtnw
        KHHrk5ZcXdvqbLzyrF+oPJiNMopI57NtXeTT3687LeVmpwfLD6OyvHfNpt6I/gk3yvdc2ue
        7xEMNW4blxoX5u78ORd+ZSpo+wsVJKNYgZz4qljjmINN1m//8rLUULIF3p+cAVVug8b0Yig
        oi+Tk7qhGcaK6zmK+xVa4DU14l+nvD9bJQ1W5bEr/VcC1qQKp9OF5EbiT2W+we2HZvabSd9
        XTW8V4PRpS2EG2bAbFIa23k5Vy6qbEbD0Lb8uVU+j0aFZCpOq84VzTHpD/XZw==
X-QQ-GoodBg: 0
From:   Xin Gao <gaoxin@cdjrlc.com>
To:     johannes@sipsolutions.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xin Gao <gaoxin@cdjrlc.com>
Subject: [PATCH] mac80211: Variable type completion
Date:   Wed, 17 Aug 2022 02:10:40 +0800
Message-Id: <20220816181040.9044-1-gaoxin@cdjrlc.com>
X-Mailer: git-send-email 2.30.2
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

'unsigned int' is better than 'unsigned'.

Signed-off-by: Xin Gao <gaoxin@cdjrlc.com>
---
 net/mac80211/ibss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 14c04fd48b7a..16fe69deb40b 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1349,7 +1349,7 @@ static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
 				  capability, 0, true);
 }
 
-static unsigned ibss_setup_channels(struct wiphy *wiphy,
+static unsigned int ibss_setup_channels(struct wiphy *wiphy,
 				    struct ieee80211_channel **channels,
 				    unsigned int channels_max,
 				    u32 center_freq, u32 width)
-- 
2.30.2

