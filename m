Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1B7F6D17CC
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 08:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbjCaGvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 02:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230312AbjCaGvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 02:51:33 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E62B218FB6;
        Thu, 30 Mar 2023 23:51:31 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 32V6pE5C105773;
        Fri, 31 Mar 2023 01:51:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1680245474;
        bh=vGBhGYvpgjeEYIuKWwwOIITaxx25iDjlNuGwkM0tj2c=;
        h=From:To:CC:Subject:Date;
        b=f9viaPDlOFS1UWTstUSVYsmn04atOyb+DWPpyRku418NAQbE1GahiMcm/DeGMWH7n
         hGa+cY5qdQcPSCrVwqto+VTXXwFabeEFOMa3r1U6Y7LgOloapmrR3jQS2M9vvFwGiF
         CbkA8q5KWma/yPkB6BXGlmfrPno1corIc0Evk72I=
Received: from DFLE105.ent.ti.com (dfle105.ent.ti.com [10.64.6.26])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 32V6pEkL084509
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 31 Mar 2023 01:51:14 -0500
Received: from DFLE100.ent.ti.com (10.64.6.21) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Fri, 31
 Mar 2023 01:51:14 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Fri, 31 Mar 2023 01:51:14 -0500
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 32V6pAmQ017251;
        Fri, 31 Mar 2023 01:51:11 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <linux@armlinux.org.uk>, <pabeni@redhat.com>, <rogerq@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH net-next 0/2] Add support for J784S4 CPSW9G
Date:   Fri, 31 Mar 2023 12:21:08 +0530
Message-ID: <20230331065110.604516-1-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

This series adds a new compatible to am65-cpsw driver for the CPSW9G
instance of the CPSW Ethernet Switch on TI's J784S4 SoC which has 8
external ports and 1 internal host port.

The CPSW9G instance supports QSGMII and USXGMII modes for which driver
support is added.

Regards,
Siddharth.

Siddharth Vadapalli (2):
  net: ethernet: ti: am65-cpsw: Enable QSGMII for J784S4 CPSW9G
  net: ethernet: ti: am65-cpsw: Enable USXGMII mode for J784S4 CPSW9G

 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

-- 
2.25.1

