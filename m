Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8430644A203
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 02:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243415AbhKIBQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 20:16:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:38994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242322AbhKIBLR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 20:11:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB35A61A7B;
        Tue,  9 Nov 2021 01:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419892;
        bh=DX02jyg4DsADM/EKI/jHX7X92KcF/Yvbz8NFBiO38D4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nPO5WVjTr4r1DWEgTVGhr2FsC9ccFYYm8CO3Thwms+GjHgYOcHR3djmACVt112y5Y
         S1ol28bu6OfBjQ2AS81Gsu5dmPauDswFVNX/O5DqzHkv6nTfdIMZBxqf39epophV3n
         KSbDgXfRYkiPa2+NUEw0zP2t+EuG4gL/fdSfKxuaRzySC2TYO6wZkSAMidGvjwtxD2
         EAGX4r+ShnS1ExImQgL4qmxpRjbk1Hu6YOSJ+hjgrFwBivLAP2SxNG1IqsrJV7//6G
         DLu/8J7Jn9rnpZSdchda4W+a7rlceXXXwI9Jvm57Bq0A/ts3E6z4rVFTGdCTnyWB2m
         mwgOCZFE5eMZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     wangzhitong <wangzhitong@uniontech.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, paul@paul-moore.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 14/74] NET: IPV4: fix error "do not initialise globals to 0"
Date:   Mon,  8 Nov 2021 12:48:41 -0500
Message-Id: <20211108174942.1189927-14-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174942.1189927-1-sashal@kernel.org>
References: <20211108174942.1189927-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wangzhitong <wangzhitong@uniontech.com>

[ Upstream commit db9c8e2b1e246fc2dc20828932949437793146cc ]

this patch fixes below Errors reported by checkpatch
    ERROR: do not initialise globals to 0
    +int cipso_v4_rbm_optfmt = 0;

Signed-off-by: wangzhitong <wangzhitong@uniontech.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/cipso_ipv4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index c1ac802d6894a..7153730f7bae6 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -73,7 +73,7 @@ struct cipso_v4_map_cache_entry {
 static struct cipso_v4_map_cache_bkt *cipso_v4_cache;
 
 /* Restricted bitmap (tag #1) flags */
-int cipso_v4_rbm_optfmt = 0;
+int cipso_v4_rbm_optfmt;
 int cipso_v4_rbm_strictvalid = 1;
 
 /*
-- 
2.33.0

