Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04DE0322AC1
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 13:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbhBWMrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 07:47:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232441AbhBWMqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 07:46:55 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE01FC061574;
        Tue, 23 Feb 2021 04:46:14 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id w18so6608539plc.12;
        Tue, 23 Feb 2021 04:46:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bIU5Fb9CxcQy/ZGariRVhSdvuTdO+nuRkFkp18uwJBs=;
        b=B1TL3YgRM4AieV0pTV2f6PHBNvfCcK4vvJVY4eI2LgiIVQ+r1xwJKzNErI6sSCENdD
         8jRL1uC0/ESEkvUDCdgncXzffsH1TaeWUTCVrF37BIkkGN/w1F0QV7QlikC3Rq8DeuMY
         MKnAl2mgF8PPCCB5U1V/6ulpK7qONGEV9esZQf7UJirRFqUT3cHmrRI94Ced0w6vptRz
         0xmMOyFRKncLo2gNQSOcunMghVBj6E3LxQgAkL/zCWB/7CeMqzgbrAz0m2na2LH1vt3d
         D+bZ4uxpMbbTwuz0rVrqnJqLGdUhvfvaUdkT4vGsRSajdNLS5Jc1KXJgZZK0SFSg+KTL
         Auzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bIU5Fb9CxcQy/ZGariRVhSdvuTdO+nuRkFkp18uwJBs=;
        b=HqtnjmnotGkfK2bYD5qdWRR9ufDAW73vYE12oscQGba2F8y5Vo8KT4rWrIQXD4T3qU
         jqrTg8dxzcEE498hILluf2BWefuQlkPKu+NLrllfi6kDHJD0WlwFqqP+yr2HuKCoWVfS
         leYdb5mcROqsBHSqIaKBt3GAgzDfOVQZBHxsmz6HxHJhQpgAYKwqem5yAbqq8X7arVCx
         ldTZYjC1HtjAu1V++TT8dbd2OvORsu9Pda4SOAxMZG62PvDKC379pejyrqw4vCiqKhuZ
         /Bfolfs+6N4v3yWlNK7LFkL0jG/x62sEkC5qRE7fjV7AnykASGeNjndFdtgfkrjmxZy/
         PQxg==
X-Gm-Message-State: AOAM530/jiLPqNn/xMG3x/GLqgng3fEZzC0FMIjoYqXYc3qZ9xfcDHWF
        03AtgRMkvOzQ6MvI9uxJWlIHYg7kSdK5RIeb
X-Google-Smtp-Source: ABdhPJzuiztf+imXFA8ScPGf2iG7NxgiSM0lUFy2XCFgw01X7q6zZfhtuMy3HimMm7guLmNjtgdTgQ==
X-Received: by 2002:a17:902:c1c5:b029:e3:eec2:98e6 with SMTP id c5-20020a170902c1c5b02900e3eec298e6mr2322035plc.22.1614084374114;
        Tue, 23 Feb 2021 04:46:14 -0800 (PST)
Received: from Leo-laptop-t470s.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f28sm24971475pfk.182.2021.02.23.04.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 04:46:13 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH bpf-next] bpf: fix missing * in bpf.h
Date:   Tue, 23 Feb 2021 20:45:54 +0800
Message-Id: <20210223124554.1375051-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 34b2021cc616 ("bpf: Add BPF-helper for MTU checking") lost a *
in bpf.h. This will make bpf_helpers_doc.py stop building
bpf_helper_defs.h immediately after bpf_check_mtu, which will affect
future add functions.

Fixes: 34b2021cc616 ("bpf: Add BPF-helper for MTU checking")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 include/uapi/linux/bpf.h       | 2 +-
 tools/include/uapi/linux/bpf.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 4c24daa43bac..46248f8e024b 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3850,7 +3850,7 @@ union bpf_attr {
  *
  * long bpf_check_mtu(void *ctx, u32 ifindex, u32 *mtu_len, s32 len_diff, u64 flags)
  *	Description
-
+ *
  *		Check ctx packet size against exceeding MTU of net device (based
  *		on *ifindex*).  This helper will likely be used in combination
  *		with helpers that adjust/change the packet size.
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 4c24daa43bac..46248f8e024b 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3850,7 +3850,7 @@ union bpf_attr {
  *
  * long bpf_check_mtu(void *ctx, u32 ifindex, u32 *mtu_len, s32 len_diff, u64 flags)
  *	Description
-
+ *
  *		Check ctx packet size against exceeding MTU of net device (based
  *		on *ifindex*).  This helper will likely be used in combination
  *		with helpers that adjust/change the packet size.
-- 
2.26.2

