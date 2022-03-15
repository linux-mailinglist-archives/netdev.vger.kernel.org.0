Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 996FA4DA4E4
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 22:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352052AbiCOVxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 17:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348289AbiCOVx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 17:53:29 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [202.36.163.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C8E85BE6C
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 14:52:15 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id A0F282C066E;
        Tue, 15 Mar 2022 21:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1647381133;
        bh=Hh+egm05mOUbbME9zxNGUWPkWcPT9aPHDRgEzf3Zby8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=drYDRyil/p900aJNMTOhwHDLHHsg7LQohD0/gdX51zbxqzlPAimlJR3bjcwAfb8AR
         KixLF26cXhP4HOm381nOYZ3m/pQVPL+3r+HwncItKBuVGQs3UI32xEdIuaA2E2yc1o
         HA1SqGZEMayetTrVPQ0AQEA3c4pMQT1YVw3hwUDbMpXVugG/gt6lcPG0dXKM447Pyh
         7mceSdr19sopR0GH8iEwvrWaoM9d+eJcx2Bp9dXeEknVjP4S2YtQ6RmsYjGjrcrTWx
         56+OqRWoDBJFQRtABQrvX5hTE77nT05gEB/3MJDYYgtz5kZQuVQfG8m0wCA7LP7Z+i
         nn5WQv8YOMXQA==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B62310a8d0001>; Wed, 16 Mar 2022 10:52:13 +1300
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.30])
        by pat.atlnz.lc (Postfix) with ESMTP id 4C95613EE37;
        Wed, 16 Mar 2022 10:52:13 +1300 (NZDT)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id 034372A2677; Wed, 16 Mar 2022 10:52:10 +1300 (NZDT)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        thomas.petazzoni@bootlin.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH net-next v4 1/2] dt-bindings: net: mvneta: Add marvell,armada-ac5-neta
Date:   Wed, 16 Mar 2022 10:52:06 +1300
Message-Id: <20220315215207.2746793-2-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220315215207.2746793-1-chris.packham@alliedtelesis.co.nz>
References: <20220315215207.2746793-1-chris.packham@alliedtelesis.co.nz>
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
    Changes in v4:
    - None
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

