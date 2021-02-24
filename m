Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 798D53246EB
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 23:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235306AbhBXWeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 17:34:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234983AbhBXWee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 17:34:34 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48704C061786;
        Wed, 24 Feb 2021 14:33:54 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id f17so2753259qth.7;
        Wed, 24 Feb 2021 14:33:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P2mfwpt99Qi5BsPHIn65vBU52kmUWbq+BvY+SSkyjvo=;
        b=pLQozVRHPRwPgMQaxn01iqlRAXQv+wq/fnS8PH/nfz05ZX7yP2GNpxrJOF0zO3bJQM
         7/KSAJIb7MwXdd/2VqkyMXyaAcLp9sexYFHtMm5aLIUC3jE7N+MO1/XNiBs2nJgLT4TH
         x7FFmpLfQQCAFGwiXrAeH1SE2EGNB8UaXgH4i27/ehkrF1PECE7n1Fl7MxQrAFlyBs5t
         VtGz2CSRywhzhKUMRl95TxtOQiHr0WZVgzZLcs58FX1z1LxzG27ayVpmuZsV8en9b+kc
         rbzdxnckXMzWVDdV6wQEDHgxkNeNzmvZM+aw5M5WRjm4apy6eHjJDCGcOtdODuxm4aFu
         r10A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P2mfwpt99Qi5BsPHIn65vBU52kmUWbq+BvY+SSkyjvo=;
        b=ihaeVar7jDYzIygMRe8lmD4yH6A2FAVicBnYCSoexrqSC9pAp6isNr71l2s93Gd34d
         hLRmzZpAhh4VdyWni5ntC3igzO5dPPYVs/wcvYTSF+d96Q6iRtjMJKWbeF2hJMaNC+FJ
         oEjEoMTvok+0P8LXA7zNonSmSJC4tA7ELwjoi7k3fnax6ju8KrsCL/dVoqrJAialsAqD
         0hnZHdSPyfZqx5UTdHKJuzqwH6RBkaSgbkiax2uE1bTnUodpxI0yjydOhQtVTTACKL76
         PkB0ZCAaRqoI5sJZf2OLD/OqXu9s3TPiAi4MRmJJrROMWe+/AF1clumlmGkAF26ELlw6
         Ujdg==
X-Gm-Message-State: AOAM5335RvIT268pbaLz4pY0+j2Pw15DCEK4aFMeMOCHsSkEFc9BhizT
        pZCIAVg/PgXtzMpjAVZ6mQo=
X-Google-Smtp-Source: ABdhPJynMYC155XCGvq49kTFVwfQqphXiVdSmtr4uMVpskKp05E8twZHa6RKTfNUBe3nzRdlss0wew==
X-Received: by 2002:ac8:1408:: with SMTP id k8mr26857qtj.204.1614206033498;
        Wed, 24 Feb 2021 14:33:53 -0800 (PST)
Received: from Slackware.localdomain ([156.146.54.87])
        by smtp.gmail.com with ESMTPSA id w53sm2449986qtb.54.2021.02.24.14.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 14:33:52 -0800 (PST)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com,
        masahiroy@kernel.org, akpm@linux-foundation.org,
        valentin.schneider@arm.com, terrelln@fb.com, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH V2] init/Kconfig: Fix a typo in CC_VERSION_TEXT help text
Date:   Thu, 25 Feb 2021 04:03:25 +0530
Message-Id: <20210224223325.29099-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


s/compier/compiler/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 Changes from V1:
 Nathan and Randy, suggested  better subject line texts,so incorporated.

 init/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/Kconfig b/init/Kconfig
index ba8bd5256980..2cfed79cc6ec 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -19,7 +19,7 @@ config CC_VERSION_TEXT
 	    CC_VERSION_TEXT so it is recorded in include/config/auto.conf.cmd.
 	    When the compiler is updated, Kconfig will be invoked.

-	  - Ensure full rebuild when the compier is updated
+	  - Ensure full rebuild when the compiler is updated
 	    include/linux/kconfig.h contains this option in the comment line so
 	    fixdep adds include/config/cc/version/text.h into the auto-generated
 	    dependency. When the compiler is updated, syncconfig will touch it
--
2.29.2

