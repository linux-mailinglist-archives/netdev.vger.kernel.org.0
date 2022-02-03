Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89E3E4A87DA
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 16:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238223AbiBCPkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 10:40:10 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37034 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236351AbiBCPkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 10:40:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE83D60A3C;
        Thu,  3 Feb 2022 15:40:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2AE2BC340EF;
        Thu,  3 Feb 2022 15:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643902809;
        bh=Br/3WjvrKdzq3PB9D4aLMn0T+U57lrXHHcW39P5tUts=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JzaMi8sNwqB7QcCbitL7bZA5aBhoTWbXeWZLxc2QNIAgI1ZhEHNvAIK5KfCgjFRWC
         N890u4YcLt71yf2oF+rDJ4f1ReAwRaEZVCWj/caV7drYQ/AVCnQCLEe45Xz/zVBYtr
         DzKbjUokhB4mCpRJeLWK6+EjUFNoo7rPoaWo4lEr8MhBjf9uhrkPDL1cAqmnXu+/XD
         lTFfPT+UE6UiFM+WjULv6GO1vNYOPky8X3pMq73/Pyu9bsSd/+PVzydlbDgxXwYPsl
         zC9EmANEwAzdftzuMkWY7Oo3IxSyQkiK1G/qk4ZzYNKJ6z9PK9iu+DG4O8kV5oC6Jp
         Tw7Cc3ndMvqWw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 10E1FE5D08C;
        Thu,  3 Feb 2022 15:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] tools/resolve_btfids: Do not print any commands when building
 silently
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164390280906.30354.18316430842630830286.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Feb 2022 15:40:09 +0000
References: <20220201212503.731732-1-nathan@kernel.org>
In-Reply-To: <20220201212503.731732-1-nathan@kernel.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Tue,  1 Feb 2022 14:25:04 -0700 you wrote:
> When building with 'make -s', there is some output from resolve_btfids:
> 
> $ make -sj"$(nproc)" oldconfig prepare
>   MKDIR     .../tools/bpf/resolve_btfids/libbpf/
>   MKDIR     .../tools/bpf/resolve_btfids//libsubcmd
>   LINK     resolve_btfids
> 
> [...]

Here is the summary with links:
  - tools/resolve_btfids: Do not print any commands when building silently
    https://git.kernel.org/bpf/bpf/c/7f3bdbc3f131

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


