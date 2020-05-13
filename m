Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9CB1D1A70
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 18:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389404AbgEMQA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 12:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389381AbgEMQAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 12:00:55 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F8A2C061A0C;
        Wed, 13 May 2020 09:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=8xYqhlaf56AodBMEMHzZf5wu40Wrvnh8K80Ep72Z4QE=; b=nRbb9ZaSqk76EZQCSrXCjKKyi0
        GJgHRuj+u8CLMsmD8S/jMJWUDJc1FafDS7rGbviJ91agO2UXeMmgmZ17lHLrlOZvJ7Kz2cgw4DQnE
        x8ZwpShjfcEdJ2PDZtqoUfhRBI28R2oM+vqAV5DFQHQc6M0ngu4lTh3ZXD4FnwWrlLOkepDbAxEA2
        zb2i5J+6ZKsp7eesWFAgbP7Z5ifqYk52cj9M05f2G7JV66BRFFnO+IT/wdC5Ug2FsOCNO2PCSV/3K
        np/iArRzduzUJo1a3JPAz4UU6DrAJlFUcZQJkfjAFN6px8lJsSTAVaQbYorop4VmKXHN30Gc17Boo
        XWO6zFhg==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jYtoT-0004kp-Mc; Wed, 13 May 2020 16:00:54 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/18] maccess: update the top of file comment
Date:   Wed, 13 May 2020 18:00:25 +0200
Message-Id: <20200513160038.2482415-6-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513160038.2482415-1-hch@lst.de>
References: <20200513160038.2482415-1-hch@lst.de>
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

