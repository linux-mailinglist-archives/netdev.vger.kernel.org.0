Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1202831CB
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 10:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgJEIUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 04:20:53 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:34012 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgJEIUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 04:20:52 -0400
Received: by mail-lj1-f194.google.com with SMTP id v23so6583079ljd.1;
        Mon, 05 Oct 2020 01:20:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Zy+RVKGXgvEDv9SWGZIt64ElwiOMLO61wV0TmNcr85s=;
        b=Qdb9Q0ze6F6f4SReqvZUV1e8d2l2b3bfUogTr2ojE8n5VB3YLtg20KuZ+g+SLAc/4v
         QN8if6VaDrSgLAlLt8YlCEPaHhT5d7EQzz5OuQjV/thK0levQga0b1+rMiEhjzFt84Se
         TiS8TxfrqhcQpNCgFYgmLbD812hrB61oUa9PLCnYtkNBlA52rmM3C3U0rNdsHb6WjtzL
         0/Mt1ikJptGjKCHL2ZWUNwcpnzsSHfkh1GqJlLMyPDAxeGbz9yJ/kFL4ZVW8t6Lcu6YM
         LhX/GUaCplK0V6qhIL9N+3ZyMQLeJucB66ri4Qb1lVJommDUBqZ0T0Ey3SFiU9SNX1cm
         K4UQ==
X-Gm-Message-State: AOAM532jWAUvkbUXklPjxc4Z2BnzAaxCqbp2WwPLZ+qcpGb+1VFuObkx
        5loGXLy8StXB8Cb2A+pJ8jI=
X-Google-Smtp-Source: ABdhPJyZ1lf9ATP7ryn44YsTW33y6bjFLorhJ/Dn0x8l+17c4xIsroXx2/JzYuLTrFGAVO2S/9ZEhg==
X-Received: by 2002:a2e:575d:: with SMTP id r29mr3952094ljd.183.1601886049672;
        Mon, 05 Oct 2020 01:20:49 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id q5sm3234768lfo.200.2020.10.05.01.20.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 01:20:48 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1kPLjh-0001Tb-Jj; Mon, 05 Oct 2020 10:20:45 +0200
Date:   Mon, 5 Oct 2020 10:20:45 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Wilken Gottwalt <wilken.gottwalt@mailbox.org>
Cc:     linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 2/2] usb: serial: option: add Cellient MPL200 card
Message-ID: <20201005082045.GL5141@localhost>
References: <cover.1601715478.git.wilken.gottwalt@mailbox.org>
 <3db5418fe9e516f4b290736c5a199c9796025e3c.1601715478.git.wilken.gottwalt@mailbox.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3db5418fe9e516f4b290736c5a199c9796025e3c.1601715478.git.wilken.gottwalt@mailbox.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 03, 2020 at 11:40:29AM +0200, Wilken Gottwalt wrote:
> Add usb ids of the Cellient MPL200 card.
> 
> Signed-off-by: Wilken Gottwalt <wilken.gottwalt@mailbox.org>
> ---
>  drivers/usb/serial/option.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
> index 0c6f160a214a..a65e620b2277 100644
> --- a/drivers/usb/serial/option.c
> +++ b/drivers/usb/serial/option.c
> @@ -528,6 +528,7 @@ static void option_instat_callback(struct urb *urb);
>  /* Cellient products */
>  #define CELLIENT_VENDOR_ID			0x2692
>  #define CELLIENT_PRODUCT_MEN200			0x9005
> +#define CELLIENT_PRODUCT_MPL200			0x9025
>  
>  /* Hyundai Petatel Inc. products */
>  #define PETATEL_VENDOR_ID			0x1ff4
> @@ -1982,6 +1983,8 @@ static const struct usb_device_id option_ids[] = {
>  	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MEDIATEK_PRODUCT_DC_4COM2, 0xff, 0x02, 0x01) },
>  	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MEDIATEK_PRODUCT_DC_4COM2, 0xff, 0x00, 0x00) },
>  	{ USB_DEVICE(CELLIENT_VENDOR_ID, CELLIENT_PRODUCT_MEN200) },
> +	{ USB_DEVICE(CELLIENT_VENDOR_ID, CELLIENT_PRODUCT_MPL200),
> +	  .driver_info = RSVD(1) | RSVD(4) },

Would you mind posting the output of "lsusb -v" for this device?

>  	{ USB_DEVICE(PETATEL_VENDOR_ID, PETATEL_PRODUCT_NP10T_600A) },
>  	{ USB_DEVICE(PETATEL_VENDOR_ID, PETATEL_PRODUCT_NP10T_600E) },
>  	{ USB_DEVICE_AND_INTERFACE_INFO(TPLINK_VENDOR_ID, TPLINK_PRODUCT_LTE, 0xff, 0x00, 0x00) },	/* TP-Link LTE Module */

Johan
