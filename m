Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E26D73A0EA0
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 10:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236997AbhFIISK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 04:18:10 -0400
Received: from m12-11.163.com ([220.181.12.11]:40208 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237514AbhFIISI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 04:18:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=5yGOJ
        12pzYBCb614eaSafc6rq9IPhMkSADbTkd6ofvU=; b=fO2H5ld5ZoS2DPVzPVwbd
        /qxWiMh8zkCaVrC9WhJE+5GNSf2feIvrhmj/UwhVEcmCFxra1AWUkQn43jF6HFzz
        Ck/9NYwvYbvtCqaY55PEDAdQDeCYuJK6qyF4tiN2EbytfFNFkrolkwTM81H02UNN
        LAxE0Eoa/6ukyCm/7dsdT0=
Received: from ubuntu.localdomain (unknown [218.17.89.92])
        by smtp7 (Coremail) with SMTP id C8CowAC3zJy9eMBgbdo5hA--.4674S2;
        Wed, 09 Jun 2021 16:15:59 +0800 (CST)
From:   13145886936@163.com
To:     johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gushengxian <gushengxian@yulong.com>
Subject: [PATCH] nl80211: fix a mistake in grammar
Date:   Wed,  9 Jun 2021 01:15:56 -0700
Message-Id: <20210609081556.19641-1-13145886936@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: C8CowAC3zJy9eMBgbdo5hA--.4674S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7JFyDuF1UKFy5uFyxGF4xtFb_yoWfJrc_Xr
        48ZrsYyay8Jr47u3y8CanIvr4qk3s5GrZ3Z39xCFZ2kry3XrZ5X3s3XrWDArn09r18ury3
        W395Cry3G3ZFvjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU57u4UUUUUU==
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5zrdx5xxdq6xppld0qqrwthudrp/1tbiGhysg1aD+DWrggAAsY
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: gushengxian <gushengxian@yulong.com>

Fix a mistake in grammar.

Signed-off-by: gushengxian <gushengxian@yulong.com>
---
 net/wireless/nl80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index fc9286afe3c9..68dff0ca3190 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -8128,7 +8128,7 @@ int nl80211_parse_random_mac(struct nlattr **attrs,
 	memcpy(mac_addr, nla_data(attrs[NL80211_ATTR_MAC]), ETH_ALEN);
 	memcpy(mac_addr_mask, nla_data(attrs[NL80211_ATTR_MAC_MASK]), ETH_ALEN);
 
-	/* don't allow or configure an mcast address */
+	/* don't allow or configure a mcast address */
 	if (!is_multicast_ether_addr(mac_addr_mask) ||
 	    is_multicast_ether_addr(mac_addr))
 		return -EINVAL;
-- 
2.25.1

