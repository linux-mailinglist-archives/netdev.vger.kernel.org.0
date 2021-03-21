Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3CC34307A
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 02:22:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbhCUBKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 21:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbhCUBJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 21:09:58 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E07C061574;
        Sat, 20 Mar 2021 18:09:58 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id c4so7056519qkg.3;
        Sat, 20 Mar 2021 18:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LLjFApal9gMK0Vx1mZd/SlRCzWigv0Q0T5Vb350wjfY=;
        b=Lix9A6KbGtt46lOUgEVcJ8iZ4szAIjbq1m4AObtr6mgHNDLgO70SiiMQf4c9QOIHkA
         cqnlKCWfD7T7aV1JKgJMNJjS+pw7xRT/Y/5c/j23HH+LUIJCUYD2lIC9OeNXrimgQ9U/
         wd5rcBpE7SYyYgZJx2tULoEpgOQ1JsjA/DsHd4Qy7JgGY4ZF0slL+Ugn5cih/MFATBlS
         byEtZItmDiMhwQkWswqR251Css1JlM2mAz0iOXsE1xlWVLp6d1ISX3Rj/Z8x/13pKbs1
         QjjqGwTN5RUqygW/LKhskhJ9JOee5OqVj0yeXEW6XDZ31rdjwv3WveOUJjSISpj1aIxd
         oWoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LLjFApal9gMK0Vx1mZd/SlRCzWigv0Q0T5Vb350wjfY=;
        b=rXgEP1Intm4XmE/mGIEAW0VIpJbTEUtGotfjkk4ltq76XX4oeK4bql0wCBikTkOSaz
         LWfKg0XSLuOgziN+cUUUZSSxAnmpXet7+3Sl5wUamNATgc44LHiHBLCbqD6wIEo9NfU9
         L1dndjyBZ3g49YWcOmIt+8UmqGwtRf4bg8VW1olFD1ehWUkxQ9GX+2ute5tM3Hvi68aD
         BfPEhOWu1/hNhVjK33x6CKCh6PgHmgCh494r3blwnK+H2UmuaX9OTHmTRfIjD0bsWJLT
         8TtrKPA4oh492Qu74tJMj8qD4yjgnScQg1WikW9VlekbgqvkZeM0kXd69vZTYKBcEh89
         nj4Q==
X-Gm-Message-State: AOAM533q2s4mWttUR2dt+MxKEEoBqEezK4ABEx+4VTOIusytV8OwiFNr
        K7JfJb+F6AbVbu3ZnXsn82s=
X-Google-Smtp-Source: ABdhPJx3zZaiRjkaCybT6CcSThfX623bMOcePVOKmOGP9s36WJ7j5xF0KPA3P/7eoyTF6e3+MQcLNQ==
X-Received: by 2002:a37:8cd:: with SMTP id 196mr5028109qki.434.1616288997831;
        Sat, 20 Mar 2021 18:09:57 -0700 (PDT)
Received: from localhost.localdomain ([156.146.55.187])
        by smtp.gmail.com with ESMTPSA id 73sm7816448qkk.131.2021.03.20.18.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 18:09:57 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
        mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
        jolsa@redhat.com, namhyung@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] perf evlist: Mundane typo fix
Date:   Sun, 21 Mar 2021 06:39:30 +0530
Message-Id: <20210321010930.12489-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


s/explicitely/explicitly/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 tools/perf/builtin-top.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 3673c04d16b6..173ace43f845 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1607,7 +1607,7 @@ int cmd_top(int argc, const char **argv)
 	if (status) {
 		/*
 		 * Some arches do not provide a get_cpuid(), so just use pr_debug, otherwise
-		 * warn the user explicitely.
+		 * warn the user explicitly.
 		 */
 		eprintf(status == ENOSYS ? 1 : 0, verbose,
 			"Couldn't read the cpuid for this machine: %s\n",
--
2.30.1

