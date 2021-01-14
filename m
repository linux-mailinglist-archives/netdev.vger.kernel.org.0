Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E53812F59FE
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 05:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbhANEob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 23:44:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:34832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726404AbhANEoX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 23:44:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7D2E238EC;
        Thu, 14 Jan 2021 04:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610599423;
        bh=vg05N9MsH2t812UGcMDwUVmBTi1mTfXJOVduRfQ+sdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OiRf0UDAr+ANAZU/gphYIYFBr0NjKzEOUODRgZyJ4YF1gjUbC8Ao+iqKxMfcVTw8I
         qWzf3H2oiQU/NRgrFzH3Hdd6+4A2qdry3UPNK2eeNEgmZdqdok2gcG1NbDO63j3JmO
         hh3tJ1TNGY5o+7z+nQVinu3d6JsMRHxAwxiuCWDKltYxaBvrMQwBkRHJoqOJ1e+h+w
         2Jm+nUadMudvUiUzD5dwSwDfcx/3murunfWnHUJYZlRnqB6pZ9xys/6AXzCMTh8lvP
         wZSRtTF5iwBEkOVJQXcJIuP1KjxprNWuskWS+2ao6+Uzfb4BKRqsYnNAIcrwHJDto7
         1qB7C5HmV4Vfg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        davem@davemloft.net, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v5 1/5] net: sfp: add SFP_PASSWORD address
Date:   Thu, 14 Jan 2021 05:43:27 +0100
Message-Id: <20210114044331.5073-2-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210114044331.5073-1-kabel@kernel.org>
References: <20210114044331.5073-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add SFP_PASSWORD = 0x7b to the diagnostics enumerator. This address is
described in SFF-8436 and SFF-8636.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 include/linux/sfp.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/sfp.h b/include/linux/sfp.h
index 38893e4dd0f0..81b40b2d6b1b 100644
--- a/include/linux/sfp.h
+++ b/include/linux/sfp.h
@@ -490,6 +490,7 @@ enum {
 
 	SFP_EXT_STATUS			= 0x76,
 	SFP_VSL				= 0x78,
+	SFP_PASSWORD			= 0x7b,
 	SFP_PAGE			= 0x7f,
 };
 
-- 
2.26.2

