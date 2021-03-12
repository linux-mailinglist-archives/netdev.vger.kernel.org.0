Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC03D338216
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 01:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbhCLAKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 19:10:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:35068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230516AbhCLAKI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 19:10:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9874064F86;
        Fri, 12 Mar 2021 00:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615507808;
        bh=Y3sk1aioaT2vZPU4+RoV2ntPrdby9FZLhK4jyRPlXZA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t/44NLXednal7UiqXGsBu03lc16XHFOJtJPO23N1XOCqGFQz1FX/N9SVGYTfXtAIW
         hQS2aOvYfvozQLdpq9lf5rN5IVO0rFpZpxpQ77ke2xrSpQzWurdRF7RfDpzrZwaNXr
         kdD09g5a/Wu7IQ8UVJchr+TQUC1Y2SGCI2CSHcp/OpL7Uh3+n/66cTCExsp17s1kDu
         NzD8r3yM60fDNqTgO0Is+7ma54wJFlKa6i3w4qbZMs7OJGTg3Yr+uNZzKKxoLsXlwv
         lD6+PjltN04OnafSm2MJhWA0EM70nyKYwwXLqz+UexQxGM4H4+dBtW0YxkjqrR/CDo
         RCC14H81efTPg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 866FB609E7;
        Fri, 12 Mar 2021 00:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: sock: simplify tw proto registration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161550780854.9767.12432124529018963233.git-patchwork-notify@kernel.org>
Date:   Fri, 12 Mar 2021 00:10:08 +0000
References: <20210311025736.77235-1-xiangxia.m.yue@gmail.com>
In-Reply-To: <20210311025736.77235-1-xiangxia.m.yue@gmail.com>
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     netdev@vger.kernel.org, alexanderduyck@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 11 Mar 2021 10:57:36 +0800 you wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> Introduce the new function tw_prot_init (inspired by
> req_prot_init) to simplify "proto_register" function.
> 
> tw_prot_cleanup will take care of a partially initialized
> timewait_sock_ops.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: sock: simplify tw proto registration
    https://git.kernel.org/netdev/net/c/b80350f39370

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


