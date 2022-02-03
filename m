Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2307F4A905D
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 23:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355628AbiBCWAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 17:00:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47000 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355624AbiBCWAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 17:00:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E13B9B835CD;
        Thu,  3 Feb 2022 22:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BAC23C340EF;
        Thu,  3 Feb 2022 22:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643925610;
        bh=1rkoyXl0TX+flY23ZfVhoH6T8eO5nqRM9yJ+4BlPp1A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YiUFA61g80eyQitmKfdOQ0IKz+6orhcVXCU8iqA46GBHX/LFDLKMqMnlNdwCigiGl
         A/Zi5x7H6WAgkBZDuFcum6m+XWhYQLCgXnmsKKFILJD8/dRRA4/lBA9lfYvGbfYZcp
         rAj9d9i2k54SqSU7hBaAaRYuLy9hEgM8AwXL5wj2e4xWdZotmLQAiFC+VMjGDzbQYT
         y3/67HUxPDxc7mcjub7JvxZpN8J1HC79sEaU/wBmAaE/SC9Co7Ceyzngl9spMKafDE
         panqykpZTfpUTCi3eGokgJjm/lJofs1qCWYApJVC/4CDVv9k/3xfOZJMlNM0x/zW5h
         dHZ6PaarlCY3g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A3D56E5D08C;
        Thu,  3 Feb 2022 22:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf 2022-02-03
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164392561066.25807.1627541754798663535.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Feb 2022 22:00:10 +0000
References: <20220203155815.25689-1-daniel@iogearbox.net>
In-Reply-To: <20220203155815.25689-1-daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        andrii.nakryiko@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  3 Feb 2022 16:58:15 +0100 you wrote:
> Hi David, hi Jakub,
> 
> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 6 non-merge commits during the last 10 day(s) which contain
> a total of 7 files changed, 11 insertions(+), 236 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf 2022-02-03
    https://git.kernel.org/netdev/net/c/77b1b8b43ec3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


