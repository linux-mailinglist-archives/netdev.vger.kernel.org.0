Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 092DE4F53B0
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 06:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2361278AbiDFE0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 00:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346462AbiDEUOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 16:14:20 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96EFBF9579;
        Tue,  5 Apr 2022 12:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=eYk0gPFR2AUPJs0yZA7OBgLex9V+UAce7tSCv+EmtqU=; b=k4UniureN6YlXO0aih+66IQ0FY
        fKjeyCxoY8+22msCQUFMtQ5w1kwhF4L9zr4naG6u7600N0/f5u/FLGk8ImAf4WYbXq+zuQuBTTH6V
        8MpWsrgHU0KMFhHxjpd6lHw5z8SCZ9utBfNbolYxcsAHgwQ7cWqL1mF9BtfoTYblg10Q=;
Received: from p200300daa70ef200456864e8b8d10029.dip0.t-ipconnect.de ([2003:da:a70e:f200:4568:64e8:b8d1:29] helo=Maecks.lan)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1nbpJP-00035V-3W; Tue, 05 Apr 2022 21:57:59 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH v2 01/14] dt-bindings: net: mediatek: add optional properties for the SoC ethernet core
Date:   Tue,  5 Apr 2022 21:57:42 +0200
Message-Id: <20220405195755.10817-2-nbd@nbd.name>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405195755.10817-1-nbd@nbd.name>
References: <20220405195755.10817-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

Introduce dma-coherent, cci-control and hifsys optional properties to
the mediatek ethernet controller bindings

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 Documentation/devicetree/bindings/net/mediatek-net.txt | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/mediatek-net.txt b/Documentation/devicetree/bindings/net/mediatek-net.txt
index 72d03e07cf7c..13cb12ee4ed6 100644
--- a/Documentation/devicetree/bindings/net/mediatek-net.txt
+++ b/Documentation/devicetree/bindings/net/mediatek-net.txt
@@ -41,6 +41,12 @@ Required properties:
 - mediatek,pctl: phandle to the syscon node that handles the ports slew rate
 	and driver current: only for MT2701 and MT7623 SoC
 
+Optional properties:
+- dma-coherent: present if dma operations are coherent
+- mediatek,cci-control: phandle to the cache coherent interconnect node
+- mediatek,hifsys: phandle to the mediatek hifsys controller used to provide
+	various clocks and reset to the system.
+
 * Ethernet MAC node
 
 Required properties:
-- 
2.35.1

