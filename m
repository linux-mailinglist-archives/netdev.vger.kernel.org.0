Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 260D26BC5A4
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 06:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbjCPFaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 01:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjCPFaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 01:30:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E28191ACE8
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 22:30:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75C9F61E4A
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 05:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BC0EAC4339B;
        Thu, 16 Mar 2023 05:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678944618;
        bh=BBuwxrba+qYFu1cJkgRqJ50eqcLqJhyeqGx/Xs29MIc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AmNFTsceKx4siHBbj0AE5ZamCevWd0mvzXYTHtjpehIUBMPq+TAQtCKmWoppMiwZ0
         bw/WYOV7I4l0Zd7WYb3b/SDGLPo2BmPZC7Wcsz3oNeM07CIqqx9UKnN86eHoTPgkHT
         i+FQkQ2AvWcMf4/VwLpFnrK537Rb+qZqPi21dLVFaTwjCQ93uHACcWo5UVFHo+SC+u
         ouFyqrXo5mPOL8X63H9GLrjPZU5+ltgjO3u3V2eygRZuwm6HSji/ubZ2vqVUlfy3+q
         RWCEg8jtofcIuP2i8PeR6ZXNZ0DJPmja7kLGkbY+/fFwpT3iidYbjk0cMTCQ+Bfeht
         r8rcfSo8qKMzQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A2065E66CBF;
        Thu, 16 Mar 2023 05:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] nfp: flower: add support for multi-zone
 conntrack
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167894461866.21360.10731960012700531249.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Mar 2023 05:30:18 +0000
References: <20230314063610.10544-1-louis.peens@corigine.com>
In-Reply-To: <20230314063610.10544-1-louis.peens@corigine.com>
To:     Louis Peens <louis.peens@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        simon.horman@corigine.com, netdev@vger.kernel.org,
        oss-drivers@corigine.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 14 Mar 2023 08:36:04 +0200 you wrote:
> This series add changes to support offload of connection tracking across
> multiple zones. Previously the driver only supported offloading of a
> single goto_chain, spanning a single zone. This was implemented by
> merging a pre_ct rule, post_ct rule and the nft rule. This series
> provides updates to let the original post_ct rule act as the new pre_ct
> rule for a next set of merges if it contains another goto and
> conntrack action. In pseudo-tc rule format this adds support for:
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] nfp: flower: add get_flow_act_ct() for ct action
    https://git.kernel.org/netdev/net-next/c/8a8db7aeaa6d
  - [net-next,2/6] nfp: flower: refactor function "is_pre_ct_flow"
    https://git.kernel.org/netdev/net-next/c/cee7b339d806
  - [net-next,3/6] nfp: flower: refactor function "is_post_ct_flow"
    https://git.kernel.org/netdev/net-next/c/0b8d953cce26
  - [net-next,4/6] nfp: flower: add goto_chain_index for ct entry
    https://git.kernel.org/netdev/net-next/c/3e44d19934b9
  - [net-next,5/6] nfp: flower: prepare for parameterisation of number of offload rules
    https://git.kernel.org/netdev/net-next/c/46a83c85b683
  - [net-next,6/6] nfp: flower: offload tc flows of multiple conntrack zones
    https://git.kernel.org/netdev/net-next/c/a87ceb3d42af

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


