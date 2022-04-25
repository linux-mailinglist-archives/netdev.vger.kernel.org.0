Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCEC050DE31
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 12:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241521AbiDYKxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 06:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240663AbiDYKxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 06:53:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA8346F495
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 03:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1C61B8128F
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 10:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 89950C385AD;
        Mon, 25 Apr 2022 10:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650883812;
        bh=Dx4NtzlFSe5sX2UNBbwvaBZvHYxGKsHFO58SUO5hcl8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jkLi5FP5wQwNWY9N9jU4EcIzVSFlzCsh9SpG4ZG8ty8u5gnKfuL3KNCNOnrenMTuD
         pPeQjEOypJ3MqCrVIoRWiKHbi4fgcJ6fAD/Bz6ekRB7ubI5CFTDGCMtn5juNy8c4BI
         hqSQoKwlKpVgMayMBAVeCsUYuDnz59Re7TkcoE4FpLWP8L6nqGn8KLbKuhbgP6oc5E
         GV9KRC6dJ8KsvUcztK2CHZ7yPobRORW/mGorcH3c3pR4VnlJcFzDu+5iWekGDJcvl6
         hVAfQc7dPX7Fv7paUccv6jBrpOuqNRVRq6V66LpP7Qd3uMnO3mIO5pm9l5zQCyvr+d
         SDg+bJ44Jhx8Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 62CB8E6D402;
        Mon, 25 Apr 2022 10:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: flood multicast to CPU when slave has
 IFF_PROMISC
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165088381240.11295.6166816059782110924.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Apr 2022 10:50:12 +0000
References: <20220421224222.3563522-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220421224222.3563522-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, olteanv@gmail.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 22 Apr 2022 01:42:22 +0300 you wrote:
> Certain DSA switches can eliminate flooding to the CPU when none of the
> ports have the IFF_ALLMULTI or IFF_PROMISC flags set. This is done by
> synthesizing a call to dsa_port_bridge_flags() for the CPU port, a call
> which normally comes from the bridge driver via switchdev.
> 
> The bridge port flags and IFF_PROMISC|IFF_ALLMULTI have slightly
> different semantics, and due to inattention/lack of proper testing, the
> IFF_PROMISC flag allows unknown unicast to be flooded to the CPU, but
> not unknown multicast.
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: flood multicast to CPU when slave has IFF_PROMISC
    https://git.kernel.org/netdev/net/c/7c762e70c50b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


