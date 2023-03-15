Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 550EA6BAA3B
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 09:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbjCOIAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 04:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231741AbjCOIAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 04:00:14 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA1E366D3D;
        Wed, 15 Mar 2023 01:00:12 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 32F7xrH9054826;
        Wed, 15 Mar 2023 02:59:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1678867193;
        bh=/chdimC1GrtyDSZ38Uw6LyuDnCvg7dvq6j5vQRR9ksc=;
        h=From:To:CC:Subject:Date;
        b=BcBukwp+o9XXJfaK8N90ZB5UnVz8TzJi1BFEAj8JW/4HTYpiSTC9ho4ruN6Qnd38T
         FdGOiA4ieRyA9cRfVoM7q+jvb9IzHB1aWyk/vxnc8BFuIs1CL6deH+geBbCKw1FZ8r
         u80Gj9VxMYrbG52KNxMftLa7hF30TapZUNbPVos0=
Received: from DFLE103.ent.ti.com (dfle103.ent.ti.com [10.64.6.24])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 32F7xr3b048296
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Mar 2023 02:59:53 -0500
Received: from DFLE109.ent.ti.com (10.64.6.30) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Wed, 15
 Mar 2023 02:59:53 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Wed, 15 Mar 2023 02:59:53 -0500
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 32F7xmKb042755;
        Wed, 15 Mar 2023 02:59:49 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <nsekhar@ti.com>,
        <rogerq@kernel.org>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH net-next 0/2] Add J784S4 CPSW9G NET Bindings
Date:   Wed, 15 Mar 2023 13:29:46 +0530
Message-ID: <20230315075948.1683120-1-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

This series cleans up the bindings by reordering the compatibles, followed
by adding the bindings for CPSW9G instance of CPSW Ethernet Switch on TI's
J784S4 SoC.

Siddharth Vadapalli (2):
  dt-bindings: net: ti: k3-am654-cpsw-nuss: Fix compatible order
  dt-bindings: net: ti: k3-am654-cpsw-nuss: Add J784S4 CPSW9G support

 .../devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

-- 
2.25.1

