Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1A345F2E7F
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 11:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbiJCJvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 05:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbiJCJvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 05:51:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35AE917E32;
        Mon,  3 Oct 2022 02:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED3FEB80F01;
        Mon,  3 Oct 2022 09:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8CCC2C433D6;
        Mon,  3 Oct 2022 09:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664790614;
        bh=Ht/U0qko1eD4sGnYBSJaML5quvU0H7269FRiH21oUkc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=V0hLZqgjpSrXX9K+ROTSeSllAiJ4U45c5/PqppnLsUEZxw0FipXAEDwGWdM4sIDpb
         6zu5fAYsvpB8Ff1TD/dfyQLGhV5PMpb/lOq00/x5nuKBkM+B/bNZcxxbCWk4YFF+Bq
         EQiLBboy2n2+LRNvyFtQBQT4sY1YD3FZYS5X8GTJxoe+V3hx9bUxmT7Ut5ajU/BWFR
         eaHDo6GHHQyDpD7iwSpCgDC8cjWWMUIFdeLHoxFddZ3ztiEBOdEMMUrYkTo6J/wPED
         pu9iDfxwOULTS2UA7HYTP075j+N+04scnX++6W3LjI2SPf6dIchLUTrT0m/1Jhsd3b
         N820ot0oiJ+RA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 67EBCE49FA3;
        Mon,  3 Oct 2022 09:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: sparx5: Fix return type of sparx5_port_xmit_impl
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166479061442.29582.11755477144424955738.git-patchwork-notify@kernel.org>
Date:   Mon, 03 Oct 2022 09:50:14 +0000
References: <20220929181947.62909-1-nhuck@google.com>
In-Reply-To: <20220929181947.62909-1-nhuck@google.com>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     kuba@kernel.org, Steen.Hegelund@microchip.com,
        UNGLinuxDriver@microchip.com, casper.casan@gmail.com,
        davem@davemloft.net, edumazet@google.com, error27@gmail.com,
        horatiu.vultur@microchip.com, lars.povlsen@microchip.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, nathan@kernel.org, ndesaulniers@google.com,
        netdev@vger.kernel.org, pabeni@redhat.com, trix@redhat.com
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
by David S. Miller <davem@davemloft.net>:

On Thu, 29 Sep 2022 11:19:47 -0700 you wrote:
> The ndo_start_xmit field in net_device_ops is expected to be of type
> netdev_tx_t (*ndo_start_xmit)(struct sk_buff *skb, struct net_device *dev).
> 
> The mismatched return type breaks forward edge kCFI since the underlying
> function definition does not match the function hook definition.
> 
> The return type of sparx5_port_xmit_impl should be changed from int to
> netdev_tx_t.
> 
> [...]

Here is the summary with links:
  - [v2] net: sparx5: Fix return type of sparx5_port_xmit_impl
    https://git.kernel.org/netdev/net/c/73ea73507359

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


