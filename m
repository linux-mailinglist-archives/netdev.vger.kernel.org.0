Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C72AB3A354C
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 23:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbhFJVCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 17:02:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:44280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230248AbhFJVCD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 17:02:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 34A61613D8;
        Thu, 10 Jun 2021 21:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623358807;
        bh=XvG/+QpeoFzd5YXD9ge0fe+us0myedB/pI3DyTa8gCs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EyrRWR53x2jZFI/d/bGjvSiBn873oO+i7hXP7rgj/TWDXAJUG485Wh2jxkYXaI+yx
         6WHUZDiqiBbMka5rIyhe5rKGwOx0VrI8rKfZK45zlFgCHIfcystwTxV04NKi49xyQz
         JGzyLmWFYaJ+NdezsGIxA4IJ0Ng9hSXcxLXSASHs1pEytqnmODNkCuvkaf1kxt3EMr
         Ccu+4b5iwUE5cG2WybzlBsQUNzGYZUDy+RHP09jp9ZUVBYSBNAq4UZ9wHcNZfcHF8H
         UNHdttno0dV8X86JyNZEP2tLGv/owxexSvnBq5n6qB3kEmhYCobt1Y+2sly6/iON+s
         +wlM764LIjm8g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2923460A0C;
        Thu, 10 Jun 2021 21:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8] net: ixp4xx_hss: clean up some code style issues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162335880716.5408.1335895859351758154.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Jun 2021 21:00:07 +0000
References: <1623309605-15671-1-git-send-email-huangguangbin2@huawei.com>
In-Reply-To: <1623309605-15671-1-git-send-email-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, xie.he.0141@gmail.com,
        ms@dev.tdt.de, willemb@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 10 Jun 2021 15:19:57 +0800 you wrote:
> From: Peng Li <lipeng321@huawei.com>
> 
> This patchset clean up some code style issues.
> 
> Peng Li (8):
>   net: ixp4xx_hss: remove redundant blank lines
>   net: ixp4xx_hss: add blank line after declarations
>   net: ixp4xx_hss: fix the code style issue about "foo* bar"
>   net: ixp4xx_hss: move out assignment in if condition
>   net: ixp4xx_hss: add some required spaces
>   net: ixp4xx_hss: remove redundant spaces
>   net: ixp4xx_hss: fix the comments style issue
>   net: ixp4xx_hss: add braces {} to all arms of the statement
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] net: ixp4xx_hss: remove redundant blank lines
    https://git.kernel.org/netdev/net-next/c/5c32fdbb8997
  - [net-next,2/8] net: ixp4xx_hss: add blank line after declarations
    https://git.kernel.org/netdev/net-next/c/6f2016ed6538
  - [net-next,3/8] net: ixp4xx_hss: fix the code style issue about "foo* bar"
    https://git.kernel.org/netdev/net-next/c/6487fab04f27
  - [net-next,4/8] net: ixp4xx_hss: move out assignment in if condition
    https://git.kernel.org/netdev/net-next/c/99ebe65eb9c0
  - [net-next,5/8] net: ixp4xx_hss: add some required spaces
    https://git.kernel.org/netdev/net-next/c/dee014567732
  - [net-next,6/8] net: ixp4xx_hss: remove redundant spaces
    https://git.kernel.org/netdev/net-next/c/137d5672f80f
  - [net-next,7/8] net: ixp4xx_hss: fix the comments style issue
    https://git.kernel.org/netdev/net-next/c/17ce9764bb26
  - [net-next,8/8] net: ixp4xx_hss: add braces {} to all arms of the statement
    https://git.kernel.org/netdev/net-next/c/e0bd276463e8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


