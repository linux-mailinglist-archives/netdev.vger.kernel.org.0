Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1604B4CE469
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 12:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbiCELLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 06:11:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiCELLC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 06:11:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3870B57B0B
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 03:10:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9FAACB80AB0
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 11:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3A220C340F1;
        Sat,  5 Mar 2022 11:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646478610;
        bh=NTnIdgyuKFnpjk563SUcqlHYoCMmpONi2LiVsZQkJoE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XFFjMY+C6il0R+DFv7jdyla1VY7kOQY4GJJnPmSs1vRdX0mmVUWid34E4XQ0nYGAc
         qkhi3kvfg/uRgLLBfTrfBzbhIBbgF209Pi8AsBLh4PV/8Mk7be4m+zrThFqYIySY9r
         04iz2QmjjSLzSpiulMoqVEcZY+vF7ouUOWt3atBvnh1jGifsgyKBp/CKMWvF/kpM4i
         3wbtStH9Hd7+k0VJs940kk8pdWba/I6sDdlamJc4S9a0g356SwNUPHHqA6C1Bk8TUw
         fKi9NubXcRiunPWB6+9LLc8bcXMA0GPK6O66ioof/IfKVmL8dWfzrq3d+DDbxUl+Km
         7rMBQdhekp1hQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1E9B6EAC095;
        Sat,  5 Mar 2022 11:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v5 0/3] net: dsa: realtek: add rtl8_4t tag
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164647861012.11318.812242174220088028.git-patchwork-notify@kernel.org>
Date:   Sat, 05 Mar 2022 11:10:10 +0000
References: <20220303015235.18907-1-luizluca@gmail.com>
In-Reply-To: <20220303015235.18907-1-luizluca@gmail.com>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, linus.walleij@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  2 Mar 2022 22:52:32 -0300 you wrote:
> This patch series adds support for rtl8_4t tag. It is a variant of
> rtl8_4 tag, with identical values but placed at the end of the packet
> (before CRC).
> 
> It forces checksum in software before adding the tag as those extra
> bytes at the end of the packet would be summed together with the rest of
> the payload. When the switch removes the tag before sending the packet
> to the network, that checksum will not match.
> 
> [...]

Here is the summary with links:
  - [net-next,v5,1/3] dt-bindings: net: dsa: add rtl8_4 and rtl8_4t tag formats
    https://git.kernel.org/netdev/net-next/c/617c3cc3aafd
  - [net-next,v5,2/3] net: dsa: tag_rtl8_4: add rtl8_4t trailing variant
    https://git.kernel.org/netdev/net-next/c/cd87fecdedd7
  - [net-next,v5,3/3] net: dsa: realtek: rtl8365mb: add support for rtl8_4t
    https://git.kernel.org/netdev/net-next/c/59dc7b4f7f45

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


