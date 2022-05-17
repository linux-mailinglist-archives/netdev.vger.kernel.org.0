Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBEBC529C3D
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 10:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240333AbiEQIUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 04:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232381AbiEQIUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 04:20:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CBA960D8;
        Tue, 17 May 2022 01:20:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC41261243;
        Tue, 17 May 2022 08:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 52365C34117;
        Tue, 17 May 2022 08:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652775612;
        bh=QyxujttSv5a8CJWHbBKBQU0yq5VwviWomahOUnym0wo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=G8/Na8eMEhOYe/YEA3/vLYzZKAZM/KPBBc9iv8S33tC2lmljcWoibHrpyKTbc+uSe
         87Vnzz+I2y4WfMeJ9RUGEwKha3lXwPDRQuLhI4i+EIl7BPyMO407RkLIuzKnTUcibo
         UB29XOEeD0lfM7wHb869ttmAhjy6ImBskxFVDe+cVzkni7wACc6CQpwVWT8XUQNi9n
         adwehYbq9h27DobAkv5U4PbkfIO3Amj7QkptFReMlllfWPgam9tganUEE3EWFHQAet
         +gvZlDcyBdW3ydlhERyQCAgE4XL+wZK5GLwAp3NAZ2TFHotZEbkrWXIDb2uI6zSRuq
         +AWkNu/Kx971w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 32770F0389D;
        Tue, 17 May 2022 08:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: lan966x: Fix assignment of the MAC address
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165277561220.28744.11715921270225705422.git-patchwork-notify@kernel.org>
Date:   Tue, 17 May 2022 08:20:12 +0000
References: <20220513180030.3076793-1-horatiu.vultur@microchip.com>
In-Reply-To: <20220513180030.3076793-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 13 May 2022 20:00:30 +0200 you wrote:
> The following two scenarios were failing for lan966x.
> 1. If the port had the address X and then trying to assign the same
>    address, then the HW was just removing this address because first it
>    tries to learn new address and then delete the old one. As they are
>    the same the HW remove it.
> 2. If the port eth0 was assigned the same address as one of the other
>    ports eth1 then when assigning back the address to eth0 then the HW
>    was deleting the address of eth1.
> 
> [...]

Here is the summary with links:
  - [net] net: lan966x: Fix assignment of the MAC address
    https://git.kernel.org/netdev/net/c/af8ca6eaa9b2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


