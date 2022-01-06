Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49396486448
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 13:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238769AbiAFMUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 07:20:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238778AbiAFMUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 07:20:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4167DC0611FD
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 04:20:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F099EB820D4
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 12:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AD062C36AE5;
        Thu,  6 Jan 2022 12:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641471614;
        bh=X5IwBfEHtRNLG1mOK8wiC6QDJhFq3Ime29vv/RhyuhY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GOWY51mlzK5whxoLVYmccoxYG7KrS5cMeyBhmtWf9ZvN3hChzWETIxM+krJamGjg+
         Ww2r5j3t0BLwn7EXRwxL+UITpzxAEsOZ7Y7qfbyNJZDjrnU9+MzVPVJ3hRmON10Ned
         /i3TGKgW+TyLH+rvBYS6Zi/G6aysUkRuTj1JXgsO7VBK2abW8LRUS8zHyX41/M9Mg7
         Hoi8BNUK+Qvi/NA/PvcG2lTbsLpn5ld0ZjYNtNXltcMHMYXuaam9KbKRWykYDi3lR0
         pmSK0j4X5o/2b1eAwQrecqHk9v4FlHHbOXDP5NYcGYrd90DcwCA4rHTv5sYdIUFyWK
         twhQzp8LLsAHA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9B479F79403;
        Thu,  6 Jan 2022 12:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/6] DSA initialization cleanups
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164147161463.27983.13271917543011470048.git-patchwork-notify@kernel.org>
Date:   Thu, 06 Jan 2022 12:20:14 +0000
References: <20220105231117.3219039-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220105231117.3219039-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  6 Jan 2022 01:11:11 +0200 you wrote:
> These patches contain miscellaneous work that makes the DSA init code
> path symmetric with the teardown path, and some additional patches
> carried by Ansuel Smith for his register access over Ethernet work, but
> those patches can be applied as-is too.
> https://patchwork.kernel.org/project/netdevbpf/patch/20211214224409.5770-3-ansuelsmth@gmail.com/
> 
> Vladimir Oltean (6):
>   net: dsa: reorder PHY initialization with MTU setup in slave.c
>   net: dsa: merge rtnl_lock sections in dsa_slave_create
>   net: dsa: stop updating master MTU from master.c
>   net: dsa: hold rtnl_mutex when calling dsa_master_{setup,teardown}
>   net: dsa: first set up shared ports, then non-shared ports
>   net: dsa: setup master before ports
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/6] net: dsa: reorder PHY initialization with MTU setup in slave.c
    https://git.kernel.org/netdev/net-next/c/904e112ad431
  - [v2,net-next,2/6] net: dsa: merge rtnl_lock sections in dsa_slave_create
    https://git.kernel.org/netdev/net-next/c/e31dbd3b6aba
  - [v2,net-next,3/6] net: dsa: stop updating master MTU from master.c
    https://git.kernel.org/netdev/net-next/c/a1ff94c2973c
  - [v2,net-next,4/6] net: dsa: hold rtnl_mutex when calling dsa_master_{setup,teardown}
    https://git.kernel.org/netdev/net-next/c/c146f9bc195a
  - [v2,net-next,5/6] net: dsa: first set up shared ports, then non-shared ports
    https://git.kernel.org/netdev/net-next/c/1e3f407f3cac
  - [v2,net-next,6/6] net: dsa: setup master before ports
    https://git.kernel.org/netdev/net-next/c/11fd667dac31

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


