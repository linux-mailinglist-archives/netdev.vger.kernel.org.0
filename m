Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC67430D75
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 03:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344933AbhJRB36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 21:29:58 -0400
Received: from mx.socionext.com ([202.248.49.38]:31204 "EHLO mx.socionext.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242964AbhJRB34 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 Oct 2021 21:29:56 -0400
Received: from unknown (HELO kinkan2-ex.css.socionext.com) ([172.31.9.52])
  by mx.socionext.com with ESMTP; 18 Oct 2021 10:27:43 +0900
Received: from mail.mfilter.local (m-filter-1 [10.213.24.61])
        by kinkan2-ex.css.socionext.com (Postfix) with ESMTP id D7AE62059034;
        Mon, 18 Oct 2021 10:27:43 +0900 (JST)
Received: from 172.31.9.51 (172.31.9.51) by m-FILTER with ESMTP; Mon, 18 Oct 2021 10:27:43 +0900
Received: from plum.e01.socionext.com (unknown [10.212.243.119])
        by kinkan2.css.socionext.com (Postfix) with ESMTP id 79754B62B7;
        Mon, 18 Oct 2021 10:27:43 +0900 (JST)
From:   Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Subject: [PATCH net-next 1/2] dt-bindings: net: ave: Add bindings for NX1 SoC
Date:   Mon, 18 Oct 2021 10:27:36 +0900
Message-Id: <1634520457-16440-2-git-send-email-hayashi.kunihiko@socionext.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1634520457-16440-1-git-send-email-hayashi.kunihiko@socionext.com>
References: <1634520457-16440-1-git-send-email-hayashi.kunihiko@socionext.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update AVE binding document for UniPhier NX1 SoC.

Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
---
 Documentation/devicetree/bindings/net/socionext,uniphier-ave4.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/socionext,uniphier-ave4.yaml b/Documentation/devicetree/bindings/net/socionext,uniphier-ave4.yaml
index 8a03a24a2019..6bc61c42418f 100644
--- a/Documentation/devicetree/bindings/net/socionext,uniphier-ave4.yaml
+++ b/Documentation/devicetree/bindings/net/socionext,uniphier-ave4.yaml
@@ -24,6 +24,7 @@ properties:
       - socionext,uniphier-ld11-ave4
       - socionext,uniphier-ld20-ave4
       - socionext,uniphier-pxs3-ave4
+      - socionext,uniphier-nx1-ave4
 
   reg:
     maxItems: 1
-- 
2.7.4

