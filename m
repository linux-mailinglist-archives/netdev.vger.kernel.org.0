Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 112EB3D6D27
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 06:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234844AbhG0ELN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 00:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231842AbhG0ELI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 00:11:08 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F0DC061760;
        Mon, 26 Jul 2021 21:11:08 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id c11so14237910plg.11;
        Mon, 26 Jul 2021 21:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YO+3D7atNziJ00YoEqVQ4u+r3Pt08MtNO7aczD+MpIs=;
        b=JMajMSbrz6jIETxWQrupvDuj8oMJlpeN6SfFa+yn8NBvMXHspLLtz38FYe/YoDv2Nt
         8k8sTKDARzFUv9b5TlL3oCV4rBsD2Krkzvd8OqKsWg7+OVOXGQISwgUpBKkoTAMvj10B
         LubPlCt9Berw4/zI7Vj3o4ermiWanEeoDeoA0xnfOtQLhxlhmATsMyGCsGSEmjArG/uc
         SzV/rDDGIlFQencByd0hxZ847sfdYIRf9cVCvyonBRuDXTnDBN0h4nvPPtgc55AVIIIl
         aTduj9UNfwT7y869gkzhbPWDl7FaAkpuqkJ1K+kR3cYpNsv4a8R0FK9BWaRp7Kr4l0/Z
         HO+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YO+3D7atNziJ00YoEqVQ4u+r3Pt08MtNO7aczD+MpIs=;
        b=IF5JRplNRtwEMEvo4hrvTSTqfrXmcfjAZsFcOnoULJSETY7r63n8N9OYL7e0MHs8eW
         mvi+7D+hbkvmXiRazeKtpxbcaEHv+Ixj9q00j3Mp6/JvUqg62HY6ZwTcRCYeEsevFN21
         R91cWA7fzBaAjZ24LbuD3CY9QCieAf4EbnUPuyQZrQb7vBe/jIcN+2w2d49Y93FcjZpm
         62nU4JLykg+tmc2wOt5E/c08y470/TVrh7KIKXEQhLSZQGShyAOJrYQNpaSRWt8/BbWV
         Xe4Y/YN6gL4OCMSjO+bAQuIcGxnbFLmrz46b/1hSbVP5e/uylmUZUvA0i6so/jrL7PI1
         OyXA==
X-Gm-Message-State: AOAM530OZ0N2AAbGmBi8KzBmC33hWrPjusUy+/0uzfzSlyCCS3izGedn
        5n3Pe/sHo2434KEeIkYaok0=
X-Google-Smtp-Source: ABdhPJwJ1xXU9+7YooWY30U9PI49GilcOic+Az1jVR8aLQrIzBxWCFBWte3/N1KlnN+nFubI9qlCGg==
X-Received: by 2002:aa7:90cd:0:b029:333:baa9:87b7 with SMTP id k13-20020aa790cd0000b0290333baa987b7mr20911504pfk.23.1627359067723;
        Mon, 26 Jul 2021 21:11:07 -0700 (PDT)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id p3sm1493866pgi.20.2021.07.26.21.11.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 21:11:07 -0700 (PDT)
From:   Juhee Kang <claudiajkang@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, Yonghong Song <yhs@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [bpf-next v2 2/2] samples: bpf: Add the omitted xdp samples to .gitignore
Date:   Tue, 27 Jul 2021 04:10:56 +0000
Message-Id: <20210727041056.23455-2-claudiajkang@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210727041056.23455-1-claudiajkang@gmail.com>
References: <20210727041056.23455-1-claudiajkang@gmail.com>
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

