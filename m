Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F410552E814
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 10:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347408AbiETIwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 04:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347403AbiETIwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 04:52:06 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72FD75DE58
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 01:52:04 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1nryMX-0006Xw-Bd; Fri, 20 May 2022 10:51:57 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1nryMW-0005Nx-Ak; Fri, 20 May 2022 10:51:56 +0200
Date:   Fri, 20 May 2022 10:51:56 +0200
From:   "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
To:     Pkshih <pkshih@realtek.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "neojou@gmail.com" <neojou@gmail.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "martin.blumenstingl@googlemail.com" 
        <martin.blumenstingl@googlemail.com>,
        "linux@ulli-kroll.de" <linux@ulli-kroll.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "neo_jou@realtek.com" <neo_jou@realtek.com>
Subject: Re: [PATCH 06/10] rtw88: Add common USB chip support
Message-ID: <20220520085156.GE25578@pengutronix.de>
References: <20220518082318.3898514-1-s.hauer@pengutronix.de>
 <20220518082318.3898514-7-s.hauer@pengutronix.de>
 <e9ca08c6facb8916fb9e5cbad05447321d3d0f43.camel@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9ca08c6facb8916fb9e5cbad05447321d3d0f43.camel@realtek.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:21:45 up 50 days, 20:51, 53 users,  load average: 0.08, 0.07,
 0.09
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 20, 2022 at 07:39:03AM +0000, Pkshih wrote:
> On Wed, 2022-05-18 at 10:23 +0200, Sascha Hauer wrote:
> > Add the common bits and pieces to add USB support to the RTW88 driver.
> > This is based on https://github.com/ulli-kroll/rtw88-usb.git which
> > itself is first written by Neo Jou.
> > 
> > Signed-off-by: neo_jou <neo_jou@realtek.com>
> > Signed-off-by: Hans Ulli Kroll <linux@ulli-kroll.de>
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > ---
> >  drivers/net/wireless/realtek/rtw88/Kconfig  |    3 +
> >  drivers/net/wireless/realtek/rtw88/Makefile |    2 +
> >  drivers/net/wireless/realtek/rtw88/mac.c    |    3 +
> >  drivers/net/wireless/realtek/rtw88/main.c   |    5 +
> >  drivers/net/wireless/realtek/rtw88/main.h   |    4 +
> >  drivers/net/wireless/realtek/rtw88/reg.h    |    1 +
> >  drivers/net/wireless/realtek/rtw88/tx.h     |   31 +
> >  drivers/net/wireless/realtek/rtw88/usb.c    | 1051 +++++++++++++++++++
> >  drivers/net/wireless/realtek/rtw88/usb.h    |  109 ++
> >  9 files changed, 1209 insertions(+)
> >  create mode 100644 drivers/net/wireless/realtek/rtw88/usb.c
> >  create mode 100644 drivers/net/wireless/realtek/rtw88/usb.h
> > 
> 
> [...]
> 
> > diff --git a/drivers/net/wireless/realtek/rtw88/reg.h b/drivers/net/wireless/realtek/rtw88/reg.h
> > index 84ba9ec489c37..a928899030863 100644
> > --- a/drivers/net/wireless/realtek/rtw88/reg.h
> > +++ b/drivers/net/wireless/realtek/rtw88/reg.h
> > @@ -184,6 +184,7 @@
> >  #define BIT_TXDMA_VIQ_MAP(x)                                                   \
> 				^^^^^^^ replace 8 spaces by one tab

This line is not added by me. There are spaces used before the
linebreaks throughout this file.

> > +	do {
> > +		spin_lock_irqsave(&rtwusb->rx_data_list_lock, flags);
> > +
> > +		rxcb = list_first_entry_or_null(&rtwusb->rx_data_free,
> > +						struct rx_usb_ctrl_block, list);
> > +
> > +		spin_unlock_irqrestore(&rtwusb->rx_data_list_lock, flags);
> > +		if (!rxcb)
> > +			return;
> > +
> > +		rxcb->rx_skb = alloc_skb(RTW_USB_MAX_RECVBUF_SZ, GFP_KERNEL);
> > +		if (!rxcb->rx_skb) {
> > +			rtw_err(rtwdev, "could not allocate rx skbuff\n");
> > +			return;
> > +		}
> > +
> > +		usb_fill_bulk_urb(rxcb->rx_urb, rtwusb->udev,
> > +				  usb_rcvbulkpipe(rtwusb->udev, rtwusb->pipe_in),
> > +				  rxcb->rx_skb->data, RTW_USB_MAX_RECVBUF_SZ,
> > +				  rtw_usb_read_port_complete, rxcb);
> > +
> > +		spin_lock_irqsave(&rtwusb->rx_data_list_lock, flags);
> > +		list_move(&rxcb->list, &rtwusb->rx_data_used);
> > +		spin_unlock_irqrestore(&rtwusb->rx_data_list_lock, flags);
> > +
> > +		error = usb_submit_urb(rxcb->rx_urb, GFP_KERNEL);
> > +		if (error) {
> > +			kfree_skb(rxcb->rx_skb);
> > +			if (error != -ENODEV)
> > +				rtw_err(rtwdev, "Err sending rx data urb %d\n",
> > +					   error);
> > +			rtw_usb_rx_data_put(rtwusb, rxcb);
> > +
> > +			return;
> > +		}
> > +	} while (true);
> 
> Can we have a limit of 'for(;<limit;)' insetad of 'while (true)'?

Not sure if it's worth it, but yes, it shouldn't hurt either.

> 
> > +}
> > +
> > +static void rtw_usb_cancel_rx_bufs(struct rtw_usb *rtwusb)
> > +{
> > +	struct rx_usb_ctrl_block *rxcb;
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&rtwusb->rx_data_list_lock, flags);
> > +
> > +	while (true) {
> > +		rxcb = list_first_entry_or_null(&rtwusb->rx_data_used,
> > +						struct rx_usb_ctrl_block, list);
> > +
> > +		spin_unlock_irqrestore(&rtwusb->rx_data_list_lock, flags);
> > +
> > +		if (!rxcb)
> > +			break;
> > +
> > +		usb_kill_urb(rxcb->rx_urb);
> > +
> > +		spin_lock_irqsave(&rtwusb->rx_data_list_lock, flags);
> > +		list_move(&rxcb->list, &rtwusb->rx_data_free);
> > +	}
> > +}
> 
> The spin_lock pairs are not intuitive.
> Can we change this chunk to
> 
> while (true) {
>      spin_lock();
>      rxcb = list_first_entry_or_null();
>      spin_unlock()
> 
>      if (!rxcb)
>         return;
> 
>      usb_free_urb();
> 
>      spin_lock();
>      list_del();
>      spin_unlock();
> }
> 
> The drawback is lock/unlock twice in single loop.

Yes, that's why I did it the way I did ;)

How about:

	while (true) {
		unsigned long flags;

		spin_lock_irqsave(&rtwusb->rx_data_list_lock, flags);

		rxcb = list_first_entry_or_null(&rtwusb->rx_data_free,
						struct rx_usb_ctrl_block, list);
		if (rxcb)
			list_del(&rxcb->list);

		spin_unlock_irqrestore(&rtwusb->rx_data_list_lock, flags);

		if (!rxcb)
			break;

		usb_free_urb(rxcb->rx_urb);
	}

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
