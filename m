Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2056493BDB
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 15:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355114AbiASOUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 09:20:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34114 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355034AbiASOUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 09:20:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59A4C61325;
        Wed, 19 Jan 2022 14:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B84C8C36AE3;
        Wed, 19 Jan 2022 14:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642602010;
        bh=YG4wGVWRyWi+fWpJAklFNv/bYqksOn14JwbalX/xzTs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CQaJ+GN0diUlGnTZddXqMEe7PehfdSSy1IsFyNNlmQwkhixDeNVtnpfVhwdoCnMgx
         K6cIf+lvKtmFBxIxWrr3s9ZixkNwhyV6z+LEYbUEYZyQBFAXtA6Q/A79PVoc72bONJ
         Dh8b9xn5kIEwwtOrTys17BcPUlcgy+Aj0KZJrrt41rb2lJpoAUMkPHzhNunB+LVCX5
         wRXGLbC2kIgHKb+HN0o9h7wRd56K1v585xRWp5OdDz1iGAqLe2Ie5OwDAYvVp3Hg92
         Jb/o2ReoHHTeHTPN1dpzB6bPCnlROdA2BdMBliM3/h+rNZm0422EKdcot4pte4XV+1
         fFeyY4f3ic15w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 95CF4F6079C;
        Wed, 19 Jan 2022 14:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 0/1] nfc: llcp: a fix after syzbot report
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164260201060.5270.11254904971363048637.git-patchwork-notify@kernel.org>
Date:   Wed, 19 Jan 2022 14:20:10 +0000
References: <20220119074816.6505-1-krzysztof.kozlowski@canonical.com>
In-Reply-To: <20220119074816.6505-1-krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 19 Jan 2022 08:48:15 +0100 you wrote:
> Hi,
> 
> Syzbot reported an easily reproducible NULL pointer dereference which I was
> struggling to analyze:
> https://syzkaller.appspot.com/bug?extid=7f23bcddf626e0593a39
> 
> Although direct fix is obvious, I could not actually find the exact race
> condition scenario leading to it.  The patch fixes the issue - at least under
> my QEMU - however all this code looks racy, so I have a feeling I am plumbing
> one leak without fixing root cause.
> 
> [...]

Here is the summary with links:
  - [v2,1/1] nfc: llcp: fix NULL error pointer dereference on sendmsg() after failed bind()
    https://git.kernel.org/netdev/net/c/dded08927ca3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


