Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92A5A525500
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 20:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357744AbiELSkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 14:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357728AbiELSkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 14:40:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5948270CAB;
        Thu, 12 May 2022 11:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6600EB82799;
        Thu, 12 May 2022 18:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 285E4C34100;
        Thu, 12 May 2022 18:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652380813;
        bh=dTv7tKT35uu565BSdqFAodZlglzhyhX9DdSTWzu9/f0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Mcv7wNyfSOwmrZVOLYjoA1NDDz0fbeOecwptRv0vB+kdzOUYhzhr3rQAtIOytBq6C
         6CkTe8VrdZzE1539uqQKmm1FUlr5fhf/nRVmPlSRwMSb4gBvoUtPmlcYM5bYKXfvoU
         Vf2vAxtuzzXaGfx2bxsv0xEhrPmR9ufL07hnpUPCvWmyqglAJYZpWsjWNVwLQ7WF/1
         oSGKUvIlhmKgfHuoE5TxcEPY5aDkzMvvxipLe3Ad2ftr/b5tz/v8u/UF3ZH2fwdKzy
         AmJqYIZcADO7pqSAqmqGwu6i5I4Bf/+EEKCIvZN53aga6X8lfcKE3cVq+XljinfDb1
         BmLsvAt0dJ9eg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 098C8F03937;
        Thu, 12 May 2022 18:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: bcm_sf2: Fix Wake-on-LAN with mac_link_down()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165238081303.29516.17594548345907038341.git-patchwork-notify@kernel.org>
Date:   Thu, 12 May 2022 18:40:13 +0000
References: <20220512021731.2494261-1-f.fainelli@gmail.com>
In-Reply-To: <20220512021731.2494261-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, rmk+kernel@armlinux.org.uk,
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

On Wed, 11 May 2022 19:17:31 -0700 you wrote:
> After commit 2d1f90f9ba83 ("net: dsa/bcm_sf2: fix incorrect usage of
> state->link") the interface suspend path would call our mac_link_down()
> call back which would forcibly set the link down, thus preventing
> Wake-on-LAN packets from reaching our management port.
> 
> Fix this by looking at whether the port is enabled for Wake-on-LAN and
> not clearing the link status in that case to let packets go through.
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: bcm_sf2: Fix Wake-on-LAN with mac_link_down()
    https://git.kernel.org/netdev/net/c/b7be130c5d52

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


