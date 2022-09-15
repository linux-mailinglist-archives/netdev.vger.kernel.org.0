Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9074E5BA1D8
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 22:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiIOUgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 16:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiIOUgs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 16:36:48 -0400
Received: from mx06lb.world4you.com (mx06lb.world4you.com [81.19.149.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E90144D14C
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 13:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xXfYo7mdEUbWtERxF42E9L0sZu0gezSE3rGnR0t53ho=; b=J/ZTRXQ1iW+zKBBdtxJOPha0Qm
        2jDzeYB8UGjw6B0Apb49JEDt6cEeMM2yua1VFK4aI1I0EAgOv26oBCmP8MpCscYtJMwcKDYn58kDP
        HVxAT+VWDw8/x1yz0WyrTmftx0JdEdx6QPrFzgbzAlQQvHUFiqd8oXVSMoePeuFK7dl4=;
Received: from 88-117-54-199.adsl.highway.telekom.at ([88.117.54.199] helo=hornet.engleder.at)
        by mx06lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1oYvbI-00086K-2u; Thu, 15 Sep 2022 22:36:44 +0200
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next 1/7] dt-bindings: net: tsnep: Allow dma-coherent
Date:   Thu, 15 Sep 2022 22:36:31 +0200
Message-Id: <20220915203638.42917-2-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220915203638.42917-1-gerhard@engleder-embedded.com>
References: <20220915203638.42917-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following dtbs_check error if dma-coherent is used:

...: 'dma-coherent' does not match any of the regexes: 'pinctrl-[0-9]+'
From schema: .../Documentation/devicetree/bindings/net/engleder,tsnep.yaml

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 Documentation/devicetree/bindings/net/engleder,tsnep.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/engleder,tsnep.yaml b/Documentation/devicetree/bindings/net/engleder,tsnep.yaml
index d0e1476e15b5..37e08ee744a8 100644
--- a/Documentation/devicetree/bindings/net/engleder,tsnep.yaml
+++ b/Documentation/devicetree/bindings/net/engleder,tsnep.yaml
@@ -22,6 +22,8 @@ properties:
   interrupts:
     maxItems: 1
 
+  dma-coherent: true
+
   local-mac-address: true
 
   mac-address: true
-- 
2.30.2

