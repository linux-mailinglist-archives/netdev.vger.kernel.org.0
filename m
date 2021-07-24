Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3420F3D4850
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 17:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbhGXOlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Jul 2021 10:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbhGXOlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Jul 2021 10:41:09 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB14C061575;
        Sat, 24 Jul 2021 08:21:40 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id a20so6780959plm.0;
        Sat, 24 Jul 2021 08:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YO+3D7atNziJ00YoEqVQ4u+r3Pt08MtNO7aczD+MpIs=;
        b=sWfQx2byWQ2XbJr/7AlVtlK+ZHLARyzVkDMrboDJKFf+GGtHlDyNOcUH9Fz6pW0BxK
         HFl8sBcz84XqB8IoGhvXpwJhdrr/g019BHk/B+geRKW4CFa3ah9x1+sugScKHyKYQFtd
         dGW4HhjyROkKhkDAb0YWhwwNkiR+olAKeHNL0Ih1bkxKm8z2NG+WAhCmvFFJtsDEjaKe
         LWztnqEFO1lT6ynyvimLd3hricLi+OCSm21JgErch+qkRmDeSKqNH7Gp6bX5/1lqw/FN
         /kuA1yNVR82ztAuIty/5EAUykzj9HjJfLSxV3Hi4ZvsDPqv+CavIroHhZ3BtM0vcRv42
         1rig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YO+3D7atNziJ00YoEqVQ4u+r3Pt08MtNO7aczD+MpIs=;
        b=HiB23Om8ijLcMUnOrCGsgQX5WV/7Grujxu9VQFYbN4tjqYMDDuHY6+RoUzV7ILXaMB
         gDoUgTNpP1HEhZMC1/Hntupih61x+0GExaDEdAzTkMld3+1sjuzOWU6zcgbJ/s62tduX
         dmtTP1eaJUR3oE23c0Of6EUinSewOF8tkiytovphTPtdeP/POTjbEzuG1bpWVD/m6qTX
         dNAfl19GuhCEl6P7P4lZtH1lmQrTmW/hfUiR/6vRfi9THRZpn0I1OD/DxaX3Ic36+E8M
         sCT4AjO+FWXkcAdrYJCq0/4WpKe1OwCsFN1XMUl77MJgw2QMx5Bo1+oR/b+28SnJt5Bm
         0tkA==
X-Gm-Message-State: AOAM53189qe22pcRYzKL0HEPjLYEPOqTRV0Zk2hDFwE0qYuo+6EM1FCi
        IoLBZSi/QVKN0ucWsCANmBE=
X-Google-Smtp-Source: ABdhPJy16SLT3P10eQ03C9l87/erJd/C/uV7Tf0YFLXDviZnwUZE/S9GPDy+jKPj3Vp4SB9zFA/Ykg==
X-Received: by 2002:a63:1551:: with SMTP id 17mr10016420pgv.76.1627140099737;
        Sat, 24 Jul 2021 08:21:39 -0700 (PDT)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id w22sm36682527pfu.50.2021.07.24.08.21.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Jul 2021 08:21:39 -0700 (PDT)
From:   Juhee Kang <claudiajkang@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [bpf-next 2/2] samples: bpf: Add the omitted xdp samples to .gitignore
Date:   Sat, 24 Jul 2021 15:21:24 +0000
Message-Id: <20210724152124.9762-2-claudiajkang@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210724152124.9762-1-claudiajkang@gmail.com>
References: <20210724152124.9762-1-claudiajkang@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are recently added xdp samples (xdp_redirect_map_multi and
xdpsock_ctrl_proc) which are not managed by .gitignore.

This commit adds these files to .gitignore.

Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
---
 samples/bpf/.gitignore | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/samples/bpf/.gitignore b/samples/bpf/.gitignore
index 0b9548ea8477..fcba217f0ae2 100644
--- a/samples/bpf/.gitignore
+++ b/samples/bpf/.gitignore
@@ -45,11 +45,13 @@ xdp_monitor
 xdp_redirect
 xdp_redirect_cpu
 xdp_redirect_map
+xdp_redirect_map_multi
 xdp_router_ipv4
 xdp_rxq_info
 xdp_sample_pkts
 xdp_tx_iptunnel
 xdpsock
+xdpsock_ctrl_proc
 xsk_fwd
 testfile.img
 hbm_out.log
-- 
2.27.0

