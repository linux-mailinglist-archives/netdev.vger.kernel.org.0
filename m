Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5C634F538
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 02:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbhCaAAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 20:00:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:39938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232126AbhCaAAJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 20:00:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7B9EE619C0;
        Wed, 31 Mar 2021 00:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617148809;
        bh=OoLnCuZVgOiP83S43AZ1sHcGPSTXyI8TrGz3qNR1n0Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=V3vXA98HoOCAUmCULDNF9/I+vSvpfCkokZtp95pKp+Nv2tHYo0eYiwRMV7jCwHfqU
         q/XOC/5fL5+jC6zyFi4Cya1uvnC7qq0q2M2H3cP43nWn0NDotRPtygIRFzkw6cmNHZ
         Z10JgIP/OHpmaK+BLtFg4KH18LzXIDG/iZXroXAeYthNcj8/XbkuoQSdAsbq1yXxLr
         j1yqe5M9vXghwnTg64uRjmndBjq4NWdHNdQ1vp6x+3Dp7BAeaLt9szzSkfV9nbIGDc
         sy6Y/JZ0bdTGb6IHl3r+hAdSliJB6DUC5jJviWyXQ0h0soN27YbbaBgc4N6gMMaDqO
         7vVRM/Wjl6QfQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6E65860A56;
        Wed, 31 Mar 2021 00:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] nfp: flower: ignore duplicate merge hints from FW
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161714880944.29090.1403816099790593956.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Mar 2021 00:00:09 +0000
References: <20210330083023.32495-1-simon.horman@netronome.com>
In-Reply-To: <20210330083023.32495-1-simon.horman@netronome.com>
To:     Simon Horman <simon.horman@netronome.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, yinjun.zhang@corigine.com,
        louis.peens@corigine.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 30 Mar 2021 10:30:23 +0200 you wrote:
> From: Yinjun Zhang <yinjun.zhang@corigine.com>
> 
> A merge hint message needs some time to process before the merged
> flow actually reaches the firmware, during which we may get duplicate
> merge hints if there're more than one packet that hit the pre-merged
> flow. And processing duplicate merge hints will cost extra host_ctx's
> which are a limited resource.
> 
> [...]

Here is the summary with links:
  - [net] nfp: flower: ignore duplicate merge hints from FW
    https://git.kernel.org/netdev/net/c/2ea538dbee1c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


