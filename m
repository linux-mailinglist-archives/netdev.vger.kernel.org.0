Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD714F5E3E
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 14:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232529AbiDFMYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 08:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234308AbiDFMXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 08:23:14 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E69116D;
        Wed,  6 Apr 2022 01:08:38 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id d29so1930947wra.10;
        Wed, 06 Apr 2022 01:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Oy67HKB+CH5MprbImCqTy7TMJ9Sc0ffSgIQtidsk7ic=;
        b=NbUT5qTkF0/yhbtTMiRU91oFoO0A54Mr1tlwna16DC4OO0Rr/LNqXcYHCszzOaUxjV
         6/x2ZV853pL7kHV4/RSDr8FsYGEWC0U2h5TULHMl5Tl5AkhueCmCKJp1FXV4PeLwtQJP
         unoNRURHRC1IpADCz0yElwjJtGKB4cw5VSJ7vK+CAnF8zgtDgj4uWlV7TrvPCYZTBwBr
         6dIYnop/zOV07tgWx4e7/ff8WqO6BSL+ahSr/4rDLUPJ7yBviKCuYO66ThgWTnazwt3u
         QR46MaoMWWyaltmwYP4iv66YyBURkogn2t0/JLY3nFhP/Jhs8hT6ydJNUglysMoF3zDy
         qDUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Oy67HKB+CH5MprbImCqTy7TMJ9Sc0ffSgIQtidsk7ic=;
        b=f7QK6LOR/Zp4ke41y6ZPkcl63JsVzIQhUvg3UnpKVxFBEbKAUTWdV5bOnhzrQ436K4
         vy3PxKbuJqr9TRJtBjO+Uf96j/rpPL9MyTAg7YOO8f28ArK3Ty92j3FZ+axmCoPpUHzO
         gIGhZwPvp2+Yw5ZM275TQtCeWMj8HYTZy+Lq5p4LID1Uh3VSpLUDb0IEofg/dbvgbKMI
         mkETjljV4jjsSWjo4TQR2ibtAifZADF92GZP3qDMZI2/rYrCo3jqQVAyd/SpmjivNvfg
         rNfvlPZf4bR36t+rosfwwQcwdZYj38msFUrkOrZm7JVw32nDr+pLAYw9A/LZccEDaSRV
         LFWw==
X-Gm-Message-State: AOAM533igNL7u77mDyftQLa+tk2FI4x2YWVGz5Ze5M4gF+gE4uWxDdL5
        VOz0hz83moKmqh5u5Gv/vbs=
X-Google-Smtp-Source: ABdhPJyGUySVImbWHPE8ZMHJL80liCjqLWjiWY9DChxMxo3AEPwcFSHgFeTYEXGDgCP96GwANq5Omg==
X-Received: by 2002:a5d:6d8b:0:b0:203:f9b4:be1d with SMTP id l11-20020a5d6d8b000000b00203f9b4be1dmr5704571wrs.298.1649232517257;
        Wed, 06 Apr 2022 01:08:37 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id l3-20020a1ced03000000b0038ce57d28a1sm4035390wmh.26.2022.04.06.01.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 01:08:36 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] libbpf: Fix spelling mistake "libaries" -> "libraries"
Date:   Wed,  6 Apr 2022 09:08:35 +0100
Message-Id: <20220406080835.14879-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a spelling mistake in a pr_warn message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 tools/lib/bpf/usdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/usdt.c b/tools/lib/bpf/usdt.c
index 1bce2eab5e89..c5acf2824fcc 100644
--- a/tools/lib/bpf/usdt.c
+++ b/tools/lib/bpf/usdt.c
@@ -687,7 +687,7 @@ static int collect_usdt_targets(struct usdt_manager *man, Elf *elf, const char *
 			 * to shared libraries with no PID filter.
 			 */
 			if (pid < 0) {
-				pr_warn("usdt: attaching to shared libaries without specific PID is not supported on current kernel\n");
+				pr_warn("usdt: attaching to shared libraries without specific PID is not supported on current kernel\n");
 				err = -ENOTSUP;
 				goto err_out;
 			}
-- 
2.35.1

