Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34FACF67F9
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 09:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbfKJITL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 03:19:11 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43873 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726594AbfKJITK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 03:19:10 -0500
Received: by mail-pl1-f196.google.com with SMTP id a18so6217545plm.10;
        Sun, 10 Nov 2019 00:19:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GhJqmGp+VrFnHMV4gta1TdxW0mlhmCCtJxbmydFgDMg=;
        b=ea8bHgMxuQMGLBYLRDYDzUEcOsKbJ1pv5aowPj6B5zZVYLN8pVFjjoCwzxBc+53wgV
         BF3lYo14zsAc+W68wlIXYrZ7abEf9Qj4UtA6/zIYXTyZlfslcDyFma7aYaeU4qCAd2Wd
         lci5XtWBtm+h78U1c5e9KVgT1j8Aim+QZrcf8SsFPCg4I9FMZ+jH/ev84OTPfvLgWd0m
         Ki0PdNGQX8tGHao2R33D8L6UyKbHeyqg4AoBVpwpOeL8Dok1xUXEuHOQq7h498Dk2FIB
         D/ir8QZZe7G85HM8zakF1s6O0jmTEa/ejemWdrcvpy8ciM2FeT+aQxvv33/bCEc8OZ9H
         L9NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GhJqmGp+VrFnHMV4gta1TdxW0mlhmCCtJxbmydFgDMg=;
        b=VPgF/gmbMq2AJwPd/SzkM82rrt90+e4Jq5x9Iv1eG4Sq9LhtoXskCXh9tz4ExRxV3b
         vwxeUzNRpoKFwKC1uE8wrrlsPyK0Vhl/fRPSFZEzpWV1iIcCSSbIAuF5Fs6bTvhCSyVa
         fUvenp8tbBEGZvIpuU6xKRp2LFBcK+xEcdR9zaQTXZ6OKXxExRKAC9I0fLXjyo8QdjrR
         jr9jWgqZevD0NZWgBt0AwOu1H2V8uYZ+fooXLEI8CpcSKTNDKB7dpUixA+l+8tdPIw/1
         fXxBmLLYYV4L+3E0LK8IAGLDD7QmNfXQaDFFQKjx3RMzZih72OZ2Xbi2vsump/TXRM3n
         QUpw==
X-Gm-Message-State: APjAAAWyvNBBzAolWV2S3cnOlJpKwJQZOWlcn68TAkcI4GND9ZgzzUU9
        LnSkl6D08Dq+ctjvhekUTA==
X-Google-Smtp-Source: APXvYqyZc6FtR+1FtjGfTAsodm0F1j6viostVz1EWz5ph7EmwAdu1VCMLYvdmothPTcnPXvPFIaaWg==
X-Received: by 2002:a17:902:aa02:: with SMTP id be2mr19995669plb.326.1573373948018;
        Sun, 10 Nov 2019 00:19:08 -0800 (PST)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id j23sm10617265pfe.95.2019.11.10.00.19.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Nov 2019 00:19:07 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH] samples: bpf: fix outdated README build command
Date:   Sun, 10 Nov 2019 17:19:01 +0900
Message-Id: <20191110081901.20851-1-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, building the bpf samples under samples/bpf directory isn't
working. Running make from the directory 'samples/bpf' will just shows
following result without compiling any samples.

 $ make
 make -C ../../ /git/linux/samples/bpf/ BPF_SAMPLES_PATH=/git/linux/samples/bpf
 make[1]: Entering directory '/git/linux'
   CALL    scripts/checksyscalls.sh
   CALL    scripts/atomic/check-atomics.sh
   DESCEND  objtool
 make[1]: Leaving directory '/git/linux'

Due to commit 394053f4a4b3 ("kbuild: make single targets work more
correctly"), building samples/bpf without support of samples/Makefile
is unavailable. Instead, building the samples with 'make M=samples/bpf'
from the root source directory will solve this issue.[1]

This commit fixes the outdated README build command with samples/bpf.

[0]: https://patchwork.kernel.org/patch/11168393/

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/README.rst | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/samples/bpf/README.rst b/samples/bpf/README.rst
index 5f27e4faca50..bfd2405705ed 100644
--- a/samples/bpf/README.rst
+++ b/samples/bpf/README.rst
@@ -32,12 +32,10 @@ Compiling
 For building the BPF samples, issue the below command from the kernel
 top level directory::
 
- make samples/bpf/
+ make M=samples/bpf
 
-Do notice the "/" slash after the directory name.
-
-It is also possible to call make from this directory.  This will just
-hide the the invocation of make as above with the appended "/".
+Due to samples/bpf cannot be built without support in the
+samples/Makefile, it is unavailable to call make from this directory.
 
 Manually compiling LLVM with 'bpf' support
 ------------------------------------------
@@ -63,14 +61,15 @@ Quick sniplet for manually compiling LLVM and clang
 It is also possible to point make to the newly compiled 'llc' or
 'clang' command via redefining LLC or CLANG on the make command line::
 
- make samples/bpf/ LLC=~/git/llvm/build/bin/llc CLANG=~/git/llvm/build/bin/clang
+ make M=samples/bpf LLC=~/git/llvm/build/bin/llc CLANG=~/git/llvm/build/bin/clang
 
 Cross compiling samples
 -----------------------
 In order to cross-compile, say for arm64 targets, export CROSS_COMPILE and ARCH
 environment variables before calling make. This will direct make to build
-samples for the cross target.
+samples for the cross target.::
+
+ export ARCH=arm64
+ export CROSS_COMPILE="aarch64-linux-gnu-"
+ make M=samples/bpf LLC=~/git/llvm/build/bin/llc CLANG=~/git/llvm/build/bin/clang
 
-export ARCH=arm64
-export CROSS_COMPILE="aarch64-linux-gnu-"
-make samples/bpf/ LLC=~/git/llvm/build/bin/llc CLANG=~/git/llvm/build/bin/clang
-- 
2.20.1

