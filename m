Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6BE728348F
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 13:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbgJELBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 07:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbgJELBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 07:01:42 -0400
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7600C0613A7;
        Mon,  5 Oct 2020 04:01:41 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4C4d2X0Sj2zKmfS;
        Mon,  5 Oct 2020 13:01:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mailbox.org; h=
        content-transfer-encoding:content-type:content-type:mime-version
        :references:in-reply-to:message-id:subject:subject:from:from
        :date:date:received; s=mail20150812; t=1601895696; bh=o3HxPvGqld
        CRgVtM4Sy6fX5yWv5raTGaR2SS3W63W+Q=; b=qp78uueXsZ/g9OoB56feIrn50D
        Q/AgySvgcTE447pi1TBYF1+yiwtX5aJHBhvm1W4xHK+TM3IRa1GKHXXR/XW/xchs
        a3HtylztP14OgjLXtpCM9ADbjgiA2YvPSsiefGqaPnuAy73evyEAXQJaZ1NQEtbm
        OsYhGXj68CngpPRdP7yfYUwma5a+U/IpuNAnqGwZc2bQCj5fUhJqG7haKumautEY
        c8VahOF+f6WUOd5xVh5U0YbHPywbcAMF/eXE35GCExX1AUpQQyP/CpCXC/jDiNRt
        H+9GcX/CZPVWN++8L0q1CtOR9NrHjoAYdl2qtxdfa1gNssIUy9db/1EBouIA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1601895698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kWnCdaMX4m6FP+4F2JIZtLXjwih40j5+zMm1qnrssO8=;
        b=Lh1fHDwDcB+U5pnRK0QJy+X6Ru+c9ELt/a/frBGfs+b7qHaZxPtYD/s2fAozSdqECdvyxX
        JOtjkvaAqOS+ElQ0z+QpXCqkUcZ2H5k2pHLXIlfiPg6eEwsyTEgk6ktDx+DbjjB/ASJT45
        mbmezoHFG9baMPHsZucL2W6MUcF/c+vlWNspwtlL2soK0BsTigAq6YRKsfHKHZtuHXP2kU
        4u5T5h8wajNr0SvaUDoEAUljCMk1Vhirst2qgqSxmQlo2coUxgnAvTGLe0L9Divvnb7hS2
        2z4O2dghTK1yzoqu5AhA+vGoidQsFtZP1oqxqbq8tBtFh67ve7s8pZHXbqsG4g==
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter06.heinlein-hosting.de (spamfilter06.heinlein-hosting.de [80.241.56.125]) (amavisd-new, port 10030)
        with ESMTP id 7vyDWm21A5AE; Mon,  5 Oct 2020 13:01:36 +0200 (CEST)
Date:   Mon, 5 Oct 2020 13:01:34 +0200
From:   Wilken Gottwalt <wilken.gottwalt@mailbox.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 2/2] usb: serial: option: add Cellient MPL200 card
Message-ID: <20201005130134.459b4de9@monster.powergraphx.local>
In-Reply-To: <20201005082045.GL5141@localhost>
References: <cover.1601715478.git.wilken.gottwalt@mailbox.org>
        <3db5418fe9e516f4b290736c5a199c9796025e3c.1601715478.git.wilken.gottwalt@mailbox.org>
        <20201005082045.GL5141@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -5.91 / 15.00 / 15.00
X-Rspamd-Queue-Id: 1F8E3171C
X-Rspamd-UID: 888c58
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 5 Oct 2020 10:20:45 +0200
Johan Hovold <johan@kernel.org> wrote:

> On Sat, Oct 03, 2020 at 11:40:29AM +0200, Wilken Gottwalt wrote:
> > Add usb ids of the Cellient MPL200 card.
> > 
> > Signed-off-by: Wilken Gottwalt <wilken.gottwalt@mailbox.org>
> > ---
> >  drivers/usb/serial/option.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
> > index 0c6f160a214a..a65e620b2277 100644
> > --- a/drivers/usb/serial/option.c
> > +++ b/drivers/usb/serial/option.c
> > @@ -528,6 +528,7 @@ static void option_instat_callback(struct urb *urb);
> >  /* Cellient products */
> >  #define CELLIENT_VENDOR_ID			0x2692
> >  #define CELLIENT_PRODUCT_MEN200			0x9005
> > +#define CELLIENT_PRODUCT_MPL200			0x9025
> >  
> >  /* Hyundai Petatel Inc. products */
> >  #define PETATEL_VENDOR_ID			0x1ff4
> > @@ -1982,6 +1983,8 @@ static const struct usb_device_id option_ids[] = {
> >  	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MEDIATEK_PRODUCT_DC_4COM2, 0xff,
> > 0x02, 0x01) }, { USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MEDIATEK_PRODUCT_DC_4COM2,
> > 0xff, 0x00, 0x00) }, { USB_DEVICE(CELLIENT_VENDOR_ID, CELLIENT_PRODUCT_MEN200) },
> > +	{ USB_DEVICE(CELLIENT_VENDOR_ID, CELLIENT_PRODUCT_MPL200),
> > +	  .driver_info = RSVD(1) | RSVD(4) },
> 
> Would you mind posting the output of "lsusb -v" for this device?

I would like to, but unfortunately I lost access to this really rare hardware
about a month ago. It is a Qualcomm device (0x05c6:0x9025) with a slightly
modified firmware to rebrand it as a Cellient product with a different vendor
id. How to proceed here, if I have no access to it anymore? Drop it?

> >  	{ USB_DEVICE(PETATEL_VENDOR_ID, PETATEL_PRODUCT_NP10T_600A) },
> >  	{ USB_DEVICE(PETATEL_VENDOR_ID, PETATEL_PRODUCT_NP10T_600E) },
> >  	{ USB_DEVICE_AND_INTERFACE_INFO(TPLINK_VENDOR_ID, TPLINK_PRODUCT_LTE, 0xff, 0x00,
> > 0x00) },	/* TP-Link LTE Module */
> 
> Johan

greetings,
Will
