Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBDE3A49B9
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 22:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbhFKUCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 16:02:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:56776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230211AbhFKUCF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 16:02:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1F4F1613E9;
        Fri, 11 Jun 2021 20:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623441607;
        bh=P5LQ0pydQf97BVngKIIA4qLhsk/2rEtI5tP4HhI/o/A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Id3NT9WTpdk9O9+ZfCODWBu7JeGEdzdVkZXN3wxTWYfpLYca+2BX0igFrflZqSE8n
         p/zRRVGDs5wBXSatHdMVYEkxtw49DgbBHGAfTX8e+Gaivh7affKqvWqKhVnNsx7qzx
         zby/5M4XCHDYWtyXn55Sj4irVnyTyVyX15nwZIeQe7hMdG0/CkJGJt89T72/OgQZTJ
         w9yQ0orzRTWZzjgS11K0rEeHSJ6sR0JHKkWv8AIFy34QI2/yBv0Q8KCfBDxLoShT8Q
         CSDVqkdX0WiSntW5xaIWtyXs7Ghm2fA3vd80vw5SOdZfMZ4JtzZJ6P59GyyvI8ntzq
         rm4LVoYPj0wFw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 13344609E4;
        Fri, 11 Jun 2021 20:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8] net: pc300too: clean up some code style issues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162344160707.3583.12464133502726199194.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Jun 2021 20:00:07 +0000
References: <1623382582-37854-1-git-send-email-huangguangbin2@huawei.com>
In-Reply-To: <1623382582-37854-1-git-send-email-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, xie.he.0141@gmail.com,
        ms@dev.tdt.de, willemb@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 11 Jun 2021 11:36:14 +0800 you wrote:
> From: Peng Li <lipeng321@huawei.com>
> 
> This patchset clean up some code style issues.
> 
> Peng Li (8):
>   net: pc300too: remove redundant blank lines
>   net: pc300too: add blank line after declarations
>   net: pc300too: fix the code style issue about "foo * bar"
>   net: pc300too: move out assignment in if condition
>   net: pc300too: remove redundant initialization for statics
>   net: pc300too: replace comparison to NULL with "!card->plxbase"
>   net: pc300too: add some required spaces
>   net: pc300too: fix the comments style issue
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] net: pc300too: remove redundant blank lines
    https://git.kernel.org/netdev/net-next/c/93f764371c45
  - [net-next,2/8] net: pc300too: add blank line after declarations
    https://git.kernel.org/netdev/net-next/c/a657c8b4d50d
  - [net-next,3/8] net: pc300too: fix the code style issue about "foo * bar"
    https://git.kernel.org/netdev/net-next/c/f8864e26d311
  - [net-next,4/8] net: pc300too: move out assignment in if condition
    https://git.kernel.org/netdev/net-next/c/d72f78db55d6
  - [net-next,5/8] net: pc300too: remove redundant initialization for statics
    https://git.kernel.org/netdev/net-next/c/ae6440483b54
  - [net-next,6/8] net: pc300too: replace comparison to NULL with "!card->plxbase"
    https://git.kernel.org/netdev/net-next/c/0cd2135cf83d
  - [net-next,7/8] net: pc300too: add some required spaces
    https://git.kernel.org/netdev/net-next/c/eed00311659f
  - [net-next,8/8] net: pc300too: fix the comments style issue
    https://git.kernel.org/netdev/net-next/c/ef1806a8b961

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


