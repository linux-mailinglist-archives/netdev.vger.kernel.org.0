Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCE4455180C
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 14:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242231AbiFTMCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 08:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242052AbiFTMCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 08:02:37 -0400
Received: from smtp11.infineon.com (smtp11.infineon.com [IPv6:2a00:18f0:1e00:4::5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD68718B10;
        Mon, 20 Jun 2022 05:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1655726557; x=1687262557;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NL06rcosqN3GSd/3W97hrwd/bGoUybLQu/XsjjGQzbg=;
  b=ebDzrDYwcL6iA+ta0leOu3qyOTknqjcny+d/GJoakbFBfiYaatqcVoUL
   UMI+qGD85WR7ojzBE8IA4PyyExYCvJ3FB18ITUhnng5lJ7hUzJiKtoK7R
   YzfX1zLopD8vPApuCJ/F2o7zKlP2IPZEyjJtiJaD3iqjaZnFqJh60RFBI
   U=;
X-SBRS: None
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="301894353"
X-IronPort-AV: E=Sophos;i="5.92,306,1650924000"; 
   d="scan'208";a="301894353"
Received: from unknown (HELO mucxv002.muc.infineon.com) ([172.23.11.17])
  by smtp11.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 14:02:35 +0200
Received: from MUCSE803.infineon.com (MUCSE803.infineon.com [172.23.29.29])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mucxv002.muc.infineon.com (Postfix) with ESMTPS;
        Mon, 20 Jun 2022 14:02:34 +0200 (CEST)
Received: from MUCSE807.infineon.com (172.23.29.33) by MUCSE803.infineon.com
 (172.23.29.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 20 Jun
 2022 14:02:33 +0200
Received: from ISCNPF0RJXQS.infineon.com (172.23.8.247) by
 MUCSE807.infineon.com (172.23.29.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Mon, 20 Jun 2022 14:02:32 +0200
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
Subject: [PATCH 2/4] Bluetooth: hci_bcm: Add DT compatible for CYW55572
Date:   Mon, 20 Jun 2022 14:01:27 +0200
Message-ID: <814d9e73bdf784cb29b0976c7fea227c4740ea3b.1655723462.git.hakan.jansson@infineon.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1655723462.git.hakan.jansson@infineon.com>
References: <cover.1655723462.git.hakan.jansson@infineon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.23.8.247]
X-ClientProxiedBy: MUCSE805.infineon.com (172.23.29.31) To
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

