Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0CD4E3351
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 23:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbiCUW4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 18:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbiCUWzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 18:55:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498624546D3;
        Mon, 21 Mar 2022 15:37:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E033EB81A56;
        Mon, 21 Mar 2022 21:53:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5379BC340EE;
        Mon, 21 Mar 2022 21:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647899583;
        bh=jmP3FPdm1hh5kPbcapZm2SdByBPDlY4fxfWaKWpCmCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NUWmh4+m213ANSTaeKjakFURbudcihJTBuV22WtEKa8XqjmH+DWoW3Hi705uyF3DX
         xL+e3Gs9dsUTBWmdjCWng8T1AavA0WNBLFEu1Vk7uRmYks4SM8bG2rqRlpxp3/+e7L
         nPVEbQXTdlnPV5J6HC6Gfw06Rf6zJJYTaLaxVROMCB+c8z+n8a0SKrvEKgw/d5qd46
         h3RNwj1dOhM5i1j3bLEEh8HFkTr3szg9K8FxO4fYs9+vIGBjp3qmNOcBV4hQu88fbt
         vhz3ZU/m5G71iOnXHODhrVKk3NYnHVPkKfuLrjjODdAydWFboST9RDM1U4e++qLInq
         DQv0RT/suVbhA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 4/5] net: dsa: microchip: add spi_device_id tables
Date:   Mon, 21 Mar 2022 17:52:52 -0400
Message-Id: <20220321215256.490267-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220321215256.490267-1-sashal@kernel.org>
References: <20220321215256.490267-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit e981bc74aefc6a177b50c16cfa7023599799cf74 ]

Add spi_device_id tables to avoid logs like "SPI driver ksz9477-switch
has no spi_device_id".

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz8795_spi.c | 11 +++++++++++
 drivers/net/dsa/microchip/ksz9477_spi.c | 12 ++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz8795_spi.c b/drivers/net/dsa/microchip/ksz8795_spi.c
index 866767b70d65..b0a7dee27ffc 100644
--- a/drivers/net/dsa/microchip/ksz8795_spi.c
+++ b/drivers/net/dsa/microchip/ksz8795_spi.c
@@ -124,12 +124,23 @@ static const struct of_device_id ksz8795_dt_ids[] = {
 };
 MODULE_DEVICE_TABLE(of, ksz8795_dt_ids);
 
+static const struct spi_device_id ksz8795_spi_ids[] = {
+	{ "ksz8765" },
+	{ "ksz8794" },
+	{ "ksz8795" },
+	{ "ksz8863" },
+	{ "ksz8873" },
+	{ },
+};
+MODULE_DEVICE_TABLE(spi, ksz8795_spi_ids);
+
 static struct spi_driver ksz8795_spi_driver = {
 	.driver = {
 		.name	= "ksz8795-switch",
 		.owner	= THIS_MODULE,
 		.of_match_table = of_match_ptr(ksz8795_dt_ids),
 	},
+	.id_table = ksz8795_spi_ids,
 	.probe	= ksz8795_spi_probe,
 	.remove	= ksz8795_spi_remove,
 	.shutdown = ksz8795_spi_shutdown,
diff --git a/drivers/net/dsa/microchip/ksz9477_spi.c b/drivers/net/dsa/microchip/ksz9477_spi.c
index e3cb0e6c9f6f..43addeabfc25 100644
--- a/drivers/net/dsa/microchip/ksz9477_spi.c
+++ b/drivers/net/dsa/microchip/ksz9477_spi.c
@@ -98,12 +98,24 @@ static const struct of_device_id ksz9477_dt_ids[] = {
 };
 MODULE_DEVICE_TABLE(of, ksz9477_dt_ids);
 
+static const struct spi_device_id ksz9477_spi_ids[] = {
+	{ "ksz9477" },
+	{ "ksz9897" },
+	{ "ksz9893" },
+	{ "ksz9563" },
+	{ "ksz8563" },
+	{ "ksz9567" },
+	{ },
+};
+MODULE_DEVICE_TABLE(spi, ksz9477_spi_ids);
+
 static struct spi_driver ksz9477_spi_driver = {
 	.driver = {
 		.name	= "ksz9477-switch",
 		.owner	= THIS_MODULE,
 		.of_match_table = of_match_ptr(ksz9477_dt_ids),
 	},
+	.id_table = ksz9477_spi_ids,
 	.probe	= ksz9477_spi_probe,
 	.remove	= ksz9477_spi_remove,
 	.shutdown = ksz9477_spi_shutdown,
-- 
2.34.1

