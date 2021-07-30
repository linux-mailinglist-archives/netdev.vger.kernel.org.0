Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD183DBF50
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 22:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbhG3UAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 16:00:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:57922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230217AbhG3UAK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 16:00:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BDFC360F42;
        Fri, 30 Jul 2021 20:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627675205;
        bh=XXTS4zijAhq9sf6t1Qfbj3TytNSTaEXBMB0Z0im6FAU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eTVStY3Gwl7/L3eDCW/+hRKt2p6RQmGuW/hHNu4lDGQo+V78rZZP5MmC3E12V7wK9
         +HIg/EHFc+jVV2G0FTqin6Jc/WFi1DNGXAGLGAauW5y9duY4zTYAJ2JzMExF0igoSi
         giU3SFb+wzctFeeiCr0xOrSwmm2WqkuSk2M8EQt4Tp53S0MSyud4lr/d+IElqVHbd1
         4FpafjpmLy7FU8NDnDjGxX5f4g7Rzt0/B3nvKjXdUT3BoaVI0ttK7xB3QQgG2jURGE
         S+86YOPQvQvIecJdmQO+fMWHlOaWO7/Fw/4JpAEB7j9Q438R24JLRFrAmS8rjPrpDO
         QPH89ft53gzFA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AEB38609E4;
        Fri, 30 Jul 2021 20:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] sk_buff: avoid potentially clearing 'slow_gro' field
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162767520570.29754.12350600959354612615.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Jul 2021 20:00:05 +0000
References: <aa42529252dc8bb02bd42e8629427040d1058537.1627662501.git.pabeni@redhat.com>
In-Reply-To: <aa42529252dc8bb02bd42e8629427040d1058537.1627662501.git.pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        sd@queasysnail.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 30 Jul 2021 18:30:53 +0200 you wrote:
> If skb_dst_set_noref() is invoked with a NULL dst, the 'slow_gro'
> field is cleared, too. That could lead to wrong behavior if
> the skb later enters the GRO stage.
> 
> Fix the potential issue replacing preserving a non-zero value of
> the 'slow_gro' field.
> 
> [...]

Here is the summary with links:
  - [net-next] sk_buff: avoid potentially clearing 'slow_gro' field
    https://git.kernel.org/netdev/net-next/c/a432934a3067

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


