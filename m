Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBA463CF74F
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 11:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236042AbhGTJSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 05:18:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:53950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235803AbhGTJRr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 05:17:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D23F60FE9;
        Tue, 20 Jul 2021 09:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626775105;
        bh=oZ6f/1tQAfo2KzOhKbZADa4GuV34otAXzMk8ZYbNLT4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eNbCh01MWy6I/oDBf8LFUFKfyJ8t2XHccON6nvWsMRWBIGm+bqJwz47+Laljrnl41
         oQ9NsZEElRNyTQq+5h4QuF/gzu3JtC1AjpvpfBZ9kRNZ7vhgjcmDfelpmdUteYhUNe
         0TLR4LY0SDvZphmAJwrLRcT1Mr4JQZpPAFlpE4BQ=
Date:   Tue, 20 Jul 2021 11:58:22 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Georgi Valkov <gvalkov@abv.bg>
Cc:     davem@davemloft.net, kuba@kernel.org, mhabets@solarflare.com,
        luc.vanoostenryck@gmail.com, snelson@pensando.io, mst@redhat.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, corsac@corsac.net,
        matti.vuorela@bitfactor.fi, stable@vger.kernel.org
Subject: Re: ipheth: fix EOVERFLOW in ipheth_rcvbulk_callback
Message-ID: <YPaePrgEhhaHZAOT@kroah.com>
References: <B60B8A4B-92A0-49B3-805D-809A2433B46C@abv.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B60B8A4B-92A0-49B3-805D-809A2433B46C@abv.bg>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 20, 2021 at 12:37:43PM +0300, Georgi Valkov wrote:
> ipheth: fix EOVERFLOW in ipheth_rcvbulk_callback
> https://github.com/openwrt/openwrt/pull/4084
> 
> 
> From dd109ded2b526636fff438d33433ab64ffd21583 Mon Sep 17 00:00:00 2001
> From: Georgi Valkov <gvalkov@abv.bg>
> Date: Fri, 16 Apr 2021 20:44:36 +0300
> Subject: [PATCH] ipheth: fix EOVERFLOW in ipheth_rcvbulk_callback
> 
> When rx_buf is allocated we need to account for IPHETH_IP_ALIGN,
> which reduces the usable size by 2 bytes. Otherwise we have 1512
> bytes usable instead of 1514, and if we receive more than 1512
> bytes, ipheth_rcvbulk_callback is called with status -EOVERFLOW,
> after which the driver malfunctiones and all communication stops.
> 
> Fixes: ipheth 2-1:4.2: ipheth_rcvbulk_callback: urb status: -75
> 
> Signed-off-by: Georgi Valkov <gvalkov@abv.bg>
> ---
>  drivers/net/usb/ipheth.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
