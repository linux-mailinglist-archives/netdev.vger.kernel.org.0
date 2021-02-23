Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27992322B51
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 14:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232829AbhBWNQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 08:16:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232777AbhBWNQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 08:16:01 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6995C061574;
        Tue, 23 Feb 2021 05:15:21 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id a24so9786405plm.11;
        Tue, 23 Feb 2021 05:15:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mpySz8Vhjc9j1bxV4CjFuEkHOJaoVfrCDUxThUdsvTc=;
        b=C4VATtjATC1VnUZ55isI4GSUmrQSNyTm36LD7XiOKnuNkmSe6Vgx7q6hfBsjINx3SN
         ohpfGYVCxeU6ukTr5XLxAHBdp5y9I+o8J8ANm+hasJJOA8jUQWHOv5tTRMp8L11IcGpI
         n9Jn/uSSA63jqaU6naHkWj95i5BmH/MStPmnPDiayInJAaCN4sSm+Zs/+aah37qWR74R
         C7EiywnO5JfPnXcyGNZ9qk4Aq6qnnnWQM6SO53mm1RR6BcK2YgkU7tMU2nY+ZSDgy0J2
         N8853d1BAqKvSR3CXMBalgVzkXAc4AZpRssmiXjYSLnz5QlYC22upAiWDq//z8y9XOlZ
         YqkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mpySz8Vhjc9j1bxV4CjFuEkHOJaoVfrCDUxThUdsvTc=;
        b=j/2g0abaG/s3MWkxs3KwmLjqcg8Q6+uaFdNcXaEnK0hemtikDkH6r9fUQ3b+lfVJoq
         cUUwiiitu7Qgs2XPYSCBBD2SPy9RZTTydEZISSJxcCVh6ZyL7vG/pjOJDHEsBAAlyRI1
         pLmCaBfgcR2E6b3rh/uXoQulAU/95cPkxV9io1FPS7/5K2WWCpX2sG7wdFOAzT6m2CgB
         2+DVms0SKHpN+qpjMbPBSSsBmENyMidHcye9ArQwBb2gD6ZnD5BO9FiqhuvSBgCp/cMO
         zh2Lsmx77iPWnSnT9IbKe6nClOiZRgi3tqPQoYJadvVex898pQzsKyeOpQuuRWc0A0Ms
         RNBg==
X-Gm-Message-State: AOAM531QYI1DLPTXouUeoWUSD/p6CDh0mulRzRmVkWrzX/vKjZO3JxMX
        lJerB0PAroISfD3rdfvOis5pPNEKFKwgUfey
X-Google-Smtp-Source: ABdhPJzHs5hsrqCQjxHnFnzz72uRO0MhlaSWXQioBUwhS3AgL0VLuLSfPJ6amLt101suTmO9IY3CWg==
X-Received: by 2002:a17:902:228:b029:e3:e895:7d7f with SMTP id 37-20020a1709020228b02900e3e8957d7fmr13012871plc.57.1614086120942;
        Tue, 23 Feb 2021 05:15:20 -0800 (PST)
Received: from Leo-laptop-t470s.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o11sm3519472pjg.41.2021.02.23.05.15.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 05:15:20 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 bpf-next] bpf: remove blank line in bpf helper description
Date:   Tue, 23 Feb 2021 21:14:57 +0800
Message-Id: <20210223131457.1378978-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210223124554.1375051-1-liuhangbin@gmail.com>
References: <20210223124554.1375051-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 34b2021cc616 ("bpf: Add BPF-helper for MTU checking") added an
extra blank line in bpf helper description. This will make
bpf_helpers_doc.py stop building bpf_helper_defs.h immediately after
bpf_check_mtu, which will affect future add functions.

Fixes: 34b2021cc616 ("bpf: Add BPF-helper for MTU checking")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v2: remove the blank line directly instead of adding a *
---
 include/uapi/linux/bpf.h       | 1 -
 tools/include/uapi/linux/bpf.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 4c24daa43bac..79c893310492 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3850,7 +3850,6 @@ union bpf_attr {
  *
  * long bpf_check_mtu(void *ctx, u32 ifindex, u32 *mtu_len, s32 len_diff, u64 flags)
  *	Description
-
  *		Check ctx packet size against exceeding MTU of net device (based
  *		on *ifindex*).  This helper will likely be used in combination
  *		with helpers that adjust/change the packet size.
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 4c24daa43bac..79c893310492 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3850,7 +3850,6 @@ union bpf_attr {
  *
  * long bpf_check_mtu(void *ctx, u32 ifindex, u32 *mtu_len, s32 len_diff, u64 flags)
  *	Description
-
  *		Check ctx packet size against exceeding MTU of net device (based
  *		on *ifindex*).  This helper will likely be used in combination
  *		with helpers that adjust/change the packet size.
-- 
2.26.2

