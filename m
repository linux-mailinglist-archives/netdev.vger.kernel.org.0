Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFB53E3C20
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 20:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbhHHSAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 14:00:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:58694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230049AbhHHSAZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Aug 2021 14:00:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 07C4560F9E;
        Sun,  8 Aug 2021 18:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628445606;
        bh=JQ4dY3VeQ5kfsKbia4N0EjyLHtabGDSf2o8kNYPP5tY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LZbylYujoBcFqNn3x81OTFhl1PPNt9AQSwLcsNTEpZO1iwavR/gPj5Sf8Hky41eQ3
         ZTt7zT+KSZbl6/dX+nl4nsDY073Wh4JQbcaz/Kc7ZseuH4R2WVKnpVxPx0gv4xch/B
         Ns0vN48W8fqUSVgIJa+ZH6KsiDvzK8QU+I28ghvvfHs+c9TelfUqgLZBLYvr3VGADC
         OaSiTkbABQs+ElXTvFTdPSFJLzYJ0YIMKTMPD314ISX6kjoOMKpt62MmGXyCYhJqB6
         bhk2e03aElGdPi2dITwpgdLjd2/TbBdmRdhOS9lQU2jhiTD3F7pYgwy09dQiAx3aYz
         /rVBzSS26J7bA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EE63460726;
        Sun,  8 Aug 2021 18:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next v3] tc/skbmod: Introduce SKBMOD_F_ECN option
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162844560597.17197.6311898547712916123.git-patchwork-notify@kernel.org>
Date:   Sun, 08 Aug 2021 18:00:05 +0000
References: <20210804181516.11921-1-yepeilin.cs@gmail.com>
In-Reply-To: <20210804181516.11921-1-yepeilin.cs@gmail.com>
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        cong.wang@bytedance.com, peilin.ye@bytedance.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2-next.git (refs/heads/main):

On Wed,  4 Aug 2021 11:15:16 -0700 you wrote:
> From: Peilin Ye <peilin.ye@bytedance.com>
> 
> Recently we added SKBMOD_F_ECN option support to the kernel; support it in
> the tc-skbmod(8) front end, and update its man page accordingly.
> 
> The 2 least significant bits of the Traffic Class field in IPv4 and IPv6
> headers are used to represent different ECN states [1]:
> 
> [...]

Here is the summary with links:
  - [iproute2-next,v3] tc/skbmod: Introduce SKBMOD_F_ECN option
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=e78411948dc7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


