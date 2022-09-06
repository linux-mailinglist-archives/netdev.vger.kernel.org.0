Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA8C65AE471
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 11:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239044AbiIFJkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 05:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238916AbiIFJkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 05:40:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D6A2C11E;
        Tue,  6 Sep 2022 02:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5AA1FB81696;
        Tue,  6 Sep 2022 09:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 256C0C43470;
        Tue,  6 Sep 2022 09:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662457214;
        bh=fBdUCZ/6aO0miq6wk3qCcSa/FJoAhQ9BY2+3rHkLrWA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Bb+cBu7anQQVdxlaKuVE8k1AjK3j+oIj143QHRUl7ll6EETitca+6IPE89AZDb9qe
         3yD5ceop0aOP0q9lsouI7xeTXP/XPvW6x4nef1tjnu0ybfRazgQeHDmM+0CIpgwQKK
         IvZPbnp3e9XQsEAWCOVpE//uXnvFCQKDFZqLCtY2Evq5xgaKmBf/MSkaMq27duvltT
         VhnIMhKk7PR7xA17Fb8giDbvU5TqH3F9rzu6PuxAXLrf+DVQ4t5QcKrSBqHOpt/k7a
         Y95Ed8I4RASHquB3xRsUTI/GiyztvS3irPUJTwbaCCRUEn6EbMnbnkhwa99YzIoUmR
         z5nS6F+JEeoMg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F28D2C4166F;
        Tue,  6 Sep 2022 09:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net PATCH] net: dsa: qca8k: fix NULL pointer dereference for
 of_device_get_match_data
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166245721398.28164.16891219944506386296.git-patchwork-notify@kernel.org>
Date:   Tue, 06 Sep 2022 09:40:13 +0000
References: <20220904215319.13070-1-ansuelsmth@gmail.com>
In-Reply-To: <20220904215319.13070-1-ansuelsmth@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Sun,  4 Sep 2022 23:53:19 +0200 you wrote:
> of_device_get_match_data is called on priv->dev before priv->dev is
> actually set. Move of_device_get_match_data after priv->dev is correctly
> set to fix this kernel panic.
> 
> Fixes: 3bb0844e7bcd ("net: dsa: qca8k: cache match data to speed up access")
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: qca8k: fix NULL pointer dereference for of_device_get_match_data
    https://git.kernel.org/netdev/net/c/42b998d4aa59

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


