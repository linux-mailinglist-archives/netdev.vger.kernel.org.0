Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 649FE4BE393
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378057AbiBUOga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 09:36:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377876AbiBUOfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 09:35:50 -0500
Received: from mx.tkos.co.il (guitar.tcltek.co.il [84.110.109.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B9061AF3E;
        Mon, 21 Feb 2022 06:35:26 -0800 (PST)
Received: from tarshish.tkos.co.il (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 7DDF0440EA6;
        Mon, 21 Feb 2022 16:34:50 +0200 (IST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tkos.co.il;
        s=default; t=1645454090;
        bh=8QoucjTTAdFFTOWehg8uhtSN4m+jDIPITf81eXI8sns=;
        h=From:To:Cc:Subject:Date:From;
        b=h8xH6lxcEdtGlrbB+/3DxAVKcLACewaP8XRtydkiUeAWc9Nt8U3I3VhSVZZWBh0d+
         RVrFgX1brA2Qf+6NRzesB+PwO5JTAkbONlmy04CHbxKZzHb/PmPYJNAp8ToJIA1VDV
         O3jss1u7LgttzMJ9Al8O+ym9SPu7ki8tMBlUAlgkEjIrvTNRFhTPrcxfxs/FnClo4R
         5mDLuvaC0QhTKMjxIZo80tKZoYma18y4HKivRwGdda1W7GYRts4v5/Z3Z83IsUI7Jh
         lAQNW5lcD/4IWEwOi2aPVDAdsROJUofRm74debGfmqxgoE+Euchkb6ggTd4NkfZ42N
         8QNzqnUVg4n2g==
From:   Baruch Siach <baruch@tkos.co.il>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Robert Marko <robert.marko@sartura.hr>
Cc:     Baruch Siach <baruch.siach@siklu.com>,
        Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 1/2] dt-bindings: net: ipq4019-mdio: Add ipq6018 compatible
Date:   Mon, 21 Feb 2022 16:33:21 +0200
Message-Id: <a4b1ad7b15c13f368b637efdb903da143b830a88.1645454002.git.baruch@tkos.co.il>
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

Signed-off-by: Baruch Siach <baruch.siach@siklu.com>
---
 Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml b/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
index 2af304341772..214e5270d89c 100644
--- a/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
+++ b/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
@@ -17,6 +17,7 @@ properties:
     enum:
       - qcom,ipq4019-mdio
       - qcom,ipq5018-mdio
+      - qcom,ipq6018-mdio
 
   "#address-cells":
     const: 1
-- 
2.34.1

