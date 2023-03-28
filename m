Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5456CCE03
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 01:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbjC1XaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 19:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjC1XaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 19:30:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58ED92724
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 16:30:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD5EC61A01
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 23:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 398B7C4339C;
        Tue, 28 Mar 2023 23:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680046218;
        bh=STFRDZzYjQutVf2rOLLbWoiW+BupktYRO6kMXtZ4VY0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KmIVMxmaGRb+S9OA3o7pOHp/ZyL0V25aLqwlbyG8ib/Q86Gmy0x3cXXxxsgdE+9oD
         yQ3ghSgvKoDYeDoz+J1A6Q8sAiWNq0H8nj2ji+NSJATXVotXEyjYmx5MYS8d9O957B
         7TJXdKAIiBWpNGkcAamE4V/8zKF6sVP0HATNmvyNPGkchDipmbUPtiVEh6QLjNGcIT
         lUJi94tdvzkF8mBjwqfffPykLR44P+hj5SIBdUuN7ScA3meba3CfK3/7e2Oal+4Y04
         tXffUUmXO/DK+xuwAdoPGSQ8CjlJT6GNcBAGaAOVZVRzbRtFse2mQGIY4BYPka9MFQ
         C0kJWLSKaEsag==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1FBEDE21EE2;
        Tue, 28 Mar 2023 23:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/mlx5e: Fix build break on 32bit
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168004621812.15782.10964329419685296565.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Mar 2023 23:30:18 +0000
References: <20230328200723.125122-1-saeed@kernel.org>
In-Reply-To: <20230328200723.125122-1-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        tariqt@nvidia.com
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 28 Mar 2023 13:07:23 -0700 you wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> The cited commit caused the following build break in mlx5 due to a change
> in size of MAX_SKB_FRAGS.
> 
> error: format '%lu' expects argument of type 'long unsigned int',
>        but argument 7 has type 'unsigned int' [-Werror=format=]
> 
> [...]

Here is the summary with links:
  - [net-next] net/mlx5e: Fix build break on 32bit
    https://git.kernel.org/netdev/net-next/c/163c2c705917

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


