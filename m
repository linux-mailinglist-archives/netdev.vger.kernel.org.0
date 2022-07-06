Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EBF3567B81
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 03:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbiGFBaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 21:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiGFBaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 21:30:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 006DF17E33;
        Tue,  5 Jul 2022 18:30:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BB2B6115A;
        Wed,  6 Jul 2022 01:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DC1B7C341CB;
        Wed,  6 Jul 2022 01:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657071012;
        bh=QeUwpLlOAgnUhBbQtzpbmLpKQAcESAFld14MR9yIbmc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Hh0wFeq+FXqoX8By+RQPZ+VgB+hQ1cXEd1EXBwVmlzWiqUJK0a2WcNQLy9PfOiIeb
         9koGrseo5ssoaOPTU/p6/hr/Ehm+lUwVV1IxuHK4umMXOKtVSK+3UdwsPn2xfCKVpP
         iK+3uTLl5UetspGV7MWAd1DmPkdF9wzZWX7Vc2n3sMkGerno2H3KrZHy1IDlRPwz1r
         7MrW2JxwF208ZA2UeM1riXgbmGDG6slW1mPEkq7qO5vBQx1PQTx/gTRDkGFEiL8e2j
         V+mx0YPeFURlC94qMBiWya9XBDZxGzXP6nOqm9tjXZW87S429xn170Sro5R7p6HTSS
         jD7c5JmhrTRTA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B64A5E45BDC;
        Wed,  6 Jul 2022 01:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: lan966x: hardcode the number of external ports
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165707101274.30412.12835329155937789404.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Jul 2022 01:30:12 +0000
References: <20220704153654.1167886-1-michael@walle.cc>
In-Reply-To: <20220704153654.1167886-1-michael@walle.cc>
To:     Michael Walle <michael@walle.cc>
Cc:     horatiu.vultur@microchip.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        olteanv@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  4 Jul 2022 17:36:54 +0200 you wrote:
> Instead of counting the child nodes in the device tree, hardcode the
> number of ports in the driver itself.  The counting won't work at all
> if an ethernet port is marked as disabled, e.g. because it is not
> connected on the board at all.
> 
> It turns out that the LAN9662 and LAN9668 use the same switching IP
> with the same synthesis parameters. The only difference is that the
> output ports are not connected. Thus, we can just hardcode the
> number of physical ports to 8.
> 
> [...]

Here is the summary with links:
  - [net,v2] net: lan966x: hardcode the number of external ports
    https://git.kernel.org/netdev/net/c/e6fa930f73a1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


