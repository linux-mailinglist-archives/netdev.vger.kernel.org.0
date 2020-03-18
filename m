Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB9018A570
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 22:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728547AbgCRU4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 16:56:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:56938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727303AbgCRU4I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 16:56:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E351D21973;
        Wed, 18 Mar 2020 20:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564967;
        bh=h8qI3TUvyEaVDgUUv50i3tEfzr3ss5KSUl9j5hb/Ews=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yGj4ebar36wMKYMZZECgozq9JcGV8WT6QQTEv0bFpg/xdNwdf2nm6Y6J6/Qfyysc2
         MFgWaopE4PpZFKQGYvweIlBN4+9L86w00da+8Jszi53eYUzheL17iT62v3hv00FKez
         kS4xOGWj9hyfB5bNC8MGq0Fy3qkilSeO1agw4XiY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 10/28] macsec: add missing attribute validation for port
Date:   Wed, 18 Mar 2020 16:55:37 -0400
Message-Id: <20200318205555.17447-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205555.17447-1-sashal@kernel.org>
References: <20200318205555.17447-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 31d9a1c524964bac77b7f9d0a1ac140dc6b57461 ]

Add missing attribute validation for IFLA_MACSEC_PORT
to the netlink policy.

Fixes: c09440f7dcb3 ("macsec: introduce IEEE 802.1AE driver")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macsec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 9bb65e0af7dd7..d6c92263bebef 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -2974,6 +2974,7 @@ static const struct device_type macsec_type = {
 
 static const struct nla_policy macsec_rtnl_policy[IFLA_MACSEC_MAX + 1] = {
 	[IFLA_MACSEC_SCI] = { .type = NLA_U64 },
+	[IFLA_MACSEC_PORT] = { .type = NLA_U16 },
 	[IFLA_MACSEC_ICV_LEN] = { .type = NLA_U8 },
 	[IFLA_MACSEC_CIPHER_SUITE] = { .type = NLA_U64 },
 	[IFLA_MACSEC_WINDOW] = { .type = NLA_U32 },
-- 
2.20.1

