Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81E561DD14E
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 17:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730083AbgEUPX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 11:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730045AbgEUPX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 11:23:26 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0AB2C061A0E;
        Thu, 21 May 2020 08:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=8xYqhlaf56AodBMEMHzZf5wu40Wrvnh8K80Ep72Z4QE=; b=OX42L2FK5DlrY0ihmHgVpYvF4n
        /GNueyuT6/F28jhKA0sN+lPvS0kuV7S0qwVUss8qpoExx09VimF/GY5WKMpzOvtDDnGqMI/TnuDu6
        eT2ABDPSAWZ0zSUQG3IWr0fJj2VIetRUNBqwA3zWJEY5T6vdbigsqzpdjIKJlP/SaYYnG5nBzpsHV
        MoW1s/a8Iqp6ojh11hFiPwtLsbneMpWfGzu3Nl1PdSzDenh4YIvnsayl8fqrl2/bfClINm+mwrgB8
        CjHjBJPGs0gt6eX38YWgB60pfoS043GbwKHXBPEEoKffTV2nECiywDHi2g46xT1vIS0UVEO9VfBqc
        8wPytSxA==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbn2T-0004B4-Q6; Thu, 21 May 2020 15:23:18 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/23] maccess: update the top of file comment
Date:   Thu, 21 May 2020 17:22:43 +0200
Message-Id: <20200521152301.2587579-6-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200521152301.2587579-1-hch@lst.de>
References: <20200521152301.2587579-1-hch@lst.de>
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

