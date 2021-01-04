Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 671E02E979D
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 15:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727246AbhADOs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 09:48:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:49728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726098AbhADOs7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Jan 2021 09:48:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7071D207BC;
        Mon,  4 Jan 2021 14:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609771698;
        bh=tMK9lgZTp2/PYxk2/HncYQK0TyrP7dM/vOybkysA4ls=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O5IWFhMU5QgFCcWzhum7IkBzJ98LRTKf29hw+C7u2zDTWascteDhcVLFmEFB3Z1LV
         CQALfQgyt2ileBW9dth1lC+I/miX0hslj580mwizB431pX91ml1MlTs+hFKXj18HpN
         j557hRsNIxbrDZn6iZEqIRIxJEgv+yoP5yn1ZNUcbp6ZCaSCx0nfqJNBsg8TgiaCRv
         3Z3kGZeXrefIV7tR99yYpV3Tb3FEDGqAUH8tbYT4o7E9zzZRl4bK4g7pGdjfpkd/YE
         3cb/J1zKRoiSi/7YGdYJQaveVp7rLHH1UiySVbi7gSg0jOKUcJV20yoLNJB1A1yfW8
         fgVTdq0eFNqog==
Received: from johan by xi.lan with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1kwR9a-0007Hi-KG; Mon, 04 Jan 2021 15:48:15 +0100
Date:   Mon, 4 Jan 2021 15:48:14 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     =?utf-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        linux-mmc@vger.kernel.org,
        Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH v3 09/24] wfx: add hwio.c/hwio.h
Message-ID: <X/MqrvQSAPXkqFVF@hovoldconsulting.com>
References: <20201104155207.128076-1-Jerome.Pouiller@silabs.com>
 <87lfdp98rw.fsf@codeaurora.org>
 <X+IQRct0Zsm87H4+@kroah.com>
 <4279510.LvFx2qVVIh@pc-42>
 <20210104123410.GN2809@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104123410.GN2809@kadam>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 04, 2021 at 03:34:10PM +0300, Dan Carpenter wrote:

> There is a Smatch warning for this, but I hadn't looked at the results
> in a while. :/  I'm not sure how many are valid.  Some kind of
> annotation would be nice.

> drivers/usb/class/usblp.c:593 usblp_ioctl() error: doing dma on the stack (&newChannel)
> drivers/usb/serial/iuu_phoenix.c:542 iuu_uart_flush() error: doing dma on the stack (&rxcmd)

I only looked at these two but they are are indeed valid, and I've now
fixed them up.

Johan
