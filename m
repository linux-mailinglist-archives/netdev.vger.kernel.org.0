Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 278636D0DF3
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 20:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbjC3Sks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 14:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231585AbjC3Sko (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 14:40:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1957CF749
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 11:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A46566216F
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 18:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F39E7C4339C;
        Thu, 30 Mar 2023 18:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680201618;
        bh=MMT4nbSHRr5lx7Z5Oe767KfeXyNM720+xrD3wht5dtA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R+c32V42p4R8IVU8MsyJnJoGIiW0hGQOqnjVzZ4R7zQ43nU9PZcJuPk7SGNxs94Ht
         nla9xv9IJS75JLscTnNGnJqgQNEKPG1A6ZYW2WixkPGmBvbU7DDLAKIA0mNanf0SeW
         kGrIYggY2twCZtU/YAEc6H+RDPRVWlrO4NQ1QTlEKMgi272XwP40DF1TIYzBmqTIWU
         dj0HEujGfiWSzbCBO4UHqKRPSAZBWJn1g+vFA+IahcQiSJikrTAZa9u8fW/t3ONd86
         z1VQ/6j+QEn70Hvk1jzQ55nwQsjPrZpYJq291bH8nh+Q8XESL+z8mA/NyHUxevJy0o
         yNuzqGEYMhGeg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D4B07E2A03D;
        Thu, 30 Mar 2023 18:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: sync unicast and multicast addresses for VLAN
 filters too
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168020161786.2203.16222876415991113578.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Mar 2023 18:40:17 +0000
References: <20230329151821.745752-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230329151821.745752-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, andrew@lunn.ch,
        f.fainelli@gmail.com, idosch@nvidia.com
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 29 Mar 2023 18:18:21 +0300 you wrote:
> If certain conditions are met, DSA can install all necessary MAC
> addresses on the CPU ports as FDB entries and disable flooding towards
> the CPU (we call this RX filtering).
> 
> There is one corner case where this does not work.
> 
> ip link add br0 type bridge vlan_filtering 1 && ip link set br0 up
> ip link set swp0 master br0 && ip link set swp0 up
> ip link add link swp0 name swp0.100 type vlan id 100
> ip link set swp0.100 up && ip addr add 192.168.100.1/24 dev swp0.100
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: sync unicast and multicast addresses for VLAN filters too
    https://git.kernel.org/netdev/net/c/64fdc5f341db

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


