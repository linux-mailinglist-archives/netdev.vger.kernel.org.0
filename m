Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B852E51F80D
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 11:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236754AbiEIJ1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 05:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238308AbiEIJOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 05:14:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 011AA18C058
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 02:10:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88570614BE
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 09:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E32B6C385AC;
        Mon,  9 May 2022 09:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652087412;
        bh=tshMzCGRvlPkebCSi5RUR97fB126xfaHGXr2+zsh89k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bIlt7pQKtGwHNuTanbI4RjWnTk3qe22gQbUhYscf4RSCjiWczdeOUF6D/LHRIoqlv
         lG9+lG0WOqW1E2fCRu84o6SmbypYwODf6PiUIbLnhHUKw+VBJA33Cu7rR0FBV+zrDF
         2xEaHO61/nXNgEylh1ba5IUzC+3JBx1chNBxPiIeBCtDzlKHL8tRe7892IrtmihRkB
         RkPM7UaFRpUIyY2A0+QJO0+NKnJJ9psD9xWWNriMDQvBZd/1GrPh2O4WvlIrxmIjPp
         +AzWfbZAn/IgPsu/F04BDsvUMrvNx3opDfgBUU4SBHDZRAVj6WIgSjkbnAwNTrNYqC
         XK8SrAJZxot8Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C6529F03876;
        Mon,  9 May 2022 09:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: sfc: fix memory leak due to ptp channel
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165208741180.4565.7847310079388354915.git-patchwork-notify@kernel.org>
Date:   Mon, 09 May 2022 09:10:11 +0000
References: <20220504123227.19434-1-ap420073@gmail.com>
In-Reply-To: <20220504123227.19434-1-ap420073@gmail.com>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com
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
by David S. Miller <davem@davemloft.net>:

On Wed,  4 May 2022 12:32:27 +0000 you wrote:
> It fixes memory leak in ring buffer change logic.
> 
> When ring buffer size is changed(ethtool -G eth0 rx 4096), sfc driver
> works like below.
> 1. stop all channels and remove ring buffers.
> 2. allocates new buffer array.
> 3. allocates rx buffers.
> 4. start channels.
> 
> [...]

Here is the summary with links:
  - [net,v2] net: sfc: fix memory leak due to ptp channel
    https://git.kernel.org/netdev/net/c/49e6123c65da

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


