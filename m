Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1F7566A988
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 07:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjANGAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 01:00:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjANGAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 01:00:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E3284487;
        Fri, 13 Jan 2023 22:00:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4CF6B8015B;
        Sat, 14 Jan 2023 06:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1F2F7C433EF;
        Sat, 14 Jan 2023 06:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673676020;
        bh=vZ8PPpoW6Hst/8E4kAFPPZ0jO6XPdDimrz8sBOhlOGA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Sys6INwnEtOvZccAyqntxFyVP/uNSnKHIbisiwJBCEHrndMjzNOuRIlm+0y7RHAAw
         qQTP6Olecut4FZOfFvdes7R9rblr0exS0TeKg3yEjkaFIrJtAhQf7S8fJLzFLwod+T
         1MCRhBHvbnr1G8TOi0uOoYRIaHYLltgc/gvaq1DfqceFo/wmQAtfO1MxnLkCurTvf3
         POrFKjVcADgttAlw+mmxVFuzvz5m0aJRzTsjGkQ9UugJoSVips5V0aPXH+BmVyan6/
         nrivUzCxI9XAjaf7lJ+iCeRxc5ODCB0bnelsTug2IACbsIWW8V93RBYwie2S+mQ+Vb
         ERcyyldwBkg9Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 07FDBE270DD;
        Sat, 14 Jan 2023 06:00:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: lan966x: add missing fwnode_handle_put() for ports
 node
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167367602002.19323.1560955353082376215.git-patchwork-notify@kernel.org>
Date:   Sat, 14 Jan 2023 06:00:20 +0000
References: <20230112161311.495124-1-clement.leger@bootlin.com>
In-Reply-To: <20230112161311.495124-1-clement.leger@bootlin.com>
To:     =?utf-8?b?Q2zDqW1lbnQgTMOpZ2VyIDxjbGVtZW50LmxlZ2VyQGJvb3RsaW4uY29tPg==?=@ci.codeaurora.org
Cc:     horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 12 Jan 2023 17:13:11 +0100 you wrote:
> Since the "ethernet-ports" node is retrieved using
> device_get_named_child_node(), it should be release after using it. Add
> missing fwnode_handle_put() and move the code that retrieved the node
> from device-tree to avoid complicated handling in case of error.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> 
> [...]

Here is the summary with links:
  - [net] net: lan966x: add missing fwnode_handle_put() for ports node
    https://git.kernel.org/netdev/net/c/925f3deb45df

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


