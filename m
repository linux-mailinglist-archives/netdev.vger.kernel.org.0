Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30CFC2D59CE
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 12:56:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731475AbgLJLzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 06:55:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729321AbgLJLzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 06:55:45 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3AF3C0613CF;
        Thu, 10 Dec 2020 03:55:04 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id a12so5172542wrv.8;
        Thu, 10 Dec 2020 03:55:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CdxG881XmVcC+3BxAJE5RLPRTwKuGEBk/qTCPUmATks=;
        b=BE3LGOddDLEk5ES4jCs2wfbqmVXp65l8oovj439lSBjoplOuce1Ge27ta+eNc/8zNg
         GJXXcpqzYpj2HgDrizRnh4nBFUONs8/+NgtwuSYPFUeZTswc4aEh1kXTRxGsuTaiRjRh
         DlXJOn9C9FtuKweaHzpxVLbNPBMzp6Pu3+DBdFYEsPpgbNnyZqGPx98ikXHdrz5a+X1j
         U/RuBSvNNAKL4C1MdfrEBeTDKfH0AETmH0OYtTR+kDZvXH1ZWwvpF3qlxWSjJdTpR5sv
         YgPL0AMkRRZVFoYj+h4X0w3IzWQkEnmjlXhbpyNk9pUqkDtD6zuFu4Umq2gy9FCwpudG
         lioA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CdxG881XmVcC+3BxAJE5RLPRTwKuGEBk/qTCPUmATks=;
        b=dN26PV226kh9ZRwlZflfaWaHfPSILNOZmCkLNCh3JhtBkGzdCFWTJq6BlymM+iobua
         UJzfy300F0j8CyKqqnlsN+vF5qr6idCNkeFN4G8JJApSEWfiTcozxcw4RZrKG6Lvh8z7
         t62fYAL3UNLHvZTiAEwce/yu0PWVwJ7FzW4QYkzUl5pE9ottER0pWi9SU8GjwbSQACTx
         rKdXLXMpzWtt8rg+TGFoyIPMRLZhRruw90h8GAYndRYiKNJC49FsRQMnFv//0gnHGgbx
         kTsxyiwua6KNeLXncMJkvjqQSvnpIgnlc68VTwiKQd3UY78pBp6/qeL9lAJels/g7Q5T
         MUYw==
X-Gm-Message-State: AOAM533EpxSRcZRZyhHqZSN1Quxqe5KhFobjGv0DR/lVRBw09yTa4FRw
        hpht/e6Issub8b0JfLyCy9kiUKyiCV1u9LHhAlg=
X-Google-Smtp-Source: ABdhPJwkXJT4Mw2QMaX63UxXDVd9mFEzdnXeZ0jGYjnF0YJG/MhM8piq2MFCUq+t9VMFNfnbJGDKkg==
X-Received: by 2002:a5d:4209:: with SMTP id n9mr7689169wrq.128.1607601303015;
        Thu, 10 Dec 2020 03:55:03 -0800 (PST)
Received: from kernel-dev.chello.ie ([80.111.136.190])
        by smtp.gmail.com with ESMTPSA id a14sm69033wrn.3.2020.12.10.03.55.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 03:55:02 -0800 (PST)
From:   Weqaar Janjua <weqaar.janjua@gmail.com>
X-Google-Original-From: Weqaar Janjua <weqaar.a.janjua@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, yhs@fb.com, magnus.karlsson@gmail.com,
        bjorn.topel@intel.com
Cc:     Weqaar Janjua <weqaar.a.janjua@intel.com>, shuah@kernel.org,
        skhan@linuxfoundation.org, linux-kselftest@vger.kernel.org,
        anders.roxell@linaro.org, jonathan.lemon@gmail.com
Subject: [PATCH bpf-next] selftests/bpf: xsk selftests - adding xdpxceiver to .gitignore
Date:   Thu, 10 Dec 2020 11:54:35 +0000
Message-Id: <20201210115435.3995-1-weqaar.a.janjua@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds *xdpxceiver* to selftests/bpf/.gitignore

Reported-by: Yonghong Song <yhs@fb.com>
Suggested-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Weqaar Janjua <weqaar.a.janjua@intel.com>
---
 tools/testing/selftests/bpf/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index 752d8edddc66..f5b7ef93618c 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -36,3 +36,4 @@ test_cpp
 /runqslower
 /bench
 *.ko
+xdpxceiver
-- 
2.20.1

