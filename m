Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 760F425D172
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 08:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728163AbgIDGdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 02:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgIDGd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 02:33:29 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3FCC061244;
        Thu,  3 Sep 2020 23:33:27 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id u13so3839227pgh.1;
        Thu, 03 Sep 2020 23:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f5n/OPSDhM3uanqKb+YL48CfWwtA6HLpmv/RHBP/jyY=;
        b=kkr/G8wtE4y3UOmBvwTlMDemR9VTBYMtfDA0+BMjOb5UvJC06dmFfY/WrSGBhkhpUa
         2RzRYGprc6ecvlEPx4hFEvI/x0xnS07jHinAzETkBa92eTApkwEWW7TmxZWb04y0frg7
         iTwX70mr5Io/8mF7QFzdy7TnpJxhayJGC8dFiY790TdVxkO7HPwjke/wNPYgciZqZoye
         F/XGoNqDyI86U7UTjmMpfUSinx4a6qcGdOYukRuxEl+uwIbBCql9z7oWlVbOM0+590um
         XDm/Ypqlx/KwglpLzV9T+voprRygWx2YUYdIADjYJipjGn2xcHcAGP9QB8Vr2bUeeVp7
         QDpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f5n/OPSDhM3uanqKb+YL48CfWwtA6HLpmv/RHBP/jyY=;
        b=ssXcUNZcxrgt8pIuufkJemy2s2Kqy/O9u8M/oOOL8VOq9iAqQNVJDPR3sQ/gr50enL
         KTxJIH800fPRwrFu5k9fG5GVbzDHUw+5inHaoAxI0nPdWYl2otbYZFQKd9P9KFStdBpW
         OImM/V9UhXDj6bM+HgXI1Ugb7DbEpjc+cHSfPU4cGUzMi6E7vRCGx8z5xhNy1xjU1s35
         mRIl2N8Ei/O61GPkEeYwSxUcybGEP+jsOf69kjH9ali/aX4oTu2ctyV4JVUwg/2ewIwR
         vTUBKcDs7lw0OaZdonEA+IpMeT1Aor06TTf8TIpOoeZHMZ3fWrg1GLi9WAS693PNNqdF
         bPQA==
X-Gm-Message-State: AOAM5328pC+r8XNU0qZ2jmDi48ewbTzHDu/X5t5Fy3pLAIXvyJ2kSiPN
        9kUzYssQsmXMqwKoMFIP6qpbDhMz7g==
X-Google-Smtp-Source: ABdhPJzBHUq5nZBvZXJxBIPfk1vjd84/iN3s0Jc37wJnyVOtWE9DSem87o1P9fY/j+rrL3BEVnAYtQ==
X-Received: by 2002:a63:516:: with SMTP id 22mr6221324pgf.316.1599201206864;
        Thu, 03 Sep 2020 23:33:26 -0700 (PDT)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id i20sm4865020pgk.77.2020.09.03.23.33.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2020 23:33:26 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH 2/2] samples: bpf: add xsk_fwd test file to .gitignore
Date:   Fri,  4 Sep 2020 15:33:14 +0900
Message-Id: <20200904063314.24766-2-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200904063314.24766-1-danieltimlee@gmail.com>
References: <20200904063314.24766-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds xsk_fwd test file to .gitignore which is newly added
to samples/bpf.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/samples/bpf/.gitignore b/samples/bpf/.gitignore
index 034800c4d1e6..b2f29bc8dc43 100644
--- a/samples/bpf/.gitignore
+++ b/samples/bpf/.gitignore
@@ -50,4 +50,5 @@ xdp_rxq_info
 xdp_sample_pkts
 xdp_tx_iptunnel
 xdpsock
+xsk_fwd
 testfile.img
-- 
2.25.1

