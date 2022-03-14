Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA4B34D8EBC
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 22:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245294AbiCNVdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 17:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245257AbiCNVdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 17:33:23 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A6D33335C
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 14:32:10 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id EC1B32C0C23;
        Mon, 14 Mar 2022 21:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1647293527;
        bh=L4VCOUAX7o5pSVh/zKud04ppcqVy8H/eB4l1M5HSVy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AGU44anjyAvxn1CkK7IQsm9DXOwsSNvpHEs6TWsiueC2vDsZOp4R29uB2SOePwlB2
         kB/eY116C5kpjzfodqts9x9NeEIx1DmUhBvd1ep87lEeX1Q2ycruZSPB0veTQGZlEZ
         Max+dhTprmWYDJLVRvpbocBxHlF2Y/5X7DLxvAtVhrCZ4DhQ4RvKTJJt/308CjVDfU
         Xt+j6kX0ksC0Ten2FDDgxkXPSjDvfWRZvsjxdWRuIFUTdRG2mJEKEexwRvfgZh2y2H
         Xq06OfDLgvhdQ3Z4sQJTJBCuuKUEn/xf7DICfFZeSj8RnmWbNx59fut1k1Y2ccG2Ca
         C10nZ9mzWsESg==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B622fb4570002>; Tue, 15 Mar 2022 10:32:07 +1300
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.30])
        by pat.atlnz.lc (Postfix) with ESMTP id 0B2D013EE56;
        Tue, 15 Mar 2022 10:32:07 +1300 (NZDT)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id E541D2A267A; Tue, 15 Mar 2022 10:32:03 +1300 (NZDT)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     huziji@marvell.com, ulf.hansson@linaro.org, robh+dt@kernel.org,
        davem@davemloft.net, kuba@kernel.org, linus.walleij@linaro.org,
        catalin.marinas@arm.com, will@kernel.org, andrew@lunn.ch,
        gregory.clement@bootlin.com, sebastian.hesselbarth@gmail.com,
        adrian.hunter@intel.com, thomas.petazzoni@bootlin.com,
        kostap@marvell.com, robert.marko@sartura.hr
Cc:     linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH v2 2/8] dt-bindings: net: mvneta: Add marvell,armada-ac5-neta
Date:   Tue, 15 Mar 2022 10:31:37 +1300
Message-Id: <20220314213143.2404162-3-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314213143.2404162-1-chris.packham@alliedtelesis.co.nz>
References: <20220314213143.2404162-1-chris.packham@alliedtelesis.co.nz>
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
---

Notes:
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

