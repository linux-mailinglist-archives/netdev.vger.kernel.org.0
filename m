Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 589C2361D72
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 12:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242177AbhDPJwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 05:52:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60468 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238093AbhDPJwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 05:52:05 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lXL8T-0001Up-9C; Fri, 16 Apr 2021 09:51:37 +0000
From:   Colin King <colin.king@canonical.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mac80211: minstrel_ht: remove extraneous indentation on if statement
Date:   Fri, 16 Apr 2021 10:51:37 +0100
Message-Id: <20210416095137.2033469-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The increment of idx is indented one level too deeply, clean up the
code by removing the extraneous tab.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/mac80211/rc80211_minstrel_ht.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index f21c85eb906a..6487b05da6fa 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -370,7 +370,7 @@ minstrel_ht_get_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 		/* short preamble */
 		if ((mi->supported[group] & BIT(idx + 4)) &&
 		    (rate->flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE))
-				idx += 4;
+			idx += 4;
 		goto out;
 	}
 
-- 
2.30.2

