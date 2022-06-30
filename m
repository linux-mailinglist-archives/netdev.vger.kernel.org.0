Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79C17561AA0
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 14:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235050AbiF3MqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 08:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235001AbiF3MqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 08:46:13 -0400
Received: from smtp11.infineon.com (smtp11.infineon.com [IPv6:2a00:18f0:1e00:4::5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC2F22508;
        Thu, 30 Jun 2022 05:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1656593172; x=1688129172;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=t84O14azMaMNR/tz7MWmKJe0OmdgJaTNB2neB/QIZuk=;
  b=b0iSLqs1xJfQpqcW5t4VJoBmHvazdVfkz4DCj8yLrMwPC7lyJg58FAFt
   mze9riPMYAxbV20WcmHUBer7SXEIrY9UeAS9IU3iuYvb93PPMbBXN3KhE
   WTnVvqCPm7CqzqJBZNqqCmi7WquIbfwDaxdAZ30nQJJaf0ewJVereGM9p
   s=;
X-SBRS: None
X-IronPort-AV: E=McAfee;i="6400,9594,10393"; a="304013072"
X-IronPort-AV: E=Sophos;i="5.92,234,1650924000"; 
   d="scan'208";a="304013072"
Received: from unknown (HELO mucxv003.muc.infineon.com) ([172.23.11.20])
  by smtp11.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 14:46:11 +0200
Received: from MUCSE805.infineon.com (MUCSE805.infineon.com [172.23.29.31])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mucxv003.muc.infineon.com (Postfix) with ESMTPS;
        Thu, 30 Jun 2022 14:46:11 +0200 (CEST)
Received: from MUCSE807.infineon.com (172.23.29.33) by MUCSE805.infineon.com
 (172.23.29.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 30 Jun
 2022 14:46:11 +0200
Received: from ISCNPF0RJXQS.infineon.com (172.23.8.247) by
 MUCSE807.infineon.com (172.23.29.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Thu, 30 Jun 2022 14:46:09 +0200
From:   Hakan Jansson <hakan.jansson@infineon.com>
CC:     Hakan Jansson <hakan.jansson@infineon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "Luiz Augusto von Dentz" <luiz.dentz@gmail.com>,
        <linux-bluetooth@vger.kernel.org>
Subject: [PATCH v2 3/5] Bluetooth: hci_bcm: Add DT compatible for CYW55572
Date:   Thu, 30 Jun 2022 14:45:22 +0200
Message-ID: <6d17c74d01e785ca7db21d611a5722943aeffdd3.1656583541.git.hakan.jansson@infineon.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1656583541.git.hakan.jansson@infineon.com>
References: <cover.1656583541.git.hakan.jansson@infineon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.23.8.247]
X-ClientProxiedBy: MUCSE824.infineon.com (172.23.29.55) To
 MUCSE807.infineon.com (172.23.29.33)
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CYW55572 is a Wi-Fi + Bluetooth combo device from Infineon.

Signed-off-by: Hakan Jansson <hakan.jansson@infineon.com>
---
V1 -> V2:
  - No changes, submitted as part of updated patch series

 drivers/bluetooth/hci_bcm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bluetooth/hci_bcm.c b/drivers/bluetooth/hci_bcm.c
index 6f834ff1b44b..9a129867a4c0 100644
--- a/drivers/bluetooth/hci_bcm.c
+++ b/drivers/bluetooth/hci_bcm.c
@@ -1557,6 +1557,7 @@ static const struct of_device_id bcm_bluetooth_of_match[] = {
 	{ .compatible = "brcm,bcm4349-bt", .data = &bcm43438_device_data },
 	{ .compatible = "brcm,bcm43540-bt", .data = &bcm4354_device_data },
 	{ .compatible = "brcm,bcm4335a0" },
+	{ .compatible = "infineon,cyw55572-bt" },
 	{ },
 };
 MODULE_DEVICE_TABLE(of, bcm_bluetooth_of_match);
-- 
2.25.1

