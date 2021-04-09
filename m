Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8FE535A802
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 22:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234412AbhDIUkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 16:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234386AbhDIUkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 16:40:42 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48EDDC061763
        for <netdev@vger.kernel.org>; Fri,  9 Apr 2021 13:40:29 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id l19so1907188ilk.13
        for <netdev@vger.kernel.org>; Fri, 09 Apr 2021 13:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eqErB1BGtSYLSRcvCx/61ODE5QLSgu/K7kbGZ07zxxc=;
        b=CRP2+XeE0cWPtKGLK3vM3qpEMrFVKcT+k05Mf0QBcCsNPy7LTFx7Mg82oqg6PRNP6+
         x6X+IDRmR8IL/2tQ9LQNkKT5HUYb76npzAr41tmCCN+3llZc6+lG9SiIVqh5Xsgi1aaC
         oygNusjXjaa5DSMOu1coNLxXicgNcz2Oe2jeqS34X2SwTKso+RWG8ONQ6b2GoArBz8w5
         d7GjvBOiFfTu2aKLtSF5SEXXbGIAdrhuxRNQzrNFC3u5RBn3UiHnHUo3hrDOw4tux92l
         jBT08vMEGB2UMoPiqafFt8kgzdOeUrVJu5++RtQ6Km9eJEOWa8xP7WBhqqwlDHoZl7NM
         A/qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eqErB1BGtSYLSRcvCx/61ODE5QLSgu/K7kbGZ07zxxc=;
        b=t6UgGvgG/Bm+a1giSymahdkAKu36u4yw3cWkZUaWH8a92E1WgtxKMwRDnz2bTO++BG
         o/cdWDAMj3YLu+x//NcPHeG/1kMX+Du9GBZfd9jb97DPEvxuNepuKA5csqlCHv4kQqTH
         +BCWw5OC8nN6y/rLKOaevoC1drN4bOH5P7MzYlag5lkJTgWcUBmsBOhXBTcc6alzB2+q
         IzESi1qXlWKAuh/ml0Kk6ffLWcosc7OIOVklq52Jd6z2hiOupzS8UF1EAJmWQ9ktVpH3
         TDL94vTN4FqqnEP5Ns4miJ974woM4np7Wd5ihnScA36sf+d4Q0tFw3aBWPfhr4OVsm59
         hJ4A==
X-Gm-Message-State: AOAM530eUPqX1GJi22VueZXmSLjdqPug6O84qMvKhejaUvekoW5d7fZB
        +oKC7cJ01//4QZ/Th8Sq4Hx0zaC71z6nL09V
X-Google-Smtp-Source: ABdhPJyhqyM6lypSVScVyrDKkEEtsmxSsYZMSCcVOR90TXUyUWmH2NHHQcvTxRZJBtK+df2aMa2LWw==
X-Received: by 2002:a92:c26e:: with SMTP id h14mr12449414ild.33.1618000828764;
        Fri, 09 Apr 2021 13:40:28 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id b9sm1667212ilc.28.2021.04.09.13.40.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 13:40:28 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     robh+dt@kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     agross@kernel.org, bjorn.andersson@linaro.org, elder@kernel.org,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/4] dt-bindings: net: qcom,ipa: add some compatible strings
Date:   Fri,  9 Apr 2021 15:40:21 -0500
Message-Id: <20210409204024.1255938-2-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210409204024.1255938-1-elder@linaro.org>
References: <20210409204024.1255938-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add existing supported platform "qcom,sc7180-ipa" to the set of IPA
compatible strings.  Also add newly-supported "qcom,sdx55-ipa",
"qcom,sc7280-ipa".

Signed-off-by: Alex Elder <elder@linaro.org>
---
 Documentation/devicetree/bindings/net/qcom,ipa.yaml | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
index 8f86084bf12e9..2645a02cf19bf 100644
--- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
+++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
@@ -43,7 +43,11 @@ description:
 
 properties:
   compatible:
-    const: "qcom,sdm845-ipa"
+    oneOf:
+      - const: "qcom,sc7180-ipa"
+      - const: "qcom,sc7280-ipa"
+      - const: "qcom,sdm845-ipa"
+      - const: "qcom,sdx55-ipa"
 
   reg:
     items:
-- 
2.27.0

