Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 245C6349FDF
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 03:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbhCZCjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 22:39:13 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14610 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbhCZCjA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 22:39:00 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F65hp1cJ7z19JhS;
        Fri, 26 Mar 2021 10:36:58 +0800 (CST)
Received: from localhost.localdomain (10.175.102.38) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.498.0; Fri, 26 Mar 2021 10:38:51 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     <weiyongjun1@huawei.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH -next] mac80211: minstrel_ht: remove unused variable 'mg' in minstrel_ht_next_jump_rate()
Date:   Fri, 26 Mar 2021 02:48:43 +0000
Message-ID: <20210326024843.987941-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.102.38]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GCC reports the following warning with W=1:

net/mac80211/rc80211_minstrel_ht.c:871:34: warning:
 variable 'mg' set but not used [-Wunused-but-set-variable]
  871 |  struct minstrel_mcs_group_data *mg;
      |                                  ^~

This variable is not used in function , this commit
remove it to fix the warning.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 net/mac80211/rc80211_minstrel_ht.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index ecad9b10984f..f21c85eb906a 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -868,7 +868,6 @@ static u16
 minstrel_ht_next_jump_rate(struct minstrel_ht_sta *mi, u32 fast_rate_dur,
 			   u32 slow_rate_dur, int *slow_rate_ofs)
 {
-	struct minstrel_mcs_group_data *mg;
 	struct minstrel_rate_stats *mrs;
 	u32 max_duration = slow_rate_dur;
 	int i, index, offset;
@@ -886,7 +885,6 @@ minstrel_ht_next_jump_rate(struct minstrel_ht_sta *mi, u32 fast_rate_dur,
 		u8 type;
 
 		group = (group + 1) % ARRAY_SIZE(minstrel_mcs_groups);
-		mg = &mi->groups[group];
 
 		supported = mi->supported[group];
 		if (!supported)

