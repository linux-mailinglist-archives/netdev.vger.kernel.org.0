Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE3F5AD1D0
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 13:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238284AbiIELuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 07:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237343AbiIELuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 07:50:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24343ECC9
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 04:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4174B61228
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 11:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A6A28C433B5;
        Mon,  5 Sep 2022 11:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662378614;
        bh=wMSu1j+rmPMwTgs5ElIiTyNbv2EMIZZJX8FNZ0gdT34=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kd0Mrwj+Pd1MlW97O3d4e7j/SqQ2syoQXzfTWV5ugqP+GQHI6TGUG/Iw39PciIYol
         o24lzJxqDVhqqw0VT/mHclBx4NdfO5fAzmzKWrNBOiN3IEeoYT4kFyPKE9X0T12Yuw
         Nx/Dsny+xnYTOCtUJy/3Yv9NEwOiZaV+FoqeNg9pYX/e1CqcNmqSitsIIuDzCf9lmi
         nQ4+NMd5XzAgYfvFXNky0JTXyPasPG5BzWwetf+MW24P+ay7J3yMPsdA346RR66JOZ
         Rnvo7r2tn2w+vJGXKHrns5n0o2JwFf3feJCs5HWbFXrci+dEIf8P4KYEeFlf8KXT1w
         p3ysKH96OOIog==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8EE93E1CABE;
        Mon,  5 Sep 2022 11:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] r8169: merge handling of chip versions 12 and 17
 (RTL8168B)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166237861458.7756.18127694514558944366.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Sep 2022 11:50:14 +0000
References: <bf680a50-a445-6007-e52b-0e0b0696e24c@gmail.com>
In-Reply-To: <bf680a50-a445-6007-e52b-0e0b0696e24c@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org
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

On Fri, 2 Sep 2022 22:10:53 +0200 you wrote:
> It's not clear why XID's 380 and 381..387 ever got different chip
> version id's. VER_12 and VER_17 are handled exactly the same.
> Therefore merge handling under the VER_17 umbrella.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/realtek/r8169.h            | 2 +-
>  drivers/net/ethernet/realtek/r8169_main.c       | 6 ------
>  drivers/net/ethernet/realtek/r8169_phy_config.c | 1 -
>  3 files changed, 1 insertion(+), 8 deletions(-)

Here is the summary with links:
  - [net-next] r8169: merge handling of chip versions 12 and 17 (RTL8168B)
    https://git.kernel.org/netdev/net-next/c/7e04a111cde2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


