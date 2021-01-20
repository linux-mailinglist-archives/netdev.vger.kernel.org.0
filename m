Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC622FDB0B
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 21:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388029AbhATUmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 15:42:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:45138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730157AbhATUik (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 15:38:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B15F1233FC;
        Wed, 20 Jan 2021 20:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611175073;
        bh=PoEuM5RihGLtvLuo+/upWFzSGJuLQE0GJTiZhs/OkXA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rCT1jSJhdukpLq3EZ/Q0CgA+H4LT8Kzm3VMcYVliKfKDHLddigqQvycfBG4o4OPPk
         7xrXK6tulPdVWbCclghNnXvG4mlQkyyWAeCU/vTjDMwzY1nRO1XsSKy8LBWAMFWjBz
         dLc/dmfMkyNEa4wvJwzUj5PpaMbRAmT8vSecjLap+k2o3Ax3uH+Tv+g+MhMZqOc+f6
         xn/ItXwe092nCtxNghWu1TDC7gyKUcqM1MFbzToI9Wh0CfZBnDsz/xU8Ie+pPlcrRa
         DctTZW66eAwGtoxakjipb3vWhXu9RwrR7fGx4TmxCaIjDrjQ2eu8BQL036/O0rHn3J
         u5Bdb7w5GB5fw==
Date:   Wed, 20 Jan 2021 12:37:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2021-01-18.2
Message-ID: <20210120123752.636659d1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <c066813abc5830eb094ae0c343a71e88b775b441.camel@sipsolutions.net>
References: <20210118204750.7243-1-johannes@sipsolutions.net>
        <161101020906.2232.13826999223880000897.git-patchwork-notify@kernel.org>
        <c066813abc5830eb094ae0c343a71e88b775b441.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Jan 2021 18:59:21 +0100 Johannes Berg wrote:
> Hi Jakub,
> 
> > This pull request was applied to netdev/net.git (refs/heads/master):  
> 
> Since you pulled this now, question:
> 
> I have some pending content for mac80211-next/net-next that either
> conflicts with or requires a fix from here, or such.
> 
> Could you pull net into net-next, so I can get it into mac80211-next? Or
> do you prefer another approach here? I could also double-apply the
> single patch, or pull myself but then we'd get a lot of net content into
> net-next only via mac80211-next which seems odd.

Just merged net -> net-next, you can do your thing :)

Out of curiosity are you going to rebase mac80211-next or send a PR,
fast forward and then apply the conflicting patches?
