Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6724544A399
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 02:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243540AbhKIB1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 20:27:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:50106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244215AbhKIBY7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 20:24:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E04A261B2F;
        Tue,  9 Nov 2021 01:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636420171;
        bh=I6YMP7D0RXYm5hmeBrttZmTmHBoqWCzSufs82EJtph0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=erFMbmJdU1QykTCShwcctnZr+MIeY/QB6xdIcvuwyqGe/bB7Ua35vWmBXJBmKeX06
         Jjkd2AUEFFzdBIfi4WO/nxS5pzCe9DKeFREuAw3+jI6pXguuY5xWRL2+RcVro31Wmo
         5FMu4mCNcPfTZDY9/gzt3fpPrEWLDoG5fL+xJyvW4rcdOGAGblB0sZ2o28j+lqvOTO
         zoOUxV0z9LokyiQQciOFmfvMn6EFKuHDI+etyNByuZk1WRhkT9flJYF6Q4SWnfAKO6
         StHWyOqUiqmk50fpvPvxue3zUxol4FipfPztZu+I9eLi8SQVEXiex97guipQeeXNIJ
         wcF9pr24oWogw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     wangzhitong <wangzhitong@uniontech.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, paul@paul-moore.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 07/30] NET: IPV4: fix error "do not initialise globals to 0"
Date:   Mon,  8 Nov 2021 20:08:55 -0500
Message-Id: <20211109010918.1192063-7-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109010918.1192063-1-sashal@kernel.org>
References: <20211109010918.1192063-1-sashal@kernel.org>
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
index e798e27b3c7d3..15d224cfe7c92 100644
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

