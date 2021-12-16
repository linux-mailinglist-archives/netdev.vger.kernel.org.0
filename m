Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30E52477D1F
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 21:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233785AbhLPUOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 15:14:04 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41332 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbhLPUOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 15:14:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E43861F66
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 20:14:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8B830C36AE7;
        Thu, 16 Dec 2021 20:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639685642;
        bh=mxsEmX+npgfaZnlQ7jYdTglxYn/TxXxEtzX1ifSo1vU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IR4Z0oqmsMpbtbbt1Ajk6jhOcz5/aM9oGaVMOqTsodRGxJon5TlqsyLEDdgqT2125
         bsiZudXtH0h3Uh9Bo1hbbHQsHLG1NrC4x9OlO1lmPW4V2lyCVMsP9kXmsSnh/lEWvB
         c8INfk/wsYltCQzsO45vehzIsTs3IOc0aQMiPjaXx4CFpQMwn8RorKk/c8rTtkLUJk
         CScvuJr4HT7RL+WA4cW/eNUQ7/jmzOYo+27jL7XpTh80Cuts0sOOEA2ICKk9R3HKEj
         QaEEq2AlpSifGn1mf/Z7UiLAHURPb/bh6Vta6cC5eHW3bi499jiuWKTByq97c5+CnZ
         gSJiRB5JyQHeg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 73EB360A49;
        Thu, 16 Dec 2021 20:14:02 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 net-next 0/2] fib: merge nl policies
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163968564246.28952.518699440454005991.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Dec 2021 20:14:02 +0000
References: <20211216120507.3299-1-fw@strlen.de>
In-Reply-To: <20211216120507.3299-1-fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 16 Dec 2021 13:05:05 +0100 you wrote:
> v4: resend with fixed subject line.  I preserved review tags
>     from David Ahern.
> v3: drop first two patches, otherwise unchanged.
> 
> This series merges the different (largely identical) nla policies.
> 
> v2 also squashed the ->suppress() implementation, I've dropped this.
> Problem is that it needs ugly ifdef'ry to avoid build breakage
> with CONFIG_INET=n || IPV6=n.
> 
> [...]

Here is the summary with links:
  - [v4,net-next,1/2] fib: rules: remove duplicated nla policies
    https://git.kernel.org/netdev/net-next/c/92e1bcee067f
  - [v4,net-next,2/2] fib: expand fib_rule_policy
    https://git.kernel.org/netdev/net-next/c/66495f301c69

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


