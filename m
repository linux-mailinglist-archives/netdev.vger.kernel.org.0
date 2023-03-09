Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF8FA6B1C7C
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 08:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbjCIHgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 02:36:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbjCIHgl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 02:36:41 -0500
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF9B34007;
        Wed,  8 Mar 2023 23:36:37 -0800 (PST)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 3297aIHs075859;
        Thu, 9 Mar 2023 01:36:18 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1678347378;
        bh=4kesHyziIIecK257RJyxYTTFFwyIPqWkBk5KU73VZKE=;
        h=From:To:CC:Subject:Date;
        b=SypZOeqyUTUQoiV/fZfIYXyOHT2WeF91NnaHGPgLXIZvyDTExBjjdyt6Eu7IlgaGR
         03F1lVcOoSIV2i8L9bkYFdQLiLGL0U9Lo0emIUk7IkIbt9OSahj5/sweEisjATMjRd
         gOLceNZoWQ4ELByQERjSQ9cLBRsE7iTcJFM8OIY0=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 3297aIue015637
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 9 Mar 2023 01:36:18 -0600
Received: from DFLE111.ent.ti.com (10.64.6.32) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Thu, 9
 Mar 2023 01:36:17 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Thu, 9 Mar 2023 01:36:17 -0600
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 3297aDWv019672;
        Thu, 9 Mar 2023 01:36:13 -0600
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <linux@armlinux.org.uk>, <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <nsekhar@ti.com>,
        <rogerq@kernel.org>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH net-next v3 0/2] Update CPSW bindings for Serdes PHY
Date:   Thu, 9 Mar 2023 13:06:10 +0530
Message-ID: <20230309073612.431287-1-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

This series adds documentation for the Serdes PHY. Also, the name used to
refer to the Serdes PHY in the am65-cpsw driver is updated to match the
documented name.

---
Documenting the Serdes PHY bindings was missed out in the already merged
series at:
https://lore.kernel.org/r/20230104103432.1126403-1-s-vadapalli@ti.com/
This miss was pointed out at:
https://lore.kernel.org/r/CAMuHMdW5atq-FuLEL3htuE3t2uO86anLL3zeY7n1RqqMP_rH1g@mail.gmail.com/

Changes from v2:
1. Drop "phy" suffixes in the phy-names property, changing "mac-phy" and
   "serdes-phy" to "mac" and "serdes".
2. Add a new patch to update the name used by the am65-cpsw driver to
   refer to the Serdes PHY, from "serdes-phy" to "serdes".

Changes from v1:
1. Describe phys property with minItems, items and description.
2. Use minItems and items in phy-names.
3. Remove the description in phy-names.

v2:
https://lore.kernel.org/r/20230308051835.276552-1-s-vadapalli@ti.com/
v1:
https://lore.kernel.org/r/20230306094750.159657-1-s-vadapalli@ti.com/

Siddharth Vadapalli (2):
  dt-bindings: net: ti: k3-am654-cpsw-nuss: Document Serdes PHY
  net: ethernet: ti: am65-cpsw: Update name of Serdes PHY

 .../bindings/net/ti,k3-am654-cpsw-nuss.yaml        | 14 ++++++++++++--
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |  2 +-
 2 files changed, 13 insertions(+), 3 deletions(-)

-- 
2.25.1

