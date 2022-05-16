Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEDF65293C7
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 00:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349744AbiEPWsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 18:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349720AbiEPWsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 18:48:14 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E57D14131F
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 15:48:10 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id B34652C02EB;
        Mon, 16 May 2022 22:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1652741288;
        bh=ACc6IEVM0bn4IqAX/7zUWdQYsuQJlsTvqpTaLUAizYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yuw5zMByE5Ust6J4bHCiROIHJy7u4Dehfhvx7/lmkFvbuphuXrnNOz+tzgaVUf3JE
         O2hqCYvPFe0bmI1zx92CZdh62rC02j8TkpnVS29F8b9jun//PnpmceH4skZlt7sp9w
         6mKRwVqG5vFZPE+7Akzrd96TSuhBWrUtF9h+QWBMAfzPm7tH+1YaUVxqtchdkeiJeF
         wwgw1K/lbs6f26iPFTWLGyypWWqF0p8seGCzCQ2jSKKQdzGCqbgAh8oi0odspnimap
         yKFEC+JS3sNkhYLf60WOpYLvXDiVHoksy8urBUgipflbPv/KhWjzx8SQJQsXDPyTbe
         igTY9qD8byXow==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B6282d4a80002>; Tue, 17 May 2022 10:48:08 +1200
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.30])
        by pat.atlnz.lc (Postfix) with ESMTP id 72E8913ED7D;
        Tue, 17 May 2022 10:48:08 +1200 (NZST)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id 700E92A0086; Tue, 17 May 2022 10:48:08 +1200 (NZST)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, andrew@lunn.ch,
        gregory.clement@bootlin.com, sebastian.hesselbarth@gmail.com,
        kabel@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH 2/2] dt-bindings: net: marvell,orion-mdio: Set unevaluatedProperties to false
Date:   Tue, 17 May 2022 10:48:01 +1200
Message-Id: <20220516224801.1656752-3-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516224801.1656752-1-chris.packham@alliedtelesis.co.nz>
References: <20220516224801.1656752-1-chris.packham@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=U+Hs8tju c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=oZkIemNP1mAA:10 a=QXzqMLctjYEMqmhBL2EA:9
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the binding was converted it appeared necessary to set
'unevaluatedProperties: true' because of the switch devices on the
turris-mox board. Actually the error was because of the reg property
being incorrect causing the rest of the properties to be unevaluated.

After the reg properties are fixed for turris-mox we can set
'unevaluatedProperties: false' as is generally expected.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
---
 Documentation/devicetree/bindings/net/marvell,orion-mdio.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/marvell,orion-mdio.yam=
l b/Documentation/devicetree/bindings/net/marvell,orion-mdio.yaml
index fe3a3412f093..d2906b4a0f59 100644
--- a/Documentation/devicetree/bindings/net/marvell,orion-mdio.yaml
+++ b/Documentation/devicetree/bindings/net/marvell,orion-mdio.yaml
@@ -39,7 +39,7 @@ required:
   - compatible
   - reg
=20
-unevaluatedProperties: true
+unevaluatedProperties: false
=20
 examples:
   - |
--=20
2.36.1

