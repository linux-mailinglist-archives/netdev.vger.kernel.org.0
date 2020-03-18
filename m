Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCC018A583
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 22:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbgCRVBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 17:01:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:57024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728543AbgCRU4L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 16:56:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 426B120BED;
        Wed, 18 Mar 2020 20:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564971;
        bh=q53szQKyl2fCyHnPBNvsoMFrVxZZozVrflRQuaD3teU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qtXTqtXLRAG69kdbN9dYyJ9D1Ojo9XwpS5NH2A7AJnClsa5l8RG/BkYPf1tvhwCLd
         hceGSJNnBp4zZIoBUkK+c5zMiqeFbWJ4lM61eA5trN24itrQDjq+NRUnsLlC84ufUM
         LiPPXTVw41j7osISow+7kQ+C9xBNb0UKq5QD3FHQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 13/28] netfilter: cthelper: add missing attribute validation for cthelper
Date:   Wed, 18 Mar 2020 16:55:40 -0400
Message-Id: <20200318205555.17447-13-sashal@kernel.org>
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

[ Upstream commit c049b3450072b8e3998053490e025839fecfef31 ]

Add missing attribute validation for cthelper
to the netlink policy.

Fixes: 12f7a505331e ("netfilter: add user-space connection tracking helper infrastructure")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink_cthelper.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index d33ce6d5ebce9..dd1030f5dd5e2 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -733,6 +733,8 @@ static const struct nla_policy nfnl_cthelper_policy[NFCTH_MAX+1] = {
 	[NFCTH_NAME] = { .type = NLA_NUL_STRING,
 			 .len = NF_CT_HELPER_NAME_LEN-1 },
 	[NFCTH_QUEUE_NUM] = { .type = NLA_U32, },
+	[NFCTH_PRIV_DATA_LEN] = { .type = NLA_U32, },
+	[NFCTH_STATUS] = { .type = NLA_U32, },
 };
 
 static const struct nfnl_callback nfnl_cthelper_cb[NFNL_MSG_CTHELPER_MAX] = {
-- 
2.20.1

