Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86200561AD8
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 15:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234428AbiF3NAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 09:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232428AbiF3NAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 09:00:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A208E40A15
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 06:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6DFDDB82A7D
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 13:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0B7B8C3411E;
        Thu, 30 Jun 2022 13:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656594015;
        bh=KqA3PRzRtNZhw9rkXaDiMiuH2/lWVJBQmBD50dyRETo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=o8Pk9aMw+ksBFHAqGooJXwLCcq1eclGXNJ43F9uvgKA16LOrtWHRMsQ4ra3jcdOUS
         GIGhS/n0wcSaMJPZfl5/j6k+R9vox+j/zOkLMhR2+IFYqpek/V+GNSwH69dKrpkIKJ
         Lrg9cfQANakjOK9xsmZeXjEQw3HRIvKBtjj1JZjRKfD9VfHhspEyd0QTWpdjtqa6Go
         vb3stlVTMR4m91X2iLJAV8F2gzkhypmuzet+l7xBBgamj3NNE+qI0EaEbnEYkwPuRj
         hX8T1xzMeH92gq6ACIsAUz2YrFFs3neZ5Vu+7P21+xaYH+evaO4vYxc96+tjQ5t4nL
         jiW++vNqxuRCg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E1F37E49BBB;
        Thu, 30 Jun 2022 13:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/2] net,
 neigh: introduce interval_probe_time for periodic probe
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165659401492.28302.4804695148436142310.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Jun 2022 13:00:14 +0000
References: <20220629084832.2842973-1-wangyuweihx@gmail.com>
In-Reply-To: <20220629084832.2842973-1-wangyuweihx@gmail.com>
To:     Yuwei Wang <wangyuweihx@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, daniel@iogearbox.net, roopa@nvidia.com,
        dsahern@kernel.org, qindi@staff.weibo.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 29 Jun 2022 08:48:30 +0000 you wrote:
> This series adds a new option `interval_probe_time_ms` in net, neigh
> for periodic probe, and add a limitation to prevent it set to 0
> 
> Yuwei Wang (2):
>   sysctl: add proc_dointvec_ms_jiffies_minmax
>   net, neigh: introduce interval_probe_time_ms for periodic probe
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/2] sysctl: add proc_dointvec_ms_jiffies_minmax
    https://git.kernel.org/netdev/net-next/c/c381d02b2fd5
  - [net-next,v4,2/2] net, neigh: introduce interval_probe_time_ms for periodic probe
    https://git.kernel.org/netdev/net-next/c/211da42eaa45

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


