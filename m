Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59180691A50
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 09:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbjBJIue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 03:50:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbjBJIuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 03:50:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2217B166;
        Fri, 10 Feb 2023 00:50:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3792B82291;
        Fri, 10 Feb 2023 08:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 66E19C433D2;
        Fri, 10 Feb 2023 08:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676019019;
        bh=l27vHcNNXPVIuRuS/rN9GKB+qbuqxKQGMqVEkd63keM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=is/5L6q5NfiTF9dBggiZqwG+GGyeBAQ/cb0+dgUZ1saTixCtHm0FdQhcYtg+4QZsS
         FhwlFOjMb6HfwCVf2yptyJCFq+1rKMiXp2Z/KJhmxscfaIB0wwIWTKZTCbdakFuKIS
         wV6kCc8JEEwb7BwvG/qMx+FuRbirKqpYbN86odZGF0t8oFUvNVtPQ91MCnedp1O6Ly
         HES4yxT3j6PE+WCaf/qhNHKNCU3fWs720XDdqKAenqT7jnsSXFCAa1exvFjfgrebaN
         pNUseOxxS93KKbvUcWUTN17hYOAVjLMYU+I3IlB1zYDzJ5XbOEXwQhNOPyXwH3ma23
         PAKdS7zub1bww==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4CC3BE21EC7;
        Fri, 10 Feb 2023 08:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: microchip: vcap: Add tc flower keys for lan966x
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167601901931.32230.10675972834777188254.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Feb 2023 08:50:19 +0000
References: <20230208130839.1696860-1-horatiu.vultur@microchip.com>
In-Reply-To: <20230208130839.1696860-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 8 Feb 2023 14:08:39 +0100 you wrote:
> Add the following TC flower filter keys to lan966x for IS2:
> - ipv4_addr (sip and dip)
> - ipv6_addr (sip and dip)
> - control (IPv4 fragments)
> - portnum (tcp and udp port numbers)
> - basic (L3 and L4 protocol)
> - vlan (outer vlan tag info)
> - tcp (tcp flags)
> - ip (tos field)
> 
> [...]

Here is the summary with links:
  - [net-next] net: microchip: vcap: Add tc flower keys for lan966x
    https://git.kernel.org/netdev/net-next/c/47400aaea4ff

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


