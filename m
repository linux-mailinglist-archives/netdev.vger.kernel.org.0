Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FCF55BAC32
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 13:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbiIPLUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 07:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbiIPLUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 07:20:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA2C52085
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 04:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD46662B14
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 11:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 47795C433C1;
        Fri, 16 Sep 2022 11:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663327216;
        bh=fo1PkklO8bb06/hMl5RQpuoYaTWU0M6SpKBrvjPIVaY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NSNN6gqv9C33oTrdigGOoXKTp76VyGfbdw/qdXvsSDLkLGJeCpkAtiOGk2zBmxZaD
         5HFm7BBoAN+ynvVHzJcLXa19tG+9y8WqXFvFAui2zaAm65ESgxY74Ck4VlCWgaq/3Z
         +/DP92QSl5FKSF6lyF9BdfHXChqDx+ILBP3+ohZyFnqR6yuYpSEeKbUYGTYjF83gBk
         DguIYHqSYuhwBYs2mFq1o4PwzzlG7YSiO7Ky0+ar9D1QLiGLaNAHN7BdJMYdnnvbOs
         pOkFsv0pcqk5OvzaoyEVp7oV5F0Ouz/tReyAhEji8QENqTWpk4xvjlyfBW7Xf1wD/0
         ASDDjQNSr5orA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 33F90C59A58;
        Fri, 16 Sep 2022 11:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2][pull request] Intel Wired LAN Driver Updates
 2022-09-08 (e1000e, igc)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166332721620.14472.17399319405809859190.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Sep 2022 11:20:16 +0000
References: <20220908173344.1282736-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220908173344.1282736-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org, sasha.neftin@intel.com
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
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Thu,  8 Sep 2022 10:33:42 -0700 you wrote:
> This series contains updates to e1000e and igc drivers.
> 
> Li Zhong adds checking and handling for failed PHY register reads for
> e1000e.
> 
> Sasha removes an unused define for igc.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] drivers/net/ethernet/e1000e: check return value of e1e_rphy()
    https://git.kernel.org/netdev/net-next/c/fb1752c7df4d
  - [net-next,2/2] igc: Remove IGC_MDIC_INT_EN definition
    https://git.kernel.org/netdev/net-next/c/2c5e5abf1c42

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


