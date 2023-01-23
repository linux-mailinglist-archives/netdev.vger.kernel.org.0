Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9C10677E64
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 15:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231971AbjAWOu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 09:50:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231953AbjAWOuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 09:50:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B5C5CDD0
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 06:50:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35223B80DD2
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 14:50:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D5288C4339B;
        Mon, 23 Jan 2023 14:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674485451;
        bh=GDFlJBCp4R7wNXZzSusORkrCJogcFMOl2Bv5yVHKGN8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IOg60Obh5vfEpEeOc6WJfV3YVdsqgOcPQq6tpOfT4y+vsQswk3XQ53WMqv6YFj1W8
         1rmRswK8ToMLfgPzVRw9StksPVup68+fQjl7mlDQN7A7F/Da8ROxsloABvoFlH9Mdy
         e261ZbsDJEgwJPdGbrtWqHnnXcnPtdotr5wc4tHSnFjUwThl2LImXIzsXwMahZcezA
         s3vzcRkWfvXcapp0i8LLCp4VTAIQaNZNZo4DKiJvfGaU4693NOgv0v3bioZJny0nhb
         l0W7FqzyKlgM8nXfVGVr3bfX5LqV3dgvpjBgsfIFHuwpa0UHKiRnVVXLMT/fbqnz5x
         sfUKYvPLNtlaA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B71C5C395CA;
        Mon, 23 Jan 2023 14:50:51 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: mdio: mux-meson-g12a: use devm_clk_get_enabled
 to simplify the code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167448545174.25704.8698383130212261654.git-patchwork-notify@kernel.org>
Date:   Mon, 23 Jan 2023 14:50:51 +0000
References: <84871cc7-2f96-7252-768f-5f869208045b@gmail.com>
In-Reply-To: <84871cc7-2f96-7252-768f-5f869208045b@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     neil.armstrong@linaro.org, andrew@lunn.ch, jbrunet@baylibre.com,
        martin.blumenstingl@googlemail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, khilman@baylibre.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 19 Jan 2023 23:56:37 +0100 you wrote:
> Use devm_clk_get_enabled() to simplify the code.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/mdio/mdio-mux-meson-g12a.c | 27 ++++++--------------------
>  1 file changed, 6 insertions(+), 21 deletions(-)

Here is the summary with links:
  - [net-next] net: mdio: mux-meson-g12a: use devm_clk_get_enabled to simplify the code
    https://git.kernel.org/netdev/net-next/c/32e54254bab8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


