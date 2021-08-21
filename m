Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A68F3F3A6F
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 13:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234424AbhHULrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 07:47:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:33974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229968AbhHULrr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Aug 2021 07:47:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19236611CB;
        Sat, 21 Aug 2021 11:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629546427;
        bh=zYZlHxjm3AxgVLwVWi8zq67GNGIHRWbpjO36tg1QunA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uy2VB7l8svDzzUHfBZck19UPnKl+L9Sgs/ajcBAzLl5omazzGt9UiiVjJ+McFHnJk
         6bkRnH9Wy2E9gACxCmw5VeTgZnB389l4cpmO2Lkf1HM7gYzlO+as38eJPNPlIE1yKG
         8q+p/9M6iAEHrIADm2lDNtT5cgBKQjlG0GN7fY+Q=
Date:   Sat, 21 Aug 2021 13:47:03 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Petko Manolov <petko.manolov@konsulko.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        paskripkin@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] net: usb: pegasus: fixes of set_register(s) return
 value evaluation;
Message-ID: <YSDnt1I16Plle9NC@kroah.com>
References: <20210820065753.1803-1-petko.manolov@konsulko.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210820065753.1803-1-petko.manolov@konsulko.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 20, 2021 at 09:57:53AM +0300, Petko Manolov wrote:
>   - restore the behavior in enable_net_traffic() to avoid regressions - Jakub
>     Kicinski;
>   - hurried up and removed redundant assignment in pegasus_open() before yet
>     another checker complains;
> 
> Fixes: 8a160e2e9aeb ("net: usb: pegasus: Check the return value of get_geristers() and friends;")
> Reported-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Petko Manolov <petko.manolov@konsulko.com>
> ---
>  drivers/net/usb/pegasus.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
