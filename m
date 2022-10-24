Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8F75609F0C
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 12:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiJXKa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 06:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbiJXKaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 06:30:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D554431367;
        Mon, 24 Oct 2022 03:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A53C611D9;
        Mon, 24 Oct 2022 10:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BECFAC433C1;
        Mon, 24 Oct 2022 10:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666607419;
        bh=bJAYpL6ce+IfdfREACRzSrJJjiBAuy0B/CsUL+WRwpE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KLAjnlcH9YW9aQ2HxHT+t4zfMOkDtH+nGqEXC3Ve26vHNvBLGjJP1uYlFCJJdsgMq
         uR0Tg1xhiZbnc/UOe6Xg/SL4CY61Arh6hX/F5o9RExi1xmtIbPwmYGc2KLr532W8qB
         4E0P3WtTaeIJTnTerW+tQ/ANm2uQOrmFMkg5yMBzVfSBGTBO0iq19jg/A5zUKEE25I
         FiNIFR0o/qKLinA40r+c3m+Ozi1Y2TMZr1SvCl/nohH9K3dwhbM2o/9KAv/P/86K7q
         EaKgIXdV3kPUzJkvoFH/QeoLkQ95N8TxQEYRefI7h58HUfGA33E0NtuTk17+5RZZiz
         WdLpHXhF0+zYw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 99AD4E270DE;
        Mon, 24 Oct 2022 10:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/9] Add support for Sparx5 IS2 VCAP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166660741961.18313.1095799162478409748.git-patchwork-notify@kernel.org>
Date:   Mon, 24 Oct 2022 10:30:19 +0000
References: <20221020130904.1215072-1-steen.hegelund@microchip.com>
In-Reply-To: <20221020130904.1215072-1-steen.hegelund@microchip.com>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, UNGLinuxDriver@microchip.com,
        rdunlap@infradead.org, casper.casan@gmail.com,
        rmk+kernel@armlinux.org.uk, wanjiabing@vivo.com, nhuck@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 20 Oct 2022 15:08:55 +0200 you wrote:
> This provides initial support for the Sparx5 VCAP functionality via the
> 'tc' traffic control userspace tool and its flower filter.
> 
> Overview:
> =========
> 
> The supported flower filter keys and actions are:
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/9] net: microchip: sparx5: Adding initial VCAP API support
    https://git.kernel.org/netdev/net-next/c/8beef08f4618
  - [net-next,v3,2/9] net: microchip: sparx5: Adding IS2 VCAP model to VCAP API
    https://git.kernel.org/netdev/net-next/c/e8145e0685be
  - [net-next,v3,3/9] net: microchip: sparx5: Adding IS2 VCAP register interface
    https://git.kernel.org/netdev/net-next/c/45c00ad0030c
  - [net-next,v3,4/9] net: microchip: sparx5: Adding initial tc flower support for VCAP API
    https://git.kernel.org/netdev/net-next/c/c9da1ac1c212
  - [net-next,v3,5/9] net: microchip: sparx5: Adding port keyset config and callback interface
    https://git.kernel.org/netdev/net-next/c/46be056ee0fc
  - [net-next,v3,6/9] net: microchip: sparx5: Adding basic rule management in VCAP API
    https://git.kernel.org/netdev/net-next/c/8e10490b0064
  - [net-next,v3,7/9] net: microchip: sparx5: Writing rules to the IS2 VCAP
    https://git.kernel.org/netdev/net-next/c/683e05c03275
  - [net-next,v3,8/9] net: microchip: sparx5: Adding KUNIT test VCAP model
    https://git.kernel.org/netdev/net-next/c/5d7e5b0401d7
  - [net-next,v3,9/9] net: microchip: sparx5: Adding KUNIT test for the VCAP API
    https://git.kernel.org/netdev/net-next/c/67d637516fa9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


