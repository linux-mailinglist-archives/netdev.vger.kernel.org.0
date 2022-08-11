Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF11F58F775
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 08:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233988AbiHKGKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 02:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiHKGKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 02:10:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6662CF0;
        Wed, 10 Aug 2022 23:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42D156144E;
        Thu, 11 Aug 2022 06:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9CEF9C433B5;
        Thu, 11 Aug 2022 06:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660198214;
        bh=4gQh8wznAexw574YOy/yK6wwW/AJAKqhkjWFzBlDLMU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GG/MWpG/VC2i+oksVm4Rw4k7RsEQEXQhf5n8RWrhuJDYGngx64zVmRDpbRIVuQNAT
         6bTnyqS9tbiVT4/KjvY3yvckP0vv8pHLJu9vZPMxjQIRVJXWzNNcgphliDgxKdCqsm
         NUh+3CkSi1BZEabeaikpW2mdfm4Re86SzOrlRMAY05zi+lQHAw70/wqlaii3vmfWzh
         YbzYnnbX/4UflZTtSfY8D2o0HO9fRN2GnmoBMKg/2hV0qlS43QHa9S85C9l4/8AJTP
         IL7vElYhcR10gQfJ3nuyX8X4f+CDnfPYjE5eK8CZEwdAydWOwEFe3Czv0Rnm3wk+53
         lWFKQERY5qm8w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 84034C43142;
        Thu, 11 Aug 2022 06:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net_sched: cls_route: remove from list when handle is 0
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166019821453.2125.16900691983468288417.git-patchwork-notify@kernel.org>
Date:   Thu, 11 Aug 2022 06:10:14 +0000
References: <20220809170518.164662-1-cascardo@canonical.com>
In-Reply-To: <20220809170518.164662-1-cascardo@canonical.com>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, zplin@u.northwestern.edu, kamal@canonical.com,
        stable@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  9 Aug 2022 14:05:18 -0300 you wrote:
> When a route filter is replaced and the old filter has a 0 handle, the old
> one won't be removed from the hashtable, while it will still be freed.
> 
> The test was there since before commit 1109c00547fc ("net: sched: RCU
> cls_route"), when a new filter was not allocated when there was an old one.
> The old filter was reused and the reinserting would only be necessary if an
> old filter was replaced. That was still wrong for the same case where the
> old handle was 0.
> 
> [...]

Here is the summary with links:
  - net_sched: cls_route: remove from list when handle is 0
    https://git.kernel.org/netdev/net/c/9ad36309e271

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


