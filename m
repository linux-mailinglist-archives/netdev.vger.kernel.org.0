Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5404063B792
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 03:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234932AbiK2CAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 21:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233934AbiK2CAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 21:00:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D589745A07;
        Mon, 28 Nov 2022 18:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40DF1B80F79;
        Tue, 29 Nov 2022 02:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F019DC433D6;
        Tue, 29 Nov 2022 02:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669687217;
        bh=5zE8A9pfLlYZ3Fzq+qDG8GSnv+b6JhQEwgy3jiGV/70=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FtM7TpHf7VI+fml1bMlSxNsZY1Lo0ziWvVnuP8QKG2BCjklrq5j2UM4KHSZMsYQLB
         HGn/jyM+JA7hYOTzh93OsirEPeZ+t7wnesH/VpTkL+bffh0An8Q6hBTfncdig6Bf1Q
         lSgrzxqwwNVDpbWdIQ+UsIB5vhA6IqVkELaTorQdLa2qTCmJ8se7h/cQ5BBG19ci5Y
         e7TIOzjOWgHlO6BPt05bHBW11yI1Pu+eOiqSIG/Pool41hUZ8VOeY4/6ToEEB2qd17
         vTGqjUHwojxJPMUgw+AqIY0y2JibmtGgo0PRiLOE7c8xl2TcOXEgOTBRyvBN84C7EV
         GXDZn7F19cCpg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CD64AE21EF7;
        Tue, 29 Nov 2022 02:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf 2022-11-25
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166968721683.10625.9125171857679128256.git-patchwork-notify@kernel.org>
Date:   Tue, 29 Nov 2022 02:00:16 +0000
References: <20221125001034.29473-1-daniel@iogearbox.net>
In-Reply-To: <20221125001034.29473-1-daniel@iogearbox.net>
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

On Fri, 25 Nov 2022 01:10:34 +0100 you wrote:
> Hi David, hi Jakub, hi Paolo, hi Eric,
> 
> Happy Thanksgiving!
> 
> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 10 non-merge commits during the last 8 day(s) which contain
> a total of 7 files changed, 48 insertions(+), 30 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf 2022-11-25
    https://git.kernel.org/netdev/net/c/4f4a5de12539

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


