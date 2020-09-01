Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0F27259F3C
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 21:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729106AbgIATbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 15:31:36 -0400
Received: from k17.unixstorm.org ([91.227.123.100]:38506 "EHLO
        k17.unixstorm.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbgIATbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 15:31:35 -0400
Received: from aadu223.neoplus.adsl.tpnet.pl ([83.4.98.223] helo=kamil)
        by k17.unixstorm.org with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92.3)
        (envelope-from <kamil@re-ws.pl>)
        id 1kDBz9-0002Lq-5x; Tue, 01 Sep 2020 21:31:27 +0200
From:   Kamil Lorenc <kamil@re-ws.pl>
To:     Peter Korsgaard <jacmet@sunsite.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kamil Lorenc <kamil@re-ws.pl>
Subject: [PATCH] net: usb: dm9601: Add USB ID of Keenetic Plus DSL
In_reply-To: <20200901085738.27482-1-kamil@re-ws.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-ID: <GENERATED-WASMISSING-1kDBz9-0002Lq-5x@k17.unixstorm.org>
X-ACL-Warn: Adding Message-ID header because it is missing!
X-Authenticated-Id: kamil@re-ws.pl
Date:   Tue, 1 Sep 2020 15:31:35 -0400
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Keenetic Plus DSL is a xDSL modem that uses dm9620 as its USB interface.
>
> Signed-off-by: Kamil Lorenc <kamil@re-ws.pl>
> ---
>  drivers/net/usb/dm9601.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/net/usb/dm9601.c b/drivers/net/usb/dm9601.c
> index b91f92e4e5f2..915ac75b55fc 100644
> --- a/drivers/net/usb/dm9601.c
> +++ b/drivers/net/usb/dm9601.c
> @@ -625,6 +625,10 @@ static const struct usb_device_id products[] = {
>    USB_DEVICE(0x0a46, 0x1269),  /* DM9621A USB to Fast Ethernet Adapter */
>    .driver_info = (unsigned long)&dm9601_info,
>   },
> + {
> +  USB_DEVICE(0x0586, 0x3427),  /* ZyXEL Keenetic Plus DSL xDSL modem */
> +  .driver_info = (unsigned long)&dm9601_info,
> + },
>   {},     // END
>  };
>
> --
> 2.28.0

I received an error from Peter Korsgaard's mailserver informing that his
email address does not exist. Should I do something with that fact?

