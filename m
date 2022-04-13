Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B96434FF60F
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 13:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235219AbiDMLwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 07:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235315AbiDMLwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 07:52:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE6B22DD48
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 04:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 614ED61DF6
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 11:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B4432C385A8;
        Wed, 13 Apr 2022 11:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649850615;
        bh=EkYf4W/6a0hc++lNLSb+9udxrrCvIzsl63ZBsRZVcMA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OKtqEzUjcZJMnsmDxu2WM7KKA2PqDZ4IStWjC48eXWCTZ7IbxTwEONeOb0pMuqvO3
         wcLLBXddR6GbUf3OyocFQ3GAJ0CWMyHrvjEQ9lbk877w0vRBAPIG4VOS0XgGnt3+zn
         DHiyEXpwygo1MrQnBA6f8XaevYfUbt0dj338Q0zWLr4MDpyAsFQFUJ6MK0TaWoSBQm
         6IXeEz6SoS/O8w7ZllJ6R4W5BpRYfSAFqbAO7gv99bBnOlKxEZMD0uIsThxdvV5HLY
         bC3bJDLMVupi81w2Pzyb8Ei5AZWSbTEk3fDQ/qUkz1KSyv+iFNQr6l536muhWxH1cX
         WqvEhXRSJpaWA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 988F4E8DD69;
        Wed, 13 Apr 2022 11:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phylink: remove phylink_helper_basex_speed()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164985061562.24768.136872357662331112.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Apr 2022 11:50:15 +0000
References: <E1neDgm-005IBR-BW@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1neDgm-005IBR-BW@rmk-PC.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 12 Apr 2022 11:24:00 +0100 you wrote:
> As there are now no users of phylink_helper_basex_speed(), we can
> remove this obsolete functionality.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
> The last user was the mt7530 driver which has just been merged.
> 
> [...]

Here is the summary with links:
  - [net-next] net: phylink: remove phylink_helper_basex_speed()
    https://git.kernel.org/netdev/net-next/c/1a95e04e29a1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


