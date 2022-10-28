Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75C3B610932
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 06:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiJ1EK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 00:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiJ1EKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 00:10:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E86D1C408
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 21:10:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E6056262C
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 04:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EC673C433B5;
        Fri, 28 Oct 2022 04:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666930220;
        bh=elND38mk1XD/JmqtqbNOjPNv0gNGKsT96K/LZXrWE+0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eiP0uzM5EhdfeOdZAwnfvMWHVtLMqQz/K08JOxFrYr75xoGYjddEhxMuKZtoIufEA
         BVjrr/bIclvY+kRx3ejq0pt2T8X/fa1w6G99epfqpCbsFFGT4lQkTprANYmZPXeAdQ
         5FZyQZSM56CHqZNE3fU60wpuTtzzqkrU4wCJ/B6RhYPK1uKBHLnbdPcH3p8/qicyZk
         covf4UlO/wC3PmlQZtQXATCaSQZqTM3JlSB2sNwiLQVmGUDk2OUWWsybQAm6fSiw7m
         GaJkNpo+A/29o9gjdeoH2hfJ9NlmXPz2R1VzcNGmYHuJ2J7T97tDPR0Bh2eyH1kq9X
         Nw5BvM3uf+PwA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D171EE29F32;
        Fri, 28 Oct 2022 04:10:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next 0/5] ionic: VF attr replay and other updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166693021985.17555.7911481555917817879.git-patchwork-notify@kernel.org>
Date:   Fri, 28 Oct 2022 04:10:19 +0000
References: <20221026143744.11598-1-snelson@pensando.io>
In-Reply-To: <20221026143744.11598-1-snelson@pensando.io>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        leon@kernel.org, drivers@pensando.io
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 26 Oct 2022 07:37:39 -0700 you wrote:
> For better VF management when a FW update restart or a FW crash recover is
> detected, the PF now will replay any user specified VF attributes to be
> sure the FW hasn't lost them in the restart.
> 
> Newer FW offers more packet processing offloads, so we now support them in
> the driver.
> 
> [...]

Here is the summary with links:
  - [v3,net-next,1/5] ionic: replay VF attributes after fw crash recovery
    https://git.kernel.org/netdev/net-next/c/db28adf9afeb
  - [v3,net-next,2/5] ionic: only save the user set VF attributes
    https://git.kernel.org/netdev/net-next/c/23e884a253a7
  - [v3,net-next,3/5] ionic: new ionic device identity level and VF start control
    https://git.kernel.org/netdev/net-next/c/f43a96d91df1
  - [v3,net-next,4/5] ionic: enable tunnel offloads
    https://git.kernel.org/netdev/net-next/c/cad478c7c332
  - [v3,net-next,5/5] ionic: refactor use of ionic_rx_fill()
    https://git.kernel.org/netdev/net-next/c/e55f0f5befc2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


