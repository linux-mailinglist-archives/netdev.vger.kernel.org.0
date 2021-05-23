Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA9238DB96
	for <lists+netdev@lfdr.de>; Sun, 23 May 2021 17:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbhEWPPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 11:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231776AbhEWPPv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 May 2021 11:15:51 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB503C061574;
        Sun, 23 May 2021 08:14:23 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id p39so2408589pfw.8;
        Sun, 23 May 2021 08:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DYAJsKGaNMXlZ5z7Y202JilMErjhQXaG67fAc2NRRFU=;
        b=qtR5tZ4xaAqfTOMolkHMLZoO2fh7YAnIoQIzMxo6UjgYqxugMF70cfTiTARj0xoHlq
         5/vxi7JPoEHBBJpDH5Knx56c+wwpe0KpRgf8TAThPUxE+h21/gWNq4ob2p0+ywWnu2O8
         30qkkFRGcWmB1jVBpC/UlKcSoNOvJbBHWNWS6ldXDSjujElT6a7gOHzpAlvjeLrDfLKz
         sIBdlLJSIx2GeH4lvN22wtOhr6i9fPQZCLRR10YP215yfQy+bsaDsMaf3okCZT57URsH
         dHvXXFNJcKsgDzQ/9kq66FSCt7tvLIiRg0XOp66gH6MgBilkCmYfxng2ht8JK9osXpab
         gbsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DYAJsKGaNMXlZ5z7Y202JilMErjhQXaG67fAc2NRRFU=;
        b=RQvKpspM/Kt6l8PCCu/ffSsxlc6M5gD0ID1xEWwIrP4X0lN/yN/cIP7codUeuQaxjs
         V34MIAjOZqfxbsNHA9cswhPYjSsLSLKNNW/3JAS56g5St1vcziXh7aa3ODG/fvGeAl3U
         zpVU8hnEtLgG3cYsV4IM6E240WmuUYEy/RUKD9wYQ/qaip9U2z428nfvMM2tPOcNa/+7
         nWeIM2MXtLzvmuKhTVsmlYsOcn8AtyIU3q+nv28WTn1ZL6ZDUzZT32poYf/qRM+9u3Is
         je2kFXHrQZ8hEGWyqxOiWD1NH3ll2toJnPc3WQjbXu2D+1eiwJoVV3mfY7ErN2lEOUUB
         YCsA==
X-Gm-Message-State: AOAM532TPq/U+wj+H/6jYxCN+kpB2NjMUncJd5sjmYEsladwwX+nkI2T
        92LU+9x6iBIbPMwTqoF0e0s=
X-Google-Smtp-Source: ABdhPJxgYdsRVQ+3NZpShC24UhLHetz6ER6YC9eSr/QfIL4pfvSraMInmsI+F/aTBbSLDuJHLoqqoA==
X-Received: by 2002:aa7:8d4a:0:b029:2e8:df53:cbd6 with SMTP id s10-20020aa78d4a0000b02902e8df53cbd6mr1537572pfe.13.1621782863096;
        Sun, 23 May 2021 08:14:23 -0700 (PDT)
Received: from localhost.localdomain ([2405:201:600d:a93f:c492:941f:bc2a:cc89])
        by smtp.googlemail.com with ESMTPSA id c1sm5050383pfo.181.2021.05.23.08.14.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 08:14:22 -0700 (PDT)
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
Subject: [PATCH v2] samples: bpf: ix kernel-doc syntax in file header
Date:   Sun, 23 May 2021 20:44:08 +0530
Message-Id: <20210523151408.22280-1-yashsri421@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210523150917.21748-1-yashsri421@gmail.com>
References: <20210523150917.21748-1-yashsri421@gmail.com>
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
Changes in v2: Include changes for both, samples/bpf/ibumad_kern.c and samples/bpf/ibumad_user.c in the same patch

 samples/bpf/ibumad_kern.c | 2 +-
 samples/bpf/ibumad_user.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

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
diff --git a/samples/bpf/ibumad_user.c b/samples/bpf/ibumad_user.c
index d83d8102f489..0746ca516097 100644
--- a/samples/bpf/ibumad_user.c
+++ b/samples/bpf/ibumad_user.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 
-/**
+/*
  * ibumad BPF sample user side
  *
  * This program is free software; you can redistribute it and/or
-- 
2.17.1

