Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CAF450858A
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 12:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377551AbiDTKNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 06:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377502AbiDTKM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 06:12:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE0DE3EBB6;
        Wed, 20 Apr 2022 03:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82D5361756;
        Wed, 20 Apr 2022 10:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9EB0CC385AA;
        Wed, 20 Apr 2022 10:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650449412;
        bh=33v1fCpKlgfxNoAa7aF/5COUc2afD4f94mYYvEpenVo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KJ5mifsnYE3kYckjbWvGHqiK0tmqIvdyCvgQTXPh8D1hxchyLzQfz1+b4Pd64LzfF
         RaZ3Tp0DwuqFHOsJKOEilCCdlg4OpPewk4nAPSCxWktxbJnZIo8D8+QFm2p1qGx1V8
         bAuNe8bTDgDSB/Vy0O7sP1hI7iHLfOP2vg8Q+FFhNEJsoHU2wy+E0eT6/3VnmxIMXW
         BkiuXoHB4GIsrn6HuqZK5vEq3/K3MMcwXPNkC226i1ABTKzqfqsit0ELJsMgPrcmbT
         KwylljOjJ9ZjxLR3weuLgPoNtwVeVs4pCwsjCBzZF1Rv0mXPj7OyrAl1mESdRGlyub
         KpFzEM8G1URtw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7C3AEF0383D;
        Wed, 20 Apr 2022 10:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 1/2] dt-bindings: net: dsa: realtek: cleanup compatible
 strings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165044941250.8751.17513068846690831070.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Apr 2022 10:10:12 +0000
References: <20220418233558.13541-1-luizluca@gmail.com>
In-Reply-To: <20220418233558.13541-1-luizluca@gmail.com>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, linus.walleij@linaro.org,
        alsi@bang-olufsen.dk, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzk+dt@kernel.org, arinc.unal@arinc9.com,
        devicetree@vger.kernel.org
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

On Mon, 18 Apr 2022 20:35:57 -0300 you wrote:
> Compatible strings are used to help the driver find the chip ID/version
> register for each chip family. After that, the driver can setup the
> switch accordingly. Keep only the first supported model for each family
> as a compatible string and reference other chip models in the
> description.
> 
> The removed compatible strings have never been used in a released kernel.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/2] dt-bindings: net: dsa: realtek: cleanup compatible strings
    https://git.kernel.org/netdev/net-next/c/6f2d04ccae9b
  - [net,v2,2/2] net: dsa: realtek: remove realtek,rtl8367s string
    https://git.kernel.org/netdev/net-next/c/fcd30c96af95

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


