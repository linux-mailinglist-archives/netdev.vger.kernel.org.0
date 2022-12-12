Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63DA364AB93
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 00:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234006AbiLLXaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 18:30:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233744AbiLLXaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 18:30:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A521ADAB
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 15:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8699961298
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 23:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EA235C433F1;
        Mon, 12 Dec 2022 23:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670887818;
        bh=iGRSSOoGM0SSodg+Ay5Zit9N2m46ln5I4GA2lAyVA/E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sfGlnRoTMV44nlFwsjDGOzw4ELX7UhtXPUP+2V6MwkX2fujEvMiXnaHrI0fr+dSL2
         9E8aSy4SGxOC2kAdSXLFuvMcMeVOjIDYMJK2RzPH+gOP5L3BtlhF7ItgQG8uejK3n+
         yFHgaMDkSxKhqPlWYNGRJsu5x4FqyfXXjB63m4ueRU7dNb2l8Io70V3hyvePPIKbQ+
         zqNWu0WLj9FIajoCL+7NRyrd2bx15ut86G0/MSoVurUjkaQJ6kuK+2Q9vizyqSPzfb
         OMgvjkEOvqrqjZNzgMmVf2XC1MZE6wZeWqBGJxAOH4E6o0/PGAJ6mGOb5uGimwpQz/
         XDOrICV5D7NNA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D697BC41606;
        Mon, 12 Dec 2022 23:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] net: add IFF_NO_ADDRCONF to prevent ipv6
 addrconf
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167088781787.32014.12569414144216569163.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Dec 2022 23:30:17 +0000
References: <cover.1670599241.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1670599241.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, jiri@resnulli.us,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        sridhar.samudrala@intel.com, stephen@networkplumber.org,
        liali@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  9 Dec 2022 10:21:37 -0500 you wrote:
> This patchset adds IFF_NO_ADDRCONF flag for dev->priv_flags
> to prevent ipv6 addrconf, as Jiri Pirko's suggestion.
> 
> For Bonding it changes to use this flag instead of IFF_SLAVE
> flag in Patch 1, and for Teaming and Net Failover it sets
> this flag before calling dev_open() in Patch 2 and 3.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: add IFF_NO_ADDRCONF and use it in bonding to prevent ipv6 addrconf
    https://git.kernel.org/netdev/net-next/c/8a321cf7becc
  - [net-next,2/3] net: team: use IFF_NO_ADDRCONF flag to prevent ipv6 addrconf
    https://git.kernel.org/netdev/net-next/c/0aa64df30b38
  - [net-next,3/3] net: failover: use IFF_NO_ADDRCONF flag to prevent ipv6 addrconf
    https://git.kernel.org/netdev/net-next/c/cb54d392279d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


