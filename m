Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB87278A2D
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 15:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728875AbgIYN7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 09:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728451AbgIYN7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 09:59:09 -0400
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [IPv6:2001:67c:2050::465:103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC4ABC0613CE;
        Fri, 25 Sep 2020 06:59:08 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4ByYRq2gLNzKm5Y;
        Fri, 25 Sep 2020 15:59:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mailbox.org; h=
        content-disposition:content-type:content-type:mime-version
        :message-id:subject:subject:from:from:date:date:received; s=
        mail20150812; t=1601042339; bh=yRSamacUl5zOBDZnMxEDI6efGi+UbqCon
        TJ3n+9gU4U=; b=BMoXsh/GZryw4BcyZPoAR7wdYAFMPpALMfrOY2fr2U9E/pSI6
        DODQfMuoZ+00imc1H2ljMdsrbp5nWEkZXifajj+n7VxdoxSDPmMZZyDqyc8HKloV
        g/Wiqco4ZTV2gMNg5NrbrGYuXf0I66n0X+R2plF8fIE0R087Q3npr1aKBNlFFnEj
        augRBIiNwsU8MeBSvxM3GsqReL3rHR8vqqlJwB1D/Yh2t5QQraM0JzPW6x8QS+5/
        PRz87YK57bas/7aNHL1dGo07LVnZ6mNyt4JqiFCX9E46vz3T72JkZdsSaqQhctzo
        fehpYCQsbCh1Eddj9DHi++dRiZS0ySZkCU3jg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1601042341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=qAInf77RnkgHLLay4aTkAXh67lv5i0lXxPM9EKg/cl4=;
        b=nM30oCQ7Vdkr8933DTd6hQdiHewjGyQht+04ByE1FbMUUOvsgDTpnVKVRcULMZ0gbp8RE1
        O3eyMfXKnFcKzfD2HR0I7EH+TvSz19tUEUTAAOoVbjD0+2wfZejTvOje8bJE6ctEZs/Ev7
        KY6oWjMdDQG/bcr8vfx5DuV2ldgu0mmAcAzyugI7kngnVo7ZPmCwLeObKR68zObcl3xVJX
        SF7dyWq1SXywqzdKM3PAtl/6Kj/b4js5U8b4oJoujDd3wxW9mvCtQWlHQRSYwzAXUMdPQQ
        2YH261QkNf0nnl9sf4JzcH1Z3cb2ft8dmaPThsNSkh8NA13+hDaLwW5IMoY/hw==
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by hefe.heinlein-support.de (hefe.heinlein-support.de [91.198.250.172]) (amavisd-new, port 10030)
        with ESMTP id NULZPqP4Rsji; Fri, 25 Sep 2020 15:58:59 +0200 (CEST)
Date:   Fri, 25 Sep 2020 15:58:57 +0200
From:   Wilken Gottwalt <wilken.gottwalt@mailbox.org>
To:     linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH v2] net: usb: ax88179_178a: add Toshiba usb 3.0 adapter
Message-ID: <20200925135857.GA102845@monster.powergraphx.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -4.58 / 15.00 / 15.00
X-Rspamd-Queue-Id: 5FB3F108B
X-Rspamd-UID: 92a39d
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds the driver_info and usb ids of the AX88179 based Toshiba USB 3.0
ethernet adapter.

Signed-off-by: Wilken Gottwalt <wilken.gottwalt@mailbox.org>
---
Changes in v2:
    - reposted to proper mailing list with correct commit message as
      suggested by Jakub Kicinski
---
 drivers/net/usb/ax88179_178a.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index ac7bc436da33..ed078e5a3629 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1829,6 +1829,19 @@ static const struct driver_info belkin_info = {
 	.tx_fixup = ax88179_tx_fixup,
 };
 
+static const struct driver_info toshiba_info = {
+	.description = "Toshiba USB Ethernet Adapter",
+	.bind	= ax88179_bind,
+	.unbind = ax88179_unbind,
+	.status = ax88179_status,
+	.link_reset = ax88179_link_reset,
+	.reset	= ax88179_reset,
+	.stop = ax88179_stop,
+	.flags	= FLAG_ETHER | FLAG_FRAMING_AX,
+	.rx_fixup = ax88179_rx_fixup,
+	.tx_fixup = ax88179_tx_fixup,
+};
+
 static const struct usb_device_id products[] = {
 {
 	/* ASIX AX88179 10/100/1000 */
@@ -1862,6 +1875,10 @@ static const struct usb_device_id products[] = {
 	/* Belkin B2B128 USB 3.0 Hub + Gigabit Ethernet Adapter */
 	USB_DEVICE(0x050d, 0x0128),
 	.driver_info = (unsigned long)&belkin_info,
+}, {
+	/* Toshiba USB 3.0 GBit Ethernet Adapter */
+	USB_DEVICE(0x0930, 0x0a13),
+	.driver_info = (unsigned long)&toshiba_info,
 },
 	{ },
 };
-- 
2.28.0

