Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B066D34BF64
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 23:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbhC1Vhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 17:37:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41798 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbhC1Vhe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 17:37:34 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lQd6A-0005bJ-3e; Sun, 28 Mar 2021 21:37:30 +0000
From:   Colin King <colin.king@canonical.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mac80211: remove redundant assignment of variable result
Date:   Sun, 28 Mar 2021 22:37:29 +0100
Message-Id: <20210328213729.65819-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable result is being assigned a value that is never
read and it is being updated later with a new value. The
initialization is redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/mac80211/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 5d06de61047a..2fba9db56e47 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1684,7 +1684,7 @@ static bool __ieee80211_tx(struct ieee80211_local *local,
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_vif *vif;
 	struct sk_buff *skb;
-	bool result = true;
+	bool result;
 	__le16 fc;
 
 	if (WARN_ON(skb_queue_empty(skbs)))
-- 
2.30.2

