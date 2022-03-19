Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB9784DE602
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 05:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242120AbiCSEvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 00:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241281AbiCSEvc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 00:51:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F9DA326D4
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 21:50:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93D9460BA8
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 04:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D9B27C340EF;
        Sat, 19 Mar 2022 04:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647665410;
        bh=fQw7emx8I7RHobKK5b5G+sJXj+U/BeLUf8Tzl1My12I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aLW6BkB/Rp4tosVDMrnA6X3zSfqwGR8QSaMT8mUnQHd+6Y+BHjJN4++SAs0eyiMXX
         fMvYYvxH66tM3/WhKhswcINvkdWnyVh1mlxRwpkM96b4edab+vsGjYmcJKpyLg9x5d
         zFfiLD/00YmNwXSq5jOOuK/PfI39QafaH/7BGLnK81yrV6pw/+ra6A5+soeZu6VR6w
         MM2RDqalUfrPkGCoVqy41RR37FvJ8jdn8qJTV7cKJ6lN6QGXgRw+H+u06VZbuMk+wZ
         vJmytQzFYPPOQMSFvEN3eynYm5r6Re4oaPvvDfvrirQW9J56yU5T2o8RWSsM2YVJuZ
         5l+3bNVfajkJA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BA38AE6D402;
        Sat, 19 Mar 2022 04:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2][pull request] 40GbE Intel Wired LAN Driver
 Updates 2022-03-17
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164766541075.28065.16019775091639476687.git-patchwork-notify@kernel.org>
Date:   Sat, 19 Mar 2022 04:50:10 +0000
References: <20220317160236.3534321-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220317160236.3534321-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Thu, 17 Mar 2022 09:02:34 -0700 you wrote:
> This series contains updates to i40e and igb drivers.
> 
> Tom Rix moves a conversion to little endian to occur only when the
> value is used for i40e. He also zeros out a structure to resolve
> possible use of garbage value for igb as reported by clang.
> 
> The following are changes since commit 1abea24af42c35c6eb537e4402836e2cde2a5b13:
>   selftests: net: fix array_size.cocci warning
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 40GbE
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] i40e: little endian only valid checksums
    https://git.kernel.org/netdev/net-next/c/ad739d0889a8
  - [net-next,2/2] igb: zero hwtstamp by default
    https://git.kernel.org/netdev/net-next/c/5d705de0cd34

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


