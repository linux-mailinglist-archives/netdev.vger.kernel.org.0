Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB0192F422B
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 03:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728722AbhAMC7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 21:59:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:43302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726499AbhAMC7O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 21:59:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2932323120;
        Wed, 13 Jan 2021 02:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610506713;
        bh=mpn2vymas5by2QaskISndzMgDpOQGtfwEd/ZxHwDY9M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rV7L+rqlN6fAHmsTPs4e8Ky8juvnmTwjr9EQDIv5AcFDQkaDW8/KD3KTMewZgTiVg
         EXtfDEQ8QgNTPyP0Unu3XXzexLYWzmTza+Ms7moy1Y8cXYjNlDVDrVy8XkwcfOWJFi
         0M39NQYWiKwnFIXzcIbPWHMieN9JzSAPdcvRBaYI+aRapaP592YCQyqmEqEjjnwlkX
         SAW7IHpF/nB7LaphY8GzZ7dsOWPhzWNES9pnh/zaaHnmaZBwkgiDhGfgxm0BdmiUtP
         Ep4CDEOEC9UlQaV4b4p5CwJGzfn4tTgx8Fd9uQLhfIXZix7IEoy/tBX/0avzaAGz9Z
         8d59gcgO/MtRw==
Date:   Tue, 12 Jan 2021 18:58:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/3] r8169: further improvements
Message-ID: <20210112185832.32720f86@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <6435f64ee2d1da8261ea1aed4b244a674e6ecac3.camel@kernel.org>
References: <1bc3b7ef-b54a-d517-df54-27d61ca7ba94@gmail.com>
        <6435f64ee2d1da8261ea1aed4b244a674e6ecac3.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Jan 2021 12:21:48 -0800 Saeed Mahameed wrote:
> On Tue, 2021-01-12 at 09:27 +0100, Heiner Kallweit wrote:
> > Series includes further smaller improvements.
> > 
> > Heiner Kallweit (3):
> >   r8169: align rtl_wol_suspend_quirk with vendor driver and rename it
> >   r8169: improve rtl8169_rx_csum
> >   r8169: improve DASH support
> > 
> >  drivers/net/ethernet/realtek/r8169_main.c | 81 +++++++++----------
> > ----
> >  1 file changed, 31 insertions(+), 50 deletions(-)
> >   
> 
> Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>

Applied, thanks!
