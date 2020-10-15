Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9487328EFD1
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 12:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730934AbgJOKEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 06:04:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725919AbgJOKEW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 06:04:22 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB8A620776;
        Thu, 15 Oct 2020 10:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602756262;
        bh=xojIR6spLGo+9FPgT5OQtMEpsj4OOd03/r+xLmlJR1M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bMk7EQ/57cp4QfFeML5YfX78bWt+CPoFGvyLgIuqk0wbznhkjVU0v1Lu3ILywgMEt
         XygMXajaU6ND0L0lilWa07zUDKSOWd9B299A/9hLrmEjUBqst4pKaZp0pZliqInA1T
         Pjxobs6fsPZ8E8oi/JyzKdhy2ra2R6lyW6ARc14M=
Date:   Thu, 15 Oct 2020 12:04:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Arnaud Patard <arnaud.patard@rtp-net.org>
Cc:     stable@vger.kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch 1/1] drivers/net/ethernet/marvell/mvmdio.c: Fix non OF
 case
Message-ID: <20201015100455.GA3938169@kroah.com>
References: <20201015093221.720980174@rtp-net.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015093221.720980174@rtp-net.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 15, 2020 at 11:32:15AM +0200, Arnaud Patard wrote:
> commit d934423ac26ed373dfe089734d505dca5ff679b6 upstream.
> 
> Orion5.x systems are still using machine files and not device-tree.
> Commit 96cb4342382290c9 ("net: mvmdio: allow up to three clocks to be
> specified for orion-mdio") has replaced devm_clk_get() with of_clk_get(),
> leading to a oops at boot and not working network, as reported in
> https://lists.debian.org/debian-arm/2019/07/msg00088.html and possibly in
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=908712.
>     
> Link: https://lists.debian.org/debian-arm/2019/07/msg00088.html
> Fixes: 96cb4342382290c9 ("net: mvmdio: allow up to three clocks to be specified for orion-mdio")
> Signed-off-by: Arnaud Patard <arnaud.patard@rtp-net.org>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> 

What stable tree(s) are you asking for this to be backported to?

thanks,

greg k-h
