Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCC3667AD3
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 17:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238279AbjALQaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 11:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239134AbjALQ3i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 11:29:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8A5C7;
        Thu, 12 Jan 2023 08:28:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E28862098;
        Thu, 12 Jan 2023 16:28:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE0DC433EF;
        Thu, 12 Jan 2023 16:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673540912;
        bh=mgGlQQkkF/t6/ak4py3g5m7hSWgslBssdBClAa1/QXA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ohcq9U27rhWzab5QejLSfxkHl4i3R1RavkqVjlrpGeftAByssGHJO7IcclMj0eymk
         NFi8i2F85+2bNtm21ARdqXzOxPmF/bX6qZhUD63pRUqb7ggpX4RuMkupSyEg8jcwS2
         6ps3xsS6oybgZHWRYvWJzlyChdoHQ4KHQtCXmEVzvjyTJlUnt9CN/JBwzMTO3rFx1a
         YgtBnNcXsDlBk2rAnn9eZZpOWpOZ3kfE0de2dOXp3kpCrRSB4EV7kh/w30FN7dcF+h
         A7dxECyqGxWuUu8ozutNjAceSvd4djFPvbFOw1N/v11Opy19otS5hZpK/0q6+DBe5s
         NeWh9HNAOi7Ww==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1pG0RU-0003YK-8l; Thu, 12 Jan 2023 17:28:40 +0100
Date:   Thu, 12 Jan 2023 17:28:40 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Matthew Garrett <mjg59@srcf.ucam.org>
Cc:     bjorn@mork.no, netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Matthew Garrett <mgarrett@aurora.tech>
Subject: Re: [PATCH V2 1/3] USB: serial: option: Add generic MDM9207
 configurations
Message-ID: <Y8A1OCqtqdSVQPf9@hovoldconsulting.com>
References: <20221226234751.444917-1-mjg59@srcf.ucam.org>
 <20221226234751.444917-2-mjg59@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221226234751.444917-2-mjg59@srcf.ucam.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 26, 2022 at 03:47:49PM -0800, Matthew Garrett wrote:
> The Orbic Speed RC400L presents as a generic MDM9207 device that supports
> multiple configurations. Add support for the two that expose a set of serial
> ports.

Would you mind including the output of usb-devices for this device here
for completeness?

> Signed-off-by: Matthew Garrett <mgarrett@aurora.tech>
> ---
>  drivers/usb/serial/option.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
> index dee79c7d82d5..5025810db8c9 100644
> --- a/drivers/usb/serial/option.c
> +++ b/drivers/usb/serial/option.c
> @@ -1119,6 +1119,12 @@ static const struct usb_device_id option_ids[] = {
>  	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x0023)}, /* ONYX 3G device */
>  	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x9000), /* SIMCom SIM5218 */
>  	  .driver_info = NCTRL(0) | NCTRL(1) | NCTRL(2) | NCTRL(3) | RSVD(4) },
> +	/* Qualcomm MDM9207 - 0: DIAG, 1: modem, 2: AT, 3: NMEA, 4: adb, 5: QMI */

We typically just include the port layout in the commit message (along
with usb-devices output). Then you can move the device comment to the
end of the USB_DEVICE() line (cf. ONYX 3G device above).

> +	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0xf601),
> +	  .driver_info = RSVD(4) | RSVD(5) },
> +	/* Qualcomm MDM9207 - 0,1: RNDIS, 2: DIAG, 3: modem, 4: AT, 5: NMEA, 6: adb */
> +	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0xf622),
> +	  .driver_info = RSVD(0) | RSVD(1) | RSVD(6) },
>  	/* Quectel products using Qualcomm vendor ID */
>  	{ USB_DEVICE(QUALCOMM_VENDOR_ID, QUECTEL_PRODUCT_UC15)},
>  	{ USB_DEVICE(QUALCOMM_VENDOR_ID, QUECTEL_PRODUCT_UC20),

Johan
