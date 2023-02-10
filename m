Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1CD06918B7
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 07:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbjBJGu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 01:50:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbjBJGuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 01:50:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2701742BE3;
        Thu,  9 Feb 2023 22:50:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67FF3B823E4;
        Fri, 10 Feb 2023 06:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 12788C433EF;
        Fri, 10 Feb 2023 06:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676011819;
        bh=w3l+Js+IQqMfuMoZw9WUKPk+6ckNTGeS4ZfAKc7Y0y8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=i6gq45IP4zzIAJaE8cDiPAAff8sOhpO3UluhE/nzf14+l8NtICxPv6qA04X/X26L/
         nmOnzytMc+l5a+8Lp8p8fctbzydSQ9/GB9YHDxW9M/Ys/oErHQT7uhMWV971tvKfYd
         UMnlBzoRwuzPPekxg3jA3kpdr73msIfLWThzP2l/PjHQKB2WQ4GV4npjNKO9I173Wa
         reD1jh4cHeyTxHBSiQPf5gJyr5i7a0SM0DxjJOjqwksxy578zW+E+j24MMtH2Fd++Y
         QrlsI1Bp7W1TGyrPaJkympAWf8hmp6Oxh7/1NrCwSDEmTKvn6gdRS0P/w1pvOmS27h
         a7CI1ww+d/Svg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E89CAE21EC7;
        Fri, 10 Feb 2023 06:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 1/3] string_helpers: Move string_is_valid() to the
 header
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167601181893.8112.12222841816980758259.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Feb 2023 06:50:18 +0000
References: <20230208133153.22528-1-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20230208133153.22528-1-andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     kuba@kernel.org, lucien.xin@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        dev@openvswitch.org, tipc-discussion@lists.sourceforge.net,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        pshelar@ovn.org, jmaloy@redhat.com, ying.xue@windriver.com,
        simon.horman@corigine.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  8 Feb 2023 15:31:51 +0200 you wrote:
> Move string_is_valid() to the header for wider use.
> 
> While at it, rename to string_is_terminated() to be
> precise about its semantics.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/3] string_helpers: Move string_is_valid() to the header
    https://git.kernel.org/netdev/net-next/c/f1db99c07b4f
  - [net-next,v3,2/3] genetlink: Use string_is_terminated() helper
    https://git.kernel.org/netdev/net-next/c/d4545bf9c33b
  - [net-next,v3,3/3] openvswitch: Use string_is_terminated() helper
    https://git.kernel.org/netdev/net-next/c/5c72b4c644eb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


