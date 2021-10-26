Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD47F43BBF7
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 22:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239340AbhJZVBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 17:01:49 -0400
Received: from mx3.wp.pl ([212.77.101.9]:47737 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239338AbhJZVBs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 17:01:48 -0400
Received: (wp-smtpd smtp.wp.pl 34036 invoked from network); 26 Oct 2021 22:59:21 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1635281961; bh=ciiSD8e3sFSvv6OQDD+kH7vzEjtJ0FSP62EAVw0lZEI=;
          h=From:To:Cc:Subject;
          b=V/M8xH68E+maE3K/AV/TpdvEXncEYbL/gZbEAs6RgE6j9hVIyYosLISRVOArdYYXB
           32bidD6+xLl0/GTuijfjxHH0YkeF2kMXoVHT5NnhONF5faXJCk7z9THasz55JjMoA2
           6VAvX/1so1Yxd0jXY5BzErcuqJOMHCeyM+ZfWaPU=
Received: from riviera.nat.ds.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.1])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <hauke@hauke-m.de>; 26 Oct 2021 22:59:21 +0200
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     hauke@hauke-m.de, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc:     Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: [PATCH 2/2] dt-bindings: net: lantiq-xrx200-net: Remove the burst length properties
Date:   Tue, 26 Oct 2021 22:59:02 +0200
Message-Id: <20211026205902.335936-2-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211026205902.335936-1-olek2@wp.pl>
References: <20211026205902.335936-1-olek2@wp.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-DKIM-Status: good (id: wp.pl)                                      
X-WP-MailID: 83750962c7877fb74c247c2fcd4d4a37
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [0YMB]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All SoCs with this IP core support 8 burst length. Hauke
suggested to hardcode this value and simplify the driver.

Link: https://lkml.org/lkml/2021/9/14/1533
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 .../bindings/net/lantiq,xrx200-net.yaml          | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/lantiq,xrx200-net.yaml b/Documentation/devicetree/bindings/net/lantiq,xrx200-net.yaml
index 16d831f22063..7bc074a42369 100644
--- a/Documentation/devicetree/bindings/net/lantiq,xrx200-net.yaml
+++ b/Documentation/devicetree/bindings/net/lantiq,xrx200-net.yaml
@@ -29,18 +29,6 @@ properties:
       - const: tx
       - const: rx
 
-  lantiq,tx-burst-length:
-    $ref: /schemas/types.yaml#/definitions/uint32
-    description: |
-      TX programmable burst length.
-    enum: [2, 4, 8]
-
-  lantiq,rx-burst-length:
-    $ref: /schemas/types.yaml#/definitions/uint32
-    description: |
-      RX programmable burst length.
-    enum: [2, 4, 8]
-
   '#address-cells':
     const: 1
 
@@ -53,8 +41,6 @@ required:
   - interrupt-parent
   - interrupts
   - interrupt-names
-  - lantiq,tx-burst-length
-  - lantiq,rx-burst-length
   - "#address-cells"
   - "#size-cells"
 
@@ -70,6 +56,4 @@ examples:
         interrupt-parent = <&icu0>;
         interrupts = <73>, <72>;
         interrupt-names = "tx", "rx";
-        lantiq,tx-burst-length = <8>;
-        lantiq,rx-burst-length = <8>;
     };
-- 
2.30.2

