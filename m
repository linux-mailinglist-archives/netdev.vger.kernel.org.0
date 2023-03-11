Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AACAF6B571F
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 01:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbjCKAx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 19:53:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231279AbjCKAxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 19:53:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D87E129705;
        Fri, 10 Mar 2023 16:51:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 057ACB82499;
        Sat, 11 Mar 2023 00:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AC188C4339B;
        Sat, 11 Mar 2023 00:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678495820;
        bh=itCIKp+T/ChdtHuLC7lbT4rOPxVaUZ/mprlKltObUZ0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JqZVdsXDDoQ74/fHrVuPBp8Q75b4xdt/LdmFoYxGXdhnnV2IvtZL1yNF40cir8AoN
         Q20yif8CY9NUF7WxDn7Isr6KAm31qISxKbWwqFpq0v/l9dU7X5pj1WCVvVEOuSNHYF
         FET4nlGZD7UEzaFq7FTJCAu41CMUXQAMpWpp0vQFBnksVie8qsm4o9Did/Ksvi6P5u
         iCagZhKeeUeZ3inBrEgpAiKtdKfAuy8wDdCGlhLXbbVRkv70Oz0gWFlRviUl1+dH27
         V4HeIx5/52AUPId1svDjIhpIuMH93dwS/pvi+zbHOjFsd695Cxencf3xDRhMT0MQJI
         6z/hCYs5etvZw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9336BE21EEA;
        Sat, 11 Mar 2023 00:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] net: lan966x: Add support for IS1 VCAP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167849582059.26321.14426689985313945579.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Mar 2023 00:50:20 +0000
References: <20230307220929.834219-1-horatiu.vultur@microchip.com>
In-Reply-To: <20230307220929.834219-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        lars.povlsen@microchip.com, Steen.Hegelund@microchip.com,
        daniel.machon@microchip.com, UNGLinuxDriver@microchip.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 7 Mar 2023 23:09:24 +0100 you wrote:
> Provide the Ingress Stage 1 (IS1) VCAP (Versatile Content-Aware
> Processor) support for the Lan966x platform.
> 
> The IS1 VCAP has 3 lookups and they are accessible with a TC chain id:
> - chain 1000000: IS1 Lookup 0
> - chain 1100000: IS1 Lookup 1
> - chain 1200000: IS1 Lookup 2
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] net: lan966x: Add IS1 VCAP model
    https://git.kernel.org/netdev/net-next/c/99ce286d2d30
  - [net-next,2/5] net: lan966x: Add IS1 VCAP keyset configuration for lan966x
    https://git.kernel.org/netdev/net-next/c/a4d9b3ec63de
  - [net-next,3/5] net: lan966x: Add TC support for IS1 VCAP
    https://git.kernel.org/netdev/net-next/c/135c2116fd03
  - [net-next,4/5] net: lan966x: Add TC filter chaining support for IS1 and IS2 VCAPs
    https://git.kernel.org/netdev/net-next/c/b3762a9db39c
  - [net-next,5/5] net: lan966x: Add support for IS1 VCAP ethernet protocol types
    https://git.kernel.org/netdev/net-next/c/44d706fde755

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


