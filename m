Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6790458BC4
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 22:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbfF0UjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 16:39:05 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:48552 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726572AbfF0UjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 16:39:04 -0400
Received: by mail-pf1-f201.google.com with SMTP id u21so2284186pfn.15
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 13:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=8IiyFL9XYdmb5wHoJgzy8S6dZ+cURpeMlIymnpElp2E=;
        b=fp2y5U5k/t5XJ6BNAKHykQ9W8f4Pk5MMSR8/Uj7QHA1q2C3WvGCbg01JCtDwWEGXW2
         3/YQ/1zCChQf7doPSWtsQAGadm3sp0IgZKgnobIFDdC5nFYnNdR5It4AGRu2TrjvCZSR
         SVYn0znVKCLKV/xl/4EwLxqemgLHzQ3/T/mDCSBhelU8mMGn8hYTJk5DkJn+4JtERYjg
         1e8AaitpGXrcyeVhxdGGPpuyH2bJ21hKfOmzBxzX4jRrXe6usrkMUIj1Ktl9rKaB9Dty
         VZd8v69KJwn3/oozog9/4lxZdqcrO83kMd9eOWxTgsgFWG7uoVmozicTM+EUaD6jMgPI
         3ZUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=8IiyFL9XYdmb5wHoJgzy8S6dZ+cURpeMlIymnpElp2E=;
        b=bQAGzwvJIGFE7J3/IHynOK08D0LklvBJ9jb0Dj9nyx3k0cT59BylmXqAcNUfQAGVzi
         hvjkAAFSBJkCcvd215y96CuiYLAg7/skea31DTpq2lImU9oqCgH8CKUH1tPu9k+ubel4
         ejC306sOklPz83BmSPyzp0+i4t76KbLRQ7FBo2P292ME2d8u4nbh4ot39ovcC1OzIjVT
         ub2GPiEJhn4Z5CNNnwfx+IZERHtdVRZ/ihPoQ2deFXgex+f/5O4dXb54FeWGRzzX1yk6
         pwBZPdr6Z+GujiPum46YUixyhWeF5BCSLP46f/wlbHtsw1eID+UZEUmMoKbsvFYt3QBW
         dNHQ==
X-Gm-Message-State: APjAAAV4i3R28mc5yeuTGEn4u5y5u+tNFzLbFz9IPb3cSi0wx4Q9apEJ
        psVz8i3y6sJg0WYShXtFypejDyEuiOHGxm1xoVjTPgi7IRiXZS/9WErCDaKWyd/51+VlgM/YnjX
        giCK8DSJmDxovaULOnLtAvU/8UX1wB6gLl9mGyPqTvHFx9aZzqzmCDA==
X-Google-Smtp-Source: APXvYqwczcWMcBoJMfTWU0RQ/TWDvG/AmW1KcBBPpmLBtEEma45sROXERfR6DRIuZkgENDAbvAG8vuw=
X-Received: by 2002:a65:63c3:: with SMTP id n3mr5507311pgv.139.1561667943294;
 Thu, 27 Jun 2019 13:39:03 -0700 (PDT)
Date:   Thu, 27 Jun 2019 13:38:48 -0700
In-Reply-To: <20190627203855.10515-1-sdf@google.com>
Message-Id: <20190627203855.10515-3-sdf@google.com>
Mime-Version: 1.0
References: <20190627203855.10515-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next v9 2/9] bpf: sync bpf.h to tools/
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andriin@fb.com>, Martin Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Export new prog type and hook points to the libbpf.

Cc: Andrii Nakryiko <andriin@fb.com>
Cc: Martin Lau <kafai@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/include/uapi/linux/bpf.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index b077507efa3f..a396b516a2b2 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -170,6 +170,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_FLOW_DISSECTOR,
 	BPF_PROG_TYPE_CGROUP_SYSCTL,
 	BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE,
+	BPF_PROG_TYPE_CGROUP_SOCKOPT,
 };
 
 enum bpf_attach_type {
@@ -194,6 +195,8 @@ enum bpf_attach_type {
 	BPF_CGROUP_SYSCTL,
 	BPF_CGROUP_UDP4_RECVMSG,
 	BPF_CGROUP_UDP6_RECVMSG,
+	BPF_CGROUP_GETSOCKOPT,
+	BPF_CGROUP_SETSOCKOPT,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -3541,4 +3544,15 @@ struct bpf_sysctl {
 				 */
 };
 
+struct bpf_sockopt {
+	__bpf_md_ptr(struct bpf_sock *, sk);
+	__bpf_md_ptr(void *, optval);
+	__bpf_md_ptr(void *, optval_end);
+
+	__s32	level;
+	__s32	optname;
+	__s32	optlen;
+	__s32	retval;
+};
+
 #endif /* _UAPI__LINUX_BPF_H__ */
-- 
2.22.0.410.gd8fdbe21b5-goog

