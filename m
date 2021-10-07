Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8721425C77
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 21:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233431AbhJGTqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 15:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233668AbhJGTqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 15:46:43 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6451DC061570
        for <netdev@vger.kernel.org>; Thu,  7 Oct 2021 12:44:49 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id s15so22510166wrv.11
        for <netdev@vger.kernel.org>; Thu, 07 Oct 2021 12:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eTLklvS6n4ZoeO8G/VL3RqzY+0DOV///7GFoZeh5A2M=;
        b=fIhOaDOKmB70iXA21sGcmd8cNGz2gNRmKpKbQzB1w9DU+TZ/z9/gmxfC9rg6YkN/3R
         WkCaE/BM1qDc9+jK3W1Udx9JvVRu3FrOXg7EofKe4590Jc8AG0S1hZsI5FYFFe1ugnP1
         gM/SVTC278gvsdLb57/MLVjn4Dk/cmDiba805613MLSfdf4VzubTRpy9aT8L7lQfYOf2
         e44hgdfsv8in02AKkGaYWypFAV2IwiSnZr0ehLGIcBJrJ2RzmdwQq+PxAh7jLeniriDV
         AHIg2qi45TjUvP43QXb8ydnNfg8tJBF1HRWD3raYq6S2a/R1dyV3mWMN4QFhIxzfRl2S
         wlWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eTLklvS6n4ZoeO8G/VL3RqzY+0DOV///7GFoZeh5A2M=;
        b=VxtOQTaSbXA0dYW8mrctkTltnfd/EqGWDOQlmE1Eu/GogXdbd3dMZOqes4/gkqlPto
         qR9gjmBdUvBPBoSwjtsYW+MEt9wXRQPmLFbJWFYrO0ecGtBeh4d7/Ldwou3TPSk/9ziq
         T185LCasU5j2w3VkbaoA3WTrP70c7mmPgTqWhxJwV2fb6SZ5ptqISaq2NiS9eNYBsqMR
         orfVaIynYBfVv089HqFNJdWaJvuG3F2YvCbYhgBq5F8lLfE1zTuJj3YB8dZOOucWvMFy
         dRW9due7KWfFmjNH/cD8V+rdGpFufTMY2PdtoQgcJhcYUsqfZT/aAU68UIlxLm/0opKC
         Ke5Q==
X-Gm-Message-State: AOAM530bnyzPnmcwWn7USQrf6sfNmcuW7Mm/7GrWiKS9EZt+Rg+4a/HJ
        L9TuQ5u6sKHQ3v1l2Jx5fc8Lng==
X-Google-Smtp-Source: ABdhPJxDqyJB9FD/J0QYZEyG29k7cNP4ykuea8DxzHHyaPdV5AOVQGDu3/Qq5z5pJUL89eKhSNSGRg==
X-Received: by 2002:adf:b185:: with SMTP id q5mr7856190wra.213.1633635888031;
        Thu, 07 Oct 2021 12:44:48 -0700 (PDT)
Received: from localhost.localdomain ([149.86.87.165])
        by smtp.gmail.com with ESMTPSA id u2sm259747wrr.35.2021.10.07.12.44.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 12:44:47 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v4 02/12] bpftool: remove unused includes to <bpf/bpf_gen_internal.h>
Date:   Thu,  7 Oct 2021 20:44:28 +0100
Message-Id: <20211007194438.34443-3-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211007194438.34443-1-quentin@isovalent.com>
References: <20211007194438.34443-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It seems that the header file was never necessary to compile bpftool,
and it is not part of the headers exported from libbpf. Let's remove the
includes from prog.c and gen.c.

Fixes: d510296d331a ("bpftool: Use syscall/loader program in "prog load" and "gen skeleton" command.")
Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/gen.c  | 1 -
 tools/bpf/bpftool/prog.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index cc835859465b..b2ffc18eafc1 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -18,7 +18,6 @@
 #include <sys/stat.h>
 #include <sys/mman.h>
 #include <bpf/btf.h>
-#include <bpf/bpf_gen_internal.h>
 
 #include "json_writer.h"
 #include "main.h"
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index a24ea7e26aa4..277d51c4c5d9 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -25,7 +25,6 @@
 #include <bpf/bpf.h>
 #include <bpf/btf.h>
 #include <bpf/libbpf.h>
-#include <bpf/bpf_gen_internal.h>
 #include <bpf/skel_internal.h>
 
 #include "cfg.h"
-- 
2.30.2

