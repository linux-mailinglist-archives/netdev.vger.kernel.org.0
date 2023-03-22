Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76F936C4A8D
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 13:30:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbjCVMae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 08:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbjCVMaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 08:30:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 136AF50F85;
        Wed, 22 Mar 2023 05:30:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D4FEB81CA9;
        Wed, 22 Mar 2023 12:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1F981C4339B;
        Wed, 22 Mar 2023 12:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679488219;
        bh=PTopnY57lyUVGbtedv6nlXZOc6qyeLwJVrHnrZwy0+s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NROZeOObCUvf4sLw+PGnpxR6UremYi+TQ+jFYiVOylBLQCFe4YDKtaJ7k6tDVVR14
         EH3IPLky2hsBCw38bm+etpe1U9Cz3+v5l3cjW0eg3/anyK9kVQACHCweXHeczVU9xi
         3BoQgcirqf/lMWZ8AoBN31ylMif1NT8+rCwRt50twDsCvMdRQh2ne1IpoUaOCrhFcb
         uIjFP2PUvnl5uKGkeyEfaEKQReoL23KWb0BYcIzKQdiEsiRa/uUGKD0EvSeuuW6kze
         NBAAvLzjspDtplas6JkSpvQxWpkTNAlHooelHvpWnMTlUoc9W/FV2FzqyqnT9F4dx1
         5Tmrd4EsOohdQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 035E1E66C8C;
        Wed, 22 Mar 2023 12:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] sh_eth: remove open coded netif_running()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167948821900.6670.3791726075792773514.git-patchwork-notify@kernel.org>
Date:   Wed, 22 Mar 2023 12:30:19 +0000
References: <20230321065826.2044-1-wsa+renesas@sang-engineering.com>
In-Reply-To: <20230321065826.2044-1-wsa+renesas@sang-engineering.com>
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        geert+renesas@glider.be, s.shtylyov@omp.ru, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 21 Mar 2023 07:58:26 +0100 you wrote:
> It had a purpose back in the days, but today we have a handy helper.
> 
> Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
> ---
> 
> Based on 6.3-rc3 and tested on a Renesas Lager board (R-Car H2).
> 
> [...]

Here is the summary with links:
  - [net-next] sh_eth: remove open coded netif_running()
    https://git.kernel.org/netdev/net-next/c/ce1fdb065695

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


