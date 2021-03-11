Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95A493372A0
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 13:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233178AbhCKMbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 07:31:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233166AbhCKMbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 07:31:17 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D61D2C061574;
        Thu, 11 Mar 2021 04:31:16 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id a188so14411148pfb.4;
        Thu, 11 Mar 2021 04:31:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NSzzai4vIMGBBt9pjkbuuhFEouWU7xEJcqdEzYQD0Go=;
        b=Ei6zZRzVQLJsCoGDNlX4Tujcqz1+s3ayFCqj9VLBlqHXZ5zrPIU8+e4FQf2ZtUwGe8
         EeJDVwjjCwD03wzJIh4sm03OGb/RDnbcDLlhXO4reEvJttx5nz13sNxUCFDp+ESDJPhK
         TDPtxJTDGI2x/+UOsChd3XyaZW8tz4ZgOqytIu765nu4Lozt2ImWEP4sKMrWRexUbahE
         hIDeiF9+ktDCFbG/3rGJhXz1HTEbdmvR3sFhIvfJiJRtFFQR140mrcQCKAhMUK84viva
         tDMb79DoUq6GT61kGTBxu6zg36vO4r5BsLwLirL7Xls+dDX2iP6FwyvuetyCOO2a2w8J
         ED4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NSzzai4vIMGBBt9pjkbuuhFEouWU7xEJcqdEzYQD0Go=;
        b=eBqPItWoevmIOjjWGqk8eVudN0p2Ns34XSgKUSYVCS/zvFDUhluUxh2mV90T+pjiTt
         kpIi5ZIB5zDir9UNpJxXP6ZKHNGDA1DUX+Kx6La5+BttY4uce6ZbNzVrv3gmDAFxNczd
         7Q++usHpbauUPtgjc9fo4lKQqB/Gr82AyZm1DMYkSv0NGNqWpE68GvZgGBy49P2uHgug
         gdqdARhxyhHXL5oUf/tKx+jMQsuG58Ge5gwBw5ZjGU6LdpfqwDmoxY6ZWDUCp9yOxIgX
         2444WF8etO2Iwa5CXzjQ4Yl9T5vE76+qFXXeAeJVMZNnZ5uxMXMFIVEERBqvAqkj3WpL
         9bAw==
X-Gm-Message-State: AOAM5328HPNX+dKQWV51iCR8INBpUln+WV1YZT4imht/JpHEnyvfjOrR
        0SjAXsQ9KKSxBNpaDIZpAvc=
X-Google-Smtp-Source: ABdhPJzp7QrZxigNzO6cPOzvY3azF3YeWNAjNXTc8FUGi04Dc1tN5/b7vZvYOTJAtrtHERpE68bliQ==
X-Received: by 2002:a63:1502:: with SMTP id v2mr7007804pgl.22.1615465876433;
        Thu, 11 Mar 2021 04:31:16 -0800 (PST)
Received: from localhost.localdomain ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id s28sm2473608pfd.155.2021.03.11.04.31.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 04:31:15 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: liu.xuzhi@zte.com.cn
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liu xuzhi <liu.xuzhi@zte.com.cn>
Subject: [PATCH] kernel/bpf/: fix misspellings using codespell tool
Date:   Thu, 11 Mar 2021 04:31:03 -0800
Message-Id: <20210311123103.323589-1-liu.xuzhi@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Liu xuzhi <liu.xuzhi@zte.com.cn>

A typo is found out by codespell tool in 34th lines of hashtab.c:

$ codespell ./kernel/bpf/
./hashtab.c:34 : differrent ==> different

Fix a typo found by codespell.

Signed-off-by: Liu xuzhi <liu.xuzhi@zte.com.cn>
---
 kernel/bpf/hashtab.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index d63912e73ad9..46f076c0b3a2 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -31,7 +31,7 @@
 /*
  * The bucket lock has two protection scopes:
  *
- * 1) Serializing concurrent operations from BPF programs on differrent
+ * 1) Serializing concurrent operations from BPF programs on different
  *    CPUs
  *
  * 2) Serializing concurrent operations from BPF programs and sys_bpf()
-- 
2.25.1

