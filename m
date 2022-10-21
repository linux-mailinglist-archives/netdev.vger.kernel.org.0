Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A39CA606F31
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 07:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbiJUFKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 01:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiJUFKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 01:10:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2DA4B7EDD;
        Thu, 20 Oct 2022 22:10:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F00761DC8;
        Fri, 21 Oct 2022 05:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A2A6EC4347C;
        Fri, 21 Oct 2022 05:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666329020;
        bh=37ZJQdYjGxr6XTk8ViZLdC2vTV1Y908CsCupTVXJ+Zo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ukPBUcigWcdYb3k1pemmfpcEpQDWVm9703Cf5NVIv5LkhgwYqkRrVJwhKzzFqirSD
         tbOLuS1ysSJSWxI4Ol81khDeafAKRxbufll3ij0k6mEImA0IsekMbFnOMhrOmeUido
         T48n7GUAmTiJ+OMOLWp4beoV2jI3OAx003hdfpXg2CfThHtrLu5rOF5SXFDJc9e9m9
         vQt9NsE5FCd63xetuEsTXsmxO/kuu68oKYwMpwmTUtqXXRY62ph7fksq6JHxVOJLPK
         kdbq0bVXfek6ilqbhynStymoGA1CY4XgYLf2ZxX3UdxiGwFOiYB5grVLwL8LAwySS8
         SRE71fXDmoKiw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 896F3E270E2;
        Fri, 21 Oct 2022 05:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: lan966x: Fix the rx drop counter
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166632902055.25874.960134667517802573.git-patchwork-notify@kernel.org>
Date:   Fri, 21 Oct 2022 05:10:20 +0000
References: <20221019083056.2744282-1-horatiu.vultur@microchip.com>
In-Reply-To: <20221019083056.2744282-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, UNGLinuxDriver@microchip.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 19 Oct 2022 10:30:56 +0200 you wrote:
> Currently the rx drop is calculated as the sum of multiple HW drop
> counters. The issue is that not all the HW drop counters were added for
> the rx drop counter. So if for example you have a police that drops
> frames, they were not see in the rx drop counter.
> Fix this by updating how the rx drop counter is calculated. It is
> required to add also RX_RED_PRIO_* HW counters.
> 
> [...]

Here is the summary with links:
  - [net] net: lan966x: Fix the rx drop counter
    https://git.kernel.org/netdev/net/c/f8c1c66b99a5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


