Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C16D519294
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 02:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244421AbiEDAOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 20:14:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232949AbiEDANw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 20:13:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 226E4A3;
        Tue,  3 May 2022 17:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 905B9B82270;
        Wed,  4 May 2022 00:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 373C2C385AF;
        Wed,  4 May 2022 00:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651623011;
        bh=TxkQO35EyZiqOa7CXy+eVYupNBIXHguoftlLt5CDOAE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=f/5ngEI1ddBoMN/xezCzDomXIQNUlL/ovCJ2NK3GqFRafviCTVtuv6CvcNY3YgQET
         v1nxGeCtLLsnsEjvGycG/B0O86TCoP2jHwq0OpP1qJEeWV8V/ULQR8s/Uxhgy6JuLL
         eZcTLPA/Yudpy0VYq0FQcyXgLNuxsb+8GhZKgq/eYVQ97pGBxbohCPqRr1FSbVlcp3
         gWfAvfl2+GZXX3mL2Ybg2M3jq7vRYOgXksuBhfRhw8Uw9J/NQMid9wGzYKkQcv/yAW
         9a5nSNAiSd4RV/U/fO/SFUHnvr3GSzFzN+GkyqcJywwQ7VWUfb11a0iW561Tq9G1di
         yOg2FmXiww2uA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1B39FE7399D;
        Wed,  4 May 2022 00:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] smsc911x: allow using IRQ0
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165162301110.12177.14437301464055233758.git-patchwork-notify@kernel.org>
Date:   Wed, 04 May 2022 00:10:11 +0000
References: <656036e4-6387-38df-b8a7-6ba683b16e63@omp.ru>
In-Reply-To: <656036e4-6387-38df-b8a7-6ba683b16e63@omp.ru>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        steve.glendinning@shawell.net, edumazet@google.com,
        pabeni@redhat.com, linux-sh@vger.kernel.org
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

On Mon, 2 May 2022 23:14:09 +0300 you wrote:
> The AlphaProject AP-SH4A-3A/AP-SH4AD-0A SH boards use IRQ0 for their SMSC
> LAN911x Ethernet chip, so the networking on them must have been broken by
> commit 965b2aa78fbc ("net/smsc911x: fix irq resource allocation failure")
> which filtered out 0 as well as the negative error codes -- it was kinda
> correct at the time, as platform_get_irq() could return 0 on of_irq_get()
> failure and on the actual 0 in an IRQ resource.  This issue was fixed by
> me (back in 2016!), so we should be able to fix this driver to allow IRQ0
> usage again...
> 
> [...]

Here is the summary with links:
  - smsc911x: allow using IRQ0
    https://git.kernel.org/netdev/net/c/5ef9b803a4af

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


