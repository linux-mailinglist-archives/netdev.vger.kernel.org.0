Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70E4834F5AA
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 03:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbhCaBA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 21:00:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:39536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229662AbhCaBAJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 21:00:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 839526190A;
        Wed, 31 Mar 2021 01:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617152409;
        bh=jksY5EGdStUu5S2Sgot/jObh+BYek+1jXn4XM5BKA6s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=a9lk7MdZNAWBl50ZuOQlAsUAueoFIFZzCD0T5D0e+L23snSkEC9aoVhM0+qW/UMU2
         Qw0t6mBh7TSICxlqEDC3b7tJLy+UF+IGq2kVVGHg05fMRrtDay6QDkS14iF8tnz3Y/
         GuPpACos5OPd516KobgJ4w/Y7k3WMhX1FnPAqGoCfRFnHUnVbPM36F+UI+UCTq2jPm
         ODldJt8fgYOz/tg1RHr+tl9v3evp51UXyhMlucCswEB66ts7PzM1ppl0BD6hoEHb4T
         0mjSIkNTBOzEAH+N9C5czs0HpDJ84pPSg1K61wokTA01Q0MfqhCXwkGm+0DwK+uDDy
         KVwqlk4IppsKA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7818060A6D;
        Wed, 31 Mar 2021 01:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] mlxsw: spectrum_router: Only perform atomic nexthop
 bucket replacement when requested
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161715240948.20410.8592932230770028786.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Mar 2021 01:00:09 +0000
References: <20210330065841.429433-1-idosch@idosch.org>
In-Reply-To: <20210330065841.429433-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, petrm@nvidia.com, colin.king@canonical.com,
        mlxsw@nvidia.com, idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 30 Mar 2021 09:58:41 +0300 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> When cleared, the 'force' parameter in nexthop bucket replacement
> notifications indicates that a driver should try to perform an atomic
> replacement. Meaning, only update the contents of the bucket if it is
> inactive.
> 
> [...]

Here is the summary with links:
  - [net-next] mlxsw: spectrum_router: Only perform atomic nexthop bucket replacement when requested
    https://git.kernel.org/netdev/net-next/c/7866f265b824

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


