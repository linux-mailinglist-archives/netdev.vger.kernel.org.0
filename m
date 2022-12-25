Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F12BE655E48
	for <lists+netdev@lfdr.de>; Sun, 25 Dec 2022 22:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbiLYVCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Dec 2022 16:02:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiLYVCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Dec 2022 16:02:00 -0500
X-Greylist: delayed 550 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 25 Dec 2022 13:01:55 PST
Received: from cavan.codon.org.uk (cavan.codon.org.uk [176.126.240.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C247266E;
        Sun, 25 Dec 2022 13:01:54 -0800 (PST)
Received: from x2100.. (unknown [IPv6:2607:f598:b99a:480:2da1:ebcf:44f5:35ad])
        by cavan.codon.org.uk (Postfix) with ESMTPSA id 4DB06424AC;
        Sun, 25 Dec 2022 20:52:46 +0000 (GMT)
From:   Matthew Garrett <mjg59@srcf.ucam.org>
To:     johan@kernel.org, bjorn@mork.no
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Matthew Garrett <mgarrett@aurora.tech>
Subject: [PATCH 2/3] net: usb: qmi_wwan: Add generic MDM9207 configuration
Date:   Sun, 25 Dec 2022 12:52:23 -0800
Message-Id: <20221225205224.270787-3-mjg59@srcf.ucam.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221225205224.270787-1-mjg59@srcf.ucam.org>
References: <20221225205224.270787-1-mjg59@srcf.ucam.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Orbic Speed RC400L presents as a generic MDM9207 device that supports
multiple configurations with different USB IDs. One exposes a QMI interface.
Add the ID for that.

Signed-off-by: Matthew Garrett <mgarrett@aurora.tech>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index a808d718c012..bf05b7feacc0 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1223,6 +1223,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x05c6, 0x90b2, 3)},    /* ublox R410M */
 	{QMI_FIXED_INTF(0x05c6, 0x920d, 0)},
 	{QMI_FIXED_INTF(0x05c6, 0x920d, 5)},
+	{QMI_FIXED_INTF(0x05c6, 0xf601, 5)},
 	{QMI_QUIRK_SET_DTR(0x05c6, 0x9625, 4)},	/* YUGA CLM920-NC5 */
 	{QMI_FIXED_INTF(0x0846, 0x68a2, 8)},
 	{QMI_FIXED_INTF(0x0846, 0x68d3, 8)},	/* Netgear Aircard 779S */
-- 
2.38.1

