Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A66F524065
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 00:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348883AbiEKWuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 18:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233822AbiEKWuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 18:50:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98ACB65429
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 15:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4549CB82603
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 22:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E7834C34115;
        Wed, 11 May 2022 22:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652309413;
        bh=L9PWRK1aWZtwTRnxC6cM77GLtqgSAxuqXbW/NVGR7b0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LPqzcf5Hlsn5Ei8zA1eNetNp4q0HFf+TTqt/RNtW0N4ny8T3blLLNiN6bhlJZRQDw
         /XRl6lLdon3MbqDCen77SAANUkHHFTmFsWMZLpnZ1FGqzdEF975VfFpCxU3QeyA/pF
         j63tWGnWS45S+dI52KEDremM5DMu1s3Y8yO9sNiGa2UC2AgrPyWaVWDAzwdQIJUvMo
         /axn4xZI46af9VeqdnyzIBNek82bXzVkhzQW7SAHzPeIXmX4QRq7HTFVtvPykuImQb
         vaenYQvlItxrGqIJSp6GByoDfb87bOuCIO84ag1c4WpyGleV+hKMx3AoOW6Ns8wdXu
         RTS9Y6xf1bg6g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AE05CF03933;
        Wed, 11 May 2022 22:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: ocelot: accept 1000base-X for VSC9959 and
 VSC9953
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165230941270.19374.13498792044071266776.git-patchwork-notify@kernel.org>
Date:   Wed, 11 May 2022 22:50:12 +0000
References: <20220510164320.10313-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220510164320.10313-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, olteanv@gmail.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, colin.foster@in-advantage.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 10 May 2022 19:43:20 +0300 you wrote:
> Switches using the Lynx PCS driver support 1000base-X optical SFP
> modules. Accept this interface type on a port.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/dsa/ocelot/felix.c           | 1 +
>  drivers/net/dsa/ocelot/felix.h           | 1 +
>  drivers/net/dsa/ocelot/felix_vsc9959.c   | 2 ++
>  drivers/net/dsa/ocelot/seville_vsc9953.c | 4 +++-
>  4 files changed, 7 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net: dsa: ocelot: accept 1000base-X for VSC9959 and VSC9953
    https://git.kernel.org/netdev/net-next/c/11ecf3412bdc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


