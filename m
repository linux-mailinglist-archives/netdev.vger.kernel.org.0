Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9216353B170
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 04:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233186AbiFBB2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 21:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233176AbiFBB23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 21:28:29 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF85132A20
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 18:28:27 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id nn3-20020a17090b38c300b001e0e091cf03so4893002pjb.1
        for <netdev@vger.kernel.org>; Wed, 01 Jun 2022 18:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=subject:date:message-id:mime-version:content-transfer-encoding:cc
         :from:to;
        bh=Pq/vYHE3cXk7rG+RVhj4D3DwFPV+hL1T6Kovr4vupaE=;
        b=ExwHaaZeB+DCLCHQ7ox2PTU2gawCae8ez1r5t/wmDxOouP4pn1j6KX4m0O7p2Mq8nU
         tvC1nNEPciqGWO7AFOpdWyvsmLWTttUY3SXHuVk/AFRzlTaKEUd9AfQ2XjrJGaGI+ZJX
         KAU04uZaMiZnIr031lApCZ1Z/NtVYHRzn337m3PsLylZUp2mHWrvlqnoGBkW85ppvK4F
         X689/svTbF/Gd+sZdLgWI3LtRp5Dw2zFDto4XXBfADfijXMFxGhFWsUzUNlC+CjJZNqZ
         F9mujWAvV21R9XpP7Bp3Y8WtPaygvSAIQUijzLgkH/Tupl5BmN7TT2gxXxAZ1CprXvd0
         xEGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:date:message-id:mime-version
         :content-transfer-encoding:cc:from:to;
        bh=Pq/vYHE3cXk7rG+RVhj4D3DwFPV+hL1T6Kovr4vupaE=;
        b=uqzWg1k1ICpgDJ1uPY1L36jzclNhis76RQ0gqLFC07g6Sv/GFzT8Jjm2Z4AKbVySbQ
         rflx882bxldotX7+zsBe1FJdxa7k9cNqufsWOvqhKHtB3/ia1eTkuptHlWjLqrFtX46z
         4HEgPOM3KV8N5SfbkB+3QZCbX9bscjwAfhdqKVAaJDRtuT9fpkFWN9L5aI+14Sb18MzI
         mzXPvK4cSuuoCN1FYsCrH1/jnNdZ7MKmJAG2/nSL5bXXDJl3Cr5Vp+rQzK+l1zk/jiQR
         9dcHFV1W24x6G1jECjMy7FtayeRO/Xr87y/OnXbuNQ7hLzEeBT0yz7+5QzSSa4RwWKVl
         iuqw==
X-Gm-Message-State: AOAM533vNMMAvCMaa0COIQ/lCKtd5PXSzGpEqIh31Lb3UnjIwglcdK8r
        WHptUo87fTLCOyInOV4jjyf4ZqIt4wrNPQ==
X-Google-Smtp-Source: ABdhPJzlndyk5hGK0dkUOhK/W+1F1+MjrAE3nvOnwhuedR0Fnyzgx/OORkHADuo5qaR+X3lJbjvtyA==
X-Received: by 2002:a17:902:e808:b0:161:946c:d2a5 with SMTP id u8-20020a170902e80800b00161946cd2a5mr2244981plg.93.1654133307089;
        Wed, 01 Jun 2022 18:28:27 -0700 (PDT)
Received: from localhost ([12.3.194.138])
        by smtp.gmail.com with ESMTPSA id bf7-20020a170902b90700b00163c6ac211fsm2148116plb.111.2022.06.01.18.28.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 18:28:26 -0700 (PDT)
Subject: [PATCH] dt-bindings: net: adin: Escape a trailing ":"
Date:   Wed,  1 Jun 2022 18:28:09 -0700
Message-Id: <20220602012809.8384-1-palmer@rivosinc.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc:     michael.hennerich@analog.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, alexandru.ardelean@analog.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@rivosinc.com,
        Palmer Dabbelt <palmer@rivosinc.com>
From:   Palmer Dabbelt <palmer@rivosinc.com>
To:     kuba@kernel.org
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Palmer Dabbelt <palmer@rivosinc.com>

1f77204e11f8 ("dt-bindings: net: adin: document phy clock output
properties") added a line with a ":" at the end, which is tripping up my
attempts to run the DT schema checks due to this being invalid YAML
syntax.  I get a schema check failure with the following error

    ruamel.yaml.scanner.ScannerError: mapping values are not allowed in this context

This just escapes the line in question, so it can parse.

Fixes: 1f77204e11f8 ("dt-bindings: net: adin: document phy clock output properties")
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
---
 Documentation/devicetree/bindings/net/adi,adin.yaml | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/adi,adin.yaml b/Documentation/devicetree/bindings/net/adi,adin.yaml
index 77750df0c2c4..88611720545d 100644
--- a/Documentation/devicetree/bindings/net/adi,adin.yaml
+++ b/Documentation/devicetree/bindings/net/adi,adin.yaml
@@ -37,7 +37,8 @@ properties:
     default: 8
 
   adi,phy-output-clock:
-    description: Select clock output on GP_CLK pin. Two clocks are available:
+    description: |
+      Select clock output on GP_CLK pin. Two clocks are available:
       A 25MHz reference and a free-running 125MHz.
       The phy can alternatively automatically switch between the reference and
       the 125MHz clocks based on its internal state.
-- 
2.34.1

