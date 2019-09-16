Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77E88B38C3
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 12:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbfIPKzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 06:55:07 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:44812 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732589AbfIPKzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 06:55:02 -0400
Received: by mail-lf1-f66.google.com with SMTP id q11so12131230lfc.11
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 03:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sLN8PEIzdXJ4vyRQJpg4LVfYYRixS2x0Ts7jhtzHOWM=;
        b=MhheypW2XDysOKktHNsxSG7LxAVuj81gvn1nIXQCjY3ZjEOWVw64CWPx+TsC7e8i/L
         N3aTKRxdyURBfnZY8cnxzthB0q06sfJEdgrJndGnTTm5DkQ05sqC18szpQVvwPI205JM
         FD5UbVZfrw17pax6P2aNxvYr0kPjRThua9mL+vYGNNZLqWM5aAc2R1FBXyERvpvxhH9Y
         sO3McigyojSgOHI03jFVLTIjTnYlbMcahGt86azSZyWWNsHChJFWikNBqpHmK10qnbhD
         MUjWVDOpY59AA0cDjDtsDASxXF5BF6kAI1VLiq/RWUSorKaA/C3Pq9jt+rQKiEq3xjlk
         8fRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sLN8PEIzdXJ4vyRQJpg4LVfYYRixS2x0Ts7jhtzHOWM=;
        b=MDjrS+TdjMbGWg5SVxiLhTNUhe2tr7k/PwqHEChbGgymbst+YWiroCTX+Gd18+8uQQ
         +LHtxZ8BtQMrm8lw4SgoW7kkIAMgD2wAdg3RwkU7oSDEncyD3HXsZ8Dd4njuVocGcDn3
         VLmAsioP8EHCE7bakqAfbQLVdFIlMUJFC3FGxlFDGIwNRDkW9kvzBhDs+9Xz6GfPzNUa
         ECpXeNjfmRew0GM1xr52oVkzsxuMWF/ViYHq4gys+K8qtvdE0wVg94aKOHuj1uv1v1WJ
         SzXoAiUuKMHCZ1AJN3PzsT6NZS8wqUJnqGIDx/2TlSWwKEGDbhTugkCUiKCB9cbe102p
         QjNQ==
X-Gm-Message-State: APjAAAXrF5Z9aDS4JwDPZ9Kn30slr1ZQgJ8noiiJflK0RjH3bUTwuHW2
        KtBfScbIq5vhG7iBGa+d2qil9w==
X-Google-Smtp-Source: APXvYqy4XqmgKre21JjPHCrnRIiHAk6YzQKm/zoD14WloikJ/3u32TM1a02cS68ct/GlCIZU/MCNQQ==
X-Received: by 2002:a19:4f5a:: with SMTP id a26mr37493210lfk.116.1568631298482;
        Mon, 16 Sep 2019 03:54:58 -0700 (PDT)
Received: from localhost.localdomain (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id v1sm8987737lfq.89.2019.09.16.03.54.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 03:54:57 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        sergei.shtylyov@cogentembedded.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v3 bpf-next 14/14] samples: bpf: README: add preparation steps and sysroot info
Date:   Mon, 16 Sep 2019 13:54:33 +0300
Message-Id: <20190916105433.11404-15-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190916105433.11404-1-ivan.khoronzhuk@linaro.org>
References: <20190916105433.11404-1-ivan.khoronzhuk@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add couple preparation steps: clean and configuration. Also add newly
added sysroot support info to cross-compile section.
---
 samples/bpf/README.rst | 41 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 36 insertions(+), 5 deletions(-)

diff --git a/samples/bpf/README.rst b/samples/bpf/README.rst
index 5f27e4faca50..d5845d73ab7d 100644
--- a/samples/bpf/README.rst
+++ b/samples/bpf/README.rst
@@ -14,6 +14,20 @@ Compiling requires having installed:
 Note that LLVM's tool 'llc' must support target 'bpf', list version
 and supported targets with command: ``llc --version``
 
+Clean and configuration
+-----------------------
+
+It can be needed to clean tools, samples or kernel before trying new arch or
+after some changes (on demand)::
+
+ make -C tools clean
+ make -C samples/bpf clean
+ make clean
+
+Configure kernel, defconfig for instance::
+
+ make defconfig
+
 Kernel headers
 --------------
 
@@ -68,9 +82,26 @@ It is also possible to point make to the newly compiled 'llc' or
 Cross compiling samples
 -----------------------
 In order to cross-compile, say for arm64 targets, export CROSS_COMPILE and ARCH
-environment variables before calling make. This will direct make to build
-samples for the cross target.
+environment variables before calling make. But do this before clean,
+cofiguration and header install steps described above. This will direct make to
+build samples for the cross target::
+
+ export ARCH=arm64
+ export CROSS_COMPILE="aarch64-linux-gnu-"
+
+Headers can be also installed on RFC of target board if need to keep them in
+sync (not necessarily and it creates a local "usr/include" directory also)::
+
+ make INSTALL_HDR_PATH=~/some_sysroot/usr headers_install
+
+Pointing LLC and CLANG is not necessarily if it's installed on HOST and have
+in its targets appropriate arm64 arch (usually it has several arches).
+Build samples::
+
+ make samples/bpf/
+
+Or build samples with SYSROOT if some header or library is absent in toolchain,
+say libelf, providing address to file system containing headers and libs,
+can be RFS of target board::
 
-export ARCH=arm64
-export CROSS_COMPILE="aarch64-linux-gnu-"
-make samples/bpf/ LLC=~/git/llvm/build/bin/llc CLANG=~/git/llvm/build/bin/clang
+ make samples/bpf/ SYSROOT=~/some_sysroot
-- 
2.17.1

