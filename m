Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 426D73ABC8C
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 21:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233454AbhFQTWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 15:22:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:39558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233257AbhFQTWV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 15:22:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 764BC613F2;
        Thu, 17 Jun 2021 19:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623957613;
        bh=E2bntF6F44DvAygHeG47gcePQ8gG0ZgY5vCsNKyR3Go=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cu7qECth2grYHqy+FAmHok9MoueuDEJLfzkkeLSdTpmYUJUxGmfx9/6rg3I7Hi6tg
         FPU+eOZnJ7oyZAxtKgzKlG8E6eqfOIlemyL5CwHkYvqRRGBVA9nxY5cmK+Cy+kB6Ly
         GUjAN4YjlwRjg02e7fdGJ9sTWebJWzcreJc2FddlsHbtJRrKE83/P21vIfunHgVzuo
         HQ7ET5xn9uyMr3N74cQwj/+RXNaSGHEC8WWkWmPVX56XZqlEG6PccN0Myt2z1TwWj1
         dFCJtl1QeSr0vCv/QyAF3zVIc5zJICTcRppiuy1uHdfm7zfygEUzSH9/aGMIFXDS5f
         BP54KIauLc/3g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6950B60CDF;
        Thu, 17 Jun 2021 19:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 net-next 0/6] net: hdlc_ppp: clean up some code style
 issues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162395761342.22568.14868119603155254215.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Jun 2021 19:20:13 +0000
References: <1623938599-25981-1-git-send-email-huangguangbin2@huawei.com>
In-Reply-To: <1623938599-25981-1-git-send-email-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, xie.he.0141@gmail.com,
        ms@dev.tdt.de, willemb@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 17 Jun 2021 22:03:13 +0800 you wrote:
> This patchset clean up some code style issues.
> 
> ---
> Change Log：
> V1 -> V2:
> 1. remove patch "net: hdlc_ppp: fix the comments style issue" and
> patch "net: hdlc_ppp: remove redundant spaces" from this patchset.
> 
> [...]

Here is the summary with links:
  - [V2,net-next,1/6] net: hdlc_ppp: remove redundant blank lines
    https://git.kernel.org/netdev/net-next/c/f271606f5289
  - [V2,net-next,2/6] net: hdlc_ppp: add blank line after declarations
    https://git.kernel.org/netdev/net-next/c/2b57681f94af
  - [V2,net-next,3/6] net: hdlc_ppp: fix the code style issue about "foo* bar"
    https://git.kernel.org/netdev/net-next/c/cb36c4112c52
  - [V2,net-next,4/6] net: hdlc_ppp: move out assignment in if condition
    https://git.kernel.org/netdev/net-next/c/4ec479527b9a
  - [V2,net-next,5/6] net: hdlc_ppp: remove unnecessary out of memory message
    https://git.kernel.org/netdev/net-next/c/ee58a3c7c6bb
  - [V2,net-next,6/6] net: hdlc_ppp: add required space
    https://git.kernel.org/netdev/net-next/c/37cb4b9ce062

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


