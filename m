Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91A7ED19E6
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 22:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732210AbfJIUmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 16:42:04 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:40850 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732177AbfJIUmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 16:42:02 -0400
Received: by mail-lf1-f67.google.com with SMTP id d17so2673462lfa.7
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 13:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ECSs+mjX4lDFe4jfV4JTbgbugRRkkd9F4zfelRgHKxE=;
        b=gUjn/S2efuOPXmg3rQVYqpqdFW0SwsiG98P30JRwuBNr6WxKw3KU9N6YZ+brp2Q7Rd
         yfWuTtm1rFWLipf/NFrIMqUZi4qgcP+w1Za6uCOhZZC5hfk1Ocy1Dq1gZnWHceFsFoOV
         9qnp8T9CUpAj/ngzQcF64dHtvm0D5vxtMtGczAS+nruCR1F5UdNIjKIHnqsNXMuUyL7X
         K0QH97/eIi6y08cd85YikZx/iA7vIJqNUxY4yUr038zamFrjak8kxDXCndocS12+8DxD
         Wkkc7pgTqA7D3wWX2Tw4zrquutTsCaQZwnk0E0M4UyigdMPQ2UtbWvf/0YdkBRBagiOB
         LeIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ECSs+mjX4lDFe4jfV4JTbgbugRRkkd9F4zfelRgHKxE=;
        b=bO5WolANHW9WxU8zjAZDxId2yaAIyCv4PLul4cxutZiA28I/lNFG+RibNBrwLLmufd
         VvkItyxTXFvFKXjT3b8Z/H9z3bqzH4MJ2cfRcW61SUnLDbErBigxw4i95+semqUKXz5s
         TvFsYwro1kx3tH2yZDPt5rBlaKdDFQG3nPxLCbqJhzk9AhbNkHhHbTGSXaLZymbBhgDJ
         DXHNBDgdvmrlKVE3ijWIeaPst6+4/k3HJV9GZxmZRnqlEAdnmu0jJj/V9dnk+B2M41kQ
         68Drqj/vcX/d7teU/m0AmstTzjZJo13kqRzLYl10jGPFkOJtRpzC+vFvL9lnzrEuCzpW
         4hlw==
X-Gm-Message-State: APjAAAWP96IOUV2z4ENuxWO1U267vA1LWSxhF3pcDs3tw7/kMEZ9in7E
        FasKsRgYABH5ITB5jjKY0P2B5A==
X-Google-Smtp-Source: APXvYqxemhdjS6iiJmRG8axkCDMNxDJpIzxqKSgxZS/Hg9GWCN7Oewpb7RM9aQmAbB9f47y/ECq1Tw==
X-Received: by 2002:ac2:533c:: with SMTP id f28mr3247351lfh.77.1570653720287;
        Wed, 09 Oct 2019 13:42:00 -0700 (PDT)
Received: from localhost.localdomain (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id h3sm730871ljf.12.2019.10.09.13.41.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 13:41:59 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        ilias.apalodimas@linaro.org, sergei.shtylyov@cogentembedded.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v4 bpf-next 15/15] samples/bpf: add preparation steps and sysroot info to readme
Date:   Wed,  9 Oct 2019 23:41:34 +0300
Message-Id: <20191009204134.26960-16-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191009204134.26960-1-ivan.khoronzhuk@linaro.org>
References: <20191009204134.26960-1-ivan.khoronzhuk@linaro.org>
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

