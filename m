Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA0C63AD251
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 20:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235323AbhFRSmS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 14:42:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:53038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231756AbhFRSmO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 14:42:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1241D613E2;
        Fri, 18 Jun 2021 18:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624041605;
        bh=96/QUeZIvhZBsbi6iS5CCzH6fFpQyEwQzqI2QAcyNNM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IzfBz8XNoTu21NHARdpp4M80vPmngzraqAADTzj4hmV8hQNtP+B+ds4nuUc6udlRL
         neTlosGwdG3NDwKwuxL2GxA2zXNOOd0RrT911S5HNkJHf1kLi3ulSk0sL7WuSUT9ZV
         NM+7zModa5IHAkPWlD8m4yPi2QKgY2EFgNBlus/GcX8Bn4nNBiYsXXBfJlZk4k0760
         zoUy/yQ3K//EhVFeCaqcZ/1rIHv7a40XvcbAR3Dt3t91/Tkd8abtSkmzCyhg9RCe1m
         NXrL7IhZyQ9Usk6MUbtyWh1wfsdD0LLMolpU1IB1jz8fLUV8/jW47jMVFRx/1czUhG
         kF7xYcTWv7VrA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0512560CE2;
        Fri, 18 Jun 2021 18:40:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next v1 0/2] seg6: add support for SRv6 End.DT46 Behavior
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162404160501.23407.2102812799058333171.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Jun 2021 18:40:05 +0000
References: <20210617171645.7970-1-andrea.mayer@uniroma2.it>
In-Reply-To: <20210617171645.7970-1-andrea.mayer@uniroma2.it>
To:     Andrea Mayer <andrea.mayer@uniroma2.it>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, shuah@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        stefano.salsano@uniroma2.it, paolo.lungaroni@uniroma2.it,
        ahabdels.dev@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 17 Jun 2021 19:16:43 +0200 you wrote:
> SRv6 End.DT46 Behavior is defined in the IETF RFC 8986 [1] along with SRv6
> End.DT4 and End.DT6 Behaviors.
> 
> The proposed End.DT46 implementation is meant to support the decapsulation
> of both IPv4 and IPv6 traffic coming from a *single* SRv6 tunnel.
> The SRv6 End.DT46 Behavior greatly simplifies the setup and operations of
> SRv6 VPNs in the Linux kernel.
> 
> [...]

Here is the summary with links:
  - [net-next,v1,1/2] seg6: add support for SRv6 End.DT46 Behavior
    https://git.kernel.org/netdev/net-next/c/8b532109bf88
  - [net-next,v1,2/2] selftests: seg6: add selftest for SRv6 End.DT46 Behavior
    https://git.kernel.org/netdev/net-next/c/03a0b567a03d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


