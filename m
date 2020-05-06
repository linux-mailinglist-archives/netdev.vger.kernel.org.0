Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E75811C688E
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 08:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbgEFGWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 02:22:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728213AbgEFGWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 02:22:42 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C323C061A0F;
        Tue,  5 May 2020 23:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=8xYqhlaf56AodBMEMHzZf5wu40Wrvnh8K80Ep72Z4QE=; b=sxvKi8/WbsjGhIbs0fT7Aatdkp
        kznIs8jVBvLERKVfIQq4WcPUrGY+BmfDpo+QgEj04EpjodvYUlxBjOjshsZVqnJ86Q8Jx/bvcwD54
        ceKqgKmaI5tmHmHuAC+BfPLt6urHvBNsRpf5S5hXTIU8eQU+xGGjemoHPzAXXUdmmj9J8YQNqcFEf
        waQHX5H057Cw5UhNIotpXGOd3GpwcwtF11CNspe8bWzWMHeXKxueOp6ht7xvJqBk7TA07rlctTvdr
        5UQW/g2enjOu/xQfD/uSk5OqgP8ZoTJj0WgChhpbQ73oTrvgMmt5uqrgFDaR559CveBDXiPPkvQIP
        35MGjDzg==;
Received: from [2001:4bb8:191:66b6:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWDS4-0006aB-IZ; Wed, 06 May 2020 06:22:41 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/15] maccess: update the top of file comment
Date:   Wed,  6 May 2020 08:22:13 +0200
Message-Id: <20200506062223.30032-6-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200506062223.30032-1-hch@lst.de>
References: <20200506062223.30032-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This file now also contains several helpers for accessing user memory.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/maccess.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/maccess.c b/mm/maccess.c
index 747581ac50dc9..65880ba2ca376 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Access kernel memory without faulting.
+ * Access kernel or user memory without faulting.
  */
 #include <linux/export.h>
 #include <linux/mm.h>
-- 
2.26.2

