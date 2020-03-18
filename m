Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80AE918A5C5
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 22:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbgCRUzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 16:55:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:55788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728295AbgCRUzZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 16:55:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D835C216FD;
        Wed, 18 Mar 2020 20:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564924;
        bh=rGYPdi6emtE0fvx4uq4xHL8NUN4WHMxIqrLJuxPmA1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uBMNg7Y3DxqwV/QZzQtccYS8N0fbeQfdVI9Oo5J85GDUEYGAWhoS3eYWCStnSz9Dv
         /JOGkcYNEiTBDT4qHLTvI6ty6Jmgz8giVgOm8NYEXSYd3kwLNsO+R/Q0Oed3Hm8l3T
         HBczSe3fQY8nLih7VwwmjS/gWn5fWFdWy4KjRyFM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 12/37] macsec: add missing attribute validation for port
Date:   Wed, 18 Mar 2020 16:54:44 -0400
Message-Id: <20200318205509.17053-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205509.17053-1-sashal@kernel.org>
References: <20200318205509.17053-1-sashal@kernel.org>
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
index 10a8ef2d025a1..f7a6a82c9a551 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -2989,6 +2989,7 @@ static const struct device_type macsec_type = {
 
 static const struct nla_policy macsec_rtnl_policy[IFLA_MACSEC_MAX + 1] = {
 	[IFLA_MACSEC_SCI] = { .type = NLA_U64 },
+	[IFLA_MACSEC_PORT] = { .type = NLA_U16 },
 	[IFLA_MACSEC_ICV_LEN] = { .type = NLA_U8 },
 	[IFLA_MACSEC_CIPHER_SUITE] = { .type = NLA_U64 },
 	[IFLA_MACSEC_WINDOW] = { .type = NLA_U32 },
-- 
2.20.1

