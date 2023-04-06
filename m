Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6E896D976B
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 14:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238205AbjDFMzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 08:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238182AbjDFMzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 08:55:54 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBEB276AD
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 05:55:51 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id e9so25329873ljq.4
        for <netdev@vger.kernel.org>; Thu, 06 Apr 2023 05:55:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680785750;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MaSH6VKVyllvIVoyulNJHcX5Zf384xhMFQwlL1Td7+E=;
        b=wBrcBeQW24D98uTBGo0EznIAoclKHU1IAdAx6zY8SbvuSxF7gXlCdn7qAL1Fj293ew
         t6dDJAUTDlHKP8YDw4TqyykclcRLZn+5dY/G7JVAgDJb3uNISUGeERl2l2VpColLO33e
         08yUE/E3+8Ijpb3avjmTnjQ2HPIaR3ONP5ZX+DspKQKmJQdBCD7zlGwzvCpsrWx98a7k
         qXOWH44C4j84hPyACXmZbh0ofkdxA4qFHi7UygRagHt3M3hgvVvQ8RcNBqn4ovvc0C5u
         RDz7FYVWHkYwHbROAG48RXjuxKyiy6+wDC3UwzTrbZtsKE3U5QWoLbntn0SKLHT/l6ou
         X01Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680785750;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MaSH6VKVyllvIVoyulNJHcX5Zf384xhMFQwlL1Td7+E=;
        b=VepAoqF+vBEHu2NH+wcdVLc1ipeq58lrQ+tOlTPA7SSQKwvuxYyLF5ZV1V1Go+sreb
         yFsz+85vud852670m/xxGIa8ju3B2g8d9rSObnbczLQoX1Mkd4El2AooP3ZnAPEv5Ik8
         7yVOJetY0YQaPqZTyVLiTAymb16zMwrndLfaU3Lp6KDODZvAga7ne4Vjgq6R1hB966bH
         Oawl3qoHNTjm1pMLikccDmk0FOX5q5sjOrdd5qAaJH03Sk1y4X8xQ2PJO4OT21amVOhe
         Y389lSjGWUeHpRuTlVUcHysEeU1HP9FQNtGsRt5pCmPTwI/M5r5uo13L/D02VV/h3+pd
         iyHg==
X-Gm-Message-State: AAQBX9eiAX4yr5awpC96WMaV8ppX+SKtqfz9urRz1co1kEFIG82daVPE
        OxDQ7j0xO4c1rSfwlTodz6C1Cw==
X-Google-Smtp-Source: AKy350Z1qNP61kw9TRZ4XNYACGWroatf156KUNP22OewSG5oObfBOG2l+kpUy85buNwqWEyoITzSog==
X-Received: by 2002:a2e:9001:0:b0:2a1:bcd5:f2ff with SMTP id h1-20020a2e9001000000b002a1bcd5f2ffmr2885913ljg.21.1680785750152;
        Thu, 06 Apr 2023 05:55:50 -0700 (PDT)
Received: from [192.168.1.101] (abxh37.neoplus.adsl.tpnet.pl. [83.9.1.37])
        by smtp.gmail.com with ESMTPSA id i13-20020a2e864d000000b00295765966d9sm276513ljj.86.2023.04.06.05.55.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 05:55:49 -0700 (PDT)
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
Subject: [PATCH v3 0/2] ATH10K YAML conversion
Date:   Thu, 06 Apr 2023 14:55:43 +0200
Message-Id: <20230406-topic-ath10k_bindings-v3-0-00895afc7764@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAE/BLmQC/42Nyw7CIBREf8WwFsOj1OrK/zDG3FIoNzbQQCWap
 v8u7c6VLmcyc85MkoloEjnvZhJNxoTBlyD3O6Id+N5Q7EomggnJKlbTKYyoKUyOs8e9Rd+h7xM
 9gVUWGlkJqUj5tpAMbSN47crbP4ehlGM0Fl+b7Hor2WGaQnxv7szX9pcmc8ooN5Y3XKsyrS8De
 ojhEGJPVmQWf2FEwSh1tE1TQa06/oVZluUDESuN/RcBAAA=
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>
Cc:     Marijn Suijten <marijn.suijten@somainline.org>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1680785748; l=1681;
 i=konrad.dybcio@linaro.org; s=20230215; h=from:subject:message-id;
 bh=9PQjGqgVuPrZuUbC6cUZqXg2lX9Q/iqPOnarm0Ir/U4=;
 b=QbX/IDeOvgPZmPLMuVm3A9jtVdyfC3mGd5j5WoF0iWQmtp0i76rX/IjzRRXkNMrWmz/Wk7/ZVWt/
 iFPFoGnsCmiA5N8Wxs3bp9f9TR7mX9bI4fl2n1CklFsuD4GgybXY
X-Developer-Key: i=konrad.dybcio@linaro.org; a=ed25519;
 pk=iclgkYvtl2w05SSXO5EjjSYlhFKsJ+5OSZBjOkQuEms=
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2 -> v3:
- Ran dt_binding_check explicitly to uncover an issue with the
  example - I had 2 levels of wifi-firmware{}.. Fixed that..

I hope you folks don't mind me resending so quickly, but it was a
trivial issue. Patch 2 unchanged.

v2: https://lore.kernel.org/r/20230406-topic-ath10k_bindings-v2-0-557f884a65d1@linaro.org

v1 -> v2:

Dropped:
- '|' in /description
- /properties/resets/minItems
- Unnecessary level of 'items:' in /properties/ext-fem-name
- reserved-memory in examples
- status in examples
- labels in examples

Added:
- /properties/wifi-firmware/additionalProperties: false
- /properties/wifi-firmware/properties/iommus
- /properties/qcom,coexist-support/enum (and reworded the description)
- wifi-firmware and supplies in the SNoC example

Patch 2 is unchanged, picked up rb.

v1: https://lore.kernel.org/r/20230406-topic-ath10k_bindings-v1-0-1ef181c50236@linaro.org

This is my attempt at (finally) moving ATH10K to YAML.
One inexistent dt property came out as part of that.

Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
---
Konrad Dybcio (2):
      dt-bindings: net: Convert ATH10K to YAML
      arm64: dts: qcom: sdm845-polaris: Drop inexistent properties

 .../bindings/net/wireless/qcom,ath10k.txt          | 215 -------------
 .../bindings/net/wireless/qcom,ath10k.yaml         | 357 +++++++++++++++++++++
 arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts |   2 -
 3 files changed, 357 insertions(+), 217 deletions(-)
---
base-commit: 8417c8f5007bf4567ccffda850a3157c7d905f67
change-id: 20230406-topic-ath10k_bindings-9af5fa834235

Best regards,
-- 
Konrad Dybcio <konrad.dybcio@linaro.org>

