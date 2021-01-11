Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF0F92F19BB
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 16:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732182AbhAKPcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 10:32:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbhAKPcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 10:32:08 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51715C0617A2;
        Mon, 11 Jan 2021 07:31:28 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id 190so210849wmz.0;
        Mon, 11 Jan 2021 07:31:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=ainL+gf/mI7XGV06pxoex50mFeblVQiOmvn0PY1hDZ8=;
        b=agB7ehSa0PIlEPE4KyHhmZZmMUqzg1u04v0in/yEL5tuvYA93oKwunMSeJ8phX0p35
         OuHS3qwle3aaF8WRyDmkZYNpnhfkVGxmwBvUxQxN1jX/suBeB82Lq5L5Wp15sIoB5KrZ
         cNCWLY2Mejz4LeREQ2gGltGcA5CD+65tbreoSuGSK3q+Toq17pA1d4Nx1UhOS+CNbMjS
         CnDbxXCFzge0PJupCVdV1IlmYEz1aR1NzXdwAzHi2rYQ1Vm770GkWis8iMkNubDIYKmk
         qdQxytEMGz/0IDiRUDHWLI0vKtqJXQg0IoOhVr9ehDyQjaLAW5BV62MIGY2xpxvW/xsZ
         +TOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=ainL+gf/mI7XGV06pxoex50mFeblVQiOmvn0PY1hDZ8=;
        b=lFSJNW6FglPyLPWV95UAgqbXePAR1q0Ic+G2wNwu7Y0qtKlzCVV/0RsGxcOCByiGaa
         4PKTFmIT/oCdacjBmb+QjCT9iHvIKIQOjc9ki+Td5pm+W0Ujpem8tMf0HPwKcLjvL+Re
         0oCB6QAPCsz3C2ZpeiqmKPRCUQtylrDQN+M+R6dUmYz1zDEeAjLGXY3fEdZvK79ZYSqy
         S5H2Y7DgbmyR63ktr0eUfcQtXNWDCj43Zky21UYQ8kS+uM7A252ILTixBoYMD+mC6oqG
         TyDiWY/SEy3QC21zBNph5M5eCR7qxIyp4pEP8W67cuXDhXyRhKVAv+1uTlVl2yyjdSRD
         0gWg==
X-Gm-Message-State: AOAM530pIPH1MAV2EDJ0SgMUjyJHhY3YEHIG411TELLNXbm/yLF6S6CR
        pOVxSs0Pew7pr5nU3Jr2b2y1hDu7egfjAkiL
X-Google-Smtp-Source: ABdhPJyqoE4ADfB0vSxGuNGJ/iRaxXz+w3WROj3M2s1CkONuqGu97pJymdlM13p6hVyD+Tb5gcppZQ==
X-Received: by 2002:a05:600c:258:: with SMTP id 24mr272127wmj.16.1610379086816;
        Mon, 11 Jan 2021 07:31:26 -0800 (PST)
Received: from ubuntu (bzq-233-168-31-62.red.bezeqint.net. [31.168.233.62])
        by smtp.gmail.com with ESMTPSA id b10sm184835wmj.5.2021.01.11.07.31.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 07:31:26 -0800 (PST)
Date:   Mon, 11 Jan 2021 17:31:23 +0200
From:   giladreti <gilad.reti@gmail.com>
To:     bpf@vger.kernel.org, Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Signed-off-by: giladreti <gilad.reti@gmail.com>
Message-ID: <20210111153123.GA423936@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added support for pointer to mem register spilling, to allow the verifier
to track pointer to valid memory addresses. Such pointers are returned
for example by a successful call of the bpf_ringbuf_reserve helper.

This patch was suggested as a solution by Yonghong Song.
---
 kernel/bpf/verifier.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 17270b8404f1..36af69fac591 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2217,6 +2217,8 @@ static bool is_spillable_regtype(enum bpf_reg_type type)
 	case PTR_TO_RDWR_BUF:
 	case PTR_TO_RDWR_BUF_OR_NULL:
 	case PTR_TO_PERCPU_BTF_ID:
+	case PTR_TO_MEM:
+	case PTR_TO_MEM_OR_NULL:
 		return true;
 	default:
 		return false;
-- 
2.27.0

