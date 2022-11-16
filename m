Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B05E62B719
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 11:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231442AbiKPKA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 05:00:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiKPKAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 05:00:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75295C25
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 02:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11424B81CC8
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 10:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9F38CC433D6;
        Wed, 16 Nov 2022 10:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668592816;
        bh=Ew7HxADEU/LAva1qggcSGFj3dGcDZnzL3ZQ5+IPDlmM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CrroHaMy00Jqc6B5Tc/Ry67S/UAxtRX6aWLKgwiOKJa0us04a7GG8wf6X27tLxirS
         tLOcIhsYsMEJIe8FpBH7HY3o4YQLiIPVqVT2Kv2jptv5RkF/gOc4orN6G/6lXQCZRF
         xbV1cMgs0BrS8JLhUCxQuH+eXZTC1cLXer5EEJkCqd4ZtqwRLSwqWNsO7hWceyZmi+
         wcOZ+t3s+Haz+Tvle5iZuhs+2ktAHuY6rrVwDKIq4EvEV29eel15ijGyXnDGrYRvHC
         YI4UMlC1ekojRKHDvBUtyjPxhtNqxG4BcbwXodmicZgj6yu+7j3B6RPj8JkiJFufB8
         Ap38NYFgMTQDg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 83641C395F3;
        Wed, 16 Nov 2022 10:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net: linkwatch: only report
 IF_OPER_LOWERLAYERDOWN if iflink is actually down
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166859281653.28317.17051631605087933356.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Nov 2022 10:00:16 +0000
References: <20221114144256.1908806-1-vladimir.oltean@nxp.com>
In-Reply-To: <20221114144256.1908806-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 14 Nov 2022 16:42:56 +0200 you wrote:
> RFC 2863 says:
> 
>    The lowerLayerDown state is also a refinement on the down state.
>    This new state indicates that this interface runs "on top of" one or
>    more other interfaces (see ifStackTable) and that this interface is
>    down specifically because one or more of these lower-layer interfaces
>    are down.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net: linkwatch: only report IF_OPER_LOWERLAYERDOWN if iflink is actually down
    https://git.kernel.org/netdev/net-next/c/8c55facecd7a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


