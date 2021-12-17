Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEB6547940B
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 19:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240295AbhLQSYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 13:24:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbhLQSYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 13:24:03 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B4DFC061574;
        Fri, 17 Dec 2021 10:24:03 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id r17so5336274wrc.3;
        Fri, 17 Dec 2021 10:24:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1DaKXL8orHozQmF64Lx5P0LmTQ5Gm5T6HjA9h/tMGP8=;
        b=BsipFRerfGIbeJTeuRbVUn3UqG+64FCNItkHw9vUN1xUtYkwmFpROX+fv9Eilq+qp7
         gns9xBw9nZZrqh/+sdZN6fmr1lxvZIl4N/UHYog9gLv54yldzSWj4a0K/MfIB622DQKx
         2H4lemRpOOukPWNQST9JYB+Q0m871UzMN+AFEXHqfDWegjIxX2PWf0fRexRDcX8D3SKG
         sWu/Kx+g05AUpBzeAWXvV3l/KOclFVpJyxto2ZExTDggkwBVYMkjZq+8tqqptamPspX9
         KqieSXOyC7KmwoV3WnRNmN+d9kMmGhlRZ84w7HVVNOZslGEpScfBsZk/5C394TMGPjuy
         bk5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1DaKXL8orHozQmF64Lx5P0LmTQ5Gm5T6HjA9h/tMGP8=;
        b=bbypZdo5ZVAHi5FIoC9kHzE6hS2v9sTgmIV+8+8dC6dc3UBfh3ABLsNiK9dypxlD3P
         OF7zrDG4VcDwKoyY3+G8sRxr0G0hPF/uAqKztfaBJswRyJvyQgpRzfXmEHXLm56brUjH
         +rfWDQSSn5nSWtnlDMWkDFX66BId3oCmrtqvcdxmzcMu8IaGcTUJtHqERBXs5O+KbdJw
         IJP80A49TCXeUO+SZKplqjF7fAg0KrlPhFDzzgIjYdH5oAHUCaKzSCBMJvExMXZ2Gnth
         upYkyADIHKEuG3l28cLZ36jFPFoboqmbmf6wH2g7d7+ka2DhixZ4il6H3RO0GpjEIOjo
         uZJA==
X-Gm-Message-State: AOAM531UXoU9E5n3XlSbsNAvWmJIIewC++KTu72Uu0j0EE6boiZmdPTt
        u1AzvWi8e4cHMkZFUJxFWWM=
X-Google-Smtp-Source: ABdhPJwzAPXhWGTvt6MEl6bjCoE4AGsG11ijHe8AsJObT74ax5zenkB6BRkQI/+L4y18/l4UW6Gh6Q==
X-Received: by 2002:adf:9146:: with SMTP id j64mr3540685wrj.487.1639765441644;
        Fri, 17 Dec 2021 10:24:01 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id q123sm10860191wma.30.2021.12.17.10.24.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 10:24:01 -0800 (PST)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] bpf, selftests: Fix spelling mistake "tained" -> "tainted"
Date:   Fri, 17 Dec 2021 18:24:00 +0000
Message-Id: <20211217182400.39296-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There appears to be a spelling mistake in a bpf test message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 tools/testing/selftests/bpf/verifier/value_ptr_arith.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/verifier/value_ptr_arith.c b/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
index 4d347bc53aa2..359f3e8f8b60 100644
--- a/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
+++ b/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
@@ -1078,7 +1078,7 @@
 	.errstr_unpriv = "R0 pointer -= pointer prohibited",
 },
 {
-	"map access: trying to leak tained dst reg",
+	"map access: trying to leak tainted dst reg",
 	.insns = {
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
-- 
2.33.1

