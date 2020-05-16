Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE171D5E6A
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 06:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbgEPEG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 00:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726602AbgEPEG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 00:06:26 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FDB5C061A0C;
        Fri, 15 May 2020 21:06:26 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id b12so1728829plz.13;
        Fri, 15 May 2020 21:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sSgztYEmhvB72RB8KtBYxKHKnLaLpFHzEKJ3wJXrzJc=;
        b=nUvyOK3i3IyTMfyHOqi0Eu8JXNMuQUsPg2e7zgM9Ro/dkUTL0Wj472mBtiSUapHEz8
         Sn83Xdk13jRMGukNBiovJaZljuf6EQmnWqAw62EyytUEoU/OpAkia+4wLQPwhb0i83t3
         MgzvD34nfToyC/XUXqOpH6aL51VA9JRdzsBpcVx4wOQ2JzN1bfAzennSFSG2X9ipQJY0
         /sVYNPyE8QF5YC5EQejUyBtWbfwl2a4TeNVy36ivD05y4Z/tVwbi7jFyw/Q843wdV7Md
         DRfLkprH5yHYwywmG/KdsZO2IdB9rMdjbgNNE4aaKmYIUFWC6DdTKo95e861ZuLV4Wzt
         nwCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sSgztYEmhvB72RB8KtBYxKHKnLaLpFHzEKJ3wJXrzJc=;
        b=PAPChmTbxNytpciNG5FEg9l8+85oVvqKuwMqGk9qdLkWmrQ6yZyqADK2FecDQizLKM
         TQuC5cuxfle8efiFtLxJXjW8LrwT6X2/NE14/fqg6F6tt8CnTwdCi6xnpeUeWJLlj+bz
         RaDcgUQ9/HBHeVR71aO4U1ujZJjYpQ2USYXh3t9iZs2lL6kNEHccS32i9jPW4n0TKUJl
         UaeGP9p/gzLkDxJER5qcfLMK4Yx4icULg2YrhV42Ag2b+ozAJEWTpdM7vEy5HZgRG/v8
         q9SXRA0wSLGf2N8QFPC981z+e0LPlTrhml7JYWGUhKV+Gwtsnxy+ActuAbklZC/bEVGb
         GeVQ==
X-Gm-Message-State: AOAM531iO2aay7UXKogSPcDqpB/L1d1vu15+LBXR2uZP/Z/1xFTKU8j6
        5ADsAg5p148yqrYrihdhWw==
X-Google-Smtp-Source: ABdhPJyzpw33zLAWiLhmBtZNl2jFkjaZkfcccTKC8yLKctZmCVtxA9CM+UDcVn/Bv/iXjsM6xgl8aQ==
X-Received: by 2002:a17:90a:9e8:: with SMTP id 95mr7223601pjo.189.1589601986194;
        Fri, 15 May 2020 21:06:26 -0700 (PDT)
Received: from localhost.localdomain ([219.255.158.173])
        by smtp.gmail.com with ESMTPSA id b11sm98663pjz.54.2020.05.15.21.06.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 21:06:25 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH bpf-next v2 4/5] samples: bpf: add tracex7 test file to .gitignore
Date:   Sat, 16 May 2020 13:06:07 +0900
Message-Id: <20200516040608.1377876-5-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200516040608.1377876-1-danieltimlee@gmail.com>
References: <20200516040608.1377876-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds tracex7 test file (testfile.img) to .gitignore which
comes from test_override_return.sh.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/samples/bpf/.gitignore b/samples/bpf/.gitignore
index 23837f2ed458..034800c4d1e6 100644
--- a/samples/bpf/.gitignore
+++ b/samples/bpf/.gitignore
@@ -50,3 +50,4 @@ xdp_rxq_info
 xdp_sample_pkts
 xdp_tx_iptunnel
 xdpsock
+testfile.img
-- 
2.25.1

