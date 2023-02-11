Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE2D7692DAB
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 04:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbjBKDTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 22:19:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbjBKDSk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 22:18:40 -0500
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A0323113;
        Fri, 10 Feb 2023 19:18:39 -0800 (PST)
Received: from localhost (unknown [86.120.32.152])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: cristicc)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 5630F6602114;
        Sat, 11 Feb 2023 03:18:38 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1676085518;
        bh=Qz2BvAFfeR2pDH8idXft8j3/6B8ejfNa6vswzgvImNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GHzfI5rdTu9/UZQWhAxLUwT9InbdtWjYgD9KO+/XqXr3fY4lXHlyWhChStvUQR01m
         xRLs4k3bnjFo8PWBFh51vKusUx9xj/uvL1FNUKDZXF6f9TCCX2LQ3ULqnJT1TZ0Tyo
         Rz2D4/dDd9ddU/gHRWbfF5cH8VA38de5O2pTkRwv9EqmpIRkh9frNe8X/026R1N8V4
         Tq9vVpS9hVB1I6Osa42muP8FW4Evlh11PlZ2njTaino7d+ojKQlCzS8vR7PsyWDO92
         Wss6o1LNqXIDWpvrF/z0PG5pbHmgejn/aF+Ufr5DMyRRDfMUSQF2ud2JT48tfS+Qgu
         v1uC6CLBuhwsQ==
From:   Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
To:     Lee Jones <lee@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Conor Dooley <conor@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Sagar Kadam <sagar.kadam@sifive.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com
Subject: [PATCH 02/12] dt-bindings: riscv: sifive-ccache: Add 'uncached-offset' property
Date:   Sat, 11 Feb 2023 05:18:11 +0200
Message-Id: <20230211031821.976408-3-cristian.ciocaltea@collabora.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230211031821.976408-1-cristian.ciocaltea@collabora.com>
References: <20230211031821.976408-1-cristian.ciocaltea@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the 'uncached-offset' property to be used for specifying the
uncached memory offset required for handling non-coherent DMA
transactions.

Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
---
 Documentation/devicetree/bindings/riscv/sifive,ccache0.yaml | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/riscv/sifive,ccache0.yaml b/Documentation/devicetree/bindings/riscv/sifive,ccache0.yaml
index 2b864b2f12c9..60cd87a2810a 100644
--- a/Documentation/devicetree/bindings/riscv/sifive,ccache0.yaml
+++ b/Documentation/devicetree/bindings/riscv/sifive,ccache0.yaml
@@ -82,6 +82,11 @@ properties:
 
   next-level-cache: true
 
+  uncached-offset:
+    $ref: /schemas/types.yaml#/definitions/uint64
+    description: |
+      Uncached memory offset for handling non-coherent DMA transactions.
+
   memory-region:
     maxItems: 1
     description: |
-- 
2.39.1

