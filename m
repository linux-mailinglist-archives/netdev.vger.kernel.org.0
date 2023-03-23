Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32D546C740F
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 00:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbjCWXgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 19:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbjCWXgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 19:36:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A631A241E3;
        Thu, 23 Mar 2023 16:36:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40082B8229F;
        Thu, 23 Mar 2023 23:36:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DE535C433D2;
        Thu, 23 Mar 2023 23:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679614561;
        bh=Am8M97vwZh11u6tbk3dsmDenbosqisOkpHc2ErBtE6Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mIv8B7G8q3laeVrr0l9MGJ6vCSdS9OrXJi4xxpSZYsRr3F4JyRwlvJVDqlutnPHUm
         ixd0v/FwXZezERtUT4Od8MVPWPNHdCRriPPg4y73ZjoWP25gajU4qWcKsa/fwHeX4S
         QCKmt2xlPFdQ/MiuwOk4/4rJAjnjoZcgwTZ3Jl56LRh3FJMrE838GO6QKvH06P4TXy
         nFBzAGwKK4gEYMlNRxkNSXHvAbtANHf/E2gEYpN52a+mCvBZt8bChKn0MYhnG1KNMP
         zGwtNMfbmTWviB+mHVjqQvbSJCV0ZgnfZVfwWIN9tUa7VyqXxn9uSB/CA1TeFx8FKs
         zb33r2xEhvURw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CCB01E61B85;
        Thu, 23 Mar 2023 23:36:01 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf 2023-03-23
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167961456183.10917.11553657218961185651.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Mar 2023 23:36:01 +0000
References: <20230323225221.6082-1-daniel@iogearbox.net>
In-Reply-To: <20230323225221.6082-1-daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, netdev@vger.kernel.org, bpf@vger.kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 23 Mar 2023 23:52:21 +0100 you wrote:
> Hi David, hi Jakub, hi Paolo, hi Eric,
> 
> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 8 non-merge commits during the last 13 day(s) which contain
> a total of 21 files changed, 238 insertions(+), 161 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf 2023-03-23
    https://git.kernel.org/netdev/net/c/1b4ae19e432d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


