Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54DAC43562B
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 00:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbhJTW5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 18:57:00 -0400
Received: from ixit.cz ([94.230.151.217]:58276 "EHLO ixit.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229842AbhJTW5A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 18:57:00 -0400
Received: from localhost.localdomain (ip-89-176-96-70.net.upcbroadband.cz [89.176.96.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ixit.cz (Postfix) with ESMTPSA id 7DDAF20064;
        Thu, 21 Oct 2021 00:54:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ixit.cz; s=dkim;
        t=1634770482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=7UCKEgRwp1jyGq3OkKCG3fb28bI7ggnIsfkTxpnfifs=;
        b=K03wljwNBZh9C9uiAXB9J2e7Fou6iyQi+qnfDmhAXZoLPmnp38glhE7VujWT7arZmjOCkj
        aCNcM4t91CvFNOGTo/DXO2wZYKFSUCw8Bu3QyjKjpPof+SX8v8TPxlLIAo08pH+cVIr0R8
        hfE7r2SmrbHopv9kQN70cqubanpxmAs=
From:   David Heidelberg <david@ixit.cz>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Alex Elder <elder@kernel.org>
Cc:     ~okias/devicetree@lists.sr.ht, David Heidelberg <david@ixit.cz>,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] dt-bindings: net: qcom,ipa: describe IPA v4.5 interconnects
Date:   Thu, 21 Oct 2021 00:54:34 +0200
Message-Id: <20211020225435.274628-1-david@ixit.cz>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPA v4.5 interconnects was missing from dt-schema, which was trigering
warnings while validation.

Signed-off-by: David Heidelberg <david@ixit.cz>
---
 Documentation/devicetree/bindings/net/qcom,ipa.yaml | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
index b8a0b392b24e..a2835ed52076 100644
--- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
+++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
@@ -95,6 +95,11 @@ properties:
           - description: Path leading to system memory
           - description: Path leading to internal memory
           - description: Path between the AP and IPA config space
+      - items: # IPA v4.5
+          - description: Path leading to system memory region A
+          - description: Path leading to system memory region B
+          - description: Path leading to internal memory
+          - description: Path between the AP and IPA config space
 
   interconnect-names:
     oneOf:
@@ -105,6 +110,11 @@ properties:
           - const: memory
           - const: imem
           - const: config
+      - items: # IPA v4.5
+          - const: memory-a
+          - const: memory-b
+          - const: imem
+          - const: config
 
   qcom,smem-states:
     $ref: /schemas/types.yaml#/definitions/phandle-array
-- 
2.33.0

