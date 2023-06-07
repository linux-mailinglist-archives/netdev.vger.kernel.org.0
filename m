Return-Path: <netdev+bounces-9049-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD90D726BA8
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 22:27:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 156561C20F05
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 20:26:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 290EC3B8D9;
	Wed,  7 Jun 2023 20:24:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86173AE55
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 20:24:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28DF8C433A7;
	Wed,  7 Jun 2023 20:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686169451;
	bh=5TsyhqLckU3T3bRcGBqL2TUgNr3hViXw7QjCJNyslDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dQSNA8Ur0stmFWcuxflofgjf6zfDiHievpWB+p0nuP9Pgov2EUhtzqVmLL/MfvlPQ
	 KhnKzGvn31ChChs0G1Jsc1RTBA3uukUSdV+gGFesrW+fGYpTWVCK0joAsFb4ruxLK3
	 zn8aF7cv2YsTQ0PURqmInWz47YdiryQKJzHSReAPsEkiFcFMUnDbtkducEexgGdSmR
	 pPnVJRtg8v7ZJEbiFw9XuAbS36cxPQRxvarW3sYYdrLbhTyU2+UCcPditMX3A3I+JM
	 yiFhDlQG+q1Qk6WoXmLw1eWL1J073EABH0Hub51ZO8vBW2jZaXj9kaoT47mCGhM4a4
	 Ixz9vHR/GOiOA==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	jiri@resnulli.us,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 09/11] tools: ynl-gen: don't generate forward declarations for policies - regen
Date: Wed,  7 Jun 2023 13:24:01 -0700
Message-Id: <20230607202403.1089925-10-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230607202403.1089925-1-kuba@kernel.org>
References: <20230607202403.1089925-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Renegerate code after dropping forward declarations for policies.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/generated/fou-user.c       | 2 --
 tools/net/ynl/generated/handshake-user.c | 4 ----
 tools/net/ynl/generated/netdev-user.c    | 2 --
 3 files changed, 8 deletions(-)

diff --git a/tools/net/ynl/generated/fou-user.c b/tools/net/ynl/generated/fou-user.c
index a0f33bb882e4..c08c85a6b6c4 100644
--- a/tools/net/ynl/generated/fou-user.c
+++ b/tools/net/ynl/generated/fou-user.c
@@ -42,8 +42,6 @@ const char *fou_encap_type_str(int value)
 }
 
 /* Policies */
-extern struct ynl_policy_nest fou_nest;
-
 struct ynl_policy_attr fou_policy[FOU_ATTR_MAX + 1] = {
 	[FOU_ATTR_UNSPEC] = { .name = "unspec", .type = YNL_PT_REJECT, },
 	[FOU_ATTR_PORT] = { .name = "port", .type = YNL_PT_U16, },
diff --git a/tools/net/ynl/generated/handshake-user.c b/tools/net/ynl/generated/handshake-user.c
index fe99c4ef7373..72eb1c52a8fc 100644
--- a/tools/net/ynl/generated/handshake-user.c
+++ b/tools/net/ynl/generated/handshake-user.c
@@ -69,10 +69,6 @@ const char *handshake_auth_str(enum handshake_auth value)
 }
 
 /* Policies */
-extern struct ynl_policy_nest handshake_x509_nest;
-extern struct ynl_policy_nest handshake_accept_nest;
-extern struct ynl_policy_nest handshake_done_nest;
-
 struct ynl_policy_attr handshake_x509_policy[HANDSHAKE_A_X509_MAX + 1] = {
 	[HANDSHAKE_A_X509_CERT] = { .name = "cert", .type = YNL_PT_U32, },
 	[HANDSHAKE_A_X509_PRIVKEY] = { .name = "privkey", .type = YNL_PT_U32, },
diff --git a/tools/net/ynl/generated/netdev-user.c b/tools/net/ynl/generated/netdev-user.c
index aea5c7cc8ead..3db6921b9fab 100644
--- a/tools/net/ynl/generated/netdev-user.c
+++ b/tools/net/ynl/generated/netdev-user.c
@@ -48,8 +48,6 @@ const char *netdev_xdp_act_str(enum netdev_xdp_act value)
 }
 
 /* Policies */
-extern struct ynl_policy_nest netdev_dev_nest;
-
 struct ynl_policy_attr netdev_dev_policy[NETDEV_A_DEV_MAX + 1] = {
 	[NETDEV_A_DEV_IFINDEX] = { .name = "ifindex", .type = YNL_PT_U32, },
 	[NETDEV_A_DEV_PAD] = { .name = "pad", .type = YNL_PT_IGNORE, },
-- 
2.40.1


