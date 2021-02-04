Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6483330E9A9
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 02:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234132AbhBDBut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 20:50:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:50692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233218AbhBDBur (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 20:50:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 595D964DA1;
        Thu,  4 Feb 2021 01:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612403407;
        bh=TbTgfsqOCGxCQ87GXfsQnv9W1EoaqxQn9wEPfmdCshQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hgg1FHTBfaQhnwtJzo+LZAWdWsQDLHQsuOEeZmCN/030xj2QkgBUmKX9FZx7YaWew
         bBzNKh7RTLiWPBvz4wcajCBZAVNkBPlvkzCsS6iat6jHCLDrZ2dUzA1VkN3E9SI2+e
         FsMZQvSm6KTp6BQmhRv5AWQGo9MKdMSH36L37nyq0sJBWKaOqNspOkNfRvsgQo1SFD
         K0Uzkdyp6CBQnIs+YtJ+KHIiTliI0kGPJRqehZkJkomMZY56xgBMlgdaEqH3onz/60
         jGDSJPn3pS7Gk5SB4GUsUHqT0+KyrszIpCBfkeicqEAVoYCRT9ds4svpwUCnf+5XqI
         OIhES4sgZ2d0w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3E90D609EC;
        Thu,  4 Feb 2021 01:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2,net-next,0/3] Support for OcteonTX2 98xx CPT block.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161240340725.20790.10609262359469267197.git-patchwork-notify@kernel.org>
Date:   Thu, 04 Feb 2021 01:50:07 +0000
References: <20210202152709.20450-1-schalla@marvell.com>
In-Reply-To: <20210202152709.20450-1-schalla@marvell.com>
To:     Srujana Challa <schalla@marvell.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        schandran@marvell.com, pathreya@marvell.com, jerinj@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 2 Feb 2021 20:57:06 +0530 you wrote:
> OcteonTX2 series of silicons have multiple variants, the
> 98xx variant has two crypto (CPT) blocks to double the crypto
> performance. This patchset adds support for new CPT block(CPT1).
> 
> Srujana Challa (3):
>   octeontx2-af: Mailbox changes for 98xx CPT block
>   octeontx2-af: Add support for CPT1 in debugfs
>   octeontx2-af: Handle CPT function level reset
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/3] octeontx2-af: Mailbox changes for 98xx CPT block
    https://git.kernel.org/netdev/net-next/c/de2854c87c64
  - [v2,net-next,2/3] octeontx2-af: Add support for CPT1 in debugfs
    https://git.kernel.org/netdev/net-next/c/b0f60fab7805
  - [v2,net-next,3/3] octeontx2-af: Handle CPT function level reset
    https://git.kernel.org/netdev/net-next/c/c57c58fd5c4f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


