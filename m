Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63470334954
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 22:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233005AbhCJVAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 16:00:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:32800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231911AbhCJVAN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 16:00:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 1DA8B64FD0;
        Wed, 10 Mar 2021 21:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615410013;
        bh=HtJPighkxzhTi5SUiW2p+tXG2qjnfpO48Oh0cNOkQc4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MF8A6tRfTj6Hj31AionaUju3jtjCrbTPa/Co5yc5ma+CppYq9Q4HuRVBU356fTEbl
         tn+9jrz1CWFTjwif3OlWyI24qdJ2nRFD46oPUEubUuCiLJSjmEH8Gm3W4sfyLIWzc8
         ZQVkv2AonfgxOj2DaLAZasg+F70zZD+Hd3mKGqsWJ5kiz6D1kpgN2M5hpORuEdNoYR
         vVhhW0hOFnqq1+BMmYciR795HU4isrcRT6nrjPoDcmeGdh7D4ygwPhGqW4nFz4A40I
         l8hK05dHryz9uHO+qyrHA77k7w5WjLAms9V43LGjnCvVDB8q78Wz5jrnJK7B0oa5RN
         H0D5MyN+twm/Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0DD46609B8;
        Wed, 10 Mar 2021 21:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ipv6: route.c:fix indentation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161541001305.4631.16788593573945667819.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Mar 2021 21:00:13 +0000
References: <20210310203314.wk6zjxyo6ax5chbd@kewl-virtual-machine>
In-Reply-To: <20210310203314.wk6zjxyo6ax5chbd@kewl-virtual-machine>
To:     Shubhankar Kuranagatti <shubhankarvk@gmail.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, bpf@vger.kernel.org,
        dsahern@kernel.org, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, bkkarthik@pesu.pes.edu, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 11 Mar 2021 02:03:14 +0530 you wrote:
> The series of space has been replaced by tab space
> wherever required.
> 
> Signed-off-by: Shubhankar Kuranagatti <shubhankarvk@gmail.com>
> ---
>  net/ipv6/route.c | 26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)

Here is the summary with links:
  - net: ipv6: route.c:fix indentation
    https://git.kernel.org/netdev/net-next/c/13fdb9403d9e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


