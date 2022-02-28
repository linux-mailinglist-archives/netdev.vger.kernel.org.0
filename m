Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 513AD4C6B72
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 13:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236077AbiB1MA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 07:00:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232330AbiB1MAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 07:00:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D606661E
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 04:00:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48861B81110
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 12:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EC23BC340F3;
        Mon, 28 Feb 2022 12:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646049611;
        bh=hkLRt9JbJ0EUJfif3jjqWRiRglHtQ/OYjXfQkPH2beo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eD5gPrdz4jfSzFqPf2eFXAg51NV9VX+tM/nLVRW9YZQ5KMUuvjv+ELqyvICr1M/G9
         mAZDKpWSwAT5ikRRvmgPr36jDuT02C3mXvHkJaEL4fnAiyk3XllaHqZpYht/UfdHwd
         st8tiet0cc84HEsVzqT+zLuRMsubWtlGl+7U4nckcRN9T75zl5S0Q4W5d2BGHNrkKr
         a4icIR0s/+2ESkLTyTIXlXo0PK8PzWxe3ZPIEHGPJ7SL3MtFnAd5ltUD/9mN86+4ZA
         VdknY1m9IGPNUd0fHch4ZxvA+r1EE5DhSbPsifw7OxnM36Zazmb940FKE+zFYQuflu
         Th0FyM1GDt+Bg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D3AF7E6D4BB;
        Mon, 28 Feb 2022 12:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phylink: remove phylink_set_pcs()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164604961086.22318.12233193981507469033.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Feb 2022 12:00:10 +0000
References: <E1nNyUg-00B1aX-Ft@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1nNyUg-00B1aX-Ft@rmk-PC.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Sat, 26 Feb 2022 14:56:22 +0000 you wrote:
> As all users of phylink_set_pcs() have now been updated to use the
> mac_select_pcs() method, it can be removed from the phylink kernel
> API and its functionality moved into phylink_major_config().
> 
> Removing phylink_set_pcs() gives us a single approach for attaching
> a PCS within phylink.
> 
> [...]

Here is the summary with links:
  - [net-next] net: phylink: remove phylink_set_pcs()
    https://git.kernel.org/netdev/net-next/c/a5081bad2eac

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


