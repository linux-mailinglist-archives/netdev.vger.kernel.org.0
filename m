Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 317D23EC4BB
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 21:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbhHNTag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 15:30:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:44074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229489AbhHNTae (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Aug 2021 15:30:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AA65F60F9F;
        Sat, 14 Aug 2021 19:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628969405;
        bh=34CIw8rTdHGZQQqWjzKu3L/hQZ6AvxI1r7zYiHnEIBc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Jh6gkhkBr+zfvpgzdDs2Grh9U15Ye77iOTxzitOcqgIMY1LYaGAOuhieiOElp2KDy
         uLqMNoXPxs4oPAMUV9pU/ZrE02Ay4VfKlCLaAc/jG+ndCJKIAPtYOCkGoZdU0YJcbg
         oVk2C8/0fp8g8MhRyT56XkhsIc8azL+zpI/4XrwZmSdA5yHcxAFL9m1rlCV9+P6jKg
         zFfBgXXbTSU5SBmb5NC3stP0aOVzlJUAIHXseQXzwwozyQyZytu5zOEen8V5fvD7OD
         WDCRNXbRabSUHwZ+4wVylLkTjxJTPVZTgEqD0dB3+0IE5oj57Bm6XMB2mPpD6VsWG5
         osHVcynbtXd5Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9E21C609AF;
        Sat, 14 Aug 2021 19:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/2] net: Remove the ipx network layer header files 
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162896940564.11276.8513936095062837252.git-patchwork-notify@kernel.org>
Date:   Sat, 14 Aug 2021 19:30:05 +0000
References: <20210813120803.101-1-caihuoqing@baidu.com>
In-Reply-To: <20210813120803.101-1-caihuoqing@baidu.com>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 13 Aug 2021 20:08:01 +0800 you wrote:
> commit <47595e32869f> ("<MAINTAINERS: Mark some staging directories>")
> indicated the ipx network layer as obsolete in Jan 2018,
> updated in the MAINTAINERS file.
> 
> now, after being exposed for 3 years to refactoring, so to
> remove the ipx network layer header files
> 
> [...]

Here is the summary with links:
  - [1/2] net: Remove net/ipx.h and uapi/linux/ipx.h header files
    https://git.kernel.org/netdev/net-next/c/6c9b40844751
  - [2/2] MAINTAINERS: Remove the ipx network layer info
    https://git.kernel.org/netdev/net-next/c/e4637f621203

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


