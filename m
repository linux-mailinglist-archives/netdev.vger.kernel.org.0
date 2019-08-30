Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9F6BA2BBA
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 02:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727715AbfH3Aut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 20:50:49 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:40680 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727486AbfH3Auq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 20:50:46 -0400
Received: by mail-lj1-f195.google.com with SMTP id e27so4793814ljb.7
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 17:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LKaVdiULHZHeM3qmwqXGbS3W/6JSevNYH66TL2VqMJs=;
        b=FCvja2RR0Kl7bYsDQOOUQUjMRFvKXGR7eNe2NgdFDmbxw/n8dJHTjUoGSI+mau6Y+4
         Nur0MR6ogMXxJ5zfyi7m9Wy9jxTs0li83IAoNnO3od01GnS9Hqlng6pvxCjHf6xEnMyr
         augAVWdm8PjLCzmGgLHygy3NIRgFB7JySVZRBQN0s3ZKjzbUAEdFIJqIzM5lHjreRvGG
         snI7tdFTUKcqaa8IwauSlZkbGJE8QEkzS8ZNg5oOiKBIMrKDtwadtIdeZ6JwNYKeJIn3
         tKv1ox5CdWMtkIaJu0sJl+tRU4qXmxLrhXLswctpqbwRgon6CnOE9jLR+4q5IXCY6JhA
         KYLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LKaVdiULHZHeM3qmwqXGbS3W/6JSevNYH66TL2VqMJs=;
        b=dqrKHqr/6mlnL75y1zFoVvpQEL/UDazVaFFq1EJk0V5WyfI+OveYRV0lAn18DLi1bA
         scRxh4ukuAOoDYGUkchDrLl5tBU6W1DUTG+9y88EdqOm7lRqjOS53FD/BMnS8q1j+V7M
         aS/k5l5y3QaiHB/SgONK3iBJ7C2EpMP9UrNs5Zf9CH/ydmZf+IdNJMnNchmp8GXA/MEs
         NFaNqJP9Oyq4cb0XUqki+OfED4mioAjpEyONyUb1FCSPe0lmb6nqZCmoKOGg7KiGpDzC
         z4jZsNlUfl9a2k9QIJSho9I12YPiFmQo8n7oMX6GmqR8sH2WbMttL4RIJFj0+WnqVKvQ
         g4VA==
X-Gm-Message-State: APjAAAW5lJUaeDGTize8XvIYc/pgUiuoLZGj2ouzSemVDjuLeyfft2Rf
        HxQYYZ3RNx8exYIHUzoN9DTtuQ==
X-Google-Smtp-Source: APXvYqwr9VPhPuNlVvj3eJbScYt62A3rntuEmrXbOlRiE2Zq78tGV5NynWDZnJoUv/97mud2fxSftg==
X-Received: by 2002:a2e:970e:: with SMTP id r14mr6839936lji.204.1567126244471;
        Thu, 29 Aug 2019 17:50:44 -0700 (PDT)
Received: from localhost.localdomain (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id f19sm628149lfk.43.2019.08.29.17.50.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 17:50:43 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     linux@armlinux.org.uk, ast@kernel.org, daniel@iogearbox.net,
        yhs@fb.com, davem@davemloft.net, jakub.kicinski@netronome.com,
        hawk@kernel.org, john.fastabend@gmail.com
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH RFC bpf-next 02/10] samples: bpf: Makefile: remove target for native build
Date:   Fri, 30 Aug 2019 03:50:29 +0300
Message-Id: <20190830005037.24004-3-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190830005037.24004-1-ivan.khoronzhuk@linaro.org>
References: <20190830005037.24004-1-ivan.khoronzhuk@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No need to set --target for native build, at least for arm, the
default target will be used anyway. In case of arm, for at least
clang 5 - 10 it causes error like:

clang: warning: unknown platform, assuming -mfloat-abi=soft
LLVM ERROR: Unsupported calling convention
make[2]: *** [/home/root/snapshot/samples/bpf/Makefile:299:
/home/root/snapshot/samples/bpf/sockex1_kern.o] Error 1

To make the platform to be known, only set to real triple helps:
--target=arm-linux-gnueabihf
or just drop the target key to use default one. Decision to just drop
it and thus default target will be used, looks better.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 samples/bpf/Makefile | 2 --
 1 file changed, 2 deletions(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 61b7394b811e..a2953357927e 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -197,8 +197,6 @@ BTF_PAHOLE ?= pahole
 ifdef CROSS_COMPILE
 HOSTCC = $(CROSS_COMPILE)gcc
 CLANG_ARCH_ARGS = --target=$(notdir $(CROSS_COMPILE:%-=%))
-else
-CLANG_ARCH_ARGS = -target $(ARCH)
 endif
 
 # Don't evaluate probes and warnings if we need to run make recursively
-- 
2.17.1

