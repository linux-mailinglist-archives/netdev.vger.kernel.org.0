Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E662F42C4
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 05:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbhAMEC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 23:02:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:48688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726484AbhAMECT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 23:02:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CB1D23159;
        Wed, 13 Jan 2021 04:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610510464;
        bh=V8i/eXjKFrKNDUoXFj2B9366dqtdg3B47o0eKKdiNys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EjB4Svjnz1n4cIS3Bt1HDmUteX2BlrMpGBVu2CotFhhBy/RRD/NUgRMuZzYITuMwy
         p6nqWK5eaFwF6uTSY+OGnFLoqQeR96/AOYvhrjS3np5Snx8WQt9pRgoHQ0CVVu9gdE
         +tYW+D3mAajYzYhHt2Cl1JX6nyf4g6Yyvd8yw4bWLNq3UWEU3u6FsXJnUoWHXGtsTG
         dkmkykmZqaiXPb1hC5MM96pkjc816xBIVkwx9CUHRAzyJHu2igxi/nlpjVzibPvKkn
         AAYJ5sp0bni6dG8kzrgAewFLcu7ve/25nOqLdzd7KRU7hw5gYUGDluL+HY03rFfbqp
         kqy+e3962ICug==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, schoen@loyalty.org,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH net-next v3 12/13] selftests: Remove exraneous newline in nettest
Date:   Tue, 12 Jan 2021 21:00:39 -0700
Message-Id: <20210113040040.50813-13-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20210113040040.50813-1-dsahern@kernel.org>
References: <20210113040040.50813-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: David Ahern <dsahern@kernel.org>
---
 tools/testing/selftests/net/nettest.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
index 8865cc00e93a..3568ec80785b 100644
--- a/tools/testing/selftests/net/nettest.c
+++ b/tools/testing/selftests/net/nettest.c
@@ -1462,7 +1462,6 @@ static int do_server(struct sock_args *args, int ipc_fd)
 
 	ipc_write(ipc_fd, 1);
 	while (1) {
-		log_msg("\n");
 		log_msg("waiting for client connection.\n");
 		FD_ZERO(&rfds);
 		FD_SET(lsd, &rfds);
-- 
2.24.3 (Apple Git-128)

