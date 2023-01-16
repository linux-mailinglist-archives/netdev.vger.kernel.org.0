Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9C966C127
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 15:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbjAPOIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 09:08:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231934AbjAPOHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 09:07:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BBC7241D2;
        Mon, 16 Jan 2023 06:03:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09C9D60FCB;
        Mon, 16 Jan 2023 14:03:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD974C4339B;
        Mon, 16 Jan 2023 14:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877816;
        bh=50JsM5P8iufR5LkH0954GZk0lKp+NdSus1Sdgy8HHSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rWsZSLd2g6Fj7evmxeoVC+lk3laW1uIPWKRXxvMGVJkJepQT24MfJy1csHA3eGI3t
         1ujCgbvGam+G14U3AQ6mtcAZiAYvsVy1dmyFuOP1AxhoQ3W1LZLih1OpoxCvR09Bon
         5S0Rf4YIjK7SvmpPJgI7XQhnsfWBP/nDWUFOwaTJaf58qu7l9rSq94yMYQLbeeAKJJ
         jj93ZsmAom3qr8lG9e9fC+GhGaNFdPHbnAi1VC9ASLUZvr6A6WTzrHUufKCG0aulVY
         QISFuo8T9Kmw+J/CpeT+ttj0BbMZx4rRaBaeKOYgZ7ecrq9tBCfGbBy4FtXawJEiOy
         jRmSR6jvC0Gsw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, hayeswang@realtek.com,
        jflf_kernel@gmx.com, mkl@pengutronix.de, dober6023@gmail.com,
        gaul@gaul.org, svenva@chromium.org,
        wsa+renesas@sang-engineering.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 43/53] r8152: add vendor/device ID pair for Microsoft Devkit
Date:   Mon, 16 Jan 2023 09:01:43 -0500
Message-Id: <20230116140154.114951-43-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140154.114951-1-sashal@kernel.org>
References: <20230116140154.114951-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit be53771c87f4e322a9835d3faa9cd73a4ecdec5b ]

The Microsoft Devkit 2023 is a an ARM64 based machine featuring a
Realtek 8153 USB3.0-to-GBit Ethernet adapter. As in their other
machines, Microsoft uses a custom USB device ID.

Add the respective ID values to the driver. This makes Ethernet work on
the MS Devkit device. The chip has been visually confirmed to be a
RTL8153.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Link: https://lore.kernel.org/r/20230111133228.190801-1-andre.przywara@arm.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index a481a1d831e2..23da1d9dafd1 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -9836,6 +9836,7 @@ static const struct usb_device_id rtl8152_table[] = {
 	REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x07ab),
 	REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x07c6),
 	REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x0927),
+	REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x0c5e),
 	REALTEK_USB_DEVICE(VENDOR_ID_SAMSUNG, 0xa101),
 	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x304f),
 	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3054),
-- 
2.35.1

