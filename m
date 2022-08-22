Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48D7459C137
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 16:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235229AbiHVOAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 10:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234427AbiHVOAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 10:00:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B537C37FA9;
        Mon, 22 Aug 2022 07:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A890611B4;
        Mon, 22 Aug 2022 14:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9C97BC433D6;
        Mon, 22 Aug 2022 14:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661176815;
        bh=ygchDD9pK3y0Nzdc29fCKU0n3nN9ciMhH2E2TIBjbGo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AicG4BqWHqvSkZEt+dyB/y8VkSh6VTgepBeptecuWUrSlyfYDwbk///q06IAda4vn
         tsGExcBV+ocWncCtEwyHxjTpYRJF/A/sIe7TCpBCFu9UCFmQ1ELspYR9rlYT7Bsj0G
         v268fs2iAnAPijWh5H0oD2UIvJ/POoSXJ1h6O4E2bM/rWge9nT3azJs93t+hXSFdBl
         CneuGKnO8hBVBSkdU+qelhoSdFfG/P3QuZ0XktMqTJXyJAiPf/vxBt0LneXfNcDkI8
         Ukw/H/C+CRX4WCRVvOJ3/9vaQMeawHKjXbBwM1QuTtqrc1n3+HQBXJK+dNIhKJDK1l
         wXXdvV0l4CRxw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7F405C04E59;
        Mon, 22 Aug 2022 14:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] r8152: fix flow control settings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166117681551.22523.4597726864619729966.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Aug 2022 14:00:15 +0000
References: <20220818080620.14538-392-nic_swsd@realtek.com>
In-Reply-To: <20220818080620.14538-392-nic_swsd@realtek.com>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
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

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 18 Aug 2022 16:06:18 +0800 you wrote:
> These patches fix the settings of RX FIFO about flow control.
> 
> Hayes Wang (2):
>   r8152: fix the units of some registers for RTL8156A
>   r8152: fix the RX FIFO settings when suspending
> 
>  drivers/net/usb/r8152.c | 27 ++++++++++++---------------
>  1 file changed, 12 insertions(+), 15 deletions(-)

Here is the summary with links:
  - [net,1/2] r8152: fix the units of some registers for RTL8156A
    https://git.kernel.org/netdev/net/c/6dc4df12d741
  - [net,2/2] r8152: fix the RX FIFO settings when suspending
    https://git.kernel.org/netdev/net/c/b75d61201444

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


