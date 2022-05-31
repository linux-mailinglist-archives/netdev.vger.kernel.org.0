Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D12ED538FDE
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 13:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343625AbiEaLbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 07:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235213AbiEaLbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 07:31:33 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C577B56FBE;
        Tue, 31 May 2022 04:31:32 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 24VBVGFF044912;
        Tue, 31 May 2022 06:31:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1653996676;
        bh=15TvHxwZmkBImPUYw0cYQeU2mzoHVYOnrEHB80/kkUA=;
        h=From:To:CC:Subject:Date;
        b=ibqbci39T+a6fTZhPnrfYwBEfgjL0pzHhgV8wilqSSkuhtvqmvqUv3op0hx8zTc9D
         URdbgjB1mwRyviTzhxCcz9Kj4DRpCGJY8Z3O9PHiMvSdj4HoujJfojFFcU5vWyFA8l
         +XkHjwNQsQchqz//bB6a/kXY6EnG6BABjmTMNjrY=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 24VBVGU4017478
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 31 May 2022 06:31:16 -0500
Received: from DLEE107.ent.ti.com (157.170.170.37) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Tue, 31
 May 2022 06:31:15 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Tue, 31 May 2022 06:31:15 -0500
Received: from ula0492258.dal.design.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 24VBV92o064165;
        Tue, 31 May 2022 06:31:10 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <linux@armlinux.org.uk>,
        <vladimir.oltean@nxp.com>, <grygorii.strashko@ti.com>,
        <vigneshr@ti.com>, <nsekhar@ti.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kishon@ti.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>
Subject: [PATCH 0/3] Add support for QSGMII mode to am65-cpsw driver
Date:   Tue, 31 May 2022 17:00:55 +0530
Message-ID: <20220531113058.23708-1-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for QSGMII mode to am65-cpsw driver.

For full functionality of QSGMII mode in am65-cpsw driver, phy-gmii-sel
driver has to be configured. This has been implemented in another series
at:
https://lore.kernel.org/r/20220531111221.22963-1-s-vadapalli@ti.com

There is no direct dependency on the above series being merged.

Siddharth Vadapalli (3):
  dt-bindings: net: ti: k3-am654-cpsw-nuss: Update bindings for J7200
    CPSW5G
  net: ethernet: ti: am65-cpsw: Add support for QSGMII mode
  net: ethernet: ti: am65-cpsw: Move phy_set_mode_ext() to correct
    location

 .../bindings/net/ti,k3-am654-cpsw-nuss.yaml   |  4 ++--
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      | 22 ++++++++++++++-----
 drivers/net/ethernet/ti/am65-cpsw-nuss.h      |  1 +
 3 files changed, 19 insertions(+), 8 deletions(-)

-- 
2.36.1

