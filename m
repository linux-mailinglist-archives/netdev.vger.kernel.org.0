Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8404D2C9593
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 04:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbgLADJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 22:09:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:48818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727060AbgLADJV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 22:09:21 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F5442074A;
        Tue,  1 Dec 2020 03:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606792120;
        bh=Rw8OwjnfL4gAuMy1F6ne1eKCxz6F5i0joQUFoc9mPnI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zfvQP94nDWTcZDPjLRO32NbXR2tGHSBmO9Nb18Ty9mVx/dmpNunVAxGnpTTj7x17W
         OYibJ1Gn5WxaMMsQagNTS6Yu0wF6ft7nAQvND9QDKGOIt2jta9mi55MNPupgUXSRNg
         WE1mWvaQkRPMuzoLkoCqE4dXzBt4QMGxoJyQfRrM=
Date:   Mon, 30 Nov 2020 19:08:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Subject: Re: pull-request: can-next 2020-11-30
Message-ID: <20201130190839.076f1dee@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201130141432.278219-1-mkl@pengutronix.de>
References: <20201130141432.278219-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Nov 2020 15:14:18 +0100 Marc Kleine-Budde wrote:
> Hello Jakub, hello David,
> 
> here's a pull request of 14 patches for net-next/master.
> 
> Gustavo A. R. Silva's patch for the pcan_usb driver fixes fall-through warnings 
> for Clang.
> 
> The next 5 patches target the mcp251xfd driver and are by Ursula Maplehurst and 
> me. They optimizie the TEF and RX path by reducing number of SPI core requests
> to set the UINC bit.
> 
> The remaining 8 patches target the m_can driver. The first 4 are various
> cleanups for the SPI binding driver (tcan4x5x) by Sean Nyekjaer, Dan Murphy and
> me. Followed by 4 cleanup patches by me for the m_can and m_can_platform
> driver.

Pulled, thanks!
