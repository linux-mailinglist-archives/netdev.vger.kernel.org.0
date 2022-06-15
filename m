Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6889954C37A
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 10:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244257AbiFOIae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 04:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244124AbiFOIaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 04:30:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6923457BE;
        Wed, 15 Jun 2022 01:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8992361984;
        Wed, 15 Jun 2022 08:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DF227C341C5;
        Wed, 15 Jun 2022 08:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655281813;
        bh=59x39cqttrbDrklHHKtVqVWVczn1zsvdVlM/WZVa9hs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IgXQnmMi/5YdYB2yGRqaJzKXoYrXZIsHcyOlfoJb7YHiOaxsoEZU4/hShvw4vsJzf
         m0Bd20tIbRhmZTdEqPrgk/TRWuKwUpJUlwVLIpRhQFvcb4NdQ7rp/JJKVfM0Ww59gX
         oBi8XLqHiYlVXSQR9PqHFI5qWCGJlvVvw/ZmZIqbh4JKqckspoVpLkO31i1qp3U/aE
         9/zpmbKfgjol+hriFBtbjBVB/eHD10clnrq/x/HB/Q8KqPHag6Vmx5QrckmDEPf3M1
         prx51Yi0SL88dEtWmu/y9hwbE1lnCP1Cmon9/qWH1hRg1s5In+mINt7Ab2Z9R0iFFT
         wiYsbBO12q4gA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C3210E7385E;
        Wed, 15 Jun 2022 08:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net: phy: marvell-88x2222: set proper
 phydev->port
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165528181379.16320.12216919211588572408.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Jun 2022 08:30:13 +0000
References: <20220612181934.665-1-i.bornyakov@metrotek.ru>
In-Reply-To: <20220612181934.665-1-i.bornyakov@metrotek.ru>
To:     Ivan Bornyakov <i.bornyakov@metrotek.ru>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, system@metrotek.ru
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sun, 12 Jun 2022 21:19:34 +0300 you wrote:
> phydev->port was not set and always reported as PORT_TP.
> Set phydev->port according to inserted SFP module.
> 
> Signed-off-by: Ivan Bornyakov <i.bornyakov@metrotek.ru>
> ---
> Changelog:
>   v1 -> v2: set port as PORT_NONE on SFP removal, instead of PORT_OTHER
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net: phy: marvell-88x2222: set proper phydev->port
    https://git.kernel.org/netdev/net-next/c/9794ef5a6843

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


