Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2C6345704
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 05:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhCWEzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 00:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbhCWEyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 00:54:43 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFCA2C061574;
        Mon, 22 Mar 2021 21:54:42 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id v70so13163977qkb.8;
        Mon, 22 Mar 2021 21:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QcRlQh1S/zxnKxyt3g/BCdEjQtxtzxHfEqHQxbpK75U=;
        b=h7U1zimvrj7GoyX7TkR3qcbf+7m5HNJDhy/QRaq0un/mkJtmv8uXV2qKRQqLxIFJ8h
         xeVSHyM5O3RgeMUhDB7XbsSr1gx4esyQgakp/EGz9nvyXdSEyJiPguKXkwIpCkr0XGLZ
         PG20ttLT1gg2JWHSa2tDd5c71+qQeIF6v8vtQ3Tltcb5LZCi9/NZt9jT6qQK2kcVHoK1
         wtyBpPEdZUqxA36VHOy6KHkJwVAAcurHploFqF2B/IqPe7SOLBULTnSz2CpNFmdpjKzt
         9FR1VtbwGAzFY8K/wjHiwB9KBsAw1pHnjSga6bNKrEXOg2tzFwTUdV6HUgUKxXcpxY+Z
         LXFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QcRlQh1S/zxnKxyt3g/BCdEjQtxtzxHfEqHQxbpK75U=;
        b=rvfWQ/H7+8/Bt7FKZ5cvjjw+83O06qYmnOKAGPh80cDrxzBaqSuK8IpYdcEkF3OT7M
         vLdLHMcGJULOAnO9qkEqZT7AQX51KbVh1jjKftRWrVWrI59YnEPKovo3/x/mE1zHjCWG
         ExIhKHKqEzfekBLlGhW5Lbw+9ujxsFk7C2Opp18ek50A9jUkhonfL2lnGr7jOZV6DbKd
         B3ZU/SBUM1y1V9EJpCxzW8tmUDJc1iay+WVmnC+KWfBYugMJn4FhOXd8TMzQiUAmvsM3
         IFcLuuWhEMZnXhKBL1RETqb8wH1c7mg5ZzJYscLXfxWZIkr3pKpoEz0RTVT+BC47S16U
         ZUEw==
X-Gm-Message-State: AOAM531Qdx3Ze84g9GJgoy7cVApYDWtontTX2Z/mSTY+ppFOvvO7GtDn
        UXFP8rz02YbQtIrzi4ukE8ERdIM/ZM7lCNsz
X-Google-Smtp-Source: ABdhPJzQ57h7x+e0PfDKa1SCDPjxDUK2fGVyQ7NusXMc9XQ9odnFQoPWNTIcq3LNNY8AX9K8D+dMbA==
X-Received: by 2002:ac8:6059:: with SMTP id k25mr2979267qtm.251.1616474797982;
        Mon, 22 Mar 2021 21:46:37 -0700 (PDT)
Received: from localhost.localdomain ([156.146.54.208])
        by smtp.gmail.com with ESMTPSA id n3sm10283882qtd.93.2021.03.22.21.46.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 21:46:37 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
        mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
        jolsa@redhat.com, namhyung@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, irogers@google.com, kan.liang@linux.intel.com,
        unixbhaskar@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     rdunlap@infradead.org
Subject: [PATCH] perf tools: Trivial spelling fixes
Date:   Tue, 23 Mar 2021 10:16:05 +0530
Message-Id: <20210323044605.1788192-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


s/succeded/succeeded/ ........five different places
s/revsions/revisions/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 tools/perf/util/header.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 20effdff76ce..97a0eeb6d2ab 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -127,7 +127,7 @@ static int __do_write_buf(struct feat_fd *ff,  const void *buf, size_t size)
 	return 0;
 }

-/* Return: 0 if succeded, -ERR if failed. */
+/* Return: 0 if succeeded, -ERR if failed. */
 int do_write(struct feat_fd *ff, const void *buf, size_t size)
 {
 	if (!ff->buf)
@@ -135,7 +135,7 @@ int do_write(struct feat_fd *ff, const void *buf, size_t size)
 	return __do_write_buf(ff, buf, size);
 }

-/* Return: 0 if succeded, -ERR if failed. */
+/* Return: 0 if succeeded, -ERR if failed. */
 static int do_write_bitmap(struct feat_fd *ff, unsigned long *set, u64 size)
 {
 	u64 *p = (u64 *) set;
@@ -154,7 +154,7 @@ static int do_write_bitmap(struct feat_fd *ff, unsigned long *set, u64 size)
 	return 0;
 }

-/* Return: 0 if succeded, -ERR if failed. */
+/* Return: 0 if succeeded, -ERR if failed. */
 int write_padded(struct feat_fd *ff, const void *bf,
 		 size_t count, size_t count_aligned)
 {
@@ -170,7 +170,7 @@ int write_padded(struct feat_fd *ff, const void *bf,
 #define string_size(str)						\
 	(PERF_ALIGN((strlen(str) + 1), NAME_ALIGN) + sizeof(u32))

-/* Return: 0 if succeded, -ERR if failed. */
+/* Return: 0 if succeeded, -ERR if failed. */
 static int do_write_string(struct feat_fd *ff, const char *str)
 {
 	u32 len, olen;
@@ -266,7 +266,7 @@ static char *do_read_string(struct feat_fd *ff)
 	return NULL;
 }

-/* Return: 0 if succeded, -ERR if failed. */
+/* Return: 0 if succeeded, -ERR if failed. */
 static int do_read_bitmap(struct feat_fd *ff, unsigned long **pset, u64 *psize)
 {
 	unsigned long *set;
@@ -3485,7 +3485,7 @@ static const size_t attr_pipe_abi_sizes[] = {
  * between host recording the samples, and host parsing the samples is the
  * same. This is not always the case given that the pipe output may always be
  * redirected into a file and analyzed on a different machine with possibly a
- * different endianness and perf_event ABI revsions in the perf tool itself.
+ * different endianness and perf_event ABI revisions in the perf tool itself.
  */
 static int try_all_pipe_abis(uint64_t hdr_sz, struct perf_header *ph)
 {
--
2.31.0

