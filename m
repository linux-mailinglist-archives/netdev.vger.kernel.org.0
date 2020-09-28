Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4789127AA22
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 11:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbgI1JBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 05:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbgI1JBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 05:01:13 -0400
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777E5C0613CE;
        Mon, 28 Sep 2020 02:01:13 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4C0Ghj3Q56zKmqw;
        Mon, 28 Sep 2020 11:01:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mailbox.org; h=
        content-disposition:content-type:content-type:mime-version
        :message-id:subject:subject:from:from:date:date:received; s=
        mail20150812; t=1601283666; bh=Clq2XEAIGM1kSYlOurVASqY7mgCFFffGy
        dsP/ho3vHI=; b=Bin2X1xInvWF7cGH+jsPrX0t2IrWrVn4cAd4bfdYDQWMXCAiM
        sOrlX4xA4q1Zfx4xu9a77eXiTd8R5To5SAHWYn7M9SUF2EwdXiCmGswWOiIDM4hL
        jnclv0ugIDrl8kwtE2BTTU9YJ3UPk+Bgbam2XvfYRAp7XtAm35tf1K+eDkCZeaZ1
        8nTKpJq0+PxvvDu3wp+hTz640q/jGKCN0lZir9I00U+dwmWaPPkrqY982+7UiaKK
        6/zHjRlzBy2Pp5qf3rimNrn0UsNc1T13dNdHwBpiW3gMn1d8JvTZI1090syin8b3
        frcMCkZTmKKTcKURYSwa2F84SYQJPoGzZYbtA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1601283667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=QWcqh6rMd05h1/oY1Wz5PFmM8eSbepnPd3VGzzMlgZU=;
        b=lk7MufDa0670VnuIW9x1CyqJ1Fgpy3cUEXIVWGetNgaOX9n8hU1KTT1KNlvvAQ45qmxncj
        J0BzR5aaz6l2L6PO+h9RvtAJwgT5wnxALiet18rW+jb+E4X9AyVJz45AHUgdTSJC+ivBi4
        57NMZ+eVJr+73e93O49M1beRqIhJVdl4ZPpUobLuxqNDhQmz1uZdVCGl2y60Pmj2pgOqfY
        +S2mhTm/00srpgaLBQkGwF3/R+56XO4ux2DeEVLqdf5ebFWaHccm0ZUH8VZWsGXS/iRhOE
        uF40Wcueb+Ji1okML4fMjxz7gvvX5pch3kBZ7Ghcny/xfm6+0+fTjJUgAF80nw==
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter01.heinlein-hosting.de (spamfilter01.heinlein-hosting.de [80.241.56.115]) (amavisd-new, port 10030)
        with ESMTP id 5oAgk35MSavj; Mon, 28 Sep 2020 11:01:06 +0200 (CEST)
Date:   Mon, 28 Sep 2020 11:01:04 +0200
From:   Wilken Gottwalt <wilken.gottwalt@mailbox.org>
To:     linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH v2] net: usb: ax88179_178a: fix missing stop entry in
 driver_info
Message-ID: <20200928090104.GA27570@monster.powergraphx.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -4.56 / 15.00 / 15.00
X-Rspamd-Queue-Id: 6DD45274
X-Rspamd-UID: 920c44
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds the missing .stop entry in the Belkin driver_info structure.

Signed-off-by: Wilken Gottwalt <wilken.gottwalt@mailbox.org>
---
Changes in v2:
    - reposted to proper mailing list
---
 drivers/net/usb/ax88179_178a.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index 125f7bf57590..8f1798b95a02 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1823,6 +1823,7 @@ static const struct driver_info belkin_info = {
 	.status = ax88179_status,
 	.link_reset = ax88179_link_reset,
 	.reset	= ax88179_reset,
+	.stop	= ax88179_stop,
 	.flags	= FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
-- 
2.28.0

