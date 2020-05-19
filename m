Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E62F41D9833
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 15:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729126AbgESNpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 09:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729104AbgESNpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 09:45:10 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9AE2C08C5C0;
        Tue, 19 May 2020 06:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=8xYqhlaf56AodBMEMHzZf5wu40Wrvnh8K80Ep72Z4QE=; b=TOEnE+9IznmYyPaIJeWUB9uSJm
        PEmyY5CQX5+5+83QwQkVLCPLWclduU+Z3qJwMEYFfGeK4p8ybWrxfWE+X1NEaHslYHTvnZE4oYqVA
        tMaYB7XQgrLylsvXkdwa5IuMHp6jG0h81crL1LGw45hBYdpzKv73kZv/jbyJFSjLH4eLzAmIHmfuG
        Su3bp4ibnhg6EpNTi3aR1p9U+JhIUkPAxJKHqBA7agLL1mOqW82LKg+UTZvoFiKPJJy+kYcz50APc
        cKkWhchiVsPZ3bwDzbxOce5BLS/PdaW9h0bbjMxoogETbL2cHChOhixce9zqflD8JtI35z9YkAtFQ
        cFhgD3zg==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jb2YN-0001sY-VP; Tue, 19 May 2020 13:45:08 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/20] maccess: update the top of file comment
Date:   Tue, 19 May 2020 15:44:34 +0200
Message-Id: <20200519134449.1466624-6-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200519134449.1466624-1-hch@lst.de>
References: <20200519134449.1466624-1-hch@lst.de>
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

