Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9390449D257
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 20:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244381AbiAZTLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 14:11:22 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55086 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244366AbiAZTLS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 14:11:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03584616D9
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 19:11:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA809C340EC;
        Wed, 26 Jan 2022 19:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643224277;
        bh=Gn2Mu5VGhuriVR4+UNNu1z9Y/BwciTsKAAEA+mC8PA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gqgFECUFQz1yboSuQKrgzO/Yxpa9UidtiitL6dk5Bnv6woff/5DD83nleJJK4OlJ+
         TCGjj3E2Q4I0UVlr2/cDWBOEreDr6znachN8UsOsZ75njWTZmCq5DuDwY4ixQWkeqC
         y+JZP7m1Vd+duZXxkXBXsESd7VcNFvz1qyPIcHAuU5nN3PeISb47/RNQv57iMwZVNy
         CC8CwykDVBn1xi/7FAhdi5dbM+ZBmp9bX6feIeMMgALLH7H+i0SieWLN6x7W0XgEo6
         qFUwsEIN4XuASXaoHDRnqCGPvmtqd7sPM5WjYBJZ+crKLarWyUXtfFs1tvi1S9nI/Y
         NWpWwiIDYFqJQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 12/15] netlink: remove nl_set_extack_cookie_u32()
Date:   Wed, 26 Jan 2022 11:11:06 -0800
Message-Id: <20220126191109.2822706-13-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126191109.2822706-1-kuba@kernel.org>
References: <20220126191109.2822706-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Not used since v5.10.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/netlink.h | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index 1ec631838af9..bda1c385cffb 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -135,15 +135,6 @@ static inline void nl_set_extack_cookie_u64(struct netlink_ext_ack *extack,
 	extack->cookie_len = sizeof(cookie);
 }
 
-static inline void nl_set_extack_cookie_u32(struct netlink_ext_ack *extack,
-					    u32 cookie)
-{
-	if (!extack)
-		return;
-	memcpy(extack->cookie, &cookie, sizeof(cookie));
-	extack->cookie_len = sizeof(cookie);
-}
-
 void netlink_kernel_release(struct sock *sk);
 int __netlink_change_ngroups(struct sock *sk, unsigned int groups);
 int netlink_change_ngroups(struct sock *sk, unsigned int groups);
-- 
2.34.1

