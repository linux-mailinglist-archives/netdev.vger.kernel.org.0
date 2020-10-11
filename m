Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26B0528AA0A
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 22:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbgJKUBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 16:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbgJKUBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 16:01:53 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B05C0613CE;
        Sun, 11 Oct 2020 13:01:53 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id x16so12041643pgj.3;
        Sun, 11 Oct 2020 13:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=tn5Umitn611AeU/nGjwHnxqj/V3fNuGGU1EQjASJeYI=;
        b=piMYo0v0G5zmNt8qN0DKOrVtO4qH/FQUHgtvOoamIAtPwOPOsatw7FD/7M3byxeEpM
         M8wvq2Iz5DMpeSgombV8G2zJKz/TaGg0uaJ1mKNUmR6vG2EN4Z4aaja3ZGohTqUtBJvO
         ykusySr8WrSZNW/yZMfN2wlfNtafolabvZW9trqBjqUNB2G+CZ+nZGqPtJ8tN9bmsyqj
         tNWnZNEyFo5lPKmzZdL7q6rhicUlBu3hYsxjeNSicjPeO9ZpEr4Ee++XcdVVM8dmomAa
         oGDqVzBLV/mvofWMN04CUty9sYi+/urxPYRshs5ss2dpWJbjlw/fqq8GDiWNRRbqTvjt
         fQ8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=tn5Umitn611AeU/nGjwHnxqj/V3fNuGGU1EQjASJeYI=;
        b=XPQ8zS7+EMnMHjYoKCYC1siO5w4yWcQekUF8FC1qEM3LueVKuE/UtV3ZKqNd6pHk5R
         sMXRF/UhJ5iFAJOVmXBSFDutoPZfnCuo+JGYBQ4v+dSHOlc61qjgDHWClg6HCtyZv3xS
         e4Equc+EE69sXnbRESywuW1Ql1PNRWK87hvyO731E1m23MIorsHf0Rba0sri1j1MK9ii
         8jUTWQu34Nz1DGbkFeAxozSFzrKgqH55K2VotNxbhN5XoQL89cHMOx/LNp+NpCNDDrhs
         We0DyyRBltwC0+DKe1y8sDguAF1GyGK49wjVervGydK6uQC9bH/2DKKMvYDH/f680GKr
         ohBw==
X-Gm-Message-State: AOAM530aSxkbmKIDkSteUSi/m3S0GDnW95duXQij0KQ4JhEsdrnqT6B5
        21E+Hw+vyLyD2sQsD8mUXwM=
X-Google-Smtp-Source: ABdhPJx2DhRziAxDOSQdyHIGFx4V/h+NkLUqLXixer2cSDEAsjOx2Q8XxY8knnfVON8Yts+3I6UCyQ==
X-Received: by 2002:a65:5249:: with SMTP id q9mr10787816pgp.79.1602446512516;
        Sun, 11 Oct 2020 13:01:52 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id e186sm18126491pfh.60.2020.10.11.13.01.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 11 Oct 2020 13:01:51 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, konstantin@linuxfoundation.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf-next] bpf: Migrate from patchwork.ozlabs.org to patchwork.kernel.org.
Date:   Sun, 11 Oct 2020 13:01:49 -0700
Message-Id: <20201011200149.66537-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Move the bpf/bpf-next patch processing queue to patchwork.kernel.org.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---

Hi All BPF developers,

we've migrated bpf patchwork to kernel.org.
Please monitor the bpf queue at
https://patchwork.kernel.org/project/netdevbpf/list/?delegate=121173
The new home provides:
- automatic marking of patches as 'accepted' as soon as they land in bpf/bpf-next trees.
- automatic email notification when patches are pushed into bpf/bpf-next trees.
- automatic marking as 'superseded' when patch series are respun.
- automatic marking with bpf or netdev delegate based on
  [PATCH bpf|bpf-next|net|net-next] subject and via file-based pattern matching.
- Fast UI with low latency for those in US and Europe.
- Patches sent to netdev@vger and/or bpf@vger appear in one place.

Thank you, Konstantin, for making it happen.

The patches will still appear at ozlabs.org until it stops receiving emails.
All bpf patches at ozlabs will be marked as 'not applicable'.
The ozlabs instance is deprecated. It will be used as an archive.
---
 Documentation/bpf/bpf_devel_QA.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/bpf/bpf_devel_QA.rst b/Documentation/bpf/bpf_devel_QA.rst
index 75a0dca5f295..5b613d2a5f1a 100644
--- a/Documentation/bpf/bpf_devel_QA.rst
+++ b/Documentation/bpf/bpf_devel_QA.rst
@@ -60,13 +60,13 @@ Q: Where can I find patches currently under discussion for BPF subsystem?
 A: All patches that are Cc'ed to netdev are queued for review under netdev
 patchwork project:
 
-  http://patchwork.ozlabs.org/project/netdev/list/
+  https://patchwork.kernel.org/project/netdevbpf/list/
 
 Those patches which target BPF, are assigned to a 'bpf' delegate for
 further processing from BPF maintainers. The current queue with
 patches under review can be found at:
 
-  https://patchwork.ozlabs.org/project/netdev/list/?delegate=77147
+  https://patchwork.kernel.org/project/netdevbpf/list/?delegate=121173
 
 Once the patches have been reviewed by the BPF community as a whole
 and approved by the BPF maintainers, their status in patchwork will be
-- 
2.23.0

