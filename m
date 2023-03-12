Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF0FC6B67B3
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 16:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbjCLPyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 11:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjCLPyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 11:54:54 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [217.70.178.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14DDB26840;
        Sun, 12 Mar 2023 08:54:51 -0700 (PDT)
Received: (Authenticated sender: didi.debian@cknow.org)
        by mail.gandi.net (Postfix) with ESMTPSA id 4601E100005;
        Sun, 12 Mar 2023 15:54:47 +0000 (UTC)
From:   Diederik de Haas <didi.debian@cknow.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Vasily Khoruzhick <anarsoul@gmail.com>,
        Alistair Francis <alistair@alistair23.me>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list)
Cc:     Diederik de Haas <didi.debian@cknow.org>
Subject: [PATCH] dt-bindings: net: realtek-bluetooth: Fix double RTL8723CS in desc
Date:   Sun, 12 Mar 2023 16:54:35 +0100
Message-Id: <20230312155435.12334-1-didi.debian@cknow.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The description says 'RTL8723CS/RTL8723CS/...' whereas the title and
other places reference 'RTL8723BS/RTL8723CS/...'.

Signed-off-by: Diederik de Haas <didi.debian@cknow.org>
---
I used bluetooth-next's master dd 2023-03-12 as base as opposed to
6.3-rc1 as it would otherwise conflict with "[PATCH 1/3 V4] dt-bindings:
net: realtek-bluetooth: Add RTL8821CS" which has been merged already
into bluetooth-next's master branch.
I can rebase it onto something else if needed.

 Documentation/devicetree/bindings/net/realtek-bluetooth.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml b/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml
index 8cc2b9924680..eb05be35664e 100644
--- a/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml
+++ b/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml
@@ -11,7 +11,7 @@ maintainers:
   - Alistair Francis <alistair@alistair23.me>
 
 description:
-  RTL8723CS/RTL8723CS/RTL8821CS/RTL8822CS is a WiFi + BT chip. WiFi part
+  RTL8723BS/RTL8723CS/RTL8821CS/RTL8822CS is a WiFi + BT chip. WiFi part
   is connected over SDIO, while BT is connected over serial. It speaks
   H5 protocol with few extra commands to upload firmware and change
   module speed.
-- 
2.39.2

