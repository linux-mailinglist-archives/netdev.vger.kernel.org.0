Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02267562323
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 21:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236817AbiF3TaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 15:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235269AbiF3TaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 15:30:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A37F42EED
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 12:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0252761EDA
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 19:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4BDC3C341C7;
        Thu, 30 Jun 2022 19:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656617414;
        bh=a4h/dBlRQCLXFHu++IaZpCaC3BjduZ9gXRxxaWE5i8g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=duNZmliAh4AXwMQyGGF+NmRs0C1truRJfldftcyGoF/hr58lxwDV46q2GUBuLHvwU
         Zj/uNqyQfvldbT8PNiXKHIMVCvsBUue2sOnxfvhcA7StJQVEp+UqaT9CeHx3ZaACZV
         xssBgfdMMKuzNdqGUCY4uv4LjkwfXkHk1F80989UgZaG2JlmMLO8WhoS6OyFf2eUa1
         u+R0/HGsPQiGjB1hcj1FYJxxVkhIh0sOkYbO/6dJfPELjqmXMdgHo71uMnskwch8cn
         7JQKcbpQxzSSZlQCBgyKz/2TW4YiU4RC52Fft1HQ4h3HHrJRPKyjh9Fs4dHz4kDCz3
         R7bh/Hc4pyDBQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2D867E49BBB;
        Thu, 30 Jun 2022 19:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phylink: fix NULL pl->pcs dereference during
 phylink_pcs_poll_start
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165661741418.1981.16436724422790201997.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Jun 2022 19:30:14 +0000
References: <20220629193358.4007923-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220629193358.4007923-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, rmk+kernel@armlinux.org.uk,
        linux@armlinux.org.uk, andrew@lunn.ch, hkallweit1@gmail.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 29 Jun 2022 22:33:58 +0300 you wrote:
> The current link mode of the phylink instance may not require an
> attached PCS. However, phylink_major_config() unconditionally
> dereferences this potentially NULL pointer when restarting the link poll
> timer, which will panic the kernel.
> 
> Fix the problem by checking whether a PCS exists in phylink_pcs_poll_start(),
> otherwise do nothing. The code prior to the blamed patch also only
> looked at pcs->poll within an "if (pcs)" block.
> 
> [...]

Here is the summary with links:
  - [net-next] net: phylink: fix NULL pl->pcs dereference during phylink_pcs_poll_start
    https://git.kernel.org/netdev/net-next/c/b7d78b46d5e8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


