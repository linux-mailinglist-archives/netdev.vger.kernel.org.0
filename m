Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7D551A4A1
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 17:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352947AbiEDP7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 11:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352921AbiEDP7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 11:59:14 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0627CB847;
        Wed,  4 May 2022 08:55:38 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id v12so2615467wrv.10;
        Wed, 04 May 2022 08:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wtP9hXDTn2yxCxN0X3of+jxBUyJ3pPE1spLSBo0Vj30=;
        b=qqXa9svwL8NMhVK1Gy+nfEs6AsyyPj8v3ldoTOGdWz6T7rM9N+70zCY8ogsxibCHLh
         6awoBFNjZXrfw6ZN4DGr71lSRCULT2WjFh+UcVjUjBZcy2SFdaE+R3K3+8ZJVBYVCV9t
         ESvoJaKYDq/eeFRdics70hAMrc1ri9IPZu2ioz63ukeJGse/F3+2P3urmhmT707I2h1R
         Fa1J5WZ/Rw7mi4kntJUDjTQBfj9KL79ANJtIOqollDoch0qutO8iKRcdzWlOcJLeMnVJ
         jzhQC9Xp5jk5rGTnjYdMTQ2sL28rtULpMZd9YbIf7faFF2taVbzUndHYThXOfj6PdvQR
         aAcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wtP9hXDTn2yxCxN0X3of+jxBUyJ3pPE1spLSBo0Vj30=;
        b=JnXf/w9sHgHDUnHMZgA+pvCbLwf7aw0M3pyCjjeAojKG5i/mRisyVwEWmolYPlbQ38
         q5t2Q4n9bHBrNCwpJyeydVvsxD1MmaiqEnAuP5Kh1Yz7eNsjDt0F2SARmA7+XYWTT6Wy
         L+MNLgVIdHJc/Lze1JqWrxbGLu7KhBvskdR2YYv5naheLkzPbtWDyAvXSPB4QkdIt60N
         EYe7TL9ptPTsaWX/ws7U66RUCvQldUUclg4D5clip0tfSmdg/bWFVvivkFPHPSR4O9Lz
         y7kvxIj+x8jRHrpMeAK8J/ONU/SxBHfLoUhIcK9Fj8BEH9PQtMHc6QnLf8N9fyyhsEMy
         1Dmg==
X-Gm-Message-State: AOAM5318eVm7swomehxpuFuq6IZDQgBI0c4uEIHtowwbUVRLdx12xXJy
        WQerS+X+GjH3mWlfS514C80=
X-Google-Smtp-Source: ABdhPJyAO2ajDWK9KtBeiYVElkB0jr1JpnrWYOLIIW+ZDM2z1WSjOl3K/EKnkLOcao/sWhat3JyTkA==
X-Received: by 2002:a5d:6c68:0:b0:20c:7246:a86 with SMTP id r8-20020a5d6c68000000b0020c72460a86mr7360076wrz.283.1651679736508;
        Wed, 04 May 2022 08:55:36 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id bg3-20020a05600c3c8300b003942a244ed2sm5085334wmb.23.2022.05.04.08.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 08:55:35 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] selftests/seccomp: Fix spelling mistake "Coud" -> "Could"
Date:   Wed,  4 May 2022 16:55:35 +0100
Message-Id: <20220504155535.239180-1-colin.i.king@gmail.com>
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

There is a spelling mistake in an error message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index 29c973f606b2..136df5b76319 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -4320,7 +4320,7 @@ static ssize_t get_nth(struct __test_metadata *_metadata, const char *path,
 
 	f = fopen(path, "r");
 	ASSERT_NE(f, NULL) {
-		TH_LOG("Coud not open %s: %s", path, strerror(errno));
+		TH_LOG("Could not open %s: %s", path, strerror(errno));
 	}
 
 	for (i = 0; i < position; i++) {
-- 
2.35.1

