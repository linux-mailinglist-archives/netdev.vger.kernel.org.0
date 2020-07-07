Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B42FD217710
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 20:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728697AbgGGStY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 14:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728149AbgGGStY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 14:49:24 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E069C061755;
        Tue,  7 Jul 2020 11:49:24 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id o13so17452052pgf.0;
        Tue, 07 Jul 2020 11:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7RW9GAycy/jYfe9G8gcHSdEtkDOt5RXoXGNV39lXC5Y=;
        b=m5UbdUUCNhO957dJ+XGx5PeujhizbX4+EnBxX26qbG88wLmDyzjD2jtfxbwXFQMjYw
         dpmjA73fJGZ1sWveWAocFnZRsq9Wpo3DRK3hyqWWAsFpJsXK9o6ptHqvObru7/AOuWSL
         zW7CbxR1C7doM0W7jdu/TXEcn07hxyLoBizzckbWGGBWRJdbtLTdOcAJKigF3C4H+YBb
         6QYFzZKhPQb98LB+vafsD2prc/pB5CwcDEuYCUc9K1wMd2nRHrh115nkEC1svx2MqmMv
         GoOZ8vob99h3kY22WEZe460Pkq9DHPAFfDrYhRXjfP4d9PJxsz0DQ0FPaRnTiAA9tvZS
         94lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7RW9GAycy/jYfe9G8gcHSdEtkDOt5RXoXGNV39lXC5Y=;
        b=M984IVQaQDW/rLOPGzhCB0jxZ2hzJF/1ruySEkEF5llzYHHJk8GPtoooekHAsIn/ah
         ++3YLkbtQ0rvfHpFdBhJ55e6QBkJeME0oGymeojk62U4StKc+DCh3VXPhMYWx5BlYs7D
         W+lcqgIMBLnEChtM08wB2haX7vt70yGdAG8tg3975wXieQoDaRI5QDweUO890+kPOS09
         TYnuy3zn7W3xqPOoLukgV91jIquLOTvxgk9rSLR6kyHy3lprnBHH+tz4lGwmH3tFkjB8
         ODiqg1rViWWcrQwV3DcqeTl8Qlq1TGHwCQ6qALHN/7U83CRXIExbjfC7UvsqtYt+enCv
         5Fkg==
X-Gm-Message-State: AOAM533cWbYOhWkTWyGOR1Xk0m5QZtp5CgYa6u8TNWVXoufBcly8Z0Ds
        wA3SdDeLJy+3Qvx1nRm7Yw==
X-Google-Smtp-Source: ABdhPJwwZG18SleZEjYE9DRAnMrEAAtl/pn+jZMt9BqCqFJa19sHe1qXgcHQr2jcbQ7+QdmtrN1bNA==
X-Received: by 2002:a62:fc15:: with SMTP id e21mr50922381pfh.167.1594147763559;
        Tue, 07 Jul 2020 11:49:23 -0700 (PDT)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id r7sm1625278pgu.51.2020.07.07.11.49.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 11:49:23 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v2 4/4] selftests: bpf: remove unused bpf_map_def_legacy struct
Date:   Wed,  8 Jul 2020 03:48:55 +0900
Message-Id: <20200707184855.30968-5-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200707184855.30968-1-danieltimlee@gmail.com>
References: <20200707184855.30968-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

samples/bpf no longer use bpf_map_def_legacy and instead use the
libbpf's bpf_map_def or new BTF-defined MAP format. This commit removes
unused bpf_map_def_legacy struct from selftests/bpf/bpf_legacy.h.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 tools/testing/selftests/bpf/bpf_legacy.h | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/tools/testing/selftests/bpf/bpf_legacy.h b/tools/testing/selftests/bpf/bpf_legacy.h
index 6f8988738bc1..719ab56cdb5d 100644
--- a/tools/testing/selftests/bpf/bpf_legacy.h
+++ b/tools/testing/selftests/bpf/bpf_legacy.h
@@ -2,20 +2,6 @@
 #ifndef __BPF_LEGACY__
 #define __BPF_LEGACY__
 
-/*
- * legacy bpf_map_def with extra fields supported only by bpf_load(), do not
- * use outside of samples/bpf
- */
-struct bpf_map_def_legacy {
-	unsigned int type;
-	unsigned int key_size;
-	unsigned int value_size;
-	unsigned int max_entries;
-	unsigned int map_flags;
-	unsigned int inner_map_idx;
-	unsigned int numa_node;
-};
-
 #define BPF_ANNOTATE_KV_PAIR(name, type_key, type_val)		\
 	struct ____btf_map_##name {				\
 		type_key key;					\
-- 
2.25.1

