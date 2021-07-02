Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 238E33BA4BC
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 22:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbhGBUmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 16:42:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:45314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230157AbhGBUmh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Jul 2021 16:42:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AB0576140E;
        Fri,  2 Jul 2021 20:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625258404;
        bh=po+rGhRGOfSYEVv+bPeye0RSjLRvRH4sbEbwMTi14Dk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=s6pDhvtgQBKYDAcQ12PKHPetgUgC3aNUWDeN7CX7ytAzMAniMP2UHRAF6WCZEvDYS
         CPzH/asRfcFUgjPxYRWNJpALfR2C4t7pY991LIy6hSaUzcinnsUOGR/k88egLygp4n
         nksGzgXaPAHnD3ejm6smxnXnb4DjJEerKGuPjUTou5b3PHuIEJJZQlcNnoH8hPD4dx
         A2lZzgHh3XAiD3Gvdt+7QBLSlJqdqZTJfxneduYEj6MX21KrI3KiBg2FAAap25ylvg
         obmaB2888tp5bVa+GUEV6e7e40o9a26Hs5UU0/WXDl35qV9+1mIeGUF9Ow76Ayi6O+
         nHjyM/ovmIFrw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9A14360A38;
        Fri,  2 Jul 2021 20:40:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] small tc conntrack fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162525840462.26489.15345953506982982343.git-patchwork-notify@kernel.org>
Date:   Fri, 02 Jul 2021 20:40:04 +0000
References: <20210702092139.25662-1-simon.horman@corigine.com>
In-Reply-To: <20210702092139.25662-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com, louis.peens@corigine.com,
        yinjun.zhang@corigine.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Fri,  2 Jul 2021 11:21:37 +0200 you wrote:
> Louis Peens says:
> 
> The first patch makes sure that any callbacks registered to
> the ct->nf_tables table are cleaned up before freeing.
> 
> The second patch removes what was effectively a workaround
> in the nfp driver because of the missing cleanup in patch 1.
> 
> [...]

Here is the summary with links:
  - [net,1/2] net/sched: act_ct: remove and free nf_table callbacks
    https://git.kernel.org/netdev/net/c/77ac5e40c44e
  - [net,2/2] nfp: flower-ct: remove callback delete deadlock
    https://git.kernel.org/netdev/net/c/7cc93d888df7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


