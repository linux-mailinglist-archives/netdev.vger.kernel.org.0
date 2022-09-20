Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0897A5BEA62
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 17:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbiITPkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 11:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231282AbiITPkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 11:40:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 618E93FA26
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 08:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E901E624D1
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 15:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4EB6DC433D7;
        Tue, 20 Sep 2022 15:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663688416;
        bh=VNQA+SLgNpoIoTR264vCvzBjqjfNSXRnGRdVAhD9DFE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=H4vhwuui2aKbs0V5nUd0IhzLXDZTQ7Khv2L4p70bDUVOeevkefc20UTU5gZhueV2Y
         se88EPIP0rMNYL48nYdZ2w4cwzRl6zVX3TQ/fbwMkU75Bu5fvhoLR0PWPR96vWgMVl
         AHxSkub6A2u8ziXFAKCs/usbVkaJiL2roglZOX3TBAyxztYjNYy/MLxtm/I2LDZYL6
         cXGauILuC3X4ePTDQdvbAwW6nSXD1OllVVJq9j9vyJ9JlSq/xnQ+V/N2semLrN70ds
         W86tNoSZBDGtKavnw3xXLquMwAZ+QaQKUNwSgLI25Hbs5fj4/RRCcDpwFKsJinUPJ5
         /doL30F716X8w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2E8A7E5251D;
        Tue, 20 Sep 2022 15:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] ipmr: Always call ip{,6}_mr_forward() from RCU
 read-side critical section
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166368841618.10369.12614055755880402493.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 15:40:16 +0000
References: <20220914075339.4074096-1-idosch@nvidia.com>
In-Reply-To: <20220914075339.4074096-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, dsahern@gmail.com,
        mlxsw@nvidia.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 14 Sep 2022 10:53:37 +0300 you wrote:
> Patch #1 fixes a bug in ipmr code.
> 
> Patch #2 adds corresponding test cases.
> 
> Ido Schimmel (2):
>   ipmr: Always call ip{,6}_mr_forward() from RCU read-side critical
>     section
>   selftests: forwarding: Add test cases for unresolved multicast routes
> 
> [...]

Here is the summary with links:
  - [net,1/2] ipmr: Always call ip{,6}_mr_forward() from RCU read-side critical section
    https://git.kernel.org/netdev/net/c/b07a9b26e2b1
  - [net,2/2] selftests: forwarding: Add test cases for unresolved multicast routes
    https://git.kernel.org/netdev/net/c/2b5a8c8f59d9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


