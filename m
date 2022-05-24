Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40CE1531FDE
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 02:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232201AbiEXAa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 20:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbiEXAaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 20:30:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E829D051;
        Mon, 23 May 2022 17:30:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89F35615BF;
        Tue, 24 May 2022 00:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DAD49C34100;
        Tue, 24 May 2022 00:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653352223;
        bh=WwZx9Z1eEWFyLPzcW6rTHnmzKGkSvgk9o5XVVPMOAsk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=St6o9M3eOytBVLWBBdI0PY1feujO7TUQAks4RLJN2kM+jBWA0eXwkLX1dSxkLFlpe
         cNQIr20sdVfD6je95XV7y7J+lYUTwG/ffvNcdv4ZedpoiwH9A5RG4se6BIsZrsowB+
         z1y4tRqMcz5UAtRPJYo7mjz/dxeRcc1Vog4yaFqWzBV1d+IRlDV1Sdldu0GdQyFjot
         9YoiZnHj/I1KeR0acZrGLdGkcmIjBSSzGnqAGd7bmS+49pUP2e/UXOMv6XsLwM7O6I
         0zYMbedcp+Iz5ZxJzcHrCP88Xq9xhGqRdfZFltEOJ7tcN5vxfIn57mjZ0NPF9cT2uW
         IGdLduFIlTmQw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B9428F03943;
        Tue, 24 May 2022 00:30:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf-next 2022-05-23
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165335222374.8029.12691441777905719219.git-patchwork-notify@kernel.org>
Date:   Tue, 24 May 2022 00:30:23 +0000
References: <20220523223805.27931-1-daniel@iogearbox.net>
In-Reply-To: <20220523223805.27931-1-daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ast@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 24 May 2022 00:38:05 +0200 you wrote:
> Hi David, hi Jakub, hi Paolo, hi Eric,
> 
> The following pull-request contains BPF updates for your *net-next* tree.
> 
> We've added 113 non-merge commits during the last 26 day(s) which contain
> a total of 121 files changed, 7425 insertions(+), 1586 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf-next 2022-05-23
    https://git.kernel.org/netdev/net-next/c/1ef0736c0711

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


