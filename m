Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B431D35232D
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 01:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233789AbhDAXKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 19:10:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:34266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231160AbhDAXKI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 19:10:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CE47D610FC;
        Thu,  1 Apr 2021 23:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617318608;
        bh=Y+ae4vE+FskqQEGrUAyD4C6AHKzc1GipMQ2rbkQeqJs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=J0H7meUz9HDvY5Smx6ga3Zm9g20ZKfqDz8SnJvzAlHUe+kwzdAIf22UCnsHsA0r97
         E5uYM5IxgdqKGDEA5xpp/xa5UWa1aseABtbv0Px92qdhCEU3LrtfB/3w3l1NTjxLNR
         YJqB2JAD0v+UoJz8yNdXBlyQQxWwaaXok5OGlXtRpmpWiRbcVcDlrlhxKg35GjdyH/
         cC/C4JekBzC15griDv6g8KeWTOspOwHd74/mZN05JQBSe7UuUPXlfBv5EfdPucdOEl
         +EZYBF2Ombm60iRivjQmshkm7BFhXOhuPTZYx5gCZVfOy86RzhtCt3JWEd3IRa9m5k
         oFDhit9QNFMZA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BCCA4609CD;
        Thu,  1 Apr 2021 23:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] mptcp: mptcp: fix deadlock in mptcp{,6}_release
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161731860876.11591.13180900206221380898.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Apr 2021 23:10:08 +0000
References: <cover.1617295578.git.pabeni@redhat.com>
In-Reply-To: <cover.1617295578.git.pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, mptcp@lists.linux.dev, davem@davemloft.net,
        kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu,  1 Apr 2021 18:57:43 +0200 you wrote:
> syzkaller has reported a few deadlock triggered by
> mptcp{,6}_release.
> 
> These patches address the issue in the easy way - blocking
> the relevant, multicast related, sockopt options on MPTCP
> sockets.
> 
> [...]

Here is the summary with links:
  - [net,1/2] mptcp: forbit mcast-related sockopt on MPTCP sockets
    https://git.kernel.org/netdev/net/c/86581852d771
  - [net,2/2] mptcp: revert "mptcp: provide subflow aware release function"
    https://git.kernel.org/netdev/net/c/0a3cc57978d1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


