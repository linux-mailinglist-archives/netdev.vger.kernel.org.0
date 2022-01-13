Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CEA748DB77
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 17:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236518AbiAMQQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 11:16:10 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:39843 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229496AbiAMQQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 11:16:09 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R331e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V1kkd9d_1642090558;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0V1kkd9d_1642090558)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 14 Jan 2022 00:16:07 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     johannes@sipsolutions.net
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] mac80211: Remove redundent assignment channel_type
Date:   Fri, 14 Jan 2022 00:15:57 +0800
Message-Id: <20220113161557.129427-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warnings:

net/mac80211/util.c:3265:3: warning: Value stored to 'channel_type' is
never read [clang-analyzer-deadcode.DeadStores].

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 net/mac80211/util.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index f71b042a5c8b..fea3d34e3ef3 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -3262,7 +3262,6 @@ bool ieee80211_chandef_ht_oper(const struct ieee80211_ht_operation *ht_oper,
 		channel_type = NL80211_CHAN_HT40MINUS;
 		break;
 	default:
-		channel_type = NL80211_CHAN_NO_HT;
 		return false;
 	}
 
-- 
2.20.1.7.g153144c

