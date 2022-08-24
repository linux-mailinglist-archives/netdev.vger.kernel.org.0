Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5866159F8EE
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 14:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236579AbiHXMA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 08:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236034AbiHXMAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 08:00:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BFCA7657;
        Wed, 24 Aug 2022 05:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA7FDB823A8;
        Wed, 24 Aug 2022 12:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 81515C433D7;
        Wed, 24 Aug 2022 12:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661342415;
        bh=i/aYydtbcIHGvpKiZBWz976v5ct10lPdzWsbaBwMua8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=X3hzYOXEQctM1VqHF6n90ZCi8UHKY8K7HF94VygNY/K3P2LyMTLw1Bhi6HEXibzZk
         RNvC/mNTQyd/eHp1w1oEVGC+9DSvKs5EQrwh9V+EFNsnh+WX5X79xXri/wrs3jb6Vk
         1pvLZBxLvG4iCLCvgCz1U76MzBSZzJSOkzlQEWHZvnmh9wbvCmR0ljfflqi+5GwbMk
         YfojKA2MHyrdjBm4B2O4wDTLHOcSGUKp+3NvZv8YJNPktrzj0YOmZi3VND94jOSzDP
         ZgGqBzNjbm1nsUoLN2kMpoIhUTHpSzGQrE+kBF80Z8g72GQKAPybf5pa4SfSMxAMyS
         /PjLP6z5ArZAQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5A39CE2A03B;
        Wed, 24 Aug 2022 12:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 net-next] net: marvell: prestera: implement br_port_locked
 flag offloading
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166134241536.3394.1114076220521153448.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Aug 2022 12:00:15 +0000
References: <20220822180315.3927-1-oleksandr.mazur@plvision.eu>
In-Reply-To: <20220822180315.3927-1-oleksandr.mazur@plvision.eu>
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tchornyi@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
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

On Mon, 22 Aug 2022 21:03:15 +0300 you wrote:
> Both <port> br_port_locked and <lag> interfaces's flag
> offloading is supported. No new ABI is being added,
> rather existing (port_param_set) API call gets extended.
> 
> Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> 
> V2:
>   add missing receipents (linux-kernel, netdev)
> 
> [...]

Here is the summary with links:
  - [V2,net-next] net: marvell: prestera: implement br_port_locked flag offloading
    https://git.kernel.org/netdev/net-next/c/73ef239cd843

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


