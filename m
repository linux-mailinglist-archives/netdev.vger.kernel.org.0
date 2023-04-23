Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10C6E6EBF7C
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 14:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjDWMkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 08:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjDWMkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 08:40:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 830F210E2
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 05:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27F1B60F8A
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 12:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7C044C4339B;
        Sun, 23 Apr 2023 12:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682253618;
        bh=DtltEoErDCLaR7qsriGgIwzMNzHMTvrOHnakqQ0KTbQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gQaD0uUTA+J0IAoV2mkyXusz94vIFpEOxkGFVIbG0bXynyZes0lfQ3EvMxFlptb1I
         w4hFPvJrJJy7Ulo0i0upMpTkcT4xUL4WWpxySyg66ueCZ9LLV0pbO8r0SIpQp8uJ+r
         8lcMFJLsnz06QAi3Fp7nv3JHSwEbUNR0SIcv0oUzakWrlv8Wb4ED8O0UHEkQAOJiIc
         bqWavAXQtr0Ax3L7qXKpQ9zNLPwd1UYE764G7a7BfmWsIkfal6yN/mei5s6FL0racO
         Z3qZzvFgRM+b7AiFk3Z4OmKzocfcqNmZ74x4W3rOPE2Mvkh1CAu0iN1vh46FVI3ZZ7
         bu+Tg4xGzzXVg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 600F2E270E1;
        Sun, 23 Apr 2023 12:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6][pull request] ice: lower CPU usage with GNSS
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168225361839.11682.1660923257865776990.git-patchwork-notify@kernel.org>
Date:   Sun, 23 Apr 2023 12:40:18 +0000
References: <20230420235033.2971567-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230420235033.2971567-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org, mschmidt@redhat.com,
        johan@kernel.org
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Thu, 20 Apr 2023 16:50:27 -0700 you wrote:
> Michal Schmidt says:
> 
> This series lowers the CPU usage of the ice driver when using its
> provided /dev/gnss*.
> 
> The following are changes since commit e315e7b83a22043bffee450437d7089ef373cbf6:
>   net: libwx: fix memory leak in wx_setup_rx_resources
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] ice: do not busy-wait to read GNSS data
    https://git.kernel.org/netdev/net-next/c/2f8fdcb0a73a
  - [net-next,2/6] ice: increase the GNSS data polling interval to 20 ms
    https://git.kernel.org/netdev/net-next/c/0ec636e571f5
  - [net-next,3/6] ice: remove ice_ctl_q_info::sq_cmd_timeout
    https://git.kernel.org/netdev/net-next/c/84817ab66fd0
  - [net-next,4/6] ice: sleep, don't busy-wait, for ICE_CTL_Q_SQ_CMD_TIMEOUT
    https://git.kernel.org/netdev/net-next/c/f86d6f9c49f6
  - [net-next,5/6] ice: remove unused buffer copy code in ice_sq_send_cmd_retry()
    https://git.kernel.org/netdev/net-next/c/43a630e37e25
  - [net-next,6/6] ice: sleep, don't busy-wait, in the SQ send retry loop
    https://git.kernel.org/netdev/net-next/c/b488ae52ef9f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


