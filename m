Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C957E615B75
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 05:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbiKBEaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 00:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiKBEaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 00:30:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA7924966;
        Tue,  1 Nov 2022 21:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53631617EF;
        Wed,  2 Nov 2022 04:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9FE88C433D7;
        Wed,  2 Nov 2022 04:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667363417;
        bh=ltdIYqwnIlYSHAjUqRXwiEmQ2apR906HPsgPrX5RFZM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qXNtL/M7WgHHNoE38gAmbtTeHPG6fEugKBdIFOMg2SwIjZ1bVP+zmcCaaUjJxiyfV
         wh9zfZkIwIVHi+Yr2emcshihF/99ojkZb4RbNK99zPZWNIbHhsuvSVYH31fRg+awnL
         iS7zhAZiD5urkIOwHsBhDqhEH4mB4IikpmMbOjX5GxUjaFqFPMWxqFIrTAxN9fBvyx
         yLf6PfKYRY9tEiTJdGWbV08TB5vdTXveV8aZuEqqoed2StTUiQLFlH3qmzLVjRk2a7
         vzAELvb6lheTc/Pnfrwr+5me70TkVp6oD5k2oZ2oJg5W6MDgOZexfPoocrMazNmwwh
         yPdn5E6UQ+z6Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7DFEAE270D6;
        Wed,  2 Nov 2022 04:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: lan966x: Fix unmapping of received frames using FDMA
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166736341750.16570.4089002649799561843.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Nov 2022 04:30:17 +0000
References: <20221031133421.1283196-1-horatiu.vultur@microchip.com>
In-Reply-To: <20221031133421.1283196-1-horatiu.vultur@microchip.com>
To:     'Horatiu Vultur' <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, UNGLinuxDriver@microchip.com
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 31 Oct 2022 14:34:21 +0100 you wrote:
> When lan966x was receiving a frame, then it was building the skb and
> after that it was calling dma_unmap_single with frame size as the
> length. This actually has 2 issues:
> 1. It is using a length to map and a different length to unmap.
> 2. When the unmap was happening, the data was sync for cpu but it could
>    be that this will overwrite what build_skb was initializing.
> 
> [...]

Here is the summary with links:
  - [net] net: lan966x: Fix unmapping of received frames using FDMA
    https://git.kernel.org/netdev/net/c/fc57062f98b0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


