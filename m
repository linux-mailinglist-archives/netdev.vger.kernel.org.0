Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 224F2282342
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 11:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725835AbgJCJkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 05:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbgJCJkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 05:40:35 -0400
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A0C2C0613D0;
        Sat,  3 Oct 2020 02:40:35 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4C3MKs4vZjzKmwB;
        Sat,  3 Oct 2020 11:40:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mailbox.org; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received; s=mail20150812; t=1601718032; bh=F3zl6R34j8
        XuyXiPkLvQN+72dc49XEvMfpEJa7+LlQc=; b=Xsy7LSDJp1fg3j2Gi5beilXDxh
        woGOBDoy+tUkZ85ntBWPzqtFs0rdGcuUm4Foc6+5b6ruaHVB12jrAJkg2DRxNXn0
        RaawrG4qkJAn2JrNJZmgvYDpPtL4vqUwnjvUIBPorDag271wbtk5+Ftc+zdAQQL9
        iF2GPlDprotkpoD2p5FWqUkGEKtXenLTfm8grMYRMUj/t/eavdpAnJ88xR2VLWRf
        4NLjzr9v7ojf1k9QL2IO2tUpluUGnBA2HV+WAN/2FkfmWLKJIvr0ac5mXn+/2PAj
        1Hs451ILON9FrteWbgh7hxc+jl75gWdCbgPsN9cJcPPZGC5Cdp2OG8QtQcXA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1601718033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MsE9L155w97UxlzVBtMihNM3sUIgsGa6NaXfRjav7Go=;
        b=pj88J+gyiiywF921LXpOAjSlrJgdX+34UOlafVgHeEcVsp3MbEjZe7kkN/6HniSGEXfoqi
        QJW8D7/HT/IzH2MXl/sMtAvpGGRZgp/H/ruvfW3F/5lrTiU4+T49K2LT9yIAt0MGjbRD3h
        5mvUSmn+dss8YkcGnrpGbgFfIjw2EdT09iuMboEc4eOaNYSndiukEJMR+S97iJOO2AOlbd
        Bpk3IwIP5zdIRnLZQEJI/iBc9mEIDreheVcmyxzNWx7biH0P+iRjPnOL4LwVmi7OxYlau5
        y66hMUWg1RERPRtgh41jsGfl4x/mMOZTtC4e5ZBVOqh/ofkjyOq0lHFTEHOlVg==
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by gerste.heinlein-support.de (gerste.heinlein-support.de [91.198.250.173]) (amavisd-new, port 10030)
        with ESMTP id gBLEzyHU8Er3; Sat,  3 Oct 2020 11:40:32 +0200 (CEST)
Date:   Sat, 3 Oct 2020 11:40:29 +0200
From:   Wilken Gottwalt <wilken.gottwalt@mailbox.org>
To:     linux-kernel@vger.kernel.org
Cc:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH 2/2] usb: serial: option: add Cellient MPL200 card
Message-ID: <3db5418fe9e516f4b290736c5a199c9796025e3c.1601715478.git.wilken.gottwalt@mailbox.org>
References: <cover.1601715478.git.wilken.gottwalt@mailbox.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1601715478.git.wilken.gottwalt@mailbox.org>
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -3.53 / 15.00 / 15.00
X-Rspamd-Queue-Id: 58DDE17DD
X-Rspamd-UID: b12113
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add usb ids of the Cellient MPL200 card.

Signed-off-by: Wilken Gottwalt <wilken.gottwalt@mailbox.org>
---
 drivers/usb/serial/option.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 0c6f160a214a..a65e620b2277 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -528,6 +528,7 @@ static void option_instat_callback(struct urb *urb);
 /* Cellient products */
 #define CELLIENT_VENDOR_ID			0x2692
 #define CELLIENT_PRODUCT_MEN200			0x9005
+#define CELLIENT_PRODUCT_MPL200			0x9025
 
 /* Hyundai Petatel Inc. products */
 #define PETATEL_VENDOR_ID			0x1ff4
@@ -1982,6 +1983,8 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MEDIATEK_PRODUCT_DC_4COM2, 0xff, 0x02, 0x01) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MEDIATEK_PRODUCT_DC_4COM2, 0xff, 0x00, 0x00) },
 	{ USB_DEVICE(CELLIENT_VENDOR_ID, CELLIENT_PRODUCT_MEN200) },
+	{ USB_DEVICE(CELLIENT_VENDOR_ID, CELLIENT_PRODUCT_MPL200),
+	  .driver_info = RSVD(1) | RSVD(4) },
 	{ USB_DEVICE(PETATEL_VENDOR_ID, PETATEL_PRODUCT_NP10T_600A) },
 	{ USB_DEVICE(PETATEL_VENDOR_ID, PETATEL_PRODUCT_NP10T_600E) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(TPLINK_VENDOR_ID, TPLINK_PRODUCT_LTE, 0xff, 0x00, 0x00) },	/* TP-Link LTE Module */
-- 
2.28.0

