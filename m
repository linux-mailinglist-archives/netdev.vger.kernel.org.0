Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F24DF3DF331
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237292AbhHCQvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:51:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:33138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237403AbhHCQvP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 12:51:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F34960230;
        Tue,  3 Aug 2021 16:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628009464;
        bh=KCLfJhLn1doB3b21K3LzJGJODGe82+VKFfzDFNkV+m8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=APsuuGpsR+uY6ldhW35w5GeDRnIEuWIKE9eetvLLp2Zt9pI1m+e3e2FSr/MBSf/Po
         ETUKSo3RTEiGbAi9AX/HqqpRTHJaGu32H6777Pcim8p6zCXWHdxDc470D7CumKNSDX
         qekszZDNkaniK2S7Xl9k5y4qI/fEA+MGVuUJ57e8=
Date:   Tue, 3 Aug 2021 18:51:01 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Petko Manolov <petko.manolov@konsulko.com>
Cc:     netdev@vger.kernel.org, paskripkin@gmail.com, davem@davemloft.net,
        Petko Manolov <petkan@nucleusys.com>
Subject: Re: [PATCH net 2/2] net: usb: pegasus: Remove the changelog and
 DRIVER_VERSION.
Message-ID: <YQlz9XJQ08WLfWXC@kroah.com>
References: <20210803150317.5325-1-petko.manolov@konsulko.com>
 <20210803150317.5325-3-petko.manolov@konsulko.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210803150317.5325-3-petko.manolov@konsulko.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 03, 2021 at 06:03:17PM +0300, Petko Manolov wrote:
> From: Petko Manolov <petkan@nucleusys.com>
> 
> These are now deemed redundant.
> 
> Signed-off-by: Petko Manolov <petkan@nucleusys.com>
> ---
>  drivers/net/usb/pegasus.c | 30 ++----------------------------
>  1 file changed, 2 insertions(+), 28 deletions(-)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
