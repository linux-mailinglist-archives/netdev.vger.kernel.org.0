Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53C6B3A949A
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 10:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbhFPICY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 04:02:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:58502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231865AbhFPICM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 04:02:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6B89E61375;
        Wed, 16 Jun 2021 08:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623830406;
        bh=HNK10wznP1voxN3VskXuMUlHjgjTZQtd6juzodBKNgg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MYJRCFqdbaHxjYUugvO3xa9DFwd4P7JMof5s0p/6E7Ppxv7jGpBLFau92edSwtGlh
         Ro6BMESVUK5TzKicpzzmJwo2yJQLZLtHewKm3tDDoutuScP997a3zU4tWZ0W9JCV8L
         A3jAFWoa6cqIzA7dRgtzRtvVM2TbDOrOPEu3rUyk0Qq3FRt6PqvYM8PZRatYJqWaGc
         d3htD7FePpeyAyMzMrNnhiiLEHNYRZAzUhXE/uae3MzBBABcWZ6+UUCd45hpIEWf3N
         KOtWy9II48hfn6ufjOsneyGjC7WY+9iF+wg4LzD6EGWiQJ89ERqfwZVCWoBo5A/xbr
         8qESjziF6tdjQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 55D0360953;
        Wed, 16 Jun 2021 08:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/15] net: cosa: clean up some code style issues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162383040634.10821.5938234576114586057.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Jun 2021 08:00:06 +0000
References: <1623828221-48349-1-git-send-email-huangguangbin2@huawei.com>
In-Reply-To: <1623828221-48349-1-git-send-email-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, xie.he.0141@gmail.com,
        ms@dev.tdt.de, willemb@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 16 Jun 2021 15:23:26 +0800 you wrote:
> From: Peng Li <lipeng321@huawei.com>
> 
> This patchset clean up some code style issues.
> 
> Peng Li (15):
>   net: cosa: remove redundant blank lines
>   net: cosa: add blank line after declarations
>   net: cosa: fix the code style issue about "foo* bar"
>   net: cosa: replace comparison to NULL with "!chan->rx_skb"
>   net: cosa: move out assignment in if condition
>   net: cosa: fix the comments style issue
>   net: cosa: add braces {} to all arms of the statement
>   net: cosa: remove redundant braces {}
>   net: cosa: add necessary () to macro argument
>   net: cosa: use BIT macro
>   net: cosa: fix the alignment issue
>   net: cosa: fix the code style issue about trailing statements
>   net: cosa: add some required spaces
>   net: cosa: remove trailing whitespaces
>   net: cosa: remove redundant spaces
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] net: cosa: remove redundant blank lines
    https://git.kernel.org/netdev/net-next/c/786f0dc627e6
  - [net-next,02/15] net: cosa: add blank line after declarations
    https://git.kernel.org/netdev/net-next/c/0569a3d41667
  - [net-next,03/15] net: cosa: fix the code style issue about "foo* bar"
    https://git.kernel.org/netdev/net-next/c/77282db510d9
  - [net-next,04/15] net: cosa: replace comparison to NULL with "!chan->rx_skb"
    https://git.kernel.org/netdev/net-next/c/2076b3e61a32
  - [net-next,05/15] net: cosa: move out assignment in if condition
    https://git.kernel.org/netdev/net-next/c/b4d5f1e2cdeb
  - [net-next,06/15] net: cosa: fix the comments style issue
    https://git.kernel.org/netdev/net-next/c/c0a963e25df9
  - [net-next,07/15] net: cosa: add braces {} to all arms of the statement
    https://git.kernel.org/netdev/net-next/c/c8f4b11727af
  - [net-next,08/15] net: cosa: remove redundant braces {}
    https://git.kernel.org/netdev/net-next/c/70d063b9a621
  - [net-next,09/15] net: cosa: add necessary () to macro argument
    https://git.kernel.org/netdev/net-next/c/acc3edf0054e
  - [net-next,10/15] net: cosa: use BIT macro
    https://git.kernel.org/netdev/net-next/c/3fac4b941c06
  - [net-next,11/15] net: cosa: fix the alignment issue
    https://git.kernel.org/netdev/net-next/c/9edc7d68b021
  - [net-next,12/15] net: cosa: fix the code style issue about trailing statements
    https://git.kernel.org/netdev/net-next/c/573747254f22
  - [net-next,13/15] net: cosa: add some required spaces
    https://git.kernel.org/netdev/net-next/c/e84c3e1436dc
  - [net-next,14/15] net: cosa: remove trailing whitespaces
    https://git.kernel.org/netdev/net-next/c/6619e2b63b41
  - [net-next,15/15] net: cosa: remove redundant spaces
    https://git.kernel.org/netdev/net-next/c/b8773205277e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


