Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4434572FE
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 17:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236418AbhKSQfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 11:35:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232657AbhKSQfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 11:35:36 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74FC5C06173E;
        Fri, 19 Nov 2021 08:32:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=hgrK4yDYHjIMVt7oZJJ9i/4Xaw8PAXcWvkRYgWTbUMM=; b=XgnowcMINxRw9yHvcPuDgTAXb0
        x5CZlB8iAPw99i20YKgw0mPUP29MDUWocOXFoOXpEi5zGIIDipHWy1JbTNFy3BefIIWSHaqBhLw9P
        jbC/ivNq+Zntv+Yrx93I1OVOzbzVskxRjNYzHmHvIt8x0bKMmTFyVHsj4kXsVecsLK7TlWn4pnJT0
        X3yiu7Ciu/3B21J9Olz1TpRpkl3bYwB/OEvaVwiQuz7oLhAMsE6zQPkb5/yZSOGVTMDYDPM/g/+ai
        4nQzYLo9x/PNgJARe5vjs8pncYPhf4jZzqK2Dt1JPEfk5jurd0Aw8XfuexUJsTdgaW7/FFW6MszVd
        P2EU1cNA==;
Received: from [2001:4bb8:180:22b2:ffb8:fd25:b81f:ac15] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mo6oD-009gCp-TD; Fri, 19 Nov 2021 16:32:18 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH 1/5] x86, bpf: cleanup the top of file header in bpf_jit_comp.c
Date:   Fri, 19 Nov 2021 17:32:11 +0100
Message-Id: <20211119163215.971383-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211119163215.971383-1-hch@lst.de>
References: <20211119163215.971383-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't bother mentioning the file name as it is implied, and remove the
reference to internal BPF.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/x86/net/bpf_jit_comp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 6318479077867..1d7b0c69b644d 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1,9 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * bpf_jit_comp.c: BPF JIT compiler
+ * BPF JIT compiler
  *
  * Copyright (C) 2011-2013 Eric Dumazet (eric.dumazet@gmail.com)
- * Internal BPF Copyright (c) 2011-2014 PLUMgrid, http://plumgrid.com
+ * Copyright (c) 2011-2014 PLUMgrid, http://plumgrid.com
  */
 #include <linux/netdevice.h>
 #include <linux/filter.h>
-- 
2.30.2

