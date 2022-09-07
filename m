Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F32AB5B0E7D
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 22:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbiIGUtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 16:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbiIGUtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 16:49:41 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 014D814D20
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 13:49:38 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id i15-20020a17090a4b8f00b0020073b4ac27so157631pjh.3
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 13:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=VILwDL/sIUZC34sszkWtJPfoLU5yiUkOiwtDL7IE2b0=;
        b=ClFo6oZego6igRhj/tOJY4x+HLqCA3i9nMX4KM0+Ag+rW9iC/gWlE9ZAyqzTQ4iqE3
         B2sP2BYHvX4v3bo4jjmvnSWB9pRtI0U0DfznyhuIDVSYZBukRj9fEVBD2ySXsnKW5m2q
         vIn6wNvPqNg4Ks1scp3jRgPLQMl9Hn13YAQmYf5vR1SZsjb/1hG59nidUzJkCBf5vBYA
         ri3feTAswyIQRKCZ619KqiSAMkKHUiaMMjAxyxJb05vZJmh0xQ+4JB6Q3H8nkpq7ZwaN
         Par5PHOTxOOac20WE6/B9l0FKuUeML6jF34zkqdwkJ/XSPH3MDgudonPiEfKBp6iw7m4
         yhIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=VILwDL/sIUZC34sszkWtJPfoLU5yiUkOiwtDL7IE2b0=;
        b=QW3wRqDvSdMsIqlDn5OaMkriU5SqtsCvX3GZkFCXit+azjlWc7kvz3IRUxXpe1zMiy
         cn2Sl/pKVRnDH7gZvmHsaAjSlg4dnLcifoArSXPVHu6Fp8FIwZRxFMFjKKYF05D6qjcE
         mfymhZ14b+GgMjRexz8+w0gpWE+JpEzZt0prHDXRcEz5hEWlwmaCPCyG4Ys1JsxiR1+C
         WUyminaMKoMcNsmswKke32TxL1Hlsih/GjcQUmQR9c3QLvva33SiVu/7gJl5Z/zUoaiL
         6OJNrC4/EcYEJI6/H/omTdNTnX29aSut4lUSIJ2xR3/AVG1lnNYl/WudKo26Ur5cwu/i
         T9OA==
X-Gm-Message-State: ACgBeo1RLL5WnZ14yp4EPUoxSfsoD6xfJw9xIcd8MsttR/ksihrw6Ge9
        k0/yTbFm/vQuL1Gtv6nqyAfHvw==
X-Google-Smtp-Source: AA6agR7mirZmtO2FC7GgkTq0WIz+FVoIZ5otVGbaluywI72PpIdKKFO3WQhD7jyObY6RKdBYtMAFJg==
X-Received: by 2002:a17:90b:3c8a:b0:200:b874:804 with SMTP id pv10-20020a17090b3c8a00b00200b8740804mr342150pjb.151.1662583777293;
        Wed, 07 Sep 2022 13:49:37 -0700 (PDT)
Received: from localhost.localdomain ([2401:4900:1c60:5362:9d7f:2354:1d0a:78e3])
        by smtp.gmail.com with ESMTPSA id e6-20020a17090301c600b001712c008f99sm12795140plh.11.2022.09.07.13.49.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 13:49:37 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     devicetree@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, agross@kernel.org,
        bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski@linaro.org, netdev@vger.kernel.org,
        Bjorn Andersson <andersson@kernel.org>,
        Rob Herring <robh@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        David Miller <davem@davemloft.net>
Subject: [PATCH 0/4] dt-bindings: net: Convert qcom,ethqos bindings to YAML (and related fixes)
Date:   Thu,  8 Sep 2022 02:19:20 +0530
Message-Id: <20220907204924.2040384-1-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset converts the qcom,ethqos bindings to YAML. It also
contains a few related fixes in the snps,dwmac bindings to support
Qualcomm ethqos ethernet controller for qcs404 (based) and sa8155p-adp
boards.

Note that this patchset depends on the following dts fix to avoid
any 'make dtbs_check' errors:
https://lore.kernel.org/linux-arm-msm/20220907204153.2039776-1-bhupesh.sharma@linaro.org/T/#u

Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Rob Herring <robh@kernel.org>
Cc: Vinod Koul <vkoul@kernel.org>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>

Bhupesh Sharma (4):
  dt-bindings: net: qcom,ethqos: Convert bindings to yaml
  dt-bindings: net: snps,dwmac: Add Qualcomm Ethernet ETHQOS compatibles
  dt-bindings: net: snps,dwmac: Update reg maxitems
  dt-bindings: net: snps,dwmac: Update interrupt-names

 .../devicetree/bindings/net/qcom,ethqos.txt   |  66 ---------
 .../devicetree/bindings/net/qcom,ethqos.yaml  | 139 ++++++++++++++++++
 .../devicetree/bindings/net/snps,dwmac.yaml   |  16 +-
 3 files changed, 150 insertions(+), 71 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/qcom,ethqos.txt
 create mode 100644 Documentation/devicetree/bindings/net/qcom,ethqos.yaml

-- 
2.37.1

