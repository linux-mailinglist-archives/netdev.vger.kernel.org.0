Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F409B35E432
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 18:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242915AbhDMQj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 12:39:59 -0400
Received: from mail-il1-f172.google.com ([209.85.166.172]:37387 "EHLO
        mail-il1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346966AbhDMQjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 12:39:52 -0400
Received: by mail-il1-f172.google.com with SMTP id j12so724849ils.4
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 09:39:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VLu6mFlLeCrgaCYNWsH+T8ir+Hi3WWP35ndfMCxrUhc=;
        b=mbRFoLv6z5zc7Ll8lgWA0JD04UjVYVLWCAtlFVboSVq6BWGBWFbzceWJxGXdjqTajW
         rsG4Emc378DXwjl5EzW3cRqsYDRAw0EbTxbaRtescnwBcCIXatR2cHJc+YferiTYc4zO
         vn7mJHHsZwto+UXKRYcFlDxuixrRiNfjOoktpjlVeZmsHzZgnPPUjPI9J+H/U6AE0zKY
         HPcTAknI0LPiFxeV16xftE8rmPW5TkUTlwrUjZgjOIaTkE3YyNs4vouXjQE7OQOfzOkg
         W8iM4ibkAMvLP561oZGHu+hjBclUn6IxucHRyPN+geAqtZ8oKRVYkS0IgtJvb9VfJ4Sr
         HEsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VLu6mFlLeCrgaCYNWsH+T8ir+Hi3WWP35ndfMCxrUhc=;
        b=cyLgz2Ym/PFyQ20xYml639FZckiORcTyo3MDbXtMhK4loWMijPZlEJ7kMrXJjVN8Cd
         9nd6WfaHj6SvOe8sJqUiO/A8duypGWexqJtHpTkfbJMQq94Toi64NpK0AkTqgkBdPS91
         KzvgqOF7//kjgFpRu0U5syPdBj4kRtYrRE6BQ1qG6kGt99DrPSVMP5JxaATsXk+Gr3jt
         SXY+UCDXJfmdxsfP/lApJMlody49T+QvXby4K5AgPLvmqwgQOor9fs3yxx04ASA/t5NX
         8T+TiET05WtJqhzBzaiAUPUnkdXK4OwuAZzYeX0u6FrDP3JFRjCzoIIIQlo7ouDxbAxl
         YdNQ==
X-Gm-Message-State: AOAM532vTobOIoOjB5ZOVfkO36XA/SGYcAyutuxVeHPnLoG1QvbYP1B6
        Df+4DA9it7BVYTOr/FH2EPS1nw==
X-Google-Smtp-Source: ABdhPJyvqsYiS0Iq/iFCwwpOXTWhDhNw8d9kRnUEmRl8KvhI4spB/PmpJHD5FCuxeyy+jyImZ/7I1g==
X-Received: by 2002:a05:6e02:b24:: with SMTP id e4mr28386793ilu.30.1618331910899;
        Tue, 13 Apr 2021 09:38:30 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id 11sm7054469iln.74.2021.04.13.09.38.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 09:38:30 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     robh+dt@kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/2] dt-bindings: net: qcom,ipa: add support for SM8350
Date:   Tue, 13 Apr 2021 11:38:25 -0500
Message-Id: <20210413163826.1770386-2-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210413163826.1770386-1-elder@linaro.org>
References: <20210413163826.1770386-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for "qcom,sm8350-ipa", which uses IPA v4.9.

Use "enum" rather than "oneOf/const ..." to specify compatible
strings, as suggested by Rob Herring.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 Documentation/devicetree/bindings/net/qcom,ipa.yaml | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
index 2645a02cf19bf..da5212e693e91 100644
--- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
+++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
@@ -43,11 +43,12 @@ description:
 
 properties:
   compatible:
-    oneOf:
-      - const: "qcom,sc7180-ipa"
-      - const: "qcom,sc7280-ipa"
-      - const: "qcom,sdm845-ipa"
-      - const: "qcom,sdx55-ipa"
+    enum:
+      - qcom,sc7180-ipa
+      - qcom,sc7280-ipa
+      - qcom,sdm845-ipa
+      - qcom,sdx55-ipa
+      - qcom,sm8350-ipa
 
   reg:
     items:
-- 
2.27.0

