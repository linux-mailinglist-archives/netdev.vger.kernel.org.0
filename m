Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6479F3B6B34
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 01:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236774AbhF1XMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 19:12:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:41902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236590AbhF1XMi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 19:12:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 03C6461D02;
        Mon, 28 Jun 2021 23:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624921812;
        bh=gkW62qCHQgIrYJEFmkJeNhWFZWK+2asrsyXPVnIk7aQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dzyVrNE0sN5g0flCly5RmIsYeodpWZ0Wp8YyNzwwX7969+9IW3I/oC01p1FfYhQH3
         AyVgGNhLWCqYVmsFq5KfHvxTMBDNwgd2wZMgZc9RKtJaVX54Dwj853piSMR7rt+A78
         3117uVuo3VdZbN/QgRxfTtiICcYZfnTy2lYRRei+GloUdzH69VlI1DvlvSnn88Sdts
         vHGN/4HRRBvqYSDwwl/j5tsMDDiUezdit4u3DGvKsxvXdEYHgDxo8JpylIvUk6MUxH
         f04Y15FQ72P6w8CLqgvOaCZCh0RPCp7CeEMxOxbo//tKcLJGnpcaMkZlavU9GRi4Qp
         E7LO8CFEqN62g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E8A3760CE2;
        Mon, 28 Jun 2021 23:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull request: bluetooth-next 2021-06-28
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162492181194.29625.18150550264106951771.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Jun 2021 23:10:11 +0000
References: <20210628171552.313547-1-luiz.dentz@gmail.com>
In-Reply-To: <20210628171552.313547-1-luiz.dentz@gmail.com>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (refs/heads/master):

On Mon, 28 Jun 2021 10:15:52 -0700 you wrote:
> The following changes since commit ff8744b5eb116fdf9b80a6ff774393afac7325bd:
> 
>   Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue (2021-06-25 11:59:11 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git tags/for-net-next-2021-06-28
> 
> [...]

Here is the summary with links:
  - pull request: bluetooth-next 2021-06-28
    https://git.kernel.org/netdev/net-next/c/f0305e732a1a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


