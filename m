Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89D963B0B53
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 19:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232120AbhFVRWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 13:22:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:40182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232021AbhFVRWW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 13:22:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AE4A96100B;
        Tue, 22 Jun 2021 17:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624382406;
        bh=z6pJgm00LjGn1FdJTr21+TXFrhrI8yhNyfgJ8FhkVQo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HBwZi2+DFHNmXWXs1Cg4jBQFovCanKk/N9k1EAqk8kf2gUqhXImtTXlXXfKzBt9px
         c7B+PkMemdp0FoBGiFNGmgYQzzf5+vkwfA4aJyxeuRpeGHd/b5dI2nLKGbaaGkgwYr
         xE+gQT0bEYWLe9kYQUXW6kXEcqOFhE9gQZrYfWU3zotFuKiiaqpiHrIAF7SLm2ch49
         oIv6w/IM/c2jNkTQBQ4MQXMF7x5tfknvSJ6YEGQMCbb3BG2dXbvRmT+ixCu+GsnP2p
         7XDvVpIRQzA5Y6A3khfCG68OmXudwvdZMzwzDiwzITZFFGYewQI619OlLY/n6/oSGh
         Qcbxf+iT+LMBw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A38DE60A02;
        Tue, 22 Jun 2021 17:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 00/10] net: WWAN link creation improvements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162438240666.16834.10618921519968813535.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Jun 2021 17:20:06 +0000
References: <20210621225100.21005-1-ryazanov.s.a@gmail.com>
In-Reply-To: <20210621225100.21005-1-ryazanov.s.a@gmail.com>
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     loic.poulain@linaro.org, johannes@sipsolutions.net,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 22 Jun 2021 01:50:50 +0300 you wrote:
> This series is intended to make the WWAN network links management easier
> for WWAN device drivers.
> 
> The series begins with adding support for network links creation to the
> WWAN HW simulator to facilitate code testing. Then there are a couple of
> changes that prepe the WWAN core code for further modifications. The
> following patches (4-6) simplify driver unregistering procedures by
> performing the created links cleanup in the WWAN core. 7th patch is to
> avoid the odd hold of a driver module. Next patches (8th and 9th) make
> it easier for drivers to create a network interface for a default data
> channel. Finally, 10th patch adds support for reporting of data link
> (aka channel aka context) id to make user aware which network
> interface is bound to which WWAN device data channel.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,01/10] wwan_hwsim: support network interface creation
    https://git.kernel.org/netdev/net-next/c/f842f48891ad
  - [net-next,v2,02/10] wwan: core: relocate ops registering code
    https://git.kernel.org/netdev/net-next/c/355a4e7e0a23
  - [net-next,v2,03/10] wwan: core: require WWAN netdev setup callback existence
    https://git.kernel.org/netdev/net-next/c/58c3b421c62e
  - [net-next,v2,04/10] wwan: core: multiple netdevs deletion support
    https://git.kernel.org/netdev/net-next/c/f492fccf3d62
  - [net-next,v2,05/10] wwan: core: remove all netdevs on ops unregistering
    https://git.kernel.org/netdev/net-next/c/2f75238014f0
  - [net-next,v2,06/10] net: iosm: drop custom netdev(s) removing
    https://git.kernel.org/netdev/net-next/c/322a0ba99c50
  - [net-next,v2,07/10] wwan: core: no more hold netdev ops owning module
    https://git.kernel.org/netdev/net-next/c/9f0248ea476e
  - [net-next,v2,08/10] wwan: core: support default netdev creation
    https://git.kernel.org/netdev/net-next/c/ca374290aaad
  - [net-next,v2,09/10] net: iosm: create default link via WWAN core
    https://git.kernel.org/netdev/net-next/c/83068395bbfc
  - [net-next,v2,10/10] wwan: core: add WWAN common private data for netdev
    https://git.kernel.org/netdev/net-next/c/699409240389

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


