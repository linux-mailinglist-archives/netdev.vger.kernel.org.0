Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AACBB4B11DA
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 16:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243701AbiBJPkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 10:40:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243693AbiBJPkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 10:40:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8537BFA
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 07:40:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2320661C77
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 15:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8698AC36AE2;
        Thu, 10 Feb 2022 15:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644507609;
        bh=sKIQC+uJGzmA2/Mj/WuO0ncsIstkvxSOffXRIdsqjHQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TkGrtUNYXy2iANfrXfEkPsRSL6Yx6NL74l4+sxFewHO3XCQlibcFKpaYQ/HMY//Sx
         09G+ifOdJm/4mT3WA+fqSFGLg88VpkARctEsMw8oD70kP2fvUB6TUQ8EiOpJ2R0Y5m
         BAypVqOBmC6NJzv/v1zZjtpZ5Rg1l6At9ClC7jfxASf6aSaFqmZD+30lYzEfUMI6AH
         c4MSBObYLJ6+B4clE27FVM0fovQhiwkWCAXq9zukP78BmdLfPptSTmm3104V+ihFzt
         Rny96TdlxobU2wECDXH5xl80yTXFQ7kFO0ORswRed0MhgE9qfDo2jCuNEgVulliADC
         6Z7EKqd/PA99w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6E8C7E6D453;
        Thu, 10 Feb 2022 15:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: make net->dev_unreg_count atomic
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164450760944.15967.16366498538977912397.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Feb 2022 15:40:09 +0000
References: <20220210025932.966618-1-eric.dumazet@gmail.com>
In-Reply-To: <20220210025932.966618-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Wed,  9 Feb 2022 18:59:32 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Having to acquire rtnl from netdev_run_todo() for every dismantled
> device is not desirable when/if rtnl is under stress.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: make net->dev_unreg_count atomic
    https://git.kernel.org/netdev/net-next/c/ede6c39c4f90

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


