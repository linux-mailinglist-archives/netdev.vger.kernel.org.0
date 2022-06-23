Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89369556FFF
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 03:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356130AbiFWBkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 21:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348606AbiFWBkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 21:40:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97C554338C;
        Wed, 22 Jun 2022 18:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB52FB8216E;
        Thu, 23 Jun 2022 01:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 750F7C341C7;
        Thu, 23 Jun 2022 01:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655948413;
        bh=07aI1xjjbUFLt8N5hrH4xmABdRaHtqSi3SbPqwfHhWE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sBcnRN7APxv8po0bQvScTURRxwFl6xO/eA5XXok64dvZMoIzsafgZ5pvUSlPni57n
         4vERmunzJYcBq1+kts36YspQ3lIAzZUDt8ZwrDD28LvmcApNemyHI4+G+5qIhIfq5z
         krqrpyoT/Tyj97q+OkoVnAfexJ58H/SE5COzeY4NM51ztiMl4xvuDVQuey5sNXJMTh
         XfCgBjZ3Kb9ao/rnW1bZ6tmO6W9xUsCuJRmDYhUdBcQWh4E5yVmATkGVjwOFzHR7Tg
         EkPEdsoCbWg/+wAH2rDeQMyplKWl5PFxTPKkXDjFusDnu1LojuZV2jUMnaoNIakhGJ
         QHhnSEYlhRxLw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5C39EE7386C;
        Thu, 23 Jun 2022 01:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: dsa: qca8k: reduce mgmt ethernet timeout
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165594841337.25849.11519091979168825914.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Jun 2022 01:40:13 +0000
References: <20220621151633.11741-1-ansuelsmth@gmail.com>
In-Reply-To: <20220621151633.11741-1-ansuelsmth@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 21 Jun 2022 17:16:33 +0200 you wrote:
> The current mgmt ethernet timeout is set to 100ms. This value is too
> big and would slow down any mdio command in case the mgmt ethernet
> packet have some problems on the receiving part.
> Reduce it to just 5ms to handle case when some operation are done on the
> master port that would cause the mgmt ethernet to not work temporarily.
> 
> Fixes: 5950c7c0a68c ("net: dsa: qca8k: add support for mgmt read/write in Ethernet packet")
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: dsa: qca8k: reduce mgmt ethernet timeout
    https://git.kernel.org/netdev/net/c/85467f7da189

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


