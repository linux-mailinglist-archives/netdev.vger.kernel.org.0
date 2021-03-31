Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA6E0350986
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 23:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232885AbhCaVaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 17:30:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:60604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233332AbhCaVaJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 17:30:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D04B361090;
        Wed, 31 Mar 2021 21:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617226208;
        bh=8F1c7eIs16200K1pVBmmDKMHPibMSSwD4R9Jrdbg9Ik=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=q+dh/2hzNIYtK3usj2aPiWYwowSwmuQ9OxE2iZuIpwQ9STJ6AaTmumPMqQ9W2IHge
         3zdFnmeoWyWAdJbDiSl85s7c+dpBIOLC7l/nXzvhgnyRreticOv+XFK5zxQXHaIerV
         eDBUOkcHpbDMqP8E4VsOuQmODWh50F0qmBCHHUnjjPScSrcfBtwm76qkQJMLJxqi+0
         K8uHhLYlWR5ZFycv1kTv382F3he+JDTIvi1g3t2O6ikuZ+uokPUPUn7LZcvrsecp5W
         bDEvy/Zqr6emiQnU1T3PZJ2qp9qjMKe5aAOdKdMndTXZ+G73xyGukysFUiWwGwdDo9
         kCf6mga5/c3Vg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C3964608FB;
        Wed, 31 Mar 2021 21:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] ethtool: support FEC configuration over netlink
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161722620879.13975.12571252131016197424.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Mar 2021 21:30:08 +0000
References: <20210330035954.1206441-1-kuba@kernel.org>
In-Reply-To: <20210330035954.1206441-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, mkubecek@suse.cz, andrew@lunn.ch,
        netdev@vger.kernel.org, ecree.xilinx@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 29 Mar 2021 20:59:51 -0700 you wrote:
> This series adds support for the equivalents of ETHTOOL_GFECPARAM
> and ETHTOOL_SFECPARAM over netlink.
> 
> As a reminder - this is an API which allows user to query current
> FEC mode, as well as set FEC manually if autoneg is disabled.
> It does not configure anything if autoneg is enabled (that said
> few/no drivers currently reject .set_fecparam calls while autoneg
> is disabled, hopefully FW will just ignore the settings).
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] ethtool: support FEC settings over netlink
    https://git.kernel.org/netdev/net-next/c/1e5d1f69d9fb
  - [net-next,2/3] netdevsim: add FEC settings support
    https://git.kernel.org/netdev/net-next/c/0d7f76dc11e6
  - [net-next,3/3] selftests: ethtool: add a netdevsim FEC test
    https://git.kernel.org/netdev/net-next/c/1da07e5db356

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


