Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D419868069E
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 08:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235457AbjA3HkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 02:40:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235365AbjA3HkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 02:40:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D4EE29153;
        Sun, 29 Jan 2023 23:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E79560D3A;
        Mon, 30 Jan 2023 07:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 804AFC4339C;
        Mon, 30 Jan 2023 07:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675064418;
        bh=9Fwc85MZMhR2yS2+ET9itw5LJtEX8IquDh3uMOoxktg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HHVMSfoHhp2/c9k2v0KSMSrYNQhRsHUog6EDm0dm8hNp2pPIHIT6r+WRxQuq009wN
         Z1/LFjjFNbNRRfIRK3vijUxiwYVuidykXqE9im055gedQbIk0Ek5xG2O+FXQUlV599
         QQ9QUELGRXDIwpyPsioAlG0F/4t6UonAwPzMWx3S6M0gW+L0m2yPR7uOj2PMI5MQLO
         MJsuOoJ5Z6D7glVr5be7TQI3K4+WU8o1BXsjpvg+UbYuBUVJk2+dcjWevOi1gxaQ3E
         qp5wlCuffg6Hna7tg+WOLxW9u/xoKBeukRWf+zgn+km0wVwKqGSS9JtKmo55up1rLH
         mkvjAqTv+gDMg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5F24BC4314C;
        Mon, 30 Jan 2023 07:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8] Adding Sparx5 ES2 VCAP support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167506441838.19672.6690813495078695286.git-patchwork-notify@kernel.org>
Date:   Mon, 30 Jan 2023 07:40:18 +0000
References: <20230127130830.1481526-1-steen.hegelund@microchip.com>
In-Reply-To: <20230127130830.1481526-1-steen.hegelund@microchip.com>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, UNGLinuxDriver@microchip.com,
        rdunlap@infradead.org, casper.casan@gmail.com,
        rmk+kernel@armlinux.org.uk, wanjiabing@vivo.com, nhuck@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Steen.Hegelund@microchip.com,
        daniel.machon@microchip.com, horatiu.vultur@microchip.com,
        lars.povlsen@microchip.com, error27@gmail.com, michael@walle.cc
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 27 Jan 2023 14:08:22 +0100 you wrote:
> This provides the Egress Stage 2 (ES2) VCAP (Versatile Content-Aware
> Processor) support for the Sparx5 platform.
> 
> The ES2 VCAP is an Egress Access Control VCAP that uses frame keyfields and
> previously classified keyfields to apply e.g. policing, trapping or
> mirroring to frames.
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] net: microchip: sparx5: Add support for getting keysets without a type id
    https://git.kernel.org/netdev/net-next/c/c02b19edc78d
  - [net-next,2/8] net: microchip: sparx5: Improve the IP frame key match for IPv6 frames
    https://git.kernel.org/netdev/net-next/c/4114ef2ce273
  - [net-next,3/8] net: microchip: sparx5: Improve error message when parsing CVLAN filter
    https://git.kernel.org/netdev/net-next/c/a5300724ce73
  - [net-next,4/8] net: microchip: sparx5: Add ES2 VCAP model and updated KUNIT VCAP model
    https://git.kernel.org/netdev/net-next/c/9d712b8ddbb4
  - [net-next,5/8] net: microchip: sparx5: Add ES2 VCAP keyset configuration for Sparx5
    https://git.kernel.org/netdev/net-next/c/b95d9e2c20c9
  - [net-next,6/8] net: microchip: sparx5: Add ingress information to VCAP instance
    https://git.kernel.org/netdev/net-next/c/e7e3f514713e
  - [net-next,7/8] net: microchip: sparx5: Add TC support for the ES2 VCAP
    https://git.kernel.org/netdev/net-next/c/7b911a5311b8
  - [net-next,8/8] net: microchip: sparx5: Add KUNIT tests for enabling/disabling chains
    https://git.kernel.org/netdev/net-next/c/1f741f001160

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


