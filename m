Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60E594E4955
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 23:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiCVWv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 18:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbiCVWv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 18:51:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B0365DA5E;
        Tue, 22 Mar 2022 15:50:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8903560F76;
        Tue, 22 Mar 2022 22:50:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D91DFC340F2;
        Tue, 22 Mar 2022 22:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647989426;
        bh=FFKP6nY5FeetNs2/Moob5TkdE8pyS6iLSMf135q2HJc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KPfmW0b7VuxIvri2aGnCqEvFhTRJ+IyNWHq09z0Ls3gFifvuWgDWUb2KH4s4ZGEBM
         oYn/LB1z8ZqiecChKlGbkpbH4EHQXfqnkO4Clrwx4zLSIYfxV8nQkw4gkzVIzoRUut
         b4/YFDbIKTQ/HIf+obcdQaI63vbgOe0eoCGPq/ALqTj1QlKT8okOQGQMe+4jAxP9kw
         HQwshC72Foi19zbDdrpyz01AN1+Gey60H0Im+p1GA1lvWB0MairGIrqJtGJ4s7BJ+O
         f4XWmvYNhnv1v8uVo0jqQ2Wbu383BGxMEPD7HUBadjuJc9wmbXOK2pg+/BC/h7xSpz
         eeKL9ADchBv4g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BD7D3EAC081;
        Tue, 22 Mar 2022 22:50:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf-next 2022-03-21 v2
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164798942677.23339.9509425257963920048.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Mar 2022 22:50:26 +0000
References: <20220322050159.5507-1-alexei.starovoitov@gmail.com>
In-Reply-To: <20220322050159.5507-1-alexei.starovoitov@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, peterz@infradead.org,
        rostedt@goodmis.org, mhiramat@kernel.org, kuba@kernel.org,
        andrii@kernel.org, torvalds@linux-foundation.org,
        sfr@canb.auug.org.au, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 21 Mar 2022 22:01:59 -0700 you wrote:
> Hi David, hi Jakub,
> 
> The following pull-request contains BPF updates for your *net-next* tree.
> 
> We've added 137 non-merge commits during the last 17 day(s) which contain
> a total of 143 files changed, 7123 insertions(+), 1092 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf-next 2022-03-21 v2
    https://git.kernel.org/netdev/net-next/c/0db8640df595

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


