Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 807271A65A1
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 13:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729014AbgDMLee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 07:34:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:52858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727781AbgDMLee (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 07:34:34 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F9DF20678;
        Mon, 13 Apr 2020 11:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586777673;
        bh=g9GiP2ssoJe9E0aCBX9TGi5o6GBUAuGShYoolhAc1z4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zP/NrWpsnobZvHgohl71Dc2HCMtuXVBEEkMHowUonBTGQeGADyHu+uu/beuu7wVvY
         917Mk6+VLsuPhn8gkFISr8Z5WAPQkH4wv1IfTEab7LbbcVQM45qvEzBTMRMUxDOUBm
         hrBxJUzyf4ZWosS1QMFpHd+yHb73QVfkZ6CDwMY4=
Date:   Mon, 13 Apr 2020 14:34:30 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Lauri Jakku <ljakku77@gmail.com>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        nic_swsd@realtek.com
Subject: Re: NET: r8168/r8169 identifying fix
Message-ID: <20200413113430.GM334007@unreal>
References: <4bc0fc0c-1437-fc41-1c50-38298214ec75@gmail.com>
 <20200413105838.GK334007@unreal>
 <dc2de414-0e6e-2531-0131-0f3db397680f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc2de414-0e6e-2531-0131-0f3db397680f@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 13, 2020 at 02:02:01PM +0300, Lauri Jakku wrote:
> Hi,
>
> Comments inline.
>
> On 2020-04-13 13:58, Leon Romanovsky wrote:
> > On Mon, Apr 13, 2020 at 01:30:13PM +0300, Lauri Jakku wrote:
> >> From 2d41edd4e6455187094f3a13d58c46eeee35aa31 Mon Sep 17 00:00:00 2001
> >> From: Lauri Jakku <lja@iki.fi>
> >> Date: Mon, 13 Apr 2020 13:18:35 +0300
> >> Subject: [PATCH] NET: r8168/r8169 identifying fix
> >>
> >> The driver installation determination made properly by
> >> checking PHY vs DRIVER id's.
> >> ---
> >>  drivers/net/ethernet/realtek/r8169_main.c | 70 ++++++++++++++++++++---
> >>  drivers/net/phy/mdio_bus.c                | 11 +++-
> >>  2 files changed, 72 insertions(+), 9 deletions(-)
> >
> > I would say that most of the code is debug prints.
> >
>
> I tought that they are helpful to keep, they are using the debug calls, so
> they are not visible if user does not like those.

You are missing the point of who are your users.

Users want to have working device and the code. They don't need or like
to debug their kernel.

Thanks
