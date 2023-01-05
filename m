Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0928F65E4AC
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 05:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbjAEEaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 23:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjAEEaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 23:30:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD1A3FA08;
        Wed,  4 Jan 2023 20:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E5F46136C;
        Thu,  5 Jan 2023 04:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EDB78C433F0;
        Thu,  5 Jan 2023 04:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672893017;
        bh=3IOK+7TlNiRu0be44W4rbujE94ouea9UsC4MPA4Tn70=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XuJmfj9XRZjslfQgZeOAOm08AKJPyB6BICBVfjZKjcsyHshYzh7jllj5vuJ4JiN9P
         wJqVT2xr90Vz1b8t2lLxKUhTRnY+7jeHWUHhcrt+a0wAYxuIZomvVtqVkrQyj0P5z1
         PRz9Str0HlRSIkF0i7EFnOgixuVeb3RuBoMRsw7ffygQs6rl0dXaDHVadggFSKrNjS
         CqoG1N7ipY1rRM7gGCcXvJBs0iei3k4JrSZk3i0IcarduQvm9aBWhiR9e/FTMOTZyL
         LXyCivmcRKmg9z3Ogh4oTyWYc7MRy9od99Fnzu5CAdR0q6EJpXFotiUdQUBYsjzIDu
         FkmLh7wFAGHQQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CFCC2E5724A;
        Thu,  5 Jan 2023 04:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf-next 2023-01-04
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167289301684.14549.15059636555867324349.git-patchwork-notify@kernel.org>
Date:   Thu, 05 Jan 2023 04:30:16 +0000
References: <20230105000926.31350-1-daniel@iogearbox.net>
In-Reply-To: <20230105000926.31350-1-daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, netdev@vger.kernel.org, bpf@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  5 Jan 2023 01:09:26 +0100 you wrote:
> Hi David, hi Jakub, hi Paolo, hi Eric,
> 
> The following pull-request contains BPF updates for your *net-next* tree.
> 
> We've added 45 non-merge commits during the last 21 day(s) which contain
> a total of 50 files changed, 1454 insertions(+), 375 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf-next 2023-01-04
    https://git.kernel.org/netdev/net/c/49d9601b8187

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


