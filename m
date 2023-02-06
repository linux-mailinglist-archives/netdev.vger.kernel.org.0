Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85A1A68B888
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 10:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbjBFJWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 04:22:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjBFJWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 04:22:32 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6A64C2C;
        Mon,  6 Feb 2023 01:22:32 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id h16so9671559wrz.12;
        Mon, 06 Feb 2023 01:22:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BD90p+X206Tt8csl0mMp4SNnxg6nMR0oaLUQGe511sI=;
        b=eCEhXIe6vHUbsv2ZS5k4osNE8CLLVAiIDoPfSRECMaiPEPNDsiYVUyc00TZ9vhN0IF
         1qyeUTw2E7Qcc+F1qATEEbtKGsEfThQzDhkYtioIe9DxzMaJ0Y30gUk87AW+KEFWEwwf
         LTeGpyATtgOErYw4hSmKy6i/hjBV2A2fOFOo+Yw6CWdd/kJYYTZITYzpNJ+Ibk1nsBod
         iqliW/15mSGSXIFPkEQ6f+vuOatCjW7aAAZlaEUgNKjhO/h6E7yJh6K2wCtzNEBZa+6u
         D8aSxzdmdSPNwqw/ExsgCshPZnzOGWDl2hwMOz9Jo5+2SgjQ0gPG6yHJRM/sMNC50icW
         88Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BD90p+X206Tt8csl0mMp4SNnxg6nMR0oaLUQGe511sI=;
        b=cT5hVb/yZyg/z/5wrpKPoNyxO4b7fSLVce4nkqDhcsDiVmOoaPnXsjFfUIUXqQEv2Y
         Vc8YBrf0Po8co95q7pTkDCU5w/OxD9pxsOCTHWz/WlXD76QAeW+tybh86xyq/h/ltI/m
         90Q2PtN6WwOUl+w1ba3HWyxgwcf19c9/2tp1YdY9o2dEnFjb0a5hG3wFkPuuKVIZCG53
         qUVc4LX+aGAwuFEhw5BHmETu4HikGN4y5azJgeIYb/Eo1FD7pb2HEc6T0rcOOtYZes9g
         Iqd85dSepyVvoc60S9JrrDTdH+vL0RdoplVDKw2bwEDUldd5eg77Iu1o6JprmlXJ68su
         4//Q==
X-Gm-Message-State: AO0yUKVK3uI1BTDWHAF2L+2dyb0gQIsbLzSrf4IYs0wQSul0Z+CsskvQ
        YXSJC/MM5cHRkz/r6OXC/jdo8iBTA9j6WA==
X-Google-Smtp-Source: AK7set8pXKNJVlEeOZ1sXarKDziiuN/UDiR+aCfWSmWxOP3jhobHWvWgD+7s9Mmp98J22VcUtpn1dA==
X-Received: by 2002:a05:6000:a0e:b0:2bf:b389:ae6 with SMTP id co14-20020a0560000a0e00b002bfb3890ae6mr18940435wrb.42.1675675350565;
        Mon, 06 Feb 2023 01:22:30 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id a17-20020a5d53d1000000b002c3ebbc9248sm1325248wrw.66.2023.02.06.01.22.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 01:22:30 -0800 (PST)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] selftests/bpf: Fix spelling mistake "detecion" -> "detection"
Date:   Mon,  6 Feb 2023 09:22:29 +0000
Message-Id: <20230206092229.46416-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a spelling mistake in a literal string. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 tools/testing/selftests/bpf/xdp_features.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/xdp_features.c b/tools/testing/selftests/bpf/xdp_features.c
index 10fad1243573..fce12165213b 100644
--- a/tools/testing/selftests/bpf/xdp_features.c
+++ b/tools/testing/selftests/bpf/xdp_features.c
@@ -57,7 +57,7 @@ static void sig_handler(int sig)
 
 const char *argp_program_version = "xdp-features 0.0";
 const char argp_program_doc[] =
-"XDP features detecion application.\n"
+"XDP features detection application.\n"
 "\n"
 "XDP features application checks the XDP advertised features match detected ones.\n"
 "\n"
-- 
2.30.2

