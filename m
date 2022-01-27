Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09A4A49E08C
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 12:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240120AbiA0LSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 06:18:39 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57308 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231251AbiA0LSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 06:18:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E368460C0F;
        Thu, 27 Jan 2022 11:18:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D741C340E4;
        Thu, 27 Jan 2022 11:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643282317;
        bh=MHx8Ll56fdbfHbMZIJzpqKohDBZqdKnjvZtgrGP4EGQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I+r9F3AWRPENrkGX/mc61dBrNNS/VRaS+ly2y83/zGId8MpRx4GrQFE6yYDPFWWTP
         nTiq/E/hQoOQPpgw4hWYLzA4xN+aZ+7Mw9uAmNMGD/KsmQSLOBXKV0mvt7xbOlUpgj
         gS+D0BLhXiVV3xGOBNwWBPT1UvwG9D+h5RSdbxJA=
Date:   Thu, 27 Jan 2022 12:18:34 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] usbnet: add devlink support
Message-ID: <YfJ/irQFFh3bv/1U@kroah.com>
References: <20220127110742.922752-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127110742.922752-1-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 12:07:42PM +0100, Oleksij Rempel wrote:
> @@ -2137,9 +2183,10 @@ static void usbnet_async_cmd_cb(struct urb *urb)
>  	struct usb_ctrlrequest *req = (struct usb_ctrlrequest *)urb->context;
>  	int status = urb->status;
>  
> -	if (status < 0)
> +	if (status < 0) {
>  		dev_dbg(&urb->dev->dev, "%s failed with %d",
>  			__func__, status);
> +	}
>  
>  	kfree(req);
>  	usb_free_urb(urb);

Also watch out for not-needed changes in your patch submissions.

greg k-h
