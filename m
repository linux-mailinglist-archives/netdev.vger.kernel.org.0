Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D90B38DB8D
	for <lists+netdev@lfdr.de>; Sun, 23 May 2021 17:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbhEWPLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 11:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231776AbhEWPLA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 May 2021 11:11:00 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4458C061574;
        Sun, 23 May 2021 08:09:31 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id k5so13419411pjj.1;
        Sun, 23 May 2021 08:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Mc7yOhrqVtGGsvyRmdX2MsPwB1LLZVrbl9jBESxilQ0=;
        b=CfJwiQppds25Ljl+i2BlgRJ9Iv7M4b50bCacM4p/aCYP+cxywS3w3MH7W6T1IkZkAK
         /lDgQhaMsJx/64Nk+T7KmQUdrDHkYkn05loST+KkOcmKLqxiXaUy7KNCzCRMF2GFKkEq
         FpJ0AR1Ui6ElHupyFweYu39lIF+LfsobvzAJon1Sr9biqBHh377QlAhATtQmGCf5G+qZ
         nTOFsgZOzfyqOtiOShMLmFDJnViBHRW+R6AYhS/eKMusM7HPnT56IKv86ap1KwfJ35M8
         DYHpf7zPh1ghFjr0QeVsJjifkGT7Nd7JDBVCTOj2gs7Ag1oVH9tyFXb46eMsSLN70qGa
         AY0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Mc7yOhrqVtGGsvyRmdX2MsPwB1LLZVrbl9jBESxilQ0=;
        b=FCodAgdN/WN3xxX5arShZCW/Q9yQBjLWdABw1DtgQmQqCM41ViTEQPbmxRtV3KtFu/
         HFXrXsVzm3gsvMn5g+o8LRWgkR00I3URDQ2475niZIuo9hRjaPh3WAd0gpkNFV7NUpXC
         7oB4QSdyd2ly9rV7RB5rxsUpFjL+dvu5AMWuNyizqDFc2scObUEOhRf4XDzq5nmxu/cy
         SI1bzjDKGZLza6nwkth1tKzigNRnKEndJ9jLuDDKZIL2/ib2nP9KSuA5a3N+LUbIjHe8
         mIJCUE6EZfG2Hwhjbf5fP2Fonc0e9LJOjbzQycZwwXyEvrt1iwawiio9mpMu0BYxFJ6V
         jRyw==
X-Gm-Message-State: AOAM533WUtjg5EasIB2o851NUUqXMNVXSQxnZX/5dVWMp7Lb159U4Qu+
        uxxVbXHjWqlDZ/tNVF1xScseWgXFga5ws6ju
X-Google-Smtp-Source: ABdhPJzZimt3u5Tj6ZV1xI7hQaedlcZpkQ7FtdkSvjwe8Jf+vozgbKLkQpIafNKt037IFMgKbcpIVw==
X-Received: by 2002:a17:90a:4493:: with SMTP id t19mr20118821pjg.217.1621782571290;
        Sun, 23 May 2021 08:09:31 -0700 (PDT)
Received: from localhost.localdomain ([2405:201:600d:a93f:c492:941f:bc2a:cc89])
        by smtp.googlemail.com with ESMTPSA id ch24sm13191072pjb.18.2021.05.23.08.09.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 08:09:30 -0700 (PDT)
From:   Aditya Srivastava <yashsri421@gmail.com>
To:     kafai@fb.com
Cc:     yashsri421@gmail.com, lukas.bulwahn@gmail.com,
        rdunlap@infradead.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-doc@vger.kernel.org, dledford@redhat.com, jgg@ziepe.ca,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH] samples: bpf: ix kernel-doc syntax in file header
Date:   Sun, 23 May 2021 20:39:17 +0530
Message-Id: <20210523150917.21748-1-yashsri421@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The opening comment mark '/**' is used for highlighting the beginning of
kernel-doc comments.
The header for samples/bpf/ibumad_kern.c follows this syntax, but
the content inside does not comply with kernel-doc.

This line was probably not meant for kernel-doc parsing, but is parsed
due to the presence of kernel-doc like comment syntax(i.e, '/**'), which
causes unexpected warnings from kernel-doc:
warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * ibumad BPF sample kernel side

Provide a simple fix by replacing this occurrence with general comment
format, i.e. '/*', to prevent kernel-doc from parsing it.

Signed-off-by: Aditya Srivastava <yashsri421@gmail.com>
---
 samples/bpf/ibumad_kern.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/ibumad_kern.c b/samples/bpf/ibumad_kern.c
index 26dcd4dde946..9b193231024a 100644
--- a/samples/bpf/ibumad_kern.c
+++ b/samples/bpf/ibumad_kern.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 
-/**
+/*
  * ibumad BPF sample kernel side
  *
  * This program is free software; you can redistribute it and/or
-- 
2.17.1

