Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63178435630
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 00:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbhJTW5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 18:57:02 -0400
Received: from ixit.cz ([94.230.151.217]:58292 "EHLO ixit.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230474AbhJTW5B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 18:57:01 -0400
Received: from localhost.localdomain (ip-89-176-96-70.net.upcbroadband.cz [89.176.96.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ixit.cz (Postfix) with ESMTPSA id D6A21236BE;
        Thu, 21 Oct 2021 00:54:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ixit.cz; s=dkim;
        t=1634770485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D3Oj4S+FXTM78QYEbN3J1EXoid+5Zw5B6Rc1Go0xRX0=;
        b=LQONQVcpIW3CCXS32hCuJokDz1ib8TX19BwnToLYf7KbAGgJ0HGde3lTXArvhddYNsgHWE
        xXdndDGqxeZ0DFyFK8Uv7PiTJYTmYIdHVRtdQvDB3Bo8B9mTYvz7HTGV5gtzD0/LwCo0Ol
        YCLXFBb0Tpv958zZtm24UmGPxKvXI2o=
From:   David Heidelberg <david@ixit.cz>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Alex Elder <elder@kernel.org>
Cc:     ~okias/devicetree@lists.sr.ht, David Heidelberg <david@ixit.cz>,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] dt-bindings: net: qcom,ipa: IPA does support up to two iommus
Date:   Thu, 21 Oct 2021 00:54:35 +0200
Message-Id: <20211020225435.274628-2-david@ixit.cz>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211020225435.274628-1-david@ixit.cz>
References: <20211020225435.274628-1-david@ixit.cz>
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
 Documentation/devicetree/bindings/net/qcom,ipa.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
index a2835ed52076..775b0f94504a 100644
--- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
+++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
@@ -64,7 +64,7 @@ properties:
       - const: gsi
 
   iommus:
-    maxItems: 1
+    maxItems: 2
 
   clocks:
     maxItems: 1
-- 
2.33.0

