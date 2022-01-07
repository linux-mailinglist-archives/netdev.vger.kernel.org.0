Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB76148709B
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 03:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345477AbiAGCkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 21:40:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40914 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345510AbiAGCkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 21:40:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C754161EC0;
        Fri,  7 Jan 2022 02:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 36306C36AE3;
        Fri,  7 Jan 2022 02:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641523213;
        bh=OCjOuulB7Vk7zMdgiPKl0MK+CpBj52TytPnoRbBc+00=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=k4lCnnBuzQZUxfjRPWMgA8PpsFoGNunyumf2wBNiapbj/0PTGs7HEqvvKHojrIe5L
         +7ZEEBLcLuCHubIaz1Sepaj6NE/h9otGjY8RSy346DjhY9SDtNmn5+n/BImLWo76kr
         +f4n/dwvlXBKpQrZ1y8lcZwUKyUmaeUBTZWaPhVKGHqCp5mLEPSCdQaaza6H4mpgNR
         JTUnpEBQcFtlDchtplRWbJPFGt2idxffF4I5ta+eyj0T05tPNAyHipsA+7EgYXIFXB
         OrD8J2PB/ZkzhS9C1hxTviI/LyOr5eLdGjqelhkZO/hm3sfiUvfxqWRY6T2u6Ptmnf
         OauNSS+d3Mdjw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1C43BF79408;
        Fri,  7 Jan 2022 02:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf-next 2022-01-06
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164152321311.5032.9355955440972993212.git-patchwork-notify@kernel.org>
Date:   Fri, 07 Jan 2022 02:40:13 +0000
References: <20220107013626.53943-1-alexei.starovoitov@gmail.com>
In-Reply-To: <20220107013626.53943-1-alexei.starovoitov@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, kuba@kernel.org,
        andrii@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  6 Jan 2022 17:36:26 -0800 you wrote:
> Hi David, hi Jakub,
> 
> The following pull-request contains BPF updates for your *net-next* tree.
> 
> We've added 41 non-merge commits during the last 2 day(s) which contain
> a total of 36 files changed, 1214 insertions(+), 368 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf-next 2022-01-06
    https://git.kernel.org/netdev/net-next/c/257367c0c9d8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


