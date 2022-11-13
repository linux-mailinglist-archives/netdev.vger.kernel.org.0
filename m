Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 265186271C1
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 19:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235534AbiKMSrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 13:47:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234130AbiKMSrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 13:47:35 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61BC0101D3;
        Sun, 13 Nov 2022 10:47:34 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id e13so5392956edj.7;
        Sun, 13 Nov 2022 10:47:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c/VvhqVJ3MjIrUeX8KcoaCk2MxdjNB0YANO5NhKfsGs=;
        b=asUUAzkI8LCklALoOBPjg7TKZRpt148fWwSUpD+A6laGXWukBRJhzitUj1SNfE80jZ
         4F2kvQEya67iyJMOYG9DgB/j1DKnL7JV3bJELffY3PHP5S18zuioVSdc5z/s9MPHq7s3
         osdxGXf1fbz01qUtUaeHFEBnQOLgRKLHy3QUpk0nDxA5ABsvPsF8v1qeYTaGZu4ypkC3
         x1iMbU4SpXpp7O+zGZhpgFXTZI1wa8cqIRvH/1povv3x4cmpWYrcqrSTmR/sPLnL2w0g
         OXLSIb/ffTiBcURt3O5xpEtRligDGe7QnOMyKKHm9z3qQuIXckKOMG2oMMdlEL5POD2h
         9i2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c/VvhqVJ3MjIrUeX8KcoaCk2MxdjNB0YANO5NhKfsGs=;
        b=smQaZpuPsiz3xvT4A0wXSdwFwTv5m2em5fIELagyVpQdx9X5/4UCwvDGeWHUI4Ze+z
         K8EnAqZ3w3lQJCA1CG/KoQSyMrZCWGIcPysdtIFDALU1eVZPjEAwmP5gWU4E41JVnCsj
         h3dX7TxTJO3fpWcdD59SpR5OsS3dTc7m7wT/fh2pjzqV8llLc4eC1Q4E+YC2f3ANFsaT
         g9iLhcMnYngXiqNNIdamxHeOqcKIiQmeksAUBDduhItDB51Wrq6lzHHbU3A5fREqyKYh
         oqQwCuOx2vkvFReSHEslUoe9QMSeFBUs8T9ldYWU00DE0ptYwDg2/1/w1ijEbJijsgdD
         tKHA==
X-Gm-Message-State: ANoB5pk2W7GpXnqSFd61QuXgyoTU02SAezZbhk93valWeTJdjxOHodrA
        6vec7YtJZINv8otGycZVY/Q=
X-Google-Smtp-Source: AA0mqf7tvi6e5K04Cwn4s7oPS7aqxh2YV09YqFJ89KUSfBujLP4WwY4gpJ4Y8keRMzBN3Znc5Y/BOw==
X-Received: by 2002:a50:f68c:0:b0:463:c067:8277 with SMTP id d12-20020a50f68c000000b00463c0678277mr9034371edn.185.1668365252875;
        Sun, 13 Nov 2022 10:47:32 -0800 (PST)
Received: from fedora.. (dh207-97-48.xnet.hr. [88.207.97.48])
        by smtp.googlemail.com with ESMTPSA id a2-20020aa7d742000000b004623028c594sm3760050eds.49.2022.11.13.10.47.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Nov 2022 10:47:32 -0800 (PST)
From:   Robert Marko <robimarko@gmail.com>
To:     agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Robert Marko <robimarko@gmail.com>
Subject: [PATCH 2/5] dt-bindings: net: ipq4019-mdio: add IPQ8074 compatible
Date:   Sun, 13 Nov 2022 19:47:24 +0100
Message-Id: <20221113184727.44923-2-robimarko@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221113184727.44923-1-robimarko@gmail.com>
References: <20221113184727.44923-1-robimarko@gmail.com>
MIME-Version: 1.0
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

Allow using IPQ8074 specific compatible along with the fallback IPQ4019
one in order to be able to specify which compatibles require clocks to
be able to validate them via schema.

Signed-off-by: Robert Marko <robimarko@gmail.com>
---
 Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml b/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
index 2463c0bad203..2c85ae43d27d 100644
--- a/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
+++ b/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
@@ -23,6 +23,7 @@ properties:
       - items:
           - enum:
               - qcom,ipq6018-mdio
+              - qcom,ipq8074-mdio
           - const: qcom,ipq4019-mdio
 
   "#address-cells":
-- 
2.38.1

