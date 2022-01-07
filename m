Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 241B24871B0
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 05:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbiAGEKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 23:10:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59068 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231232AbiAGEKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 23:10:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CE4661E56
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 04:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7E1DEC36AE5;
        Fri,  7 Jan 2022 04:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641528612;
        bh=Vba2acBIvYJ18Y3mOz2Q+1+es5q9Gp1iOIi6BirXsIY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KmuDmGQvoO6ttB/s8mjz0gRLnNYli3jsx8jtUDS42jPiZMfl52Ju4pIm9UeLW0qOu
         Devb8R93Vgaj6NhqszEzFyVkoEGUyWWbxG5UoWNjFaZqfQVEdjZk46PqGMwBTIwRX1
         f8zlhXOiVwqbz8VZXehFljmKwCX0VSAA1hi4JWcmAuJWzOAleFsAhVjhsecClgOgqK
         vaZ/smJ7WSRbc65tmm5UA7LOLEl8iyHPWl+1F79CnqSOCRQfB+TZIHnCrdb/lnyL7Y
         rcebTS3IHwOozZRMDt4QJGPG07HSOuZlvlf93a7AL3nKzq2oOILHeDEbWwLkz2JVqC
         A16UVUQWZqMFQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 602EDF79409;
        Fri,  7 Jan 2022 04:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5][pull request] 100GbE Intel Wired LAN Driver
 Updates 2022-01-06
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164152861239.15603.5428713390972218496.git-patchwork-notify@kernel.org>
Date:   Fri, 07 Jan 2022 04:10:12 +0000
References: <20220106183013.3777622-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220106183013.3777622-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Thu,  6 Jan 2022 10:30:08 -0800 you wrote:
> This series contains updates to ice driver only.
> 
> Victor adds restoring of advanced rules after reset.
> 
> Wojciech improves usage of switchdev control VSI by utilizing the
> device's advanced rules for forwarding.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] ice: replay advanced rules after reset
    https://git.kernel.org/netdev/net-next/c/c36a2b971627
  - [net-next,2/5] ice: improve switchdev's slow-path
    https://git.kernel.org/netdev/net-next/c/c1e5da5dd465
  - [net-next,3/5] ice: Slightly simply ice_find_free_recp_res_idx
    https://git.kernel.org/netdev/net-next/c/a5c259b16284
  - [net-next,4/5] ice: Optimize a few bitmap operations
    https://git.kernel.org/netdev/net-next/c/e75ed29db531
  - [net-next,5/5] ice: Use bitmap_free() to free bitmap
    https://git.kernel.org/netdev/net-next/c/0dbc41621875

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


