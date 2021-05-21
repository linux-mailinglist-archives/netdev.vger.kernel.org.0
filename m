Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F42A38CF2E
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 22:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbhEUUlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 16:41:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229457AbhEUUle (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 16:41:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 45D32613EC;
        Fri, 21 May 2021 20:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621629611;
        bh=rZgBN/BDxuLOXUUMP2u0/V+PjGFvGia+rreDNrgoq5U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=o7FhaFVOM4K3UFvB0Q6aotTXhCooPGcucZCJnnKuE0mr4E8p2eNhAC3EQ+elGQ9zh
         XfQ6JZ9M/vZNmvUkDvNE5zN1CUHlfQU3nm5lR3ZqDmjlo7ho5Tr3jysCAZWka0xX9z
         er/ovsmF1EuWT2H9VHiEKEY+91jWtOAZMHL4orJyzqwyHjmesmo5J9XWrksTwSp0zk
         1MxGPVIW7GieaTlgfqrdEDszVWFXRA/MJmeI+HApPNYwyNDOyu1a1xOqK6Annj8sNP
         BFPYR1lWzI+K0D48/CmxJbFZf2n/UWxItx2Bf7ff0buxlaZG6Oru+1A7909QRpYy6o
         jzLBij7PM+mMQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3C45960A56;
        Fri, 21 May 2021 20:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] net: wan: clean up some code style issues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162162961124.15420.825965836900346214.git-patchwork-notify@kernel.org>
Date:   Fri, 21 May 2021 20:40:11 +0000
References: <1621559297-9651-1-git-send-email-huangguangbin2@huawei.com>
In-Reply-To: <1621559297-9651-1-git-send-email-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, xie.he.0141@gmail.com,
        ms@dev.tdt.de, willemb@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com,
        tanhuazhong@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 21 May 2021 09:08:11 +0800 you wrote:
> This patchset clean up some code style issues.
> 
> Peng Li (6):
>   net: wan: fix an code style issue about "foo* bar"
>   net: wan: add some required spaces
>   net: wan: fix the code style issue about trailing statements
>   net: wan: remove redundant blank lines
>   net: wan: add braces {} to all arms of the statement
>   net: wan: add necessary () to macro argument
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] net: wan: fix an code style issue about "foo* bar"
    https://git.kernel.org/netdev/net-next/c/492625791649
  - [net-next,2/6] net: wan: add some required spaces
    https://git.kernel.org/netdev/net-next/c/974221c6cf54
  - [net-next,3/6] net: wan: fix the code style issue about trailing statements
    https://git.kernel.org/netdev/net-next/c/eab9948140d1
  - [net-next,4/6] net: wan: remove redundant blank lines
    https://git.kernel.org/netdev/net-next/c/145efe6c279b
  - [net-next,5/6] net: wan: add braces {} to all arms of the statement
    https://git.kernel.org/netdev/net-next/c/1bf705d4f231
  - [net-next,6/6] net: wan: add necessary () to macro argument
    https://git.kernel.org/netdev/net-next/c/70fe4523c8f6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


