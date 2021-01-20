Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 245D72FD6D2
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 18:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404114AbhATRVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 12:21:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:33762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390947AbhATRUi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 12:20:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D05822CE3;
        Wed, 20 Jan 2021 17:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611163196;
        bh=f9NjFTR2vJgUfpqeCtF+sXxDu7N4LTV5PQEfjR1od4Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Xkl/AwNYXYuEEaNYRJHeeZ9Ssl60aEZCMol7iRmgu2XKxN40uXHGVSgyqnEMRWzrI
         TslyLawgLPhLKxKpXTbX+xUQ97y266JEtdRtcAv/uwTAEwlgqHKTmIkcCmxK4FSjce
         lRJMGefeo/8wqkj2hs2ITJ68k3sTaH2qkBEufDh4oKHejkFO3Hn772mjsY+DYfR69/
         bpTJlG/PDJVai72tqGeblqO0rg/GY/B2S9vAje4JTz5dnvKLEw/c1AbGhnl7bOVBnY
         yYjshtFMhdyi/AmlooQXfRsc9yQXuKHmSGtSsdSe22yhlTRptGwDdLpzG0FBiPYSkH
         lzoyZkZtm+RJw==
Date:   Wed, 20 Jan 2021 09:19:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Subject: Re: pull-request: can 2021-01-20
Message-ID: <20210120091955.54a52e09@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210120125202.2187358-1-mkl@pengutronix.de>
References: <20210120125202.2187358-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Jan 2021 13:51:59 +0100 Marc Kleine-Budde wrote:
> Hello Jakub, hello David,
> 
> this is a pull request of 3 patches for net/master.
> 
> All three patches are by Vincent Mailhol and fix a potential use after free bug
> in the CAN device infrastructure, the vxcan driver, and the peak_usk driver. In
> the TX-path the skb is used to read from after it was passed to the networking
> stack with netif_rx_ni().

Pulled, thanks.

Seems like the PR didn't show up in patchwork at all :S Hopefully I can
still pull reight manually without the scripts :)

> Note: Patch 1/3 touches "drivers/net/can/dev.c". In net-next/master this file
> has been moved to drivers/net/can/dev/dev.c [1] and parts of it have been
> transfered into separate files. This may result in a merge conflict. Please
> carry this patch forward, the change is rather simple. Drop us a note if
> needed. Are any actions needed with regards to linux-next?

Thanks for the note, I'm sending the PR to Linus now, so I think
linux-next may never see the the conflict.
