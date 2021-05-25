Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC4E4390C74
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 00:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232143AbhEYWvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 18:51:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:60230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230288AbhEYWvk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 18:51:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 83552613D6;
        Tue, 25 May 2021 22:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621983010;
        bh=uMpouXgcFp6eBIEYRYa+pOiSx819V0p/cQvL+3veD6Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FwA1vWmgflh5hoT7JEHHGEpWXxxrAR0vrfJD7yrT5sklqxUCZOR3VIPfMqUz6ep16
         8O5Zz9gjUNcftnPSDonzKSk0EgL4+QFKZbBSPXjwSSsEZYjCzPo8Zu1j+r9yx6RCUr
         EjwC1fbldP/6UYH3D2S8CD6Igt/s/9hvYEKIXeLtQDOmaKvOCeeJD6bnfVP80d+Bs3
         xSOGZ2lB1n1sGnCgezoonkBRHJbVP1qJsJmjnbZ3dGnEXKOeKTTMxGqG+4o05WWsgN
         SyAkgjzG7jd2/rw89iv+bn08+1zBm86mWPr/6sbT5fY+iqOeLxT+Wj47ppFGd9HLUs
         s+izbedw/ZP0Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7631E608B8;
        Tue, 25 May 2021 22:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] net: wan: clean up some code style issues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162198301047.27957.15429921368540128951.git-patchwork-notify@kernel.org>
Date:   Tue, 25 May 2021 22:50:10 +0000
References: <1621951678-23466-1-git-send-email-huangguangbin2@huawei.com>
In-Reply-To: <1621951678-23466-1-git-send-email-huangguangbin2@huawei.com>
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

On Tue, 25 May 2021 22:07:52 +0800 you wrote:
> This patchset clean up some code style issues.
> 
> Peng Li (6):
>   net: wan: remove redundant blank lines
>   net: wan: add blank line after declarations
>   net: wan: fix an code style issue about "foo* bar
>   net: wan: add some required spaces
>   net: wan: replace comparison to NULL with "!card"
>   net: wan: add spaces required around that ':' and '+'
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] net: wan: remove redundant blank lines
    https://git.kernel.org/netdev/net-next/c/98d728232c98
  - [net-next,2/6] net: wan: add blank line after declarations
    https://git.kernel.org/netdev/net-next/c/9e7ee10f169f
  - [net-next,3/6] net: wan: fix an code style issue about "foo* bar
    https://git.kernel.org/netdev/net-next/c/c4fdef99d17b
  - [net-next,4/6] net: wan: add some required spaces
    https://git.kernel.org/netdev/net-next/c/69542276e2b1
  - [net-next,5/6] net: wan: replace comparison to NULL with "!card"
    https://git.kernel.org/netdev/net-next/c/2aea27bae89b
  - [net-next,6/6] net: wan: add spaces required around that ':' and '+'
    https://git.kernel.org/netdev/net-next/c/30cbb0107e98

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


