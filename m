Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7953092D6
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 10:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbhA3JEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 04:04:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:39634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229659AbhA3FAs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Jan 2021 00:00:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A07DD64E1C;
        Sat, 30 Jan 2021 05:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611982807;
        bh=yIenmksmASPqZ0TnvCBO4KKc8QG5elrrKIvNIlkxdtA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iizAYdZte50X+vzhu2OHTpa/53f6x9pjcm8oY6xYb/lG6BqncvfWWEDKlSb9L65da
         l/jstdWROFyVeq7pJyKOkzqXsJu2UQd+USu6YoBUgRKkZV/7TJhvBaBWFrOC6bgkRM
         +MeCSyLNPsin19bkfQaHyYquKjsiXxY56Cl03AhdRl0ilRGhgdiUyvlH2FC3fyFAp3
         EL4J4MtkZ9/ePDfKpsuOQ1fquqHANlwGihiQV3LTPhudLeOBNRbQaeytpO0aHgYG1w
         jr90tZts5Srse9huUT6zfRoEWnzPp/nE5txQb+nHvWpi1F/zDRh98pnZMLQt8H3uNW
         0QYAUrbjTHzkQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 89ABD60983;
        Sat, 30 Jan 2021 05:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv3 net-next 0/2] net: add support for ip generic checksum
 offload for gre
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161198280755.18955.8313504272569874296.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Jan 2021 05:00:07 +0000
References: <cover.1611825446.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1611825446.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, marcelo.leitner@gmail.com,
        dcaratti@redhat.com, davem@davemloft.net, kuba@kernel.org,
        willemb@google.com, alexander.duyck@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 28 Jan 2021 17:18:30 +0800 you wrote:
> This patchset it to add ip generic csum processing first in
> skb_csum_hwoffload_help() in Patch 1/2 and then add csum
> offload support for GRE header in Patch 2/2.
> 
> v1->v2:
>   - See each patch's changelog.
> v2->v3:
>   - See the 1st patch.
> 
> [...]

Here is the summary with links:
  - [PATCHv3,net-next,1/2] net: support ip generic csum processing in skb_csum_hwoffload_help
    https://git.kernel.org/netdev/net-next/c/62fafcd63139
  - [PATCHv3,net-next,2/2] ip_gre: add csum offload support for gre header
    https://git.kernel.org/netdev/net-next/c/efa1a65c7e19

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


