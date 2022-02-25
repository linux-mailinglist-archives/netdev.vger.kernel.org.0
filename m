Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48CF74C4FD0
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 21:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236763AbiBYUmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 15:42:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236724AbiBYUmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 15:42:35 -0500
Received: from mail.z3ntu.xyz (mail.z3ntu.xyz [128.199.32.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C4120B38C;
        Fri, 25 Feb 2022 12:42:02 -0800 (PST)
Received: from localhost.localdomain (ip-213-127-118-180.ip.prioritytelecom.net [213.127.118.180])
        by mail.z3ntu.xyz (Postfix) with ESMTPSA id BD49FC85A1;
        Fri, 25 Feb 2022 20:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=z3ntu.xyz; s=z3ntu;
        t=1645821721; bh=j4YPX1CJ6VNZFXbZ5LbV8+gDCRq7x3CH1YNtj2VgEro=;
        h=From:To:Cc:Subject:Date;
        b=X+VvD8y+TkjSA2jNk+cTB3Q39mXsDUYM4FyNXTtc2PQ1HyLZkqPIlhT8v/in7+c2r
         uj+0SM2p+/YLkJ9TbXHkQwoePKuZ64v+ahyBZRjaNRz/QF+qaXL0+uMYEsU6Mp9Uf/
         T/KgujMZL8ry0oQqzETbmAbO872aEsmPNhG1l7VA=
From:   Luca Weiss <luca@z3ntu.xyz>
To:     linux-arm-msm@vger.kernel.org
Cc:     ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        marcel@holtmann.org, Luca Weiss <luca@z3ntu.xyz>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] dt-bindings: bluetooth: broadcom: add BCM43430A0 & BCM43430A1
Date:   Fri, 25 Feb 2022 21:41:37 +0100
Message-Id: <20220225204138.935022-1-luca@z3ntu.xyz>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        FROM_SUSPICIOUS_NTLD_FP,PDS_OTHER_BAD_TLD,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the compatible string for BCM43430A0 bluetooth used in lg-lenok
and BCM43430A1 used in asus-sparrow.

Signed-off-by: Luca Weiss <luca@z3ntu.xyz>
---
Changes in v2:
- add bcm43430a1 too, adjust commit message to reflect that

 Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml b/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
index 5aac094fd217..dd035ca639d4 100644
--- a/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
+++ b/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
@@ -19,6 +19,8 @@ properties:
       - brcm,bcm4329-bt
       - brcm,bcm4330-bt
       - brcm,bcm4334-bt
+      - brcm,bcm43430a0-bt
+      - brcm,bcm43430a1-bt
       - brcm,bcm43438-bt
       - brcm,bcm4345c5
       - brcm,bcm43540-bt
-- 
2.35.1

