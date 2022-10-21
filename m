Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 191196076FF
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 14:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbiJUMiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 08:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbiJUMiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 08:38:04 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9D80263B74
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 05:38:02 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20221021123801epoutp02dcfaa3c76400577fc6ce574ba427fca1~gFdhoQBx40448704487epoutp02C
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 12:38:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20221021123801epoutp02dcfaa3c76400577fc6ce574ba427fca1~gFdhoQBx40448704487epoutp02C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1666355881;
        bh=aaA7aie8x438Es2cT27pg0nMrA6D2ftw6fa2KJeXNfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DmmF7NH8U2mylFd0XGk8JYluYr+s5EAMjlKlnzNjOk6Xfk+LFM7OusTNtnjiicbWk
         cccUGNqCMd66q3YqAfcOgdQghFE91E+ee/vBBZIqRIxnLvCMG4QXcoHOTedxdtHAz1
         g3y4Cun2a2h1h0yy5D0AkZE7QwAxu8vBy8OQOAlA=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20221021123800epcas5p1cffc504993ce8a8dd6a4731d25429efe~gFdgwiJ5r2160621606epcas5p1l;
        Fri, 21 Oct 2022 12:38:00 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4Mv3sK5N84z4x9Pw; Fri, 21 Oct
        2022 12:37:57 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        BE.AB.39477.5A292536; Fri, 21 Oct 2022 21:37:57 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20221021102621epcas5p3f10b063ae972bee587eb5beb6e1b5617~gDqkPYXAN0943809438epcas5p3J;
        Fri, 21 Oct 2022 10:26:21 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221021102621epsmtrp19dc2ad431c28296bcb8dcd9b6dbd8be4~gDqkOZWSp1811718117epsmtrp1h;
        Fri, 21 Oct 2022 10:26:21 +0000 (GMT)
X-AuditID: b6c32a4a-007ff70000019a35-20-635292a57c25
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        71.26.14392.DC372536; Fri, 21 Oct 2022 19:26:21 +0900 (KST)
Received: from cheetah.sa.corp.samsungelectronics.net (unknown
        [107.109.115.53]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20221021102619epsmtip1aab14d27def6f1aa7751483152135ae7~gDqiRL1H72574025740epsmtip15;
        Fri, 21 Oct 2022 10:26:19 +0000 (GMT)
From:   Vivek Yadav <vivek.2311@samsung.com>
To:     rcsekar@samsung.com, wg@grandegger.com, mkl@pengutronix.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, pankaj.dubey@samsung.com,
        ravi.patel@samsung.com, alim.akhtar@samsung.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sriranjani P <sriranjani.p@samsung.com>
Subject: [PATCH 1/7] dt-bindings: Document the SYSREG specific compatibles
 found on FSD SoC
Date:   Fri, 21 Oct 2022 15:28:27 +0530
Message-Id: <20221021095833.62406-2-vivek.2311@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221021095833.62406-1-vivek.2311@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmk+LIzCtJLcpLzFFi42LZdlhTS3fppKBkg6lNmhYP5m1js5hzvoXF
        4umxR+wWF7b1sVqs+j6V2eLyrjlsFusXTWGxOLZAzOLb6TeMFou2fmG3ePhhD7vFrAs7WC1u
        v1nHarH03k5WBz6PLStvMnks2FTq8fHSbUaPTas62Tz6/xp4vN93lc2jb8sqRo/Pm+QCOKKy
        bTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOArlZSKEvM
        KQUKBSQWFyvp29kU5ZeWpCpk5BeX2CqlFqTkFJgU6BUn5haX5qXr5aWWWBkaGBiZAhUmZGfc
        6n3IVtAhUnG8RbqB8RN/FyMnh4SAicTPjgssXYxcHEICuxkldn++wwqSEBL4xCixfIYnROIb
        o8SU7QsYYTr+PHrHCpHYyyhx78FaNoiOViaJmxNEQWw2AS2Jx50LWEBsEYG7jBLXFmd2MXJw
        MAvUSVw8YwASFhaIldj89wE7iM0ioCrReukR2BheAWuJNQshWiUE5CVWbzjADGJzCthIvJq/
        hRFkr4RAJ4fEk7swB7lI9G/9wgphC0u8Or6FHcKWknjZ3wZlJ0vs+NcJVZMhsWDiHqhee4kD
        V+awQNymKbF+lz5EWFZi6ql1TCA2swCfRO/vJ0wQcV6JHfNgbBWJF58nsIK0gqzqPScMEfaQ
        2NPXzg4Jnn5GiWcr5jNPYJSbhbBhASPjKkbJ1ILi3PTUYtMCo7zUcniMJefnbmIEp0otrx2M
        Dx980DvEyMTBeIhRgoNZSYTXoi4oWYg3JbGyKrUoP76oNCe1+BCjKTD8JjJLiSbnA5N1Xkm8
        oYmlgYmZmZmJpbGZoZI47+IZWslCAumJJanZqakFqUUwfUwcnFINTM7lCcZT/l9VPCHS+7+O
        7YfXgW+fYh1cpsjMDLvvcGji/PNxe1YYNS06Gnrd2NM8ecHm9k22JmynxZ7Z3o8p3Db3bGXj
        YcdjyedP71vJfoRdN/tN/UW1/bVL5gZlzVyZb983++Su3Ps8ubcWvKq+ZhPhmhk84dPtL4/3
        8n5iVqib92+xxllWI6btD1kvcfn+zO65Gf7f4smrzoL93XozFl56IemddfBP/hebtxxaOXli
        7IfPaDhvjij7vTk89J34sqnKq3eqKya2cC+RWNL0+G5UxmS9LQ754h3MAlWVZ0QWBh5I1lr9
        ouvfhP0aq3JvPb0Vsu2nt9q2XVxFvnPf7jpyKOLY5cOXKl8Jvp108ISNEktxRqKhFnNRcSIA
        N56sGB4EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsWy7bCSnO7Z4qBkg297+CwezNvGZjHnfAuL
        xdNjj9gtLmzrY7VY9X0qs8XlXXPYLNYvmsJicWyBmMW3028YLRZt/cJu8fDDHnaLWRd2sFrc
        frOO1WLpvZ2sDnweW1beZPJYsKnU4+Ol24wem1Z1snn0/zXweL/vKptH35ZVjB6fN8kFcERx
        2aSk5mSWpRbp2yVwZdzqfchW0CFScbxFuoHxE38XIyeHhICJxJ9H71i7GLk4hAR2M0r8PfKL
        ESIhJTHlzEsWCFtYYuW/5+wQRc1MEntmXGQDSbAJaEk87lwAViQi8JJRouUsWJxZoIlRYm9z
        ThcjB4ewQLTElqNFIGEWAVWJ1kuPwEp4Bawl1ixcADVfXmL1hgPMIDangI3Eq/lbwG4QAqpZ
        9ugm+wRGvgWMDKsYJVMLinPTc4sNCwzzUsv1ihNzi0vz0vWS83M3MYIDWktzB+P2VR/0DjEy
        cTAeYpTgYFYS4S14F5AsxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdC18l4IYH0xJLU7NTUgtQi
        mCwTB6dUA1Potjlq7t03lijuZAnratT/cKv/ysd09dA561Jflx+6xPs1Yl6sQXry2sjHuWUs
        hY0Cvvc/6D3bGySXoF8roOl8WPaEz7fjvLkxN5TtzsvO25gerChtNSc9+tKPdq+08DCt6W5m
        G1p8rnJOqlWsPzpvmbDtmrv8qg6bY2bNuCsUsW5NWvN1jlyuyDWTlT8z9t32/m1inGP6zznL
        izePO885XCP/GheLw/4CrTWf+Q9+Nbsa6lt23MtW6Kbh/DSOoHViJw9MNtgh9nrRrqqK20X7
        jrjf1UwQfRPMVTJBLWie6Vd7o63zsno3qwntUbMTkY07c2saX/pM71UB6tdcZHw9k+6HOd6V
        XiiyacYGJZbijERDLeai4kQA0si7OdcCAAA=
X-CMS-MailID: 20221021102621epcas5p3f10b063ae972bee587eb5beb6e1b5617
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221021102621epcas5p3f10b063ae972bee587eb5beb6e1b5617
References: <20221021095833.62406-1-vivek.2311@samsung.com>
        <CGME20221021102621epcas5p3f10b063ae972bee587eb5beb6e1b5617@epcas5p3.samsung.com>
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sriranjani P <sriranjani.p@samsung.com>

Describe the compatible properties for SYSREG controllers found on
FSD SoC.

Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Pankaj Kumar Dubey <pankaj.dubey@samsung.com>
Signed-off-by: Ravi Patel <ravi.patel@samsung.com>
Signed-off-by: Sriranjani P <sriranjani.p@samsung.com>
---
 .../devicetree/bindings/arm/tesla-sysreg.yaml | 50 +++++++++++++++++++
 MAINTAINERS                                   |  1 +
 2 files changed, 51 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/tesla-sysreg.yaml

diff --git a/Documentation/devicetree/bindings/arm/tesla-sysreg.yaml b/Documentation/devicetree/bindings/arm/tesla-sysreg.yaml
new file mode 100644
index 000000000000..bbcc6dd75918
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/tesla-sysreg.yaml
@@ -0,0 +1,50 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/arm/tesla-sysreg.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Tesla Full Self-Driving platform's system registers
+
+maintainers:
+  - Alim Akhtar <alim.akhtar@samsung.com>
+
+description: |
+  This is a system control registers block, providing multiple low level
+  platform functions like board detection and identification, software
+  interrupt generation.
+
+properties:
+  compatible:
+    oneOf:
+      - items:
+          - enum:
+              - tesla,sysreg_fsys0
+              - tesla,sysreg_peric
+          - const: syscon
+
+  reg:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+
+additionalProperties: false
+
+examples:
+  - |
+    soc {
+      #address-cells = <2>;
+      #size-cells = <2>;
+
+      sysreg_fsys0: system-controller@15030000 {
+            compatible = "tesla,sysreg_fsys0", "syscon";
+            reg = <0x0 0x15030000 0x0 0x1000>;
+      };
+
+      sysreg_peric: system-controller@14030000 {
+            compatible = "tesla,sysreg_peric", "syscon";
+            reg = <0x0 0x14030000 0x0 0x1000>;
+      };
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index a198da986146..56995e7d63ad 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2943,6 +2943,7 @@ M:	linux-fsd@tesla.com
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 L:	linux-samsung-soc@vger.kernel.org
 S:	Maintained
+F:	Documentation/devicetree/bindings/arm/tesla-sysreg.yaml
 F:	arch/arm64/boot/dts/tesla*
 
 ARM/TETON BGA MACHINE SUPPORT
-- 
2.17.1

