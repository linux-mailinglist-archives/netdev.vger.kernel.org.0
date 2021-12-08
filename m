Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE3446CE3E
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 08:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244483AbhLHHYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 02:24:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236023AbhLHHYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 02:24:07 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DE67C061574;
        Tue,  7 Dec 2021 23:20:36 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id y13so5036272edd.13;
        Tue, 07 Dec 2021 23:20:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OBpAD7jEKe2G1MwcYvVjyMRGls4uJp0G38l20vYCwQM=;
        b=jHNy8ht5kF9gCRcKBtKsIxfTb+5iUV5iKKUIhfEVuUyylOFHOTkfClS6zLm4dve3qn
         QkvOo0XrEx4GWI8hqHja9ruRmvxpf/QdzfgNs4LMpCAPUDOdnZy4NHKMLIerLYtSlgzf
         yNQ3dMmBy87ynqJOTYZWeqbTrGL7hSiRLYR+hqZRr0+u/WT+ZorEp4bq/DjLT0BLCoym
         M7wcct3LvGsKcbiWcq9dzBPv88t2AEgLrzkbqXN6U9EtuuUdLdGGmqxHD19hrZHwgRx1
         kYey89TxHwoGL59SeGLgCYDE6mnbtfbjFJUwJsU/wigKNIPa7hmvUh7v/7yRac/xp87j
         bgbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OBpAD7jEKe2G1MwcYvVjyMRGls4uJp0G38l20vYCwQM=;
        b=dhaCq9BlIjQfldCXedupIxdUJuVaanpbBi5oDjxeY4XmiU7E0rmDp33pyb1zDs92eL
         EioAoQhPCmSN2ckhSXLPUGsgJt2hpuJWPwmF4oUTdza5Oc77/MfVtjdk8QtdhlFPo9zc
         BdQIBf/ZAQSiv24oJyPtsdAMl04ZtZ9hSdWivui7kHdZvm6Bj7l7wYjw7/0WjSVS1RNg
         sxuZ6GRjcgyGbR2HUZcajlnwpjj6G/9Ex1ruvdNouz01Ymue1Rrm9ML7WUO8pYDQd5o3
         fDEo+lvPGON6hPvSniCzlXHVQIkKxSG4rCPdA+um7FCF/+KJTzF5N8MlOjPrrkZCs+CW
         N7WA==
X-Gm-Message-State: AOAM531j90ASrzBenNhim1xEmAD1LR3tXf8/8kglr6uMy3ga7rZ7Tj3E
        TDG9Qn/xVeIeDRxDWPwOoF4=
X-Google-Smtp-Source: ABdhPJxE2CzsVTyETJoEw9wE4Xxk+c3JantvsBlgR3t3ak9VleOm98XWgOLVci7maV45EzUfaCqDgQ==
X-Received: by 2002:a05:6402:3551:: with SMTP id f17mr16341832edd.129.1638948034949;
        Tue, 07 Dec 2021 23:20:34 -0800 (PST)
Received: from localhost ([81.17.18.62])
        by smtp.gmail.com with ESMTPSA id he14sm969306ejc.55.2021.12.07.23.20.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 23:20:34 -0800 (PST)
From:   =?UTF-8?q?J=CE=B5an=20Sacren?= <sakiwit@gmail.com>
To:     bfields@fieldses.org, chuck.lever@oracle.com,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        davem@davemloft.net, kuba@kernel.org, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next] net: sunrpc: fix code indentation
Date:   Wed,  8 Dec 2021 00:20:22 -0700
Message-Id: <20211208024732.142541-2-sakiwit@gmail.com>
X-Mailer: git-send-email 2.32.0
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jean Sacren <sakiwit@gmail.com>

Remove the extra space to the left of if branch.

Signed-off-by: Jean Sacren <sakiwit@gmail.com>
---
 net/sunrpc/xprtsock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index d8ee06a9650a..69b6ee5a5fd1 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1910,7 +1910,7 @@ static void xs_local_connect(struct rpc_xprt *xprt, struct rpc_task *task)
 	struct sock_xprt *transport = container_of(xprt, struct sock_xprt, xprt);
 	int ret;
 
-	 if (RPC_IS_ASYNC(task)) {
+	if (RPC_IS_ASYNC(task)) {
 		/*
 		 * We want the AF_LOCAL connect to be resolved in the
 		 * filesystem namespace of the process making the rpc
