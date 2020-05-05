Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB661C52FA
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 12:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728580AbgEEKTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 06:19:46 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:35546 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbgEEKTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 06:19:43 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 045AJb43063482;
        Tue, 5 May 2020 05:19:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588673978;
        bh=lPTQ8Twk3syYonvOqVZRnfi9SPcexxBQ4TGe67riypU=;
        h=From:To:CC:Subject:Date;
        b=gsFPAmw0ohbWG5bGZ3GN1vLBBZ5aSt3BEI84QGj9UruSINeeL2BBqtWf+zxW8XC91
         vkrZD9znhsUlnr2T7lebTN0DYEKdYw7hPTYdAWOr3qKoKVL0U1qFPXW3wMUcJCcERF
         8jMCg4fdvqxoSxHh9VbghUL7rBLElkVnM0sa2O5U=
Received: from DFLE111.ent.ti.com (dfle111.ent.ti.com [10.64.6.32])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 045AJbuV015398
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 5 May 2020 05:19:37 -0500
Received: from DFLE106.ent.ti.com (10.64.6.27) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 5 May
 2020 05:19:37 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 5 May 2020 05:19:37 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 045AJasc031149;
        Tue, 5 May 2020 05:19:37 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>
CC:     <netdev@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH net-next] dt-binding: net: ti: am65x-cpts: fix dt_binding_check fail
Date:   Tue, 5 May 2020 13:19:35 +0300
Message-ID: <20200505101935.12897-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix dt_binding_check fail:
Fix Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml: $id: relative path/filename doesn't match actual path or filename
	expected: http://devicetree.org/schemas/net/ti,k3-am654-cpts.yaml#
Unknown file referenced: [Errno 2] No such file or directory: '/usr/local/lib/python3.6/dist-packages/dtschema/schemas/net/ti,am654-cpts.yaml'
 Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml: $id: relative path/filename doesn't match actual path or filename
 expected: http://devicetree.org/schemas/net/ti,k3-am654-cpts.yaml#
Unknown file referenced: [Errno 2] No such file or directory: '/usr/local/lib/python3.6/dist-packages/dtschema/schemas/net/ti,am654-cpts.yaml'

Cc: Rob Herring <robh@kernel.org>
Fixes: 6e87ac748e94 ("dt-binding: ti: am65x: document common platform time sync cpts module")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 .../devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml          | 2 +-
 Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
index 0f3fde45e200..0c054a2ce5ba 100644
--- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
+++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
@@ -147,7 +147,7 @@ patternProperties:
   "^cpts$":
     type: object
     allOf:
-      - $ref: "ti,am654-cpts.yaml#"
+      - $ref: "ti,k3-am654-cpts.yaml#"
     description:
       CPSW Common Platform Time Sync (CPTS) module.
 
diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml
index 1b535d41e5c6..df83c320e61b 100644
--- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml
+++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
 %YAML 1.2
 ---
-$id: http://devicetree.org/schemas/net/ti,am654-cpts.yaml#
+$id: http://devicetree.org/schemas/net/ti,k3-am654-cpts.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
 title: The TI AM654x/J721E Common Platform Time Sync (CPTS) module Device Tree Bindings
-- 
2.17.1

