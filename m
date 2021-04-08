Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A42E358F2D
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 23:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232674AbhDHVac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 17:30:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:60892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232631AbhDHVa0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 17:30:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4FB9761178;
        Thu,  8 Apr 2021 21:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617917414;
        bh=+p98hfbgiSxghj7uiMq+bpdUpjxrGsRYsNx0dL3G5r8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Y1QucsTRCJOsaHStCD5u+YhPVCPsgdh91igdgOZ3Bm4S2ydYNvLaX6v52feWXs+jx
         0iwtyN35EVSfPr5j+iIuqTnmQsdLAU6TxGhfXqpHPqNNxio/QrMOcL0/lQlLH23isP
         nhQJSIByJQdmFlG3n6puY8PKMN9XsRLpUV14d/dCnfkcOO256PxvOfINf8/hNIqDXl
         xWwjYnin8PNFsHknIrK2vKLNlfwf9HUWUwjXuEIzTXYSiizy9mDK/Yf+OMRzLuJKPx
         jPYFTbQj9TLiPAdYldk+IroIk0C8FZYIzP1ETBc7M6GZi9oIHO6ePE2FpYvUrINosj
         a//vYzrl7wjAQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4209760A2A;
        Thu,  8 Apr 2021 21:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull request: bluetooth-next 2021-04-08
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161791741426.16984.10090857068493742554.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Apr 2021 21:30:14 +0000
References: <20210408164506.1686871-1-luiz.dentz@gmail.com>
In-Reply-To: <20210408164506.1686871-1-luiz.dentz@gmail.com>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        luiz.von.dentz@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (refs/heads/master):

On Thu,  8 Apr 2021 09:45:06 -0700 you wrote:
> The following changes since commit d310ec03a34e92a77302edb804f7d68ee4f01ba0:
> 
>   Merge tag 'perf-core-2021-02-17' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2021-02-21 12:49:32 -0800)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git tags/for-net-next-2021-04-08
> 
> [...]

Here is the summary with links:
  - pull request: bluetooth-next 2021-04-08
    https://git.kernel.org/netdev/net-next/c/4438669eb703

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


