Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2B8C2F30C9
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 14:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbhALNL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 08:11:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:34288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbhALNLZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 08:11:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E902A23104;
        Tue, 12 Jan 2021 13:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610457044;
        bh=+I0/CAlCSgREEqQUkT62aVbfKK8iKlEIHmnPI9Xh+LU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oBRMoK91OPAtO51gk8exkl4tg1E+5bRaxZssSyfLuIrpFG/yq0ZO7NIiD9g1gjYxY
         wRPw5f//p2rico1l2rTePxE8qvR7/ymw6MlxhHqHYYvfDLrvYM7TwbcwaGz6lMJ6Eh
         NPcuF4XJPGTSasFb64QSpYyoyli1TAHm2oLJ8HSA=
Date:   Tue, 12 Jan 2021 14:11:53 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Roland Dreier <roland@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.10 23/51] CDC-NCM: remove "connected" log
 message
Message-ID: <X/2gGVG7Dn4nvj2V@kroah.com>
References: <20210112125534.70280-1-sashal@kernel.org>
 <20210112125534.70280-23-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112125534.70280-23-sashal@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 07:55:05AM -0500, Sasha Levin wrote:
> From: Roland Dreier <roland@kernel.org>
> 
> [ Upstream commit 59b4a8fa27f5a895582ada1ae5034af7c94a57b5 ]
> 
> The cdc_ncm driver passes network connection notifications up to
> usbnet_link_change(), which is the right place for any logging.
> Remove the netdev_info() duplicating this from the driver itself.
> 
> This stops devices such as my "TRENDnet USB 10/100/1G/2.5G LAN"
> (ID 20f4:e02b) adapter from spamming the kernel log with
> 
>     cdc_ncm 2-2:2.0 enp0s2u2c2: network connection: connected
> 
> messages every 60 msec or so.
> 
> Signed-off-by: Roland Dreier <roland@kernel.org>
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Link: https://lore.kernel.org/r/20201224032116.2453938-1-roland@kernel.org
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/net/usb/cdc_ncm.c | 3 ---
>  1 file changed, 3 deletions(-)

This is already queued up to be in the next round of stable releases, so
no need to queue it up again :)

thanks,

greg k-h
