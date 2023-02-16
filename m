Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8C0698EB0
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 09:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjBPIaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 03:30:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjBPIaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 03:30:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB6E2CC45;
        Thu, 16 Feb 2023 00:30:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B82D3B8265F;
        Thu, 16 Feb 2023 08:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 33E0EC4339B;
        Thu, 16 Feb 2023 08:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676536219;
        bh=BoI3Pa5/8NBSfjvMPIAStqEd9DYVS/ieE9UgjkVV5bE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ax2KpHwcRtYKxX2JPuCgBzUGN3n4xSKpKATqqVyCbHckiFydU9U5sg+eYVDc2LMkU
         ORIbSKYskRNaTRBNgeRmQrci1hPPhH1ZF6YLbVJmG3SrIyn4ALVBnTxZOIR0mDXmRu
         q+b47jz7neOpom9Rt/7M45XcbadtmaB7j/TNQlpg8GUy7KMQoxXXXJGUSYVWodSR2+
         SiP85nafE7BIyPcJYSqswPsY64Qc3BefOIC25il3wdqn6e/2X3TEfXP7RcswkWAJXD
         Oo+98QEfl/yhnTWHTZprbjpX+QjryenUKXNClb4ZVoJAMCLlEVeSTYlI/MNDRCu0Ao
         B/RyevKn5rWew==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 14927E29F3F;
        Thu, 16 Feb 2023 08:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 00/10] Adding Sparx5 ES0 VCAP support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167653621907.28100.17908588254142053263.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Feb 2023 08:30:19 +0000
References: <20230214104049.1553059-1-steen.hegelund@microchip.com>
In-Reply-To: <20230214104049.1553059-1-steen.hegelund@microchip.com>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, UNGLinuxDriver@microchip.com,
        rdunlap@infradead.org, casper.casan@gmail.com,
        rmk+kernel@armlinux.org.uk, wanjiabing@vivo.com, nhuck@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Steen.Hegelund@microchip.com,
        daniel.machon@microchip.com, horatiu.vultur@microchip.com,
        lars.povlsen@microchip.com, error27@gmail.com, michael@walle.cc
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 14 Feb 2023 11:40:39 +0100 you wrote:
> This provides the Egress Stage 0 (ES0) VCAP (Versatile Content-Aware
> Processor) support for the Sparx5 platform.
> 
> The ES0 VCAP is an Egress Access Control VCAP that uses frame keyfields and
> previously classified keyfields to add, rewrite or remove VLAN tags on the
> egress frames, and is therefore often referred to as the rewriter.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,01/10] net: microchip: sparx5: Discard frames with SMAC multicast addresses
    https://git.kernel.org/netdev/net-next/c/65b6625069a4
  - [net-next,v2,02/10] net: microchip: sparx5: Clear rule counter even if lookup is disabled
    https://git.kernel.org/netdev/net-next/c/d7953da4f293
  - [net-next,v2,03/10] net: microchip: sparx5: Egress VLAN TPID configuration follows IFH
    https://git.kernel.org/netdev/net-next/c/38f6408c6071
  - [net-next,v2,04/10] net: microchip: sparx5: Use chain ids without offsets when enabling rules
    https://git.kernel.org/netdev/net-next/c/0518e914f34a
  - [net-next,v2,05/10] net: microchip: sparx5: Improve the error handling for linked rules
    https://git.kernel.org/netdev/net-next/c/b5b0c3645988
  - [net-next,v2,06/10] net: microchip: sparx5: Add ES0 VCAP model and updated KUNIT VCAP model
    https://git.kernel.org/netdev/net-next/c/a5cc98adf3cb
  - [net-next,v2,07/10] net: microchip: sparx5: Updated register interface with VCAP ES0 access
    https://git.kernel.org/netdev/net-next/c/f2a77dd69f51
  - [net-next,v2,08/10] net: microchip: sparx5: Add ES0 VCAP keyset configuration for Sparx5
    https://git.kernel.org/netdev/net-next/c/3cbe7537a7f1
  - [net-next,v2,09/10] net: microchip: sparx5: Add TC support for the ES0 VCAP
    https://git.kernel.org/netdev/net-next/c/52b28a93c45d
  - [net-next,v2,10/10] net: microchip: sparx5: Add TC vlan action support for the ES0 VCAP
    https://git.kernel.org/netdev/net-next/c/ebf44ded76e9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


