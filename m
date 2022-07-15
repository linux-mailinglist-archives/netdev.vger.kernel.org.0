Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3CC4575FC3
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 13:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232618AbiGOLKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 07:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiGOLKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 07:10:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F6486896;
        Fri, 15 Jul 2022 04:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A3B362288;
        Fri, 15 Jul 2022 11:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5AD9CC341CD;
        Fri, 15 Jul 2022 11:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657883414;
        bh=35zKBueGnyzYxrAS5X+/n4rmS5AwWglaqmiCs4ziBMc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=avQDVyPkFTOavgiQ6BmUqQ/ratCRa0Mz9SZyrna4ftoG4dbvg9T7YIE4Mg4MFjK1w
         334LvMuOrMK6PpwOz12e3JjAGMtw9kRX1oO3k2CV1PVzINapUEiPXO7S5Xe4Zfq06k
         wzrznaLWxJQx5vDrfXBTRvGNfedUxwxjbZ06ep+CyscuE/cTzZqKKmx2OqJ8f+6IUT
         I0GMYZI30g8HmdRaIzaY7d9j1/d1cWK3haYfVoP8fx7b5VChtjga5em6HuErOWmqig
         9ZioDmI9lA4U/oPXokQNWg/Myevm4A/ZTXAO9kBG8i3MHbdy7TzRTsydfpDcbjHySd
         VHghaXy993cjw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3A423E4522E;
        Fri, 15 Jul 2022 11:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH] net: dsa: qca8k: move driver to qca dir
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165788341423.15583.10070357441922135556.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Jul 2022 11:10:14 +0000
References: <20220713205350.18357-1-ansuelsmth@gmail.com>
In-Reply-To: <20220713205350.18357-1-ansuelsmth@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, gregkh@linuxfoundation.org,
        axboe@kernel.dk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 13 Jul 2022 22:53:50 +0200 you wrote:
> Move qca8k driver to qca dir in preparation for code split and
> introduction of ipq4019 switch based on qca8k.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
> 
> This is a start for the required changes for code
> split. Greg wasn't so negative about this kind of change
> so I think we can finally make the move.
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: qca8k: move driver to qca dir
    https://git.kernel.org/netdev/net-next/c/4bbaf764e1e1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


