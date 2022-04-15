Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14710502876
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 12:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245413AbiDOKwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 06:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352399AbiDOKwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 06:52:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 807DE37A37;
        Fri, 15 Apr 2022 03:50:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2539262254;
        Fri, 15 Apr 2022 10:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7AEFEC385A8;
        Fri, 15 Apr 2022 10:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650019811;
        bh=7/ESHId8wX12eVYRQF0wmIv/Na6HJY/nO3fDu6peM40=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WFr90kb4/MXlxtBJWPh6lJ42nlxXlYKnfNOi8XzRTnbPXtNHswx6JdBqgJ9K7S/k7
         WCnyiudTSqU4RyyiUxDxM2RWIJv5dkhpOGJwDT+1epn21C5UDBoMq8JAE87jdylpZU
         1gzaC3tIoB8CrEG/SKQ2dl7JenDJEfFy1WO9fScFcsFIZW/oGh2LqiwZQr/ZlnQC35
         nwXodFTpuMtyy9igtwoXeCbVYAzJ06oXrNKOdXDhgvdHKXCD7f7FCI7ERORdOjUuo2
         mA5bEoVyQipe6iIyjsaeuqBVEpVPCmubCWkGMdMOpnhng85QN5yULL/60Hll1U08OK
         9j2fphIvBQoYQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 58668E6D402;
        Fri, 15 Apr 2022 10:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] net: emaclite: Trivial code cleanup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165001981135.26584.13278892661034431919.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Apr 2022 10:50:11 +0000
References: <1649939831-14901-1-git-send-email-radhey.shyam.pandey@xilinx.com>
In-Reply-To: <1649939831-14901-1-git-send-email-radhey.shyam.pandey@xilinx.com>
To:     Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        andrew@lunn.ch, michal.simek@xilinx.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        git@xilinx.com
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 14 Apr 2022 18:07:08 +0530 you wrote:
> This patchset fix coding style issues, remove BUFFER_ALIGN
> macro and also update copyright text.
> 
> 
> I have to resend as earlier series didn't reach mailing list
> due to some configuration issue.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: emaclite: Fix coding style
    https://git.kernel.org/netdev/net-next/c/945e659dffad
  - [net-next,2/3] net: emaclite: Update copyright text to correct format
    https://git.kernel.org/netdev/net-next/c/7ae7d494f626
  - [net-next,3/3] net: emaclite: Remove custom BUFFER_ALIGN macro
    https://git.kernel.org/netdev/net-next/c/7240bf6fb216

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


