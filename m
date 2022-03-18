Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 094864DE36C
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 22:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241085AbiCRVVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 17:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235024AbiCRVVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 17:21:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D55A21D7EB
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 14:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D53161261
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 21:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 84133C340FA;
        Fri, 18 Mar 2022 21:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647638413;
        bh=okinufeaGudUI8pxFbh5lxOJES5b+aAr8Da59/egmOI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Mu4meHZmji+ePwtub+ebdCM28utBb/dJya5zAtID0iw/bxiF68SGihvQjlxfSegzs
         5BC+ID+CcVsFAaD+yL14Ps2On12SCUao5I/WAH9rElBc1XZQ713Po/NJLJ2K92NLlV
         4hxMlCpth/WMVEKc7hWZovnd9ZPPdcxhm1nfZxu9tKcUlCq12h8n5eCaZ6NtVWdhiz
         G+ew5yJb1BRiO8wA6fRFA3gXR1fPUpZtNADF7zmtwK5D4JcuHxoAw3wWdaJaTyuJ+I
         X8wB2o1UsKPZOEIAB+d1ujoeLZb3N8BHfioZu/MePzXAXoYadhUCTcUR89Thse9Pbl
         92qWMY5cZPIkQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6EE88F03842;
        Fri, 18 Mar 2022 21:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] af_unix: Remove unnecessary brackets around
 CONFIG_AF_UNIX_OOB.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164763841345.20195.13908005948053811168.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Mar 2022 21:20:13 +0000
References: <20220317032308.65372-1-kuniyu@amazon.co.jp>
In-Reply-To: <20220317032308.65372-1-kuniyu@amazon.co.jp>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     davem@davemloft.net, kuba@kernel.org, kuni1840@gmail.com,
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 17 Mar 2022 12:23:08 +0900 you wrote:
> Let's remove unnecessary brackets around CONFIG_AF_UNIX_OOB.
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> ---
> This is a follow up patch from
> https://lore.kernel.org/netdev/20220316194614.3e38cadc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/#t
> 
> [...]

Here is the summary with links:
  - [net-next] af_unix: Remove unnecessary brackets around CONFIG_AF_UNIX_OOB.
    https://git.kernel.org/netdev/net-next/c/4edf21aa94ee

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


