Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3871B584F9A
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 13:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235074AbiG2LaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 07:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232959AbiG2LaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 07:30:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D00D134
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 04:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7A3161E92
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 11:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 46459C43141;
        Fri, 29 Jul 2022 11:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659094214;
        bh=YTh812N94iTAkMkctWnkTNZH59EScxVdZ0HIYLHdSBA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NREj1UCkXoRsGKKLkJF1IOboGZf+RN2Vp982hK06KhxgUQaN55wRmZtHXfgMojRad
         +MHEZqcCq8dR4tUQQAmvLoDcIDKYuH0AURMzOK7r4ZgZ/wM2pGod44bT+Mnv74IVMJ
         DnzeDexcdIxbOnn5mEvmHEE7vcTSrafuFHBmqfgoIJ+y/vpjNGXCV17/+9hxrAoX7x
         Hky+psSwPdq7WpGnocKjkR8q5WTRw0xKhyHonPbGAMUeWUvgNZ6GLAve6U34ddGAx5
         /tgXcEvtS/ezOfbmJL40gMWB0tWDXU3HHKkGpFKuly1hGuX0aPFh1mA+r1Sjf0oaJa
         V9QiKAOu5JhIA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 311B1C43140;
        Fri, 29 Jul 2022 11:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] mtk_eth_soc: introduce xdp multi-frag support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165909421419.27900.9288866445051799762.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Jul 2022 11:30:14 +0000
References: <cover.1658955249.git.lorenzo@kernel.org>
In-Reply-To: <cover.1658955249.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, ilias.apalodimas@linaro.org,
        lorenzo.bianconi@redhat.com, jbrouer@redhat.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 27 Jul 2022 23:20:49 +0200 you wrote:
> Convert mtk_eth_soc driver to xdp_return_frame_bulk APIs.
> 
> Lorenzo Bianconi (3):
>   net: ethernet: mtk_eth_soc: introduce mtk_xdp_frame_map utility
>     routine
>   net: ethernet: mtk_eth_soc: introduce xdp multi-frag support
>   net: ethernet: mtk_eth_soc: add xdp tx return bulking support
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: ethernet: mtk_eth_soc: introduce mtk_xdp_frame_map utility routine
    https://git.kernel.org/netdev/net-next/c/b16fe6d82b71
  - [net-next,2/3] net: ethernet: mtk_eth_soc: introduce xdp multi-frag support
    https://git.kernel.org/netdev/net-next/c/155738a4f319
  - [net-next,3/3] net: ethernet: mtk_eth_soc: add xdp tx return bulking support
    https://git.kernel.org/netdev/net-next/c/853246dbf5e8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


