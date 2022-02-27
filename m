Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBAE4C5A06
	for <lists+netdev@lfdr.de>; Sun, 27 Feb 2022 09:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbiB0ITp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 03:19:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbiB0ITo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 03:19:44 -0500
Received: from mx.tkos.co.il (guitar.tcltek.co.il [84.110.109.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E350B3B3E3;
        Sun, 27 Feb 2022 00:19:07 -0800 (PST)
Received: from tarshish.tkos.co.il (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id E655E440932;
        Sun, 27 Feb 2022 10:18:25 +0200 (IST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tkos.co.il;
        s=default; t=1645949906;
        bh=3IxnfjF7BB1CodfrPmPLlp9lzQkWUXQyUXY6ck9jdeM=;
        h=From:To:Cc:Subject:Date:From;
        b=oC7SU1D9eGfZBIlL6chy6ecPnCZoBq3SFFBJ7wuOahkEtuh/OWT2uHHBO2KMV4DPu
         +GiKytinOuiHM48N7Ek8A6kJyinHI1v6UQxwcQsXBT0ytGqenPDuuSl28pfE+Jz4v4
         rM5C2ciIJqlR01uN9FUoNuD++W2EC8NOD2JBYIkO3/1ZAY2/G0KGJlORw1S7DdV8To
         TLcvDEjLmwRB2ldIP1TGSNodT65kgAU33ZdD/c4EgK77dUM0J5pvPcqOxHeD25yCid
         gJ7vJr4mILkLdFE7C5mSaKg71Mfk4VkKtFtG+93bSm+5DJGm/5CY26YJA7bDEJNeh8
         QFdPPXxGnPj8A==
From:   Baruch Siach <baruch@tkos.co.il>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Robert Marko <robert.marko@sartura.hr>
Cc:     Baruch Siach <baruch.siach@siklu.com>,
        Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH v2 1/2] dt-bindings: net: ipq4019-mdio: Add ipq6018 compatible
Date:   Sun, 27 Feb 2022 10:18:33 +0200
Message-Id: <e96e06d3228d9bbd927da32379ba78d5b4b718a7.1645949914.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baruch Siach <baruch.siach@siklu.com>

The IPQ60xx MDIO bus is the same as IPQ4019.

Change 'enum' to 'items' list to allow fallback to older compatible
strings.

Signed-off-by: Baruch Siach <baruch.siach@siklu.com>
---

v2:

  Update the schema to allow fallback compatible (Rob Herring)
---
 Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml b/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
index 2af304341772..01fa8406fa33 100644
--- a/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
+++ b/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
@@ -14,9 +14,10 @@ allOf:
 
 properties:
   compatible:
-    enum:
+    items:
       - qcom,ipq4019-mdio
       - qcom,ipq5018-mdio
+      - qcom,ipq6018-mdio
 
   "#address-cells":
     const: 1
-- 
2.34.1

