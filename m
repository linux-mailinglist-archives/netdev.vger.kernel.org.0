Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E28857EB77
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 04:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236627AbiGWCK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 22:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbiGWCK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 22:10:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0497DF5AD;
        Fri, 22 Jul 2022 19:10:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 998EC6231F;
        Sat, 23 Jul 2022 02:10:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E4EBBC341C7;
        Sat, 23 Jul 2022 02:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658542226;
        bh=OgJgFHjY1OObcoSi2yee9cax62lJyTHikeZwaWoKPXU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Lukm2Zet1Wr+VMnhWRov/SBQpZ3ajUTqL0nD1XvXkQxYJp62SN9fEC0AaaYkPm2LF
         puNFx3bfSbE2iAyL/ejKmsvs3kXJXTf7yVeFO9ryTADebtRfq3cbkYTMRyT1QhFTJC
         gDDI5BLpvUM/fYdqd9HRQAbXq+jxaciOpj5W46TDc9qIenFNnXLIRmMXlxAvNEN12N
         hsgA+zS3k0whup5pyRFHW/kraYaGjEpafYL/da7PTC5dp7FsKh1OPj2BZsY/tLBlF+
         a0H8WXTO1yiaGaq9Ua183+sr0CnnqBnatQg03wqE7G9M+rudIYRenUO3+5uvEPNid+
         GJuf4VLF6PX7g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C7415E45200;
        Sat, 23 Jul 2022 02:10:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull request: bluetooth-next 2022-07-22
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165854222581.22628.15052144644989173431.git-patchwork-notify@kernel.org>
Date:   Sat, 23 Jul 2022 02:10:25 +0000
References: <20220723002232.964796-1-luiz.dentz@gmail.com>
In-Reply-To: <20220723002232.964796-1-luiz.dentz@gmail.com>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 22 Jul 2022 17:22:32 -0700 you wrote:
> The following changes since commit 6e0e846ee2ab01bc44254e6a0a6a6a0db1cba16d:
> 
>   Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-07-21 13:03:39 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git tags/for-net-next-2022-07-22
> 
> [...]

Here is the summary with links:
  - pull request: bluetooth-next 2022-07-22
    https://git.kernel.org/netdev/net-next/c/4a934eca7b39

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


