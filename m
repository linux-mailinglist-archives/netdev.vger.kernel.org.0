Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAAFD49E05D
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 12:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239938AbiA0LN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 06:13:59 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48230 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233389AbiA0LN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 06:13:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64EBDB821EE;
        Thu, 27 Jan 2022 11:13:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AA00C340E4;
        Thu, 27 Jan 2022 11:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643282036;
        bh=1iWMjgJQHCCxYrBwu4Lbg5lRy+4oxDRGMKV7x5712Fg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZP7hMg+XeiSp8zezCJlwfyQ6OVUgmpg5veAuBQoAz4irmeQjX41BTmXViWj1H691g
         /YUlYS81UKBzptd4p9dGZwVBf8Qvt0HSL4UNcebVL1jVkhn1Hye9KnVXPWlgY62sZJ
         b8pNS3CR6dNRudjE3JFhEbHwcP9qmbLmvkTrSGBk=
Date:   Thu, 27 Jan 2022 12:13:53 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] usbnet: add devlink support
Message-ID: <YfJ+ceEzvzMM1JsW@kroah.com>
References: <20220127110742.922752-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127110742.922752-1-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 12:07:42PM +0100, Oleksij Rempel wrote:
> The weakest link of usbnet devices is the USB cable.

The weakest link of any USB device is the cable, why is this somehow
special to usbnet devices?

> Currently there is
> no way to automatically detect cable related issues except of analyzing
> kernel log, which would differ depending on the USB host controller.
> 
> The Ethernet packet counter could potentially show evidence of some USB
> related issues, but can be Ethernet related problem as well.
> 
> To provide generic way to detect USB issues or HW issues on different
> levels we need to make use of devlink.

Please make this generic to all USB devices, usbnet is not special here
at all.

NAK.

greg k-h
