Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A96761746B
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 03:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbiKCCuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 22:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbiKCCuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 22:50:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB5B10FF0;
        Wed,  2 Nov 2022 19:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01C8561CFE;
        Thu,  3 Nov 2022 02:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 62F55C433D7;
        Thu,  3 Nov 2022 02:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667443816;
        bh=WDPESprcEEOJiYBftEOyywxHbJzWhbLi8a7DQVjpgZM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hp9gFc7s4pK1m9+S1sIUqxbgE146uhaGZx6mETd/zUUmFvJUmI3BbXzA+fWVOpwUF
         CNySt9UZebEmFQLsnone1bQUr5wRQgqfRpQtYfu/idpU/1saF3Vk7+/lbyKrk1XU6o
         SecCVM72mXk05ulaQG/31aMWtpXJVsM7e5S5ZWAekBYjf6/oFrgH3wtENHuuv0GZ9P
         Xlh8cH9gLTbmhCKK7nc45ewUuddcRb4JoQLExOynF4MoLvMMF6kc95UL+hk+gQbdDJ
         OqjHbVkMW8MbX2ZQB+1WAWNwiTAC9gIJWIM5RYTuZDGwp2Ao4kEfqSVKJk/tIQLNwz
         ENNmXe63BkSDQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 39528E270D2;
        Thu,  3 Nov 2022 02:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bluetooth 2022-10-02
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166744381623.12330.6046590537256991700.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Nov 2022 02:50:16 +0000
References: <20221102235927.3324891-1-luiz.dentz@gmail.com>
In-Reply-To: <20221102235927.3324891-1-luiz.dentz@gmail.com>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  2 Nov 2022 16:59:27 -0700 you wrote:
> The following changes since commit ba9169f57090efdee6b13601fced57e123db8777:
> 
>   Merge branch 'misdn-fixes' (2022-11-02 12:34:48 +0000)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2022-10-02
> 
> [...]

Here is the summary with links:
  - pull-request: bluetooth 2022-10-02
    https://git.kernel.org/netdev/net/c/ef1fdc936cb0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


