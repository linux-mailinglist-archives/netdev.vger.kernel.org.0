Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68F3D2F76EB
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 11:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731614AbhAOKo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 05:44:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbhAOKoY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 05:44:24 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FBBCC0613D3;
        Fri, 15 Jan 2021 02:43:44 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id u21so9906556lja.0;
        Fri, 15 Jan 2021 02:43:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q5KthTeXhG9zYR2XUBnXVlinwFDvxSXX3TRUTi/EkJk=;
        b=eOiVjdCcyHtEZxvGbZBM2F3z2kQX62FWVXnciVmtsxZVQTtZcPEvmQjQANp4fRH4Y0
         6cRHxPc4YrAj3s+6lm/z3TpwnjIj1kX6ASx1DbHPPR2XHCxscfCBjeDz+gZEejUUXMXS
         xnLwkHSz0QXcl6Vzu6Qh2I9af3tJslAnrYci06rSCJQE54xeALPCf8+9jlpV3PoXel7D
         jwmO/o+z2HBmc6kV7Rv6+ECBnZbKIvTe1Dc36tRR718bKLdF+JEbrgcRJbnKKhoyKD8q
         LjyscSazJQaVi+wqfDSyE96weGhQIJqRxNoGmubtNOudIvVExuadYGU1ueCDEtKZMIia
         JZDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q5KthTeXhG9zYR2XUBnXVlinwFDvxSXX3TRUTi/EkJk=;
        b=jTytNBtXC1bXTm2sh1E06PNVyGf+sEE35ELKqGQdTkBzPqeYVcVmdUrQRrwmJfqAXP
         NIwUqDqbmyBcEDGucayH45Rzw1G/1tiHKv0I3uZkzq25EkC2UeaJDnSbhh395nEWU/Bd
         8AqqD/jHpqUqLSAl2xIZNmLzJxTIZi4NJmBHOC86OJCWS8Lt0Ak9Y9+jlcgDg8In/or4
         /QX4b7yDlHqUh6l8R0WduN0YLwmlix2JB4XBPVupGGbi+e8rtyJVfoUnNlKsijIMajKH
         gc5a7avz//QKoe5BwgsKZFFHst7JZoLisXX+JHD5yy8GTVruO6FpB5zp73llJ1+gRqSn
         JfkA==
X-Gm-Message-State: AOAM532CcNHdj2vSM6Rb5evdERnQgeMYufO1xITt1RU7psA9SbZV2Dmx
        NfM8geD1qWRPx5UeRuHRK+M=
X-Google-Smtp-Source: ABdhPJxHW9y/m+FKwNjJRh6qlv0CDana0YCVPGb3v4OIgQCK1Os++OtGqZ7VIgMhBv60vWc37rBzYg==
X-Received: by 2002:a2e:7613:: with SMTP id r19mr5371921ljc.284.1610707422639;
        Fri, 15 Jan 2021 02:43:42 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id c3sm762267ljk.88.2021.01.15.02.43.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 02:43:41 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        linux-riscv@lists.infradead.org
Subject: [PATCH bpf] MAINTAINERS: update my email address
Date:   Fri, 15 Jan 2021 11:43:37 +0100
Message-Id: <20210115104337.7751-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn@kernel.org>

My Intel email will stop working in a not too distant future. Move my
MAINTAINERS entries to my kernel.org address.

Signed-off-by: Björn Töpel <bjorn@kernel.org>
---
 .mailmap    | 2 ++
 MAINTAINERS | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/.mailmap b/.mailmap
index 632700cee55c..b1ab0129c7d6 100644
--- a/.mailmap
+++ b/.mailmap
@@ -55,6 +55,8 @@ Bart Van Assche <bvanassche@acm.org> <bart.vanassche@wdc.com>
 Ben Gardner <bgardner@wabtec.com>
 Ben M Cahill <ben.m.cahill@intel.com>
 Björn Steinbrink <B.Steinbrink@gmx.de>
+Björn Töpel <bjorn@kernel.org> <bjorn.topel@gmail.com>
+Björn Töpel <bjorn@kernel.org> <bjorn.topel@intel.com>
 Boris Brezillon <bbrezillon@kernel.org> <b.brezillon.dev@gmail.com>
 Boris Brezillon <bbrezillon@kernel.org> <b.brezillon@overkiz.com>
 Boris Brezillon <bbrezillon@kernel.org> <boris.brezillon@bootlin.com>
diff --git a/MAINTAINERS b/MAINTAINERS
index b15514a770e3..0dfd1a67d430 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3336,7 +3336,7 @@ F:	arch/riscv/net/
 X:	arch/riscv/net/bpf_jit_comp64.c
 
 BPF JIT for RISC-V (64-bit)
-M:	Björn Töpel <bjorn.topel@gmail.com>
+M:	Björn Töpel <bjorn@kernel.org>
 L:	netdev@vger.kernel.org
 L:	bpf@vger.kernel.org
 S:	Maintained
@@ -19409,7 +19409,7 @@ F:	drivers/net/ethernet/*/*/*xdp*
 K:	(?:\b|_)xdp(?:\b|_)
 
 XDP SOCKETS (AF_XDP)
-M:	Björn Töpel <bjorn.topel@intel.com>
+M:	Björn Töpel <bjorn@kernel.org>
 M:	Magnus Karlsson <magnus.karlsson@intel.com>
 R:	Jonathan Lemon <jonathan.lemon@gmail.com>
 L:	netdev@vger.kernel.org

base-commit: 4237e9f4a96228ccc8a7abe5e4b30834323cd353
-- 
2.27.0

