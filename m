Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7941549E3F7
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 15:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240368AbiA0OAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 09:00:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236884AbiA0OAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 09:00:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1511C061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 06:00:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DA0E61B8D
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 14:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D50CCC340EF;
        Thu, 27 Jan 2022 14:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643292010;
        bh=fuxNmULtsgNCuFSvQVh98CjexGQvH+8isVMDzy7ABpI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lg4+xwVh1AybDV2H2RmdkJYveSRbIeDPrDrQx+n6bp/OlRW6DDpleM+5aWaNsoqTs
         NtjgOK6KxrFnXff/C8lk6yOQcfUdgSSmo6nClPoJU+r+C1l7SKFNqxYRxsXDfLiqzj
         1DBHY2GfLW3phqwZXVl41sKvnKR6o1VNtDyao8tkaBbyms9Vdmc+VCAbd5pdPE8Mzr
         ekWS8THqhkUeCfko2xD6gf4qjOX9d4ndeBfM46vJ81blxrk5EhRDZedQmuJXbXZrWX
         sZNrP3Pedy+gNz5zVIopo1k7YnDV1DaE+R2j1rzNdPDydoUj5ukUMu+r9HLd37p4a7
         Ir9iPEz4s3WVw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BEFC2E6BAC6;
        Thu, 27 Jan 2022 14:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: bridge: vlan: fix single net device option dumping
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164329201077.13469.5252832269191984892.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Jan 2022 14:00:10 +0000
References: <20220126131025.2500274-1-nikolay@nvidia.com>
In-Reply-To: <20220126131025.2500274-1-nikolay@nvidia.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        bridge@lists.linux-foundation.org, roopa@nvidia.com,
        bpoirier@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 26 Jan 2022 15:10:25 +0200 you wrote:
> When dumping vlan options for a single net device we send the same
> entries infinitely because user-space expects a 0 return at the end but
> we keep returning skb->len and restarting the dump on retry. Fix it by
> returning the value from br_vlan_dump_dev() if it completed or there was
> an error. The only case that must return skb->len is when the dump was
> incomplete and needs to continue (-EMSGSIZE).
> 
> [...]

Here is the summary with links:
  - [net] net: bridge: vlan: fix single net device option dumping
    https://git.kernel.org/netdev/net/c/dcb2c5c6ca9b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


