Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B515412749
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 22:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbhITUbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 16:31:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:49982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235150AbhITU3a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 16:29:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB046610A0;
        Mon, 20 Sep 2021 20:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632169683;
        bh=OGvFVt7OMuwz3WLk5ieNZgsTBVHUvdk/X4GpPiLvG08=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ctH8VNqTbWuWohLtn8S7Q++m7eHZkeZODDFTL881HLnxCyHYNQzTY8qwLY7TQmbI+
         KbdFLm2vKLzsrYvjBvh2lSsimGyCHOnsCt5WPckKGml1A9CfkVvlFlV5hdWldFFSVA
         gwXS8HB/3i4b0FInIHo5R2aigDJXok3M5SPIfsRwmZ+nfy6uoL8grW/lBe/S86NoWr
         3aq7rozGQbBrMENDEiFYb+Fnr40I3OKRiSsFQU9ocv/5fKEEnH3Mk0sa+M6kDDaTON
         l8V+R0YaL4Owvh8r04iXZXd1I63pG2yCx1KV84QZEtJgX1hxZPUP5GGSBoZGoh833c
         1p2047ddiOs0Q==
Date:   Mon, 20 Sep 2021 13:28:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
        netdev@vger.kernel.org, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, m.chetan.kumar@intel.com,
        linuxwwan@intel.com
Subject: Re: [PATCH V2 net-next 0/6] net: wwan: iosm: fw flashing & cd
 collection
Message-ID: <20210920132801.7ab99be1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <163212901143.27858.1001521725257769247.git-patchwork-notify@kernel.org>
References: <20210919172424.25764-1-m.chetan.kumar@linux.intel.com>
        <163212901143.27858.1001521725257769247.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Sep 2021 09:10:11 +0000 patchwork-bot+netdevbpf@kernel.org
wrote:
> On Sun, 19 Sep 2021 22:54:24 +0530 you wrote:
> > This patch series brings-in support for M.2 7560 Device firmware flashing &
> > coredump collection using devlink.
> > - Driver Registers with Devlink framework.
> > - Register devlink params callback for configuring device params
> >   required in flashing or coredump flow.
> > - Implements devlink ops flash_update callback that programs modem
> >   firmware.
> > - Creates region & snapshot required for device coredump log collection.
> > 
> > [...]  
> 
> Here is the summary with links:
>   - [V2,net-next,1/6] net: wwan: iosm: devlink registration
>     https://git.kernel.org/netdev/net-next/c/4dcd183fbd67
>   - [V2,net-next,2/6] net: wwan: iosm: fw flashing support
>     https://git.kernel.org/netdev/net-next/c/b55734745568
>   - [V2,net-next,3/6] net: wwan: iosm: coredump collection support
>     https://git.kernel.org/netdev/net-next/c/09e7b002ff67
>   - [V2,net-next,4/6] net: wwan: iosm: transport layer support for fw flashing/cd
>     https://git.kernel.org/netdev/net-next/c/8d9be0634181
>   - [V2,net-next,5/6] net: wwan: iosm: devlink fw flashing & cd collection documentation
>     https://git.kernel.org/netdev/net-next/c/64302024bce5
>   - [V2,net-next,6/6] net: wwan: iosm: fw flashing & cd collection infrastructure changes
>     https://git.kernel.org/netdev/net-next/c/607d574aba6e
> 
> You are awesome, thank you!

I had to post a revert of v1 because it was merged too quickly,
and the same exact thing happens to v2. Maybe it's just me but 
feels very disheartening.

The flashing API is really easy to extended all the devlink params 
here should be part of the flashing API.
