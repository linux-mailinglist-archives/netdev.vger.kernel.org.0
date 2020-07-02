Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36CD2211A08
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 04:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbgGBCRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 22:17:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbgGBCRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 22:17:12 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CD34C08C5C1;
        Wed,  1 Jul 2020 19:17:12 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id m9so1570120pfh.0;
        Wed, 01 Jul 2020 19:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7RW9GAycy/jYfe9G8gcHSdEtkDOt5RXoXGNV39lXC5Y=;
        b=RhjxyAsKkFT03Yq41wnm8qaneC+trRbRkIh8eclDKadEuXVRzm8dYYaKDj37kBOfYD
         uTNN74EYsDhwKWhGxAMtC4Ov/+0xwcRXvP/dQZWsl2PnD/ju1dA68rUtOGkIw1BXEF0h
         ESdQGHAXyQFckaTqsmcHhecy9AJuoBuCdOi8GGAdyXs9xqtoWquQ0uIkNG1I4sm1vSc5
         ednb5Sy1t+hnDQhGRUgA+ta0iocgVeNp6Yt0ptPtav6qJqROh2w2SdUzTr/TC3MbDEJd
         aCPscGYfmgmhJ0R4t0YgM/Ng37OmqM3etnP3gaR1iT2yRa5ky4hgrqGz9qeXFSXCffio
         MfMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7RW9GAycy/jYfe9G8gcHSdEtkDOt5RXoXGNV39lXC5Y=;
        b=haEus1j8Ioge5NXVlhZK7rWqaUxwRJzlbxG8M50DMam4/vtjML8QPf/y3usjQAv6x0
         YAuoISmZOdwU/ZIWX1/JbMvwbnWrshckikq2GRbX1FOIhtCBZJgd//F4iz7uKcl6L1Xh
         QtTmDkrpiqoByqXOI1mFTBSiYQMLz8vQ9b1phhhclfSST65NDd0B1mF00x7xMu4PvmV3
         vAo0znbS3y+N5sacRHERxrHbsI8hHH6tUJg48U65lK5hONQsLg1HUozvtmHEptLQ+2wh
         mN3zUHGGcPi27b5ZowcHxBua9hR162OaZvTIUeM+vi/hptLBJDuxNr2E1HfntXbFuxtm
         uw7Q==
X-Gm-Message-State: AOAM531hhuW1Gqv0x5PMHECwliI/t2BU0gCwPBfBQVpbjW2WKrjhUxaW
        l5uZAd3yUTemF6UCP5kG/g==
X-Google-Smtp-Source: ABdhPJxBEvLQHAQgF8jj/Z6523bo3tbcOzmFaSa3gsVxtRhqDCMgm9bpm4JJcHby/Ql18emBNfEzCA==
X-Received: by 2002:a65:6150:: with SMTP id o16mr8013698pgv.237.1593656232162;
        Wed, 01 Jul 2020 19:17:12 -0700 (PDT)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id s1sm6428828pjp.14.2020.07.01.19.17.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 19:17:11 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next 4/4] selftests: bpf: remove unused bpf_map_def_legacy struct
Date:   Thu,  2 Jul 2020 11:16:46 +0900
Message-Id: <20200702021646.90347-5-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702021646.90347-1-danieltimlee@gmail.com>
References: <20200702021646.90347-1-danieltimlee@gmail.com>
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

