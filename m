Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA97C27AA84
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 11:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgI1JRu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 05:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726497AbgI1JRt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 05:17:49 -0400
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 795C5C061755;
        Mon, 28 Sep 2020 02:17:49 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4C0H3s5BsYzKmhQ;
        Mon, 28 Sep 2020 11:17:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mailbox.org; h=
        content-disposition:content-type:content-type:mime-version
        :message-id:subject:subject:from:from:date:date:received; s=
        mail20150812; t=1601284662; bh=DaQNedV6DLtdwBn+je055grMSGGeN+eKd
        aMluY5HgPA=; b=uCazI0O4zQ8/9ThymAdpvM2q41ag/kVMcICuj/HWLZ7kgSvcw
        Jvowar61N8lKciKHvuiYNsNwi3KbnkWwHO44BAOuBFBceRIndhm2bPSOz1KnD8iS
        OK3F9geN2kBcxsfXHhJLIsZZQsu5UQWwfY7EsaR3oXGpmS4nxUS+vNB3jDS33zAB
        jk8F8LtCkmHO3rwZQe1GziomavNxlgI0S2Ub5F3wvLm9IFRocoNKWaJpFVaGWGlk
        HMF9FJf2q6/5tTh304PgDahROtfEXbLTTB1sHCq9z2xKhOzYbMnjJAGHEMn8zZyN
        9liIwlAuDQZcEx4gijvO4pGSrVsvb8Pxw+gwQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1601284663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=MXZaoCL3jvL4JTPmpwCWyRFRJ4/ouJjr9l+t03/UAe0=;
        b=GAh4hikUZdp5D/mRG/aWUovRD+5BAdGEvxqjKVcVLyIbMD+jA92H0FIL/9W1Xc0oykiAyi
        WUgYQ5XpyhlkvDX0MBJtJrYnQtl+doCimzcWPRQLH2k2WJJzsaHUzsZGRhrcyRSqeX8S0f
        9t6Nfk3E5PXBw+X8M3ike/WHIuMsWdSBZn0epYAkObc5s80ygtFRDOUVZ/m+diGlRob07V
        VpIjgsGN9CVj6aagReSrnQ21g6xJiWlNVC3P3RcN1hdzaCjN8Rmn9G1WozZF3D8szb4xFh
        ah8RzC1bLkNDMbX/DhUOygY4XNrWHNZkcRo2Vs5FAKJRkb7dfihr6JtiENTehA==
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter01.heinlein-hosting.de (spamfilter01.heinlein-hosting.de [80.241.56.115]) (amavisd-new, port 10030)
        with ESMTP id aI_hhMDNdxGq; Mon, 28 Sep 2020 11:17:42 +0200 (CEST)
Date:   Mon, 28 Sep 2020 11:17:40 +0200
From:   Wilken Gottwalt <wilken.gottwalt@mailbox.org>
To:     linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH] net: usb: ax88179_178a: add MCT usb 3.0 adapter
Message-ID: <20200928091740.GA27844@monster.powergraphx.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -4.56 / 15.00 / 15.00
X-Rspamd-Queue-Id: B56B01714
X-Rspamd-UID: ab3207
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds the driver_info and usb ids of the AX88179 based MCT U3-A9003 USB
3.0 ethernet adapter.

Signed-off-by: Wilken Gottwalt <wilken.gottwalt@mailbox.org>
---
 drivers/net/usb/ax88179_178a.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index 8f1798b95a02..5541f3faedbc 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1842,6 +1842,19 @@ static const struct driver_info toshiba_info = {
 	.tx_fixup = ax88179_tx_fixup,
 };
 
+static const struct driver_info mct_info = {
+	.description = "MCT USB 3.0 Gigabit Ethernet Adapter",
+	.bind	= ax88179_bind,
+	.unbind	= ax88179_unbind,
+	.status	= ax88179_status,
+	.link_reset = ax88179_link_reset,
+	.reset	= ax88179_reset,
+	.stop	= ax88179_stop,
+	.flags	= FLAG_ETHER | FLAG_FRAMING_AX,
+	.rx_fixup = ax88179_rx_fixup,
+	.tx_fixup = ax88179_tx_fixup,
+};
+
 static const struct usb_device_id products[] = {
 {
 	/* ASIX AX88179 10/100/1000 */
@@ -1879,6 +1892,10 @@ static const struct usb_device_id products[] = {
 	/* Toshiba USB 3.0 GBit Ethernet Adapter */
 	USB_DEVICE(0x0930, 0x0a13),
 	.driver_info = (unsigned long)&toshiba_info,
+}, {
+	/* Magic Control Technology U3-A9003 USB 3.0 Gigabit Ethernet Adapter */
+	USB_DEVICE(0x0711, 0x0179),
+	.driver_info = (unsigned long)&mct_info,
 },
 	{ },
 };
-- 
2.28.0

