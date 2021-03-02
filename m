Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 075EB32B384
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449581AbhCCEAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:00:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443437AbhCBLrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 06:47:45 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E951DC061356
        for <netdev@vger.kernel.org>; Tue,  2 Mar 2021 03:47:03 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id r17so34628660ejy.13
        for <netdev@vger.kernel.org>; Tue, 02 Mar 2021 03:47:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pwkg4Wcjp3GD4nmALaWuQYmUdvO456JkG0Tk+ZBhRI4=;
        b=AOON4rW/0Fl153aiznBdJXVi/7Db9kWfPZnkn6TClXRA2CykWhYQOfebP4yLV6NPWH
         LWdCcjqwI2BvZBhUqknwSdTFO63JlTRX1paNowiJ33G5IpsIzGcgCUtgi12DheVPt1zw
         SzZio/HNLfTx5/EOe074lainPiVhOUlzRlRUJ9ysBXX7NcgKh8WgzFfKSxRI/pkv/Clk
         3ORbmyyGTMZ0VEjK+MYjI2cQkdUizSHSFvXYg06rYm0ENLKhoXcR8JIU70gNr8Jl+D/S
         /ym0SrheXcX36jnQNqnC1AhemKcfpWkSnYusW1QcHiOYnuZ7qsEy+31Hc0GjFHWl8FC0
         w9Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pwkg4Wcjp3GD4nmALaWuQYmUdvO456JkG0Tk+ZBhRI4=;
        b=Ni3KO89zFeD5kA/KD1lAlLILcq6NyxJwN6pfFZQXn4YySYRe4kiS9XoYfHA0jj0AWL
         rE2TkshzlZ2sulZEjl2Yt17dptl5pGJtR49NfdG4GCRT2fouwtXQCjmBLs1eXHyxC+I+
         r5T7wzo+DPfSLfPlQfiEjIQTx2/nFGr91UYB6oe3cwDvtkNLmX8YdY3V4bflZZjbXGaN
         5b+p87500Kb9d/OCoZeTRVsBP4h7AYl9A7+arjjIX9xG+KVefrs1RozPCKtPENiv7MDS
         5/4mKWd7XTegRUAIIfqJDKwoeK4b6cXC5mqCI4Gegp3iDXwrvDhQxbdRkYW9AJ/XslW0
         PVcw==
X-Gm-Message-State: AOAM532faJ2CVYQz6oJq+5UTjIJbYEJNhHgvFfL48UG4/gGz3IQ9m8d1
        pXMPn2pmAxqzLlrgEkebG3Q=
X-Google-Smtp-Source: ABdhPJzRuFtfL+rDROj1lz8NYgTV3qtdaq88R4tStIw2g0jj1elwl5DqmyrNcb+KCpyhHhF47hoiZg==
X-Received: by 2002:a17:907:962a:: with SMTP id gb42mr19948988ejc.206.1614685622649;
        Tue, 02 Mar 2021 03:47:02 -0800 (PST)
Received: from skbuf ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id l6sm18777107edn.82.2021.03.02.03.47.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 03:47:02 -0800 (PST)
Date:   Tue, 2 Mar 2021 13:47:01 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        michael@walle.cc, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, andrew@lunn.ch,
        vladimir.oltean@nxp.com
Subject: Re: [PATCH v3 net 0/8] Fixes for NXP ENETC driver
Message-ID: <20210302114701.agmjacnf6vudbuko@skbuf>
References: <20210301111818.2081582-1-olteanv@gmail.com>
 <161463480768.18741.11451492687720022399.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161463480768.18741.11451492687720022399.git-patchwork-notify@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 01, 2021 at 09:40:07PM +0000, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This series was applied to netdev/net.git (refs/heads/master):
> 
> On Mon,  1 Mar 2021 13:18:10 +0200 you wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > 
> > This contains an assorted set of fixes collected over the past 2 weeks
> > on the enetc driver. Some are related to VLAN processing, some to
> > physical link settings, some are fixups of previous hardware workarounds,
> > and some are simply zero-day data path bugs that for some reason were
> > never caught or at least identified.
> > 
> > [...]
> 
> Here is the summary with links:
>   - [v3,net,1/8] net: enetc: don't overwrite the RSS indirection table when initializing
>     https://git.kernel.org/netdev/net/c/c646d10dda2d
>   - [v3,net,2/8] net: enetc: initialize RFS/RSS memories for unused ports too
>     https://git.kernel.org/netdev/net/c/3222b5b613db
>   - [v3,net,3/8] net: enetc: take the MDIO lock only once per NAPI poll cycle
>     https://git.kernel.org/netdev/net/c/6d36ecdbc441
>   - [v3,net,4/8] net: enetc: fix incorrect TPID when receiving 802.1ad tagged packets
>     https://git.kernel.org/netdev/net/c/827b6fd04651
>   - [v3,net,5/8] net: enetc: don't disable VLAN filtering in IFF_PROMISC mode
>     https://git.kernel.org/netdev/net/c/a74dbce9d454
>   - [v3,net,6/8] net: enetc: force the RGMII speed and duplex instead of operating in inband mode
>     https://git.kernel.org/netdev/net/c/c76a97218dcb
>   - [v3,net,7/8] net: enetc: remove bogus write to SIRXIDR from enetc_setup_rxbdr
>     https://git.kernel.org/netdev/net/c/96a5223b918c
>   - [v3,net,8/8] net: enetc: keep RX ring consumer index in sync with hardware
>     https://git.kernel.org/netdev/net/c/3a5d12c9be6f
> 
> You are awesome, thank you!
> --
> Deet-doot-dot, I am a bot.
> https://korg.docs.kernel.org/patchwork/pwbot.html

Thanks.
This is somewhat non-ideal, since, as discussed on patch 8/8, I was
planning to resend a new version with the proper Fixes: tag, but
obviously I did not get the chance to do that:
https://patchwork.kernel.org/project/netdevbpf/patch/20210301111818.2081582-9-olteanv@gmail.com/
However, at this point, doing anything at all would be messier than not
doing anything, and according to my calculations, nothing breaks even if
patch 8/8 is backported to kernels containing just the initial commit of
the driver, but not the MDIO workaround. The next_to_use variable will
just be written twice (with the same value) to the RX ring's consumer
index, once in enetc_refill_rx_ring and the second time immediately
afterwards, in enetc_setup_rxbdr.
If I get the chance to NACK backporting of patch 8 to stable kernels
that don't contain commit "enetc: Workaround for MDIO register access
issue" (aka to stable kernels lower than linux-5.9.y) then I'll do that.
