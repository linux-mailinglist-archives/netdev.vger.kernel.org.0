Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8D6B640900
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 16:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233732AbiLBPMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 10:12:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233707AbiLBPMO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 10:12:14 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B4298546;
        Fri,  2 Dec 2022 07:12:13 -0800 (PST)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 2182715CC;
        Fri,  2 Dec 2022 16:12:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1669993931;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ryyz8/ynnKevChebtMryHbd9slV8Kyps8Up1I1RJ+G4=;
        b=cacZUseSbJSKJzQHS7+s92sPKYQWE/4BXysE46NM5BH0FOfFA6l+DDJPqfR0xtPg2nFvkr
        ezpavx1GTaB2krxRTtMe/1sQQouvQtl1QGFAejN13A4QG8gyVuRoqMIzJDnTTtWYw99yih
        Ol2EaQNN21HadhqoMe1igvlQnglaSufCZiUHXJsD/BWoI2P+ZJJq2JFvdJAPU3eTZFmCMp
        5tlLiKRAcny7BpGn7z1RUWhPF+x+jQ8aqKSsVz5uAxun08LotDrzViXyJYni+KIciIYrwj
        GfL02MZMMgNk8DbzKk7cMK9C1UUTfuPFHD0Tk7aGHyAbQ5k4v6+lOJZU09okzg==
From:   Michael Walle <michael@walle.cc>
To:     Xu Liang <lxu@maxlinear.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v1 2/4] dt-bindings: vendor-prefixes: add MaxLinear
Date:   Fri,  2 Dec 2022 16:12:02 +0100
Message-Id: <20221202151204.3318592-3-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221202151204.3318592-1-michael@walle.cc>
References: <20221202151204.3318592-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MaxLinear is a manufacturer of integrated circuits.
https://www.maxlinear.com

Signed-off-by: Michael Walle <michael@walle.cc>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 10c178d97b02..ae13a8776364 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -773,6 +773,8 @@ patternProperties:
     description: MaxBotix Inc.
   "^maxim,.*":
     description: Maxim Integrated Products
+  "^maxlinear,.*":
+    description: MaxLinear Inc.
   "^mbvl,.*":
     description: Mobiveil Inc.
   "^mcube,.*":
-- 
2.30.2

