Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9F6E31C1C1
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 19:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbhBOSjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 13:39:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:34134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230484AbhBOSia (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 13:38:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6BC564E2B;
        Mon, 15 Feb 2021 18:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613414228;
        bh=ZsYaZWVoy3Thd1L18Ga6lVGL/f6RrZzh2j1/jf5iUUM=;
        h=From:To:Cc:Subject:Date:From;
        b=emrERkTj2xQav1e1mex9k++TBWWZAaCASWW88L1Vtd0IJoOxbezZ9F3EwriRTKqM/
         WkVYNzw2MrkMdk0JoiUtQLBrGqNlIJ7aqSXp//JAKiAEyX8puEUbG4DKstnUi6RwNn
         7fqMFQ88pewjycwr+7QNM1V0+my83ds/W2yRKTgyltH58/0wc0yGGTEhLpsZCQ5Jgg
         w9xB/xTrmt9LK+gSgJhG0oXEILpI2rNRymnQInhBomt1nHN+bb/KmBY8vzcFqJzr6c
         pU8p8dNGDwU6NJLWBY+GqvYoCsDqWPgl5g7CVAJJYIj2oiMS3Fk6N7UJUhnyKkSK1m
         4rp8nOZfB1xMQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Schemmel <christoph.schemmel@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 1/3] NET: usb: qmi_wwan: Adding support for Cinterion MV31
Date:   Mon, 15 Feb 2021 13:37:04 -0500
Message-Id: <20210215183706.122183-1-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Schemmel <christoph.schemmel@gmail.com>

[ Upstream commit a4dc7eee9106a9d2a6e08b442db19677aa9699c7 ]

Adding support for Cinterion MV31 with PID 0x00B7.

T:  Bus=04 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#= 11 Spd=5000 MxCh= 0
D:  Ver= 3.20 Cls=ef(misc ) Sub=02 Prot=01 MxPS= 9 #Cfgs=  1
P:  Vendor=1e2d ProdID=00b7 Rev=04.14
S:  Manufacturer=Cinterion
S:  Product=Cinterion USB Mobile Broadband
S:  SerialNumber=b3246eed
C:  #Ifs= 4 Cfg#= 1 Atr=a0 MxPwr=896mA
I:  If#=0x0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
I:  If#=0x1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x3 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option

Signed-off-by: Christoph Schemmel <christoph.schemmel@gmail.com>
Link: https://lore.kernel.org/r/20210202084523.4371-1-christoph.schemmel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index bdfe88c754dfe..d2e5f5b7adf18 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1291,6 +1291,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x1e2d, 0x0082, 5)},	/* Cinterion PHxx,PXxx (2 RmNet) */
 	{QMI_FIXED_INTF(0x1e2d, 0x0083, 4)},	/* Cinterion PHxx,PXxx (1 RmNet + USB Audio)*/
 	{QMI_QUIRK_SET_DTR(0x1e2d, 0x00b0, 4)},	/* Cinterion CLS8 */
+	{QMI_FIXED_INTF(0x1e2d, 0x00b7, 0)},	/* Cinterion MV31 RmNet */
 	{QMI_FIXED_INTF(0x413c, 0x81a2, 8)},	/* Dell Wireless 5806 Gobi(TM) 4G LTE Mobile Broadband Card */
 	{QMI_FIXED_INTF(0x413c, 0x81a3, 8)},	/* Dell Wireless 5570 HSPA+ (42Mbps) Mobile Broadband Card */
 	{QMI_FIXED_INTF(0x413c, 0x81a4, 8)},	/* Dell Wireless 5570e HSPA+ (42Mbps) Mobile Broadband Card */
-- 
2.27.0

