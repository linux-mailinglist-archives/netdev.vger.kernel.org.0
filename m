Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A62B454DDE8
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 11:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376569AbiFPJKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 05:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359112AbiFPJKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 05:10:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BA8E52E75;
        Thu, 16 Jun 2022 02:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC2A9B82330;
        Thu, 16 Jun 2022 09:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 646AEC3411C;
        Thu, 16 Jun 2022 09:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655370614;
        bh=v3LzgN/UAeNgTRLw78tfLU45yvH+bg2GM46GCAKKCOk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aou3pE7C2Gn3QjhYNlzk6UvJxqzpRGAtvhjPipzb/UlW5J3OUHvYZfZSU8c1JtI2W
         lqUw03b0WSx9VfM1R0DWUjA7NmJJIN2F5/qIVad6iesgoYEC2JhqQASJ2JGfl9HJ/1
         OPCNOPJzKq0oYJPkRC7tXtCUqAP/r+maRUnN5q17NdgIRVYJ8LG274UkjG7muBuPNz
         mx+XTAvhHqnUKOyu+Xh/P5243hXsxoV8YYSOegephqZ5lWsj630LHFYB9NDK/Dk5vT
         //QzhIRA1qtiVq6CiS/zdO3+VM6PYBh0cOlpwazirnnoLY+UxO0qh/p/oRiMVnYd2b
         LLeJYY/7+to7Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 446CDE7385C;
        Thu, 16 Jun 2022 09:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next,v2,0/2] net: mana: Add PF and XDP_REDIRECT support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165537061427.3948.3823927999620148456.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Jun 2022 09:10:14 +0000
References: <1655238535-19257-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1655238535-19257-1-git-send-email-haiyangz@microsoft.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        decui@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        paulros@microsoft.com, shacharr@microsoft.com, olaf@aepfle.de,
        vkuznets@redhat.com, davem@davemloft.net,
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

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 14 Jun 2022 13:28:53 -0700 you wrote:
> The patch set adds PF and XDP_REDIRECT support.
> 
> Dexuan Cui (1):
>   net: mana: Add the Linux MANA PF driver
> 
> Haiyang Zhang (1):
>   net: mana: Add support of XDP_REDIRECT action
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] net: mana: Add the Linux MANA PF driver
    https://git.kernel.org/netdev/net-next/c/1566e7d6206f
  - [net-next,v2,2/2] net: mana: Add support of XDP_REDIRECT action
    https://git.kernel.org/netdev/net-next/c/7a8938cd024d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


