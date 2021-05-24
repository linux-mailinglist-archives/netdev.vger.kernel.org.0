Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5752F38F4C2
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 23:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233790AbhEXVLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 17:11:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:32882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233771AbhEXVLp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 17:11:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E716E6141A;
        Mon, 24 May 2021 21:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621890616;
        bh=fzUhbVcQvBGt6AjKlTvMbb8soGm43PZnaSq2zGi4F4w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mUMTzGtoxPlJ5lSPxir5UJwn9W4xzDKkvIlYzUd9OpGXuSSfkZmGS39363c8G1/qe
         4Eu9owaL5lbeSlb8jGezXKE8fY96Taw5r+EIo5mhUr5YV7soIwH1qrmFeeHrW79Dh0
         QsPmW9EuwNeoa2dNakmnDAj2sTJIfrC/hDblUQi0sFDAj3MzRcVrC8BXdbCi0MQXRi
         G0vue1oa7+r/B3EujrF2lXDTAX0QD72V6vIgQej/200k+gOEQcb1M3MQy6qjqTfO0b
         SLYWDL35fA8bxhtc3i9cP7ymsWYbfqSUjkT5LHsgwqG/EQ1/64WAYeNLVtqfzFRwVx
         D31qq2XQaF2BQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D89F660CD0;
        Mon, 24 May 2021 21:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/10] net: wan: clean up some code style issues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162189061688.7619.17487449991942944358.git-patchwork-notify@kernel.org>
Date:   Mon, 24 May 2021 21:10:16 +0000
References: <1621867637-2680-1-git-send-email-huangguangbin2@huawei.com>
In-Reply-To: <1621867637-2680-1-git-send-email-huangguangbin2@huawei.com>
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

On Mon, 24 May 2021 22:47:07 +0800 you wrote:
> This patchset clean up some code style issues.
> 
> Peng Li (10):
>   net: wan: remove redundant blank lines
>   net: wan: fix an code style issue about "foo* bar"
>   net: wan: add blank line after declarations
>   net: wan: code indent use tabs where possible
>   net: wan: fix the code style issue about trailing statements
>   net: wan: add some required spaces
>   net: wan: move out assignment in if condition
>   net: wan: replace comparison to NULL with "!card"
>   net: wan: fix the comments style issue
>   net: wan: add braces {} to all arms of the statement
> 
> [...]

Here is the summary with links:
  - [net-next,01/10] net: wan: remove redundant blank lines
    https://git.kernel.org/netdev/net-next/c/8890d0a1891a
  - [net-next,02/10] net: wan: fix an code style issue about "foo* bar"
    https://git.kernel.org/netdev/net-next/c/b32db030b96e
  - [net-next,03/10] net: wan: add blank line after declarations
    https://git.kernel.org/netdev/net-next/c/f0328a192290
  - [net-next,04/10] net: wan: code indent use tabs where possible
    https://git.kernel.org/netdev/net-next/c/261795f4113b
  - [net-next,05/10] net: wan: fix the code style issue about trailing statements
    https://git.kernel.org/netdev/net-next/c/e5877104b5ec
  - [net-next,06/10] net: wan: add some required spaces
    https://git.kernel.org/netdev/net-next/c/c3b6b5c64f39
  - [net-next,07/10] net: wan: move out assignment in if condition
    https://git.kernel.org/netdev/net-next/c/87feef1cfbbe
  - [net-next,08/10] net: wan: replace comparison to NULL with "!card"
    https://git.kernel.org/netdev/net-next/c/336d781bd952
  - [net-next,09/10] net: wan: fix the comments style issue
    https://git.kernel.org/netdev/net-next/c/80d67b95d1fe
  - [net-next,10/10] net: wan: add braces {} to all arms of the statement
    https://git.kernel.org/netdev/net-next/c/d1406175f968

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


