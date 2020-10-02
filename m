Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54E2D280D6A
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 08:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726036AbgJBGVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 02:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbgJBGVH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 02:21:07 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA5AEC0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 23:21:06 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601619664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=dmRXkbljcIcLvofqo51cTni2zbEAkdyaVwKfitIseos=;
        b=shNMW3VFwXqWcn6+ubQjQeR/6CRcXVCoKPy6Wv36G1AGCA0ysCKvF5H9SuVdkB8pSq/zz9
        XSsxbmzAtoJpHIvd8JYK4bOjoRJCYUPVBucofJXONkdT0rW0M1PA1lGzWErUSGaFCrzqBn
        KTdf6Xf/01wSQfF3yYozFqY4JRlCCcKDkOsDDwlxtzJLh/XqmNsVUdxJm4arlcDDKy85KE
        zxMf9mXXkrN6qaqwI/FxOLMEav0/jBw229nKbIHQaGNf+ugKPx0kb0MCmzFK1idSAx139D
        SQGFGVSQIFjCLehbsN78ckxxj+t4A6j7IuSIcjRCoPKSn+uPBM8yU5ZcV1Sprg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601619664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=dmRXkbljcIcLvofqo51cTni2zbEAkdyaVwKfitIseos=;
        b=3UgMdFVV9YbEKqlPMfNOSCQeyBPFqM7buDf980FrghvV3tRrEKKBREsBqpy6xoFgQJrsRz
        AiP0Mo36HgKXr5Cg==
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next] dt-bindings: net: dsa: b53: Add missing reg property to example
Date:   Fri,  2 Oct 2020 08:20:51 +0200
Message-Id: <20201002062051.8551-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The switch has a certain MDIO address and this needs to be specified using the
reg property. Add it to the example.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 Documentation/devicetree/bindings/net/dsa/b53.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/b53.txt b/Documentation/devicetree/bindings/net/dsa/b53.txt
index cfd1afdc6e94..80437b2fc935 100644
--- a/Documentation/devicetree/bindings/net/dsa/b53.txt
+++ b/Documentation/devicetree/bindings/net/dsa/b53.txt
@@ -106,6 +106,7 @@ Ethernet switch connected via MDIO to the host, CPU port wired to eth0:
 
 		switch0: ethernet-switch@30 {
 			compatible = "brcm,bcm53125";
+			reg = <30>;
 			#address-cells = <1>;
 			#size-cells = <0>;
 
-- 
2.20.1

