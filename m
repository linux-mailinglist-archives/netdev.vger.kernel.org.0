Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFD13B9629
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 20:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232859AbhGAScf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 14:32:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:40128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229894AbhGASce (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Jul 2021 14:32:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 18B2561405;
        Thu,  1 Jul 2021 18:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625164204;
        bh=GihiRSbccHSR4LmYVwQDKPEnx2x4PtODwIrG+6Xdw0Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pnNK2MQcV3kl4l3R6/PCxDMwtwi3KelAfnnwp5uQjrKIA/XQUs1vY/dHYSxVhNEvW
         cjPEZVd2ncwuIf998UMemDjoczk1BTe05pYFy5hV/eGmd6c0vwdlE4KJG1jbKG+Tc4
         L2jhJW8tvmagR9JmRiIw4M/MnZ43BXQZFZciBZyk2DXS/TCLQeNUWjFKwzP1XV6EjH
         0ODlzVVczVVhdqFePm9DxzB5AUMCopiYwaJwH/rxAdPtspKzVRsrhyVw/Uu/OTdL2h
         GVtWQcGoX22VCmoBUv9FloCQP+GmZpEc+WDeDJpsKQdmulh5GGqpe1gM3RMoN8O8/D
         FuhXeWjaf7EcA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0D14A609F7;
        Thu,  1 Jul 2021 18:30:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: annotate data race around sk_ll_usec
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162516420404.17332.15046751218544947451.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Jul 2021 18:30:04 +0000
References: <20210629141245.1278533-1-eric.dumazet@gmail.com>
In-Reply-To: <20210629141245.1278533-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 29 Jun 2021 07:12:45 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> sk_ll_usec is read locklessly from sk_can_busy_loop()
> while another thread can change its value in sock_setsockopt()
> 
> This is correct but needs annotations.
> 
> [...]

Here is the summary with links:
  - [net] net: annotate data race around sk_ll_usec
    https://git.kernel.org/netdev/net/c/0dbffbb5335a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


