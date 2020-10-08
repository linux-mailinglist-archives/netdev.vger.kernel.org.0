Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 882B3287963
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731139AbgJHP7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729939AbgJHP4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:56:02 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A674C0613D2;
        Thu,  8 Oct 2020 08:56:02 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id c6so2962059plr.9;
        Thu, 08 Oct 2020 08:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7Q32D5CWrjwlnU0wFJzUstmYpsSOyuhF8U8ZNzuPadE=;
        b=h7pyCSiTlX8XM1WRQJ9/R2+ZZZnGwZIiuqK3yUyp7OgBNmW6vW1h21GTIlEVsf6ieY
         VRGKVK4E3EXU0BE34y5VaAA5IBY4LIikXg4qVWkGwd/8bSq9a+V14PeYPmltSPEXzOfE
         Ezis5ElkTrG0bX1PmViYVq9Kok37d2FphmId3lmdhIiA6Qg8pcYtupwNH6k7i3jgqrG2
         Dbmc5zI++f9royums9F9f5v7P6TrIhJUZWqepOZa9L5v9rp/QhewDt3zZNfwmb5N4quU
         f2/k6hVUEwtEdeFhUVRhFaF2ptxSEyMiEv5H+QX16HDixtRlqrgYJrfgQoEvF69uHslX
         LeUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7Q32D5CWrjwlnU0wFJzUstmYpsSOyuhF8U8ZNzuPadE=;
        b=P9kCpdKCzLmjWzLxl9NHFWQsc4l6B7jSDrgAaetBkCs1RIJml0oPWTu0fLNvrTntQS
         gvBq2wksgGEGgzYMlCSNMQAB+md+HZEW9b7EvSft+VBaP97SN1Kt1yDoR6R1SdvbmuLl
         oEGeZ6k3adxY2blkODsXpytB+Tot27kBCWO4kGYR/O1dkz9h/NeqrVhggVUINa9cSTS/
         WkT9GgFF4HloHqd6YtGsxfEcpwxuDXeiXF8BVyQaYCUh9YnZb7EAQmYYLapDTd4HKkvZ
         6xGkJuKtvcrGN9wM2vvWrKpL65qeMkZrg49K8M6w2NfohuXnKlCJ5uobvMvVdU8Etvsj
         Y0EA==
X-Gm-Message-State: AOAM532A8CQrYiXpo4pTcEVjl275j7Co6hmn8/DgJXyUFHKVtrmKYxRi
        joAjaS00kvRgSJK8R8XBlao=
X-Google-Smtp-Source: ABdhPJwOIkjWdNRLnU/2bKUSHy1DURHSTQ1Lf2WEKTxeRb3DOyv25ADtQciN8r8fxGGYFltxyFhPTw==
X-Received: by 2002:a17:902:d88e:b029:d0:89f4:6222 with SMTP id b14-20020a170902d88eb02900d089f46222mr8442136plz.10.1602172562022;
        Thu, 08 Oct 2020 08:56:02 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.55.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:56:01 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 071/117] ath10k: set fops_enable_extd_tx_stats.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:23 +0000
Message-Id: <20201008155209.18025-71-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 348cd95c8196 ("ath10k: add debugfs entry to enable extended tx stats")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/ath/ath10k/debug.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index d1f8cf0d5604..8829232e2b34 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -2097,7 +2097,8 @@ static ssize_t ath10k_read_enable_extd_tx_stats(struct file *file,
 static const struct file_operations fops_enable_extd_tx_stats = {
 	.read = ath10k_read_enable_extd_tx_stats,
 	.write = ath10k_write_enable_extd_tx_stats,
-	.open = simple_open
+	.open = simple_open,
+	.owner = THIS_MODULE,
 };
 
 static ssize_t ath10k_write_peer_stats(struct file *file,
-- 
2.17.1

