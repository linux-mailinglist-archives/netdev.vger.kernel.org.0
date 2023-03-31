Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A783B6D2704
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 19:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbjCaRu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 13:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232223AbjCaRuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 13:50:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D443086B5;
        Fri, 31 Mar 2023 10:50:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8FF21B83142;
        Fri, 31 Mar 2023 17:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 46F09C4339B;
        Fri, 31 Mar 2023 17:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680285019;
        bh=Uz+mafsyhUgMVCl7laaaCx29KO0PBd0X4xppgfw/gt8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=o6oQ7T6zzSSfZq2bLncR7ZVpgSgXotORmadL+RAojyH+gfLIT4jiQXmMylI1tKGb1
         1OLHqAiEfr6V/lSnFxUAlNe+Bgqw2072oHtW2P5FiXY2gNLNbdsvglIAnBp0dP2Ts6
         BSZbugwQPMY9q1r65UvMzbmFXKvM85UqorBQUaj/c8BBfQcN6pxhCPsu2w7WWz+H9A
         ukpc5i110GiTB8dkprhsc5yGjmPEF4WXXnB+pKN/IRzkJQgSGu783hAmF/PyLdHWtU
         isQoF1AFqmh194D//3Ya+5XicEwBgUJIzXtk08OvAdx9mlznJDrRO+LAxUgtsLe+9V
         pC5z/IgNP8g+w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1B639C395C3;
        Fri, 31 Mar 2023 17:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] netfilter updates for net-next 2023-03-30
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168028501910.16821.2574990833697528551.git-patchwork-notify@kernel.org>
Date:   Fri, 31 Mar 2023 17:50:19 +0000
References: <20230331104809.2959-1-fw@strlen.de>
In-Reply-To: <20230331104809.2959-1-fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org,
        netfilter-devel@vger.kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 31 Mar 2023 12:48:09 +0200 you wrote:
> Hello,
> 
> This pull request contains changes for the *net-next* tree.
> 
> 1. No need to disable BH in nfnetlink proc handler, freeing happens
>    via call_rcu.
> 2. Expose classid in nfetlink_queue, from Eric Sage.
> 3. Fix nfnetlink message description comments, from Matthieu De Beule.
> 4. Allow removal of offloaded connections via ctnetlink, from Paul Blakey.
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] netfilter updates for net-next 2023-03-30
    https://git.kernel.org/netdev/net-next/c/54fd494af9d4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


