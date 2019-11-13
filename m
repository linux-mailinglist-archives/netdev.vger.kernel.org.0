Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD46FA216
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 03:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730746AbfKMCB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 21:01:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:57316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729479AbfKMCB0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 21:01:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8122D222C9;
        Wed, 13 Nov 2019 02:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610486;
        bh=j9Zcp3P2qjbCbgdGS8uBWmnp7vlhR4j9Ra7HKixGESQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xkg6OPbAWgpomszfXGx7uVmRBqg4DhWzi/bRv3ExA2ub+itK+2WnJ49cD64+HsPSu
         /QRJ2gW4Sj3Q3gy0x70YbhEKOtedsNLvOKV2VbvcPg+IW1IQEb1+z3UIz9y9aZMl1G
         0Q0pu/i+LcJnLuD3sPwsNAnhnfjAV0YA2iEw6DcU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 66/68] mac80211: minstrel: fix CCK rate group streams value
Date:   Tue, 12 Nov 2019 20:59:30 -0500
Message-Id: <20191113015932.12655-66-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015932.12655-1-sashal@kernel.org>
References: <20191113015932.12655-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 80df9be67c44cb636bbc92caeddad8caf334c53c ]

Fixes a harmless underflow issue when CCK rates are actively being used

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rc80211_minstrel_ht.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 30fbabf4bcbc1..593184d14b3ef 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -128,7 +128,7 @@
 
 #define CCK_GROUP					\
 	[MINSTREL_CCK_GROUP] = {			\
-		.streams = 0,				\
+		.streams = 1,				\
 		.flags = 0,				\
 		.duration = {				\
 			CCK_DURATION_LIST(false),	\
-- 
2.20.1

