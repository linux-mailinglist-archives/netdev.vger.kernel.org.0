Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8C8E6499F2
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 09:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbiLLIQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 03:16:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiLLIQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 03:16:23 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D688C745;
        Mon, 12 Dec 2022 00:16:22 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1670832980;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zrsx5QRpxED70KTD4zLw9erRh4XFXoJec1PK5+HO4TI=;
        b=AZqr5eZGn5nqQ6wQGllROKyEAxIH16fMdnqMsWiyWUUrOebeixj2pWnsG+/TiHRDfvaHPT
        VHN+UewhuddWQJo+eUR+AqiWb/0OyfJ+zzwpuq6NOx6Zw5uoyRpelb4Ax9MHTMa0JCO1WB
        pOYDrrCZrOqwotJzoKsVnMiinteEiRlU2P1wwMA8FcEJtGggrZAhAje4+Y0vqZh/Szi6fu
        VimfgyBstTAXRcmZ+x8Qpu1VZTnsR0LE6qE0qFrkKh2SXbvG8aoIuuyfeSMTeIbUPw0eHW
        bDYZkY3xRvSt4H7LYIemIy7jqzVkBzIySuuzg/Z8YYe6N8qCz9G+ESZ+hXMTqA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1670832980;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zrsx5QRpxED70KTD4zLw9erRh4XFXoJec1PK5+HO4TI=;
        b=TSfdVrwVNgmi1K/wCwBzejcN8WQdpw4otZmCv+e4NXeD+474etRPRR6rHcnu8lvRyd8qzM
        zkGRb4dn9fuvSrAA==
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next] dt-bindings: net: dsa: hellcreek: Sync DSA maintainers
Date:   Mon, 12 Dec 2022 09:15:46 +0100
Message-Id: <20221212081546.6916-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current DSA maintainers are Florian Fainelli, Andrew Lunn and Vladimir
Oltean. Update the hellcreek binding accordingly.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 .../devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml       | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml b/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
index 73b774eadd0b..1d7dab31457d 100644
--- a/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
@@ -12,7 +12,7 @@ allOf:
 maintainers:
   - Andrew Lunn <andrew@lunn.ch>
   - Florian Fainelli <f.fainelli@gmail.com>
-  - Vivien Didelot <vivien.didelot@gmail.com>
+  - Vladimir Oltean <olteanv@gmail.com>
   - Kurt Kanzenbach <kurt@linutronix.de>
 
 description:
-- 
2.30.2

