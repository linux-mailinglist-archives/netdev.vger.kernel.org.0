Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE93EA94EE
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 23:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729640AbfIDVXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 17:23:06 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:42650 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730245AbfIDVXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 17:23:05 -0400
Received: by mail-lj1-f196.google.com with SMTP id y23so171305lje.9
        for <netdev@vger.kernel.org>; Wed, 04 Sep 2019 14:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1A0DTH8yoCPJNcxERaZ+ijIkUOQqqgHSIHaATGrPTFQ=;
        b=JxOWBX3K7ATM3R5k6qLko7irOYaDDp/EgE8lqfrCSuMD68Wxvfb5wgkZ5UbBXSNViD
         R37hhdMVyVTttgCsjHZkCQK2sZsQ/+mOjH2MmEnjoNubt0fsAOh+YGAb5XgJJ7CiMDVm
         Oj0dm134XL61kE1LH53qBXVlpjUIpWHL04VEkk0t0hzqmk6ihGiJu1fwZYv8qOnE/agN
         s0JL+ECqalNyE3mSNjOsv45sWpYK0MD9Xb5RhXGiwzcJlKmj7RfFCi0Mx8TMIsSEXmwf
         3pc3CzpYyw4n2l94LKGE5Ws0K3mJNjjYb6vSUrZ64UMhnFZ6v1EEzgCkPrikOTSfU4Kj
         g8Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1A0DTH8yoCPJNcxERaZ+ijIkUOQqqgHSIHaATGrPTFQ=;
        b=fRetIQgO/VXA1D32jDE/8q0btoXJ6PkKQuBi/jJ3ZKCqKU0Cnk0jv3dXvBlvKnJ0UJ
         dEJ96SCv4DP2DRAajmX2sQkNNrJXJJpaS8I2Dj8HL/vrov5sZNXTfgOfz7cm8NgA7FWs
         9C2/FKBgDLPBDVni6UjR+DfwCBPFKraDFL9ELvK4ijRI1CYHijX0fWctjVfMf8ybM79+
         eSy0Zt0gcm1qgdK8U+kMELr/roUIIM9dQffzdB0/JhxTIbHSTqEpgHrjPqcZ6vp0uafR
         NZ/wlJfRMyV/Z+OdAm9Q5qsVV70eYtelqCaZC3swYHV46HNwaqSWc/FbALjBFh36fQuR
         lOJQ==
X-Gm-Message-State: APjAAAVw5lf85RggYweqAQYPDWHewWC9iqnKBXFgB0dXJogmh/V4H+me
        EpFpnL0luYlvx3lQ/AagKKYU9w==
X-Google-Smtp-Source: APXvYqwz4ndJZfXhBcpi8UvRZpCbYG9ilF+aaCsG3QbQJpYkccg1tFAjfOYCP6qU35rHpewQ9EUEDA==
X-Received: by 2002:a2e:7210:: with SMTP id n16mr14294364ljc.235.1567632183622;
        Wed, 04 Sep 2019 14:23:03 -0700 (PDT)
Received: from localhost.localdomain (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id s8sm3540836ljd.94.2019.09.04.14.23.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2019 14:23:03 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH bpf-next 2/8] samples: bpf: Makefile: remove target for native build
Date:   Thu,  5 Sep 2019 00:22:06 +0300
Message-Id: <20190904212212.13052-3-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190904212212.13052-1-ivan.khoronzhuk@linaro.org>
References: <20190904212212.13052-1-ivan.khoronzhuk@linaro.org>
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

Only set to real triple helps: --target=arm-linux-gnueabihf
or just drop the target key to use default one. Decision to just
drop it and thus default target will be used (wich is native),
looks better.

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

