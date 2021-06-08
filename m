Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 113CB3A01B3
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 21:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236931AbhFHSzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 14:55:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:49214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235383AbhFHSvw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 14:51:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 39BDD61490;
        Tue,  8 Jun 2021 18:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623177604;
        bh=kEKnY1HilTeW2SLhc2IcPjpt7/MpLI041RCVw4yeVNk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XVvXVf84PdzMaFBTcCwDmoQqKL/hI2n/mVtPPTnXT0hX/BHhKuuy9Mdaq+bSKA6Px
         FoQ5ABvJsiM+Swoc6sRm9HiBwpORIV8cHIZoS2EQg+mh4kCXWew9YXdGYnyBP7ToMs
         9w/GN3UQ4D4X+AGU1C4rKBNN7KF0EblEgn5vE5oJDPwK5bjDmpza3fwF7Re51s0PVn
         JE3NcOWX4r/hG2bTxTS4VHqzYpVj2Al1ucNpppxdHaE67Ne4qwDbBZeMYrxX3U7wGB
         p2U+p+Lwail/tgKz75H/WW5s7teYlc8lqaBJoae9V9MKGptv+J+9jv1pxttZXQoaC6
         gBFHiwLu0BmVA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2512C609E3;
        Tue,  8 Jun 2021 18:40:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: ipv4: Remove unneed BUG() function
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162317760414.20688.2496488740637270649.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Jun 2021 18:40:04 +0000
References: <20210608015315.3091149-1-zhengyongjun3@huawei.com>
In-Reply-To: <20210608015315.3091149-1-zhengyongjun3@huawei.com>
To:     zhengyongjun <zhengyongjun3@huawei.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 8 Jun 2021 09:53:15 +0800 you wrote:
> When 'nla_parse_nested_deprecated' failed, it's no need to
> BUG() here, return -EINVAL is ok.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  net/ipv4/devinet.c  | 2 +-
>  net/ipv6/addrconf.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [v2] net: ipv4: Remove unneed BUG() function
    https://git.kernel.org/netdev/net/c/5ac6b198d7e3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


