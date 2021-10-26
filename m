Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72E0243B741
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 18:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237343AbhJZQfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 12:35:11 -0400
Received: from ixit.cz ([94.230.151.217]:42498 "EHLO ixit.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237240AbhJZQfK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 12:35:10 -0400
Received: from localhost.localdomain (ip-89-176-96-70.net.upcbroadband.cz [89.176.96.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ixit.cz (Postfix) with ESMTPSA id A923620064;
        Tue, 26 Oct 2021 18:32:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ixit.cz; s=dkim;
        t=1635265964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=t9bEpiQ2ZnS6NktrTQfvBI0rU+3jycXxqoxo4KY8Vk0=;
        b=QT/xbwaer1PJOkc0d6dB4ogDDdzZFfRIhDaqBkv2V3s9oIzCJe1lZL+hYqGTKlLmrh6LrM
        6EwxOvwwCrW+zS3t0B4iRaxIbMRmliy2H5hXQjeZGCXNd+xrJF6NpKssl4YKnKFhd6I17d
        /1ogllkMMPpjYXtuwt+q2mgwqj3YMr0=
From:   David Heidelberg <david@ixit.cz>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Alex Elder <elder@kernel.org>
Cc:     ~okias/devicetree@lists.sr.ht, David Heidelberg <david@ixit.cz>,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] dt-bindings: net: qcom,ipa: IPA does support up to two iommus
Date:   Tue, 26 Oct 2021 18:32:40 +0200
Message-Id: <20211026163240.131052-1-david@ixit.cz>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix warnings as:
arch/arm/boot/dts/qcom-sdx55-mtp.dt.yaml: ipa@1e40000: iommus: [[21, 1504, 0], [21, 1506, 0]] is too long
	From schema: Documentation/devicetree/bindings/net/qcom,ipa.yaml

Signed-off-by: David Heidelberg <david@ixit.cz>
---
 Documentation/devicetree/bindings/net/qcom,ipa.yaml | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
index b8a0b392b24e..b86edf67ce62 100644
--- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
+++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
@@ -64,7 +64,8 @@ properties:
       - const: gsi
 
   iommus:
-    maxItems: 1
+    minItems: 1
+    maxItems: 2
 
   clocks:
     maxItems: 1
-- 
2.33.0

