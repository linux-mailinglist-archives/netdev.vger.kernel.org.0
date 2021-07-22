Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5BE3D20E5
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 11:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbhGVIth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 04:49:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:38056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231401AbhGVItg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 04:49:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E80D561222;
        Thu, 22 Jul 2021 09:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626946206;
        bh=v01HdLdKCrfVTBNVxn1zyEN2xp0NOUsk4fVa6Eyoc4c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iF1ykeFvHZ0K1nhfYKvPOoT2WeAs1EAJjmZBigCyH2Xobsbxb8jEQWG65fE1UlSUt
         l7z/bWDvD/XO3QpjnpoZcROXGGL5TuDzuaDwhXUhceXzaR8VgRuulGBvJNh3e4ZyYK
         cQjsRdQF3PyGQf78rJYowteT/Wh5RGNjqCHT0pSomzzwHV9d6MDw66o3Z7fIiXKBrQ
         Z0xRGiyCysdiC4wOzS2cjka/JwBRDco5tzStd5nJHCDre7AVFwu+WJLHIjD5Z6yA1V
         fPFSCLBprfzZBzCTIN3PyBq7y1I/0cAzFsMpUS3ZBAtQNjeOCXTDEsF0bd+Da7cUBu
         WPO/XMsn0FirA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DCA93609AC;
        Thu, 22 Jul 2021 09:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ipv6: fix "'ioam6_if_id_max' defined but not used"
 warn
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162694620589.16207.11142546463619255575.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Jul 2021 09:30:05 +0000
References: <20210722075504.1793321-1-matthieu.baerts@tessares.net>
In-Reply-To: <20210722075504.1793321-1-matthieu.baerts@tessares.net>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, justin.iurman@uliege.be, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 22 Jul 2021 09:55:04 +0200 you wrote:
> When compiling without CONFIG_SYSCTL, this warning appears:
> 
>   net/ipv6/addrconf.c:99:12: error: 'ioam6_if_id_max' defined but not used [-Werror=unused-variable]
>      99 | static u32 ioam6_if_id_max = U16_MAX;
>         |            ^~~~~~~~~~~~~~~
>   cc1: all warnings being treated as errors
> 
> [...]

Here is the summary with links:
  - [net-next] ipv6: fix "'ioam6_if_id_max' defined but not used" warn
    https://git.kernel.org/netdev/net-next/c/176f716cb72f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


