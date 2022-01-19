Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFD84933C5
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 04:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351383AbiASDuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 22:50:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57752 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240579AbiASDuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 22:50:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4854361578;
        Wed, 19 Jan 2022 03:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A2B2CC340E3;
        Wed, 19 Jan 2022 03:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642564209;
        bh=DG/ebJHUYu5veefi7vtpJV/B2/oIE5ZHTz5ziKxm8NQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AGfNrwWzTvZJdwoED62uS7kPvmbqexwXu/7b7uUgeyHnv9cb/refIll5sf9Qr10xr
         fXOa86Cjis7wCj2KZ69CCkrAI7Bt17ljXtrbi3NyjyzWskSdp+ejyykK9RmwlkOabS
         iziKkMEcUEwlZAxHmpqIgoKGFOXq9i9XFI0ZoTzuYByybw1AS9Y1yyNN8YXGxFzN9Z
         dOtnyD2BTTnNahLCl7XYrGu1k3bZL3zgOqh9FvebikQ2e54QzJnSWf8jgMW4hB0ttG
         rjwfyE77M+2GVdhfvtDYSBgEwyhPXalziWnoCVWz9G7AVY5q720dqwWBT/5/2S205G
         7KLn/0hwKfWuw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8A2CCF60795;
        Wed, 19 Jan 2022 03:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf 2022-01-19
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164256420956.29050.17359978453947882108.git-patchwork-notify@kernel.org>
Date:   Wed, 19 Jan 2022 03:50:09 +0000
References: <20220119011825.9082-1-daniel@iogearbox.net>
In-Reply-To: <20220119011825.9082-1-daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        andrii@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 19 Jan 2022 02:18:25 +0100 you wrote:
> Hi David, hi Jakub,
> 
> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 12 non-merge commits during the last 8 day(s) which contain
> a total of 12 files changed, 262 insertions(+), 64 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf 2022-01-19
    https://git.kernel.org/netdev/net/c/99845220d3c3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


