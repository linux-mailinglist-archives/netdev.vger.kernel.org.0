Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A157576B5C
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 05:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbiGPDAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 23:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiGPDAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 23:00:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2BD2165B9
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 20:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F495B82F43
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 03:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BADDBC3411E;
        Sat, 16 Jul 2022 03:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657940413;
        bh=JgNEfQqd5zQvL/6VH+ErOmSrSlocUo4AqIHbV9zoBOM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DOXXDifLMPc8AGuxoYkdrLh2nIBTRhTisO4LHEZFh2ASGa9hl8WQ+Lka4O60PQNcp
         sqLxVnCF5N+welFCvAhBEl4WIlLhNmU8qNYqh4QaoWivcyD0VdSeuNjnDgi98gmhbh
         X6RhN1j88NJLnCaz4FPRZU7q+8+adYUoJx6lfe+oZ0XnPMOrWXUqieHbOHMvyZg+K2
         UZs8JmuFphjSoKEe8vfYAQUEKyWzuFxpHt+dHeK1I3qLHc49a4ciEpMHAQy92JJ5Hz
         lV18d/sEURjZM1NhMkj6RmwRNJxEp9kM6r7QfL3xm16MHwyYpYm7cdyWLMb8OpQhNk
         johorCBJtRsEA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 99554E4522F;
        Sat, 16 Jul 2022 03:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 net] tcp/udp: Make early_demux back namespacified.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165794041362.22960.15806075295187695378.git-patchwork-notify@kernel.org>
Date:   Sat, 16 Jul 2022 03:00:13 +0000
References: <20220713175207.7727-1-kuniyu@amazon.com>
In-Reply-To: <20220713175207.7727-1-kuniyu@amazon.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, subashab@codeaurora.org, kuni1840@gmail.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 13 Jul 2022 10:52:07 -0700 you wrote:
> Commit e21145a9871a ("ipv4: namespacify ip_early_demux sysctl knob") made
> it possible to enable/disable early_demux on a per-netns basis.  Then, we
> introduced two knobs, tcp_early_demux and udp_early_demux, to switch it for
> TCP/UDP in commit dddb64bcb346 ("net: Add sysctl to toggle early demux for
> tcp and udp").  However, the .proc_handler() was wrong and actually
> disabled us from changing the behaviour in each netns.
> 
> [...]

Here is the summary with links:
  - [v4,net] tcp/udp: Make early_demux back namespacified.
    https://git.kernel.org/netdev/net/c/11052589cf5c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


