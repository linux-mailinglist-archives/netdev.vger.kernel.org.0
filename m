Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD7A4D317D
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 16:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233676AbiCIPLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 10:11:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233603AbiCIPLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 10:11:15 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F61A8899;
        Wed,  9 Mar 2022 07:10:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5DF7BCE1F88;
        Wed,  9 Mar 2022 15:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 85C35C340F4;
        Wed,  9 Mar 2022 15:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646838610;
        bh=8A++k1unyMO7ogmcxrVkwhnjVKFbRqrxcw3dIBb2GXk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZPxAfpLJfwukLpVp5d+7Su8+FZ9CF9ZrfxEznb28YkTBaZ9VZ09kk+w18UFxSVSXe
         FlYN4/czqbb7vXQ/bh2tfF4eKQgYkvdTfsHQXvYoEkRMbSZpDL/QH+/SYJC8dISf7l
         a8xRcWR4RAlsP94kFtuozMl58YIIacS437NI4RA85RgZjLyZVsQPPLObzpMY1j7qLY
         DLOnEMYgaVhhbdOVauYj2um0LQA43ubcj6Tr9EnADHUhl/yn4zxqg6ZyIEJV5BHWzB
         A70Bv6/PUOCbgoL/qyyhjemgxb9AJRkn/S8XpD4QtHZNGbVxiInK2YbJssAG2VlzWr
         j3IHH7t+oHcYQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 69A2AEAC095;
        Wed,  9 Mar 2022 15:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] MAINTAINERS: rectify entry for REALTEK RTL83xx SMI DSA ROUTER
 CHIPS
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164683861042.12949.8199505673073393663.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Mar 2022 15:10:10 +0000
References: <20220308103027.32191-1-lukas.bulwahn@gmail.com>
In-Reply-To: <20220308103027.32191-1-lukas.bulwahn@gmail.com>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        luizluca@gmail.com, linus.walleij@linaro.org, alsi@bang-olufsen.dk,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue,  8 Mar 2022 11:30:27 +0100 you wrote:
> Commit 429c83c78ab2 ("dt-bindings: net: dsa: realtek: convert to YAML
> schema, add MDIO") converts realtek-smi.txt to realtek.yaml, but missed to
> adjust its reference in MAINTAINERS.
> 
> Hence, ./scripts/get_maintainer.pl --self-test=patterns complains about a
> broken reference.
> 
> [...]

Here is the summary with links:
  - MAINTAINERS: rectify entry for REALTEK RTL83xx SMI DSA ROUTER CHIPS
    https://git.kernel.org/netdev/net-next/c/7f415828f987

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


