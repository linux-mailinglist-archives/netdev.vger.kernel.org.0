Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5767609F0B
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 12:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiJXKaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 06:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiJXKaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 06:30:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F019C30542
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 03:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A585611DD
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 10:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CBFCCC433B5;
        Mon, 24 Oct 2022 10:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666607419;
        bh=FPjnR1hEM0W78WwvG9EdKb/AWVmK1Nb0mah3R0plt28=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QndAFQEhDiIohfVVBYrPq1cHqNeP6xY/h+6kXn7XskxHMMDJKAGCMZ78u0p/YoVY5
         QtXMLnlSF7IRD+TyziDWoKvrfe0V8pYVEriVeAcJm6wuAZiR+2IArxj+CzwS1uiI60
         CQ1x3uWlktFBuJy+riCXU5N53wPlSg9Ru7ZDIzLHCprjtYnFxBSoGZQRJUEnN0G2Mt
         FIseP0G1V3P/jm36aiFWprELkCG+IIN0RQ1hXBpIbAjEuu3Q2tTZBrh83XpinADiet
         aITNiDNCVuW52CyRg3Qb3YkC8zz6Qgddncov5eaLBDIGNDz11JBBFYhsBzKvPOyY0f
         zeyzvvPp2fclQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A92FDC4166D;
        Mon, 24 Oct 2022 10:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] Add support for 800Gbps speed
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166660741968.18313.3884972751898561670.git-patchwork-notify@kernel.org>
Date:   Mon, 24 Oct 2022 10:30:19 +0000
References: <cover.1666277135.git.petrm@nvidia.com>
In-Reply-To: <cover.1666277135.git.petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, idosch@nvidia.com,
        amcohen@nvidia.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, dsahern@kernel.org, mlxsw@nvidia.com
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
by David S. Miller <davem@davemloft.net>:

On Thu, 20 Oct 2022 17:20:02 +0200 you wrote:
> Amit Cohen <amcohen@nvidia.com> writes:
> 
> The next Nvidia Spectrum ASIC will support 800Gbps speed.
> The IEEE 802 LAN/MAN Standards Committee already published standards for
> 800Gbps, see the last update [1] and the list of approved changes [2].
> 
> As first phase, add support for 800Gbps over 8 lanes (100Gbps/lane).
> In the future 800Gbps over 4 lanes can be supported also.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] ethtool: Add support for 800Gbps link modes
    https://git.kernel.org/netdev/net-next/c/404c76783f32
  - [net-next,2/3] mlxsw: Add support for 800Gbps link modes
    https://git.kernel.org/netdev/net-next/c/cceef209ddd7
  - [net-next,3/3] bonding: 3ad: Add support for 800G speed
    https://git.kernel.org/netdev/net-next/c/41305d3781d7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


