Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E22F49C595
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 09:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238583AbiAZIyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 03:54:04 -0500
Received: from air.basealt.ru ([194.107.17.39]:47546 "EHLO air.basealt.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230231AbiAZIyD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 03:54:03 -0500
X-Greylist: delayed 523 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Jan 2022 03:54:03 EST
Received: by air.basealt.ru (Postfix, from userid 490)
        id 3840258980A; Wed, 26 Jan 2022 08:45:28 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on
        sa.local.altlinux.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=ham autolearn_force=no version=3.4.1
Received: from asheplyakov-rocket.smb.basealt.ru (unknown [193.43.9.4])
        by air.basealt.ru (Postfix) with ESMTPSA id 5143A58942B;
        Wed, 26 Jan 2022 08:45:26 +0000 (UTC)
From:   Alexey Sheplyakov <asheplyakov@basealt.ru>
To:     netdev@vger.kernel.org
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Alexey Sheplyakov <asheplyakov@basealt.ru>
Subject: [PATCH 2/2] dt-bindings: dwmac: Add bindings for Baikal-T1/M SoCs
Date:   Wed, 26 Jan 2022 12:44:56 +0400
Message-Id: <20220126084456.1122873-2-asheplyakov@basealt.ru>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220126084456.1122873-1-asheplyakov@basealt.ru>
References: <20220126084456.1122873-1-asheplyakov@basealt.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added dwmac bindings for Baikal-T1 and Baikal-M SoCs

Signed-off-by: Alexey Sheplyakov <asheplyakov@basealt.ru>
---
 Documentation/devicetree/bindings/net/snps,dwmac.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 7eb43707e601..a738059f03ef 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -53,6 +53,7 @@ properties:
         - allwinner,sun8i-r40-gmac
         - allwinner,sun8i-v3s-emac
         - allwinner,sun50i-a64-emac
+        - baikal,dwmac
         - loongson,ls2k-dwmac
         - loongson,ls7a-dwmac
         - amlogic,meson6-dwmac
-- 
2.32.0

