Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB5B35BD8FD
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 03:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiITBA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 21:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiITBAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 21:00:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D1D4A815
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 18:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E279EB82288
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 01:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 99149C433D7;
        Tue, 20 Sep 2022 01:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663635615;
        bh=/m7KEqFB3cdriX9MUnKf4hePJoRPVzvC75NOWnDaR88=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Vs3EI4EsgSwnE7uMdT56mPa9xeEkZ7me/Vu/ibEdCi+o6T5tqvWe+pe4ZvBs5st6E
         uzu4B8HP/XjfGPUULbtmZzn9jCaeqFb288GTg5JItgVL69Lla36j0mEUKKL9Gd3LWM
         koXeBnr8Vvg8sFwCpPho8EyRqQ9i0h1Fvsg7tNs3lKDzCqAkW8sXMlrBSXGlNno9Ip
         ReudW400IwLil/+NprJk8vbWZrrzGksNhNLv7eJKf722uyOtD1RIshLanR+LAmNJH9
         VE3LpzUbxotCwXp6306bS6wLph82r6FCEl1IZe65dVkI3BfomOb3/txPPxp515frpY
         mAhILKQKEIaKw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7BC4DE52535;
        Tue, 20 Sep 2022 01:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ethernet: mtk_eth_soc: enable XDP support just for
 MT7986 SoC
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166363561549.18776.5047495381087045644.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 01:00:15 +0000
References: <2bf31e27b888c43228b0d84dd2ef5033338269e2.1663074002.git.lorenzo@kernel.org>
In-Reply-To: <2bf31e27b888c43228b0d84dd2ef5033338269e2.1663074002.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lorenzo.bianconi@redhat.com,
        arinc.unal@arinc9.com, sergio.paracuellos@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 13 Sep 2022 15:03:05 +0200 you wrote:
> Disable page_pool/XDP support for MT7621 SoC in order fix a regression
> introduce adding XDP for MT7986 SoC. There is no a real use case for XDP
> on MT7621 since it is a low-end cpu. Moreover this patch reduces the
> memory footprint.
> 
> Tested-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Fixes: 23233e577ef9 ("net: ethernet: mtk_eth_soc: rely on page_pool for single page buffers")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net] net: ethernet: mtk_eth_soc: enable XDP support just for MT7986 SoC
    https://git.kernel.org/netdev/net/c/5e69163d3b99

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


