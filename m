Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16F1D33A7D8
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 21:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234300AbhCNUTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 16:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234105AbhCNUSj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 16:18:39 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 508CAC061574;
        Sun, 14 Mar 2021 13:18:39 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id 16so5314709pfn.5;
        Sun, 14 Mar 2021 13:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=c7ceTWseizLIsxRZ7DEFlP8MrTkw1YZqdjYDfUZGU5Q=;
        b=bQ5AMnMDmsZpyhK7cilSiPqF6WhCEstiH7Ovzw8lwaXvUU6cZhEvHEa6PsDKCdkZXe
         znxScJ52/p7Wc/Y7JtDtbjvBTlIi6UI8uBkk0MpdzRtqu3h8gg9F0w0rb6YtNeTuCE9l
         +To7j3/QQxfdxKGZYEC+1MpOUn2MIttzls954pgAVQAWFKWi52BEzH5G8hOQZ+DO8WJp
         hGq9GmW1dmycg6LBos7D28hmhovg6yM3GnBORyY6ko8QlLfwo9Alcrz7kKZcUYkfDVSg
         JyiEAKQeKNxLtps/aBwzeXrwiDe4bLppOfFuGveWN9i5XGwDVpDP8sp8m8UHkuNudkoT
         mcww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=c7ceTWseizLIsxRZ7DEFlP8MrTkw1YZqdjYDfUZGU5Q=;
        b=huxJKywD4YSZ/+OuYYAR6USZcQyEqw7MhwhC70HBFozMzcDw8j6P8LPsPlAkcuLCLI
         qc7STRYjXpIR4elV3xb5XSn6WQPSDIs25qB8JaCTPY2bhOC8JQJObnTl4k0X/F/NJXRq
         ZbLgt71QFhYV5xwsSkO0NNtkm/DqpLJ/64So9TFTzhKyfwfxgLMywSwbGyMlNL3YN2I5
         54I+vAa5ohp6mz4aDQf9q6nNiJWI5sMCg4rw50mg2tBbeOF5d8KaPzpquvsBeWnfK8y7
         BLqhMqzD1H4U/O9K1rMBGrEwdBIEr+haHfJ8BK28+b57Abn9LNkPgCdZd3Sp6GP5+nNI
         rPZQ==
X-Gm-Message-State: AOAM531dSFB7o4kvFwXfImOneYvqKCs15KsiDtHQU82pdNtlhfbyC0M5
        w3niZzs6j/4gvZ/QTp2HHck=
X-Google-Smtp-Source: ABdhPJzMWHIAOa+F3sw3VzNeU4j4nXVEZ2Xwro4q8rzyMBesO0c/OFNDcAVps3rMPBLIlcgRRGfdiw==
X-Received: by 2002:a05:6a00:1749:b029:1fb:de26:a8e9 with SMTP id j9-20020a056a001749b02901fbde26a8e9mr7426034pfc.26.1615753118809;
        Sun, 14 Mar 2021 13:18:38 -0700 (PDT)
Received: from localhost.localdomain ([2405:201:600d:a089:acdc:a5a5:c438:c1e3])
        by smtp.googlemail.com with ESMTPSA id n10sm10943793pgk.91.2021.03.14.13.18.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 13:18:38 -0700 (PDT)
From:   Aditya Srivastava <yashsri421@gmail.com>
To:     siva8118@gmail.com
Cc:     yashsri421@gmail.com, lukas.bulwahn@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        amitkarwar@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 02/10] rsi: rsi_coex: fix file header comment syntax
Date:   Mon, 15 Mar 2021 01:48:10 +0530
Message-Id: <20210314201818.27380-3-yashsri421@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210314201818.27380-1-yashsri421@gmail.com>
References: <20210314201818.27380-1-yashsri421@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The opening comment mark '/**' is used for highlighting the beginning of
kernel-doc comments.

The header comment used in drivers/net/wireless/rsi/rsi_coex.h
follows kernel-doc syntax, i.e. starts with '/**'. But the content
inside the comment does not comply with kernel-doc specifications (i.e.,
function, struct, etc).

This causes unwelcomed warning from kernel-doc:
"warning: wrong kernel-doc identifier on line:
 * Copyright (c) 2018 Redpine Signals Inc."

Replace this comment syntax with general comment format, i.e. '/*' to
prevent kernel-doc from parsing it.

Signed-off-by: Aditya Srivastava <yashsri421@gmail.com>
---
 drivers/net/wireless/rsi/rsi_coex.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_coex.h b/drivers/net/wireless/rsi/rsi_coex.h
index 0fdc67f37a56..2c14e4c651b9 100644
--- a/drivers/net/wireless/rsi/rsi_coex.h
+++ b/drivers/net/wireless/rsi/rsi_coex.h
@@ -1,4 +1,4 @@
-/**
+/*
  * Copyright (c) 2018 Redpine Signals Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
-- 
2.17.1

