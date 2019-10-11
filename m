Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3B1AD35E5
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 02:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbfJKA2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 20:28:46 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39035 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727823AbfJKA2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 20:28:44 -0400
Received: by mail-lj1-f193.google.com with SMTP id y3so8029970ljj.6
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 17:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pOlOkzzU0bwqDGQkGWa87uAZFQ6B6XzFeEn3c66o8lU=;
        b=QHN9i8ukUhuJBaTW1UkwsHCf7J5j7HE4qIMcwKRdrirpcaAonzp03YiEqPSRwe3zx/
         xA0MoKbGih4p4DFXZwDwFBVobJyP2faVBo7sSRFrH+xMkpC/PIjgjau5tDOW+sFmwLwz
         g1hsnFO0QNDJkY3FkwUuMwhUKVchwkKKVMSTy0IBQDH2rghXK2Kb+YMjb+e9v4KFDu0l
         5++1qegXGXuL7utw193IWXAe67LN2wicnj/KIR+LUI+F5L2i9Y7eBDqDrS+Yn4GQu+Dy
         0MUQU2rjtqKV6psnZKCzGon4ksn3ln70MKD8EGIAdfYhyEuOTccCJajTz1HJ7wxhCkN3
         Ez7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pOlOkzzU0bwqDGQkGWa87uAZFQ6B6XzFeEn3c66o8lU=;
        b=ezL/qn+jDwqP/qpYAGv8IJxxrFM3v7k3D+msPpBbGKk+ZkJan0st+RnGPeE30yVk/D
         We7HIm00FaxudN+y+dGKsaqtsHYjVOyz8A6RjWMzucY9dZDqKS7c60269ZyV6NnHyc1x
         bV8xOA3gpq2sSWHo67teQN3UL+3mgaksWmeIQhqMvf9h90Sac+krgNqUlteqk70Ze9C9
         iv/2K6AlVzFC8Se50DUVzmFq2ML8K65J8paONJyDfI6Qv3UyJ7Bf+5w0XGtPhWQoUeCG
         Z2gyr2W3BJbHU/F6Pe7UZMcEZ/NS+vYaJeK3pYbpGU2OFH4p0jBZYwSJGl5E67D0X8aQ
         VTeA==
X-Gm-Message-State: APjAAAVpWZT1gbcHJDTuN3Zm06HcYS71fqICWMz9ut94lFxJDFrcGRbn
        nL8WFvscpf0yDZ5oVK9R+oWvoQ==
X-Google-Smtp-Source: APXvYqx/hZhkYlHMDs/0fYgLREAPdm0Rklj16fXnm+aBEBcqoa/exgzworlTmmiIrWj0rsP8Zh/sXw==
X-Received: by 2002:a2e:a0ca:: with SMTP id f10mr7479171ljm.83.1570753721062;
        Thu, 10 Oct 2019 17:28:41 -0700 (PDT)
Received: from localhost.localdomain (88-201-94-178.pool.ukrtel.net. [178.94.201.88])
        by smtp.gmail.com with ESMTPSA id 126sm2367010lfh.45.2019.10.10.17.28.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 17:28:40 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        ilias.apalodimas@linaro.org, sergei.shtylyov@cogentembedded.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v5 bpf-next 15/15] samples/bpf: add preparation steps and sysroot info to readme
Date:   Fri, 11 Oct 2019 03:28:08 +0300
Message-Id: <20191011002808.28206-16-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191011002808.28206-1-ivan.khoronzhuk@linaro.org>
References: <20191011002808.28206-1-ivan.khoronzhuk@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add couple preparation steps: clean and configuration. Also add newly
added sysroot support info to cross-compile section.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 samples/bpf/README.rst | 41 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 36 insertions(+), 5 deletions(-)

diff --git a/samples/bpf/README.rst b/samples/bpf/README.rst
index 5f27e4faca50..cc1f00a1ee06 100644
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
+Headers can be also installed on RFS of target board if need to keep them in
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

