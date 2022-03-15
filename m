Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86A6D4D9231
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 02:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344259AbiCOBTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 21:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344245AbiCOBTK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 21:19:10 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF7EC14012
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 18:17:55 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 4D3852C0A56;
        Tue, 15 Mar 2022 01:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1647307073;
        bh=p8tBUemvUZ1bjRc8f+KeSaAtHGCEVnZWTcvNI577MMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hZuy5m6+K5SSU8lKaNV9Xs5PTM4jxMRO1p+IFde5ZHfaSiqbhr6ariWtew60KpEeW
         Cbt4dADnHOYKy8Yw9XE66o/n5vWHPTHqfNZtVqJ6YIjqRht1hUImRmjmPGJpplJcTH
         YDA/70ny0Myjye62Uuhjw66Ctx49ALFFLMlBlCY+JfVbEdp4FvwsNqrhQZ9mm81yF5
         lxCNbBIK7f+Dw35lU3JaCM3yQfZ889PM53+wmfIjC4vMECkumTIl7r8pBu5KgHyZQq
         pE9PxtDTeSava9l9DkR5/J0S5TpAZh9WFOQNQNui6HuR26uXwWLzZptBvK24yjjYa0
         aeLr9Go5ZisrA==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B622fe9400001>; Tue, 15 Mar 2022 14:17:52 +1300
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.30])
        by pat.atlnz.lc (Postfix) with ESMTP id C636713EE43;
        Tue, 15 Mar 2022 14:17:52 +1300 (NZDT)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id 56BD82A2677; Tue, 15 Mar 2022 14:17:50 +1300 (NZDT)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        thomas.petazzoni@bootlin.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH net-next v3 1/2] dt-bindings: net: mvneta: Add marvell,armada-ac5-neta
Date:   Tue, 15 Mar 2022 14:17:41 +1300
Message-Id: <20220315011742.2465356-2-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220315011742.2465356-1-chris.packham@alliedtelesis.co.nz>
References: <20220315011742.2465356-1-chris.packham@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=Cfh2G4jl c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=o8Y5sQTvuykA:10 a=GiZJWJlgZr2mIF3OtF0A:9
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

The out of band port on the 98DX2530 SoC is similar to the armada-3700
except it requires a slightly different MBUS window configuration. Add a
new compatible string so this difference can be accounted for.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---

Notes:
    Changes in v3:
    - Split from larger series
    - Add review from Andrew
    Changes in v2:
    - New

 .../devicetree/bindings/net/marvell-armada-370-neta.txt          | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/marvell-armada-370-net=
a.txt b/Documentation/devicetree/bindings/net/marvell-armada-370-neta.txt
index 691f886cfc4a..2bf31572b08d 100644
--- a/Documentation/devicetree/bindings/net/marvell-armada-370-neta.txt
+++ b/Documentation/devicetree/bindings/net/marvell-armada-370-neta.txt
@@ -5,6 +5,7 @@ Required properties:
 	"marvell,armada-370-neta"
 	"marvell,armada-xp-neta"
 	"marvell,armada-3700-neta"
+	"marvell,armada-ac5-neta"
 - reg: address and length of the register set for the device.
 - interrupts: interrupt for the device
 - phy: See ethernet.txt file in the same directory.
--=20
2.35.1

