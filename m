Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D187169483
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 03:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728900AbgBWCbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 21:31:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:53030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728684AbgBWCXa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Feb 2020 21:23:30 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADC702071E;
        Sun, 23 Feb 2020 02:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582424609;
        bh=8ITaZFZgUihDSQO1mZwt+UkaagCefQ1Nx1g4etIaBuU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QXeIZGu3od7hsQclm5tn0+c0LBNMsOYLCGNQOjsA95RRa5HwEnNJzb3ECCrWaK+t1
         +0x+MIiuP1UNJGC/yY7kKd6KGlSs3L2x9h0D+ISvEleZxsWBC3hzH2r/zDzJlZq20V
         he5KZ30XN76L8WQWGqHGcjX31qyfEdO5wuxzEluc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 44/50] cfg80211: add missing policy for NL80211_ATTR_STATUS_CODE
Date:   Sat, 22 Feb 2020 21:22:29 -0500
Message-Id: <20200223022235.1404-44-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200223022235.1404-1-sashal@kernel.org>
References: <20200223022235.1404-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

[ Upstream commit ea75080110a4c1fa011b0a73cb8f42227143ee3e ]

The nl80211_policy is missing for NL80211_ATTR_STATUS_CODE attribute.
As a result, for strictly validated commands, it's assumed to not be
supported.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Link: https://lore.kernel.org/r/20200213131608.10541-2-sergey.matyukevich.os@quantenna.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c74646b7a751f..1930513f541e1 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -437,6 +437,7 @@ const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT] = { .type = NLA_FLAG },
 	[NL80211_ATTR_CONTROL_PORT_OVER_NL80211] = { .type = NLA_FLAG },
 	[NL80211_ATTR_PRIVACY] = { .type = NLA_FLAG },
+	[NL80211_ATTR_STATUS_CODE] = { .type = NLA_U16 },
 	[NL80211_ATTR_CIPHER_SUITE_GROUP] = { .type = NLA_U32 },
 	[NL80211_ATTR_WPA_VERSIONS] = { .type = NLA_U32 },
 	[NL80211_ATTR_PID] = { .type = NLA_U32 },
-- 
2.20.1

