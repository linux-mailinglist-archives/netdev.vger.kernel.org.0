Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F81A54A97B
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 08:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351463AbiFNGaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 02:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350935AbiFNGaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 02:30:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A8119FB3;
        Mon, 13 Jun 2022 23:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 568DD60BD4;
        Tue, 14 Jun 2022 06:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AA2BBC3411C;
        Tue, 14 Jun 2022 06:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655188213;
        bh=HA2CQg+BitG9bOayuL2B8arkzc3hd7J7CQXjmEDy+iw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KdwzHfWZ3ngZ+jbEeNNtKYnKVB/pPKihkewunLwciZ53EF78EnjwbP+P0gzKXb2HP
         70gsMkHrQQgm6jiXTfbSWgvKClNTEflDpO4fm/s5bgjmGzqnwimk/R6v4pX0OMMGuc
         qYKR6HOVi7OHiyriAzdsjEBwcilp8Drq1B724VxwyuxPxiOYb8XoIcRRiwfN6rsjWq
         o5kuZnFG+hqiq6m7knTs/XWwN1nRwDwIKajqJL21iIZ/D5cTHjl5EnTISzaj1N5Nkj
         V/RYc/3Ln+7YYX1wYlWxPqllntxq9pOKhAUwD8k2IRvjOiAcBl4EHJS6CDl0GihoLc
         sW6fkiOq2FIDA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8A342E6D482;
        Tue, 14 Jun 2022 06:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phy: fixed_phy: set phy_mask before calling
 mdiobus_register()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165518821356.28798.7031862060852260110.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Jun 2022 06:30:13 +0000
References: <20220606200208.1665417-1-linux@rasmusvillemoes.dk>
In-Reply-To: <20220606200208.1665417-1-linux@rasmusvillemoes.dk>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  6 Jun 2022 22:02:08 +0200 you wrote:
> There's no point probing for phys on this artificial bus, so we can
> save a little bit of boot time by telling mdiobus_register() not to do
> that.
> 
> This doesn't have any functional change, since, at this point,
> fixed_mdio_read() returns 0xffff for all addresses/registers, so
> 
> [...]

Here is the summary with links:
  - [net-next] net: phy: fixed_phy: set phy_mask before calling mdiobus_register()
    https://git.kernel.org/netdev/net-next/c/bfa54812f0bc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


