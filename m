Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEDFA44A20E
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 02:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241516AbhKIBQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 20:16:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:39304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242476AbhKIBN3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 20:13:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2EA361AA7;
        Tue,  9 Nov 2021 01:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419934;
        bh=ULKQ63rfbo3UsSQPS/WJaTvKPIUI/gelpcCUQyW5j8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kKf1CcAnhnOaj2xeD0LVGgj+K6jLKii32kuxSS4F3RHFvURke9kfcEnFNNC8ii3sS
         WTME8SyOD1s8RES04zRkhSGUFjNddqUR/C1DmhIWBQkhF2jsYVwKOqYOWhNINiXhLK
         qYJwwLqyGrjuhUI4N6bx1e9D9FYFn+Uy1RqbX2GeU+0nKgg4ZSEM3RWbMavo8w2d4T
         1H+JcjfyWbOLMLBhpix86fAf0roRErG1OHfPmhkz4QTaa97sCEi3WDN6Kecpkaf8ad
         HPf/ts9e1571kOuNvHU4V7uU41ULd+LMi/r8ZZtuJdXVM7xJ5PselhmWE3tVjq+QzH
         u56zgWoeY8biQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     wangzhitong <wangzhitong@uniontech.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, paul@paul-moore.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 10/47] NET: IPV4: fix error "do not initialise globals to 0"
Date:   Mon,  8 Nov 2021 12:49:54 -0500
Message-Id: <20211108175031.1190422-10-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108175031.1190422-1-sashal@kernel.org>
References: <20211108175031.1190422-1-sashal@kernel.org>
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
index e8b8dd1cb1576..75908722de47a 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -87,7 +87,7 @@ struct cipso_v4_map_cache_entry {
 static struct cipso_v4_map_cache_bkt *cipso_v4_cache;
 
 /* Restricted bitmap (tag #1) flags */
-int cipso_v4_rbm_optfmt = 0;
+int cipso_v4_rbm_optfmt;
 int cipso_v4_rbm_strictvalid = 1;
 
 /*
-- 
2.33.0

