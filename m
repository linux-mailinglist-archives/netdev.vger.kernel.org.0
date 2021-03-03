Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5E0432B42A
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352942AbhCCEgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:36:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:45138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347712AbhCCELa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 23:11:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id EFA9264E74;
        Wed,  3 Mar 2021 04:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614744608;
        bh=2iTWY43mTbs048ITXSbGjDL46X2hweHRYNTSKVdsFdA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=L9ZZ9UsCFHKM110kKKJURYQtSn+2RG74W4sg0LiKogk+D3FqC25PK+fIQiVXku0nJ
         WjA4wdrtFxWw5MZdHQ2uWF1XGHby+I1kIQBZfIzuM62I6SNLh9OcW3aiohUUVZgisv
         WwBOW/+qVHHgulNHl+1BISN6Lqxl+pzUiCG+VbNcFesUrs41hCplfGahnEbYw/ES2d
         zzYqE1U+l1NBFDMWWfZuvWmERdB0CPb9bqCcEZ9STEZT84i+JqKGznXRhP1KaPJdio
         ohYl1Q/bZaVirCXRd+4byBU9KMQvYTn41atx7YQXmgVAtEG3FdJgmcgZN3qrrkLHac
         wM8YafxEc/xbQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E0B0D609E2;
        Wed,  3 Mar 2021 04:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next 0/4] devlink: Use utils helpers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161474460791.20759.14044138325168314556.git-patchwork-notify@kernel.org>
Date:   Wed, 03 Mar 2021 04:10:07 +0000
References: <20210301105654.291949-1-parav@nvidia.com>
In-Reply-To: <20210301105654.291949-1-parav@nvidia.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     dsahern@gmail.com, stephen@networkplumber.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to iproute2/iproute2-next.git (refs/heads/main):

On Mon, 1 Mar 2021 12:56:50 +0200 you wrote:
> This series uses utils helper for socket operations, string
> processing and print error messages.
> 
> Patch summary:
> Patch-1 uses utils library helper for string split and string search
> Patch-2 extends library for socket receive operation
> Patch-3 converts devlink to use socket helpers from utlis library
> Patch-4 print error when user provides invalid flavour or state
> 
> [...]

Here is the summary with links:
  - [iproute2-next,1/4] devlink: Use library provided string processing APIs
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=03662000e433
  - [iproute2-next,2/4] utils: Introduce helper routines for generic socket recv
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=e3a4067e5257
  - [iproute2-next,3/4] devlink: Use generic socket helpers from library
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=62ff25e51bb6
  - [iproute2-next,4/4] devlink: Add error print when unknown values specified
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=c54e7bd60547

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


