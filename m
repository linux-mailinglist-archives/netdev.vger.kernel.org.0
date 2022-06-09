Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0DA544614
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 10:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241674AbiFIIiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 04:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232184AbiFIIiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 04:38:07 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C8A188;
        Thu,  9 Jun 2022 01:38:06 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id 187so20480488pfu.9;
        Thu, 09 Jun 2022 01:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eOJK9crUYKXyIABR6BLtgcFnqJSYVkj6ggY7lPw/iao=;
        b=LAl1d08X8q2e31YN0ruuS4C7xF3BExBRczatwKid46gwkpweQBeZKpjY7IebrKADy1
         B7gBZE2l/EjyLooNLPI1woQOhXCMT4w/6CCwrIKjjA/wyOhCDiJDad3WBp5NRzj8iyTp
         ivM979eTiOXFmrGA9KNWhDed+wEC75jzkpoP/12Q7gwAI+R+hnU9sVTdb4o1UJ1wSokk
         /IOuclVZTU6yLneviGtZ9JKi/MEdLCZAqahoEYDyxsU913IVvHOwJT9cPJ/06d4T8xM6
         2nZiH5pc6hKisud0BvrIHVflWYMCvna2CuzYPOb4Mo1K2wP4i/cLe/51/WpgGZR9u6Ny
         BCgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eOJK9crUYKXyIABR6BLtgcFnqJSYVkj6ggY7lPw/iao=;
        b=Y5aRPtsQAybKJNBxKVo5zta2QtYoo/h1f+SCVX++jq2kt7lYpnRK8VveheczAuJs2a
         BOl794m0gm9TVgt2FIuSZTfOKVeAx8m+GTz7jKQ/9ftFJCZ3Cc1YRhpewiDEty2rpPfA
         o7xiNS/8UdLnjHPqpN18BiS9Xlzh4Vb2tu+OJtcxqO8S1MY7wokweijj57Ro+AXC4w67
         EMjYc5N4N8Cs97T/tDfJXGL/jtmpb9/vzz536ms6+jM5MlblrjnYtAobUT3j3wS6MYz0
         XVFpZMYaR5kcGOMNatU+eUnGl/gIYadiTHYQtuzszuB1W39hXbbWWy32apa7JOffL1r7
         06NA==
X-Gm-Message-State: AOAM531I7HrZwojwzNNP9s0rbLiLAvsyyGr1f/zGmNjeKemGJ2HtIJrP
        wqC80o8Ml2tdAiCX7FOFnqU=
X-Google-Smtp-Source: ABdhPJx8jI/nVpRWlGVbTToQMkEUzvbfXlIkQWgiOaIqr9dbjO8e3D+CJoRKgGSCIm6aa374Ikqu1w==
X-Received: by 2002:a05:6a00:1502:b0:51c:2991:f1c with SMTP id q2-20020a056a00150200b0051c29910f1cmr16805716pfu.37.1654763885935;
        Thu, 09 Jun 2022 01:38:05 -0700 (PDT)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id ru12-20020a17090b2bcc00b001cb6527ca39sm18206436pjb.0.2022.06.09.01.38.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 01:38:05 -0700 (PDT)
From:   Kosuke Fujimoto <fujimotokosuke0@gmail.com>
X-Google-Original-From: Kosuke Fujimoto <fujimotoksouke0@gmail.com>
To:     corbet@lwn.net, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org
Cc:     linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kosuke Fujimoto <fujimotoksouke0@gmail.com>,
        Kosuke Fujimoto <fujimotokosuke0@gmail.com>
Subject: [PATCH] bpf, docs: Fix typo "BFP_ALU" to "BPF_ALU"
Date:   Thu,  9 Jun 2022 04:39:37 -0400
Message-Id: <20220609083937.245749-1-fujimotoksouke0@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"BFP" should be "BPF"

Signed-off-by: Kosuke Fujimoto <fujimotokosuke0@gmail.com>
---
 Documentation/bpf/instruction-set.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/bpf/instruction-set.rst b/Documentation/bpf/instruction-set.rst
index 1de6a57c7e1e..9e27fbdb2206 100644
--- a/Documentation/bpf/instruction-set.rst
+++ b/Documentation/bpf/instruction-set.rst
@@ -127,7 +127,7 @@ BPF_XOR | BPF_K | BPF_ALU64 means::
 Byte swap instructions
 ----------------------
 
-The byte swap instructions use an instruction class of ``BFP_ALU`` and a 4-bit
+The byte swap instructions use an instruction class of ``BPF_ALU`` and a 4-bit
 code field of ``BPF_END``.
 
 The byte swap instructions operate on the destination register
-- 
2.31.1

