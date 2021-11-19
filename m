Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32218457304
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 17:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236484AbhKSQfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 11:35:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233602AbhKSQfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 11:35:36 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E57C061748;
        Fri, 19 Nov 2021 08:32:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=GNeRs6qZFZPc663s5+T7KLVGL5U6BId/g/KYhk+VVo4=; b=QK3AXE5Kdm8eAXHlRUEAVcadVB
        RbeU5tGKmyFNgQMuHR5wekfcGjdDCF7qjY9KpbKcQB4gU4pSuH30YpZmi6hnJq4fKImxhQgHnyN8a
        xJH9ljlvm/my6e2cqJ/v8p/E5isvCxiwXjBhkHMb+rryrTEjb9lTg+IR4wwKhVqb4/JwaglC10vSf
        uDSOKiToS+IvmspqJRVy+jdnvmbEn0SzAVd70weQehy66yTNP0zvprTuSp6AtsErKTBdIlAzVFIOO
        mJmhG17p/Z6lrJJIkO3fDY57W/KZoCdPS1hsTbcY6azESatYfTvnmA7ZWw2rR1hXGk/LG/tGL6HQf
        BUETHGCg==;
Received: from [2001:4bb8:180:22b2:ffb8:fd25:b81f:ac15] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mo6oF-009gCv-En; Fri, 19 Nov 2021 16:32:20 +0000
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
Subject: [PATCH 2/5] bpf: remove a redundant comment on bpf_prog_free
Date:   Fri, 19 Nov 2021 17:32:12 +0100
Message-Id: <20211119163215.971383-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211119163215.971383-1-hch@lst.de>
References: <20211119163215.971383-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The comment telling that the prog_free helper is freeing the program is
not exactly useful, so just remove it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 kernel/bpf/core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index b52dc845ecea3..189d85d64bf1c 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2301,7 +2301,6 @@ static void bpf_prog_free_deferred(struct work_struct *work)
 	}
 }
 
-/* Free internal BPF program */
 void bpf_prog_free(struct bpf_prog *fp)
 {
 	struct bpf_prog_aux *aux = fp->aux;
-- 
2.30.2

