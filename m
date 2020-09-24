Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6B542768DF
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 08:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgIXG1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 02:27:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbgIXG1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 02:27:32 -0400
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D80C0613CE;
        Wed, 23 Sep 2020 23:27:32 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4BxlTD12DVzQl8x;
        Thu, 24 Sep 2020 08:27:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mailbox.org; h=
        content-disposition:content-type:content-type:mime-version
        :message-id:subject:subject:from:from:date:date:received; s=
        mail20150812; t=1600928845; bh=7B4yQBLdUFDs9feFHdCThn3G16i3rfICn
        JryaWCFccU=; b=i19K6hvxv0JeNYWCbFto+jzpY/6dvgTDvKpOCZHwx1Goj7TQ2
        0lgDTYsxJ0UwRWBaxDWcZv5ksXBoEg4iQrFquFuJL+80DAA0okODsrNJj/9Ghn0T
        eCTrX/qW8iAsfbJ7eoxjnF/8U9LW7E+bZ4jBqDhMY2/As+uFf7sKzGE+UR325hzG
        U8aY7dDJYMsZbOdaGDpK6Q7LEyqvM1zVjxS3XmkQEkpgFIt/uG+GgCpourd4+NXb
        4w69Xs0bZIrV8eWzxxvAe4Ly/USnSBYtO4fyEIxr0YRxXaelKcHOGS8VXsACqCLV
        ZkNwxe3Qll7MiFxcK3b3fQwVNcsaSaVdyTr0Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1600928846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=MLYLXufmHm+IPMon/KMutx5OLmK1QEFqDnmoQOhlCkU=;
        b=ffkSfaqNfJ/SvVmOpe2CktybseFDO+p5W5LNLp+smcwuJO+1zv0Ep/sR8m5vn6ByGTKQsQ
        nxAbDevxUS9axGTYXhzcAZt5mWkpoFpYOht0tcojBqBhwLF7Yz0jotJLR3k6KN+DZnCUAO
        gABpfY4UtyU5ux75c+E5ZbkkMQXDE6rZjSRe3PCdzX7GTfnCsUQGmFRI2IyOQjZe6AUKFl
        YvteErxpz6d6s8SDzoIgU0rcp9Rfn3UJEdSxaNxLlP55xcOH9Fmu5WzsyRInDzbwrlPoci
        GQaqYQoUMPdGxvwsmkE82cvn1klJNiSRk/dDIngYtqaLYwUZ+sDu2+J68qYdRg==
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter06.heinlein-hosting.de (spamfilter06.heinlein-hosting.de [80.241.56.125]) (amavisd-new, port 10030)
        with ESMTP id KC95yWCztS8c; Thu, 24 Sep 2020 08:27:25 +0200 (CEST)
Date:   Thu, 24 Sep 2020 08:27:22 +0200
From:   Wilken Gottwalt <wilken.gottwalt@mailbox.org>
To:     linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH] net: usb: ax88179_178a: add Toshiba usb 3.0 adapter
Message-ID: <20200924062722.GA20280@monster.powergraphx.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -4.58 / 15.00 / 15.00
X-Rspamd-Queue-Id: 21E39170A
X-Rspamd-UID: 37bc61
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reposted and added netdev as suggested by Jakub Kicinski.

---
Adds the driver_info and usb ids of the AX88179 based Toshiba USB 3.0
ethernet adapter.

Signed-off-by: Wilken Gottwalt <wilken.gottwalt@mailbox.org>
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

