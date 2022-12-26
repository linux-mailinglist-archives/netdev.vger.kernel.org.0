Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF26165662A
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 00:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232515AbiLZXvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 18:51:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiLZXvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 18:51:10 -0500
Received: from cavan.codon.org.uk (irc.codon.org.uk [IPv6:2a00:1098:84:22e::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413BCDE0;
        Mon, 26 Dec 2022 15:51:07 -0800 (PST)
Received: from x2100.. (52-119-115-32.PUBLIC.monkeybrains.net [52.119.115.32])
        by cavan.codon.org.uk (Postfix) with ESMTPSA id 7D4DC424AC;
        Mon, 26 Dec 2022 23:51:04 +0000 (GMT)
From:   Matthew Garrett <mjg59@srcf.ucam.org>
To:     johan@kernel.org, bjorn@mork.no
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Matthew Garrett <mgarrett@aurora.tech>
Subject: [PATCH V2 2/3] net: usb: qmi_wwan: Add generic MDM9207 configuration
Date:   Mon, 26 Dec 2022 15:47:50 -0800
Message-Id: <20221226234751.444917-3-mjg59@srcf.ucam.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221226234751.444917-1-mjg59@srcf.ucam.org>
References: <20221226234751.444917-1-mjg59@srcf.ucam.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,KHOP_HELO_FCRDNS,SPF_HELO_NEUTRAL,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
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

