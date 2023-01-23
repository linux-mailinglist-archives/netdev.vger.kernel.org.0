Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12EA2677C52
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 14:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbjAWNUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 08:20:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231556AbjAWNUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 08:20:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E31C81ABC2
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 05:20:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13126B80D54
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 13:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B8243C433EF;
        Mon, 23 Jan 2023 13:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674480016;
        bh=j1cRNkI+eiOGFbfvYLEqXlvWUEGt1EpxSmH/UHX4HoM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RgS3HTDISd047s/OfH5RZblXj8hrMeLCqAGmyrEBJVEyxpyfx+RgTqYvboinHwykc
         +ugAcTKDa2MHIDK678E7jHz+UQ8ey987s2mqIgfslyJ9EVa+Yk6ApDrqCkD+pv+5Wx
         fU6esYwWIF988t+Kssg2HLGyrMoXzaIkf7Zd/ftOAIbzuv8lQNTMx475+uJGmJvIF2
         xVH4/KzccE/ikTsqZ+KRfjk3BxedeAVz82/58USyc2trc1D0YwsY+rqSf96kh0dwpb
         qaIYIoSTxCZQ/vkJbU/HQp1I4RoDmqK70L/xZjNB+oCoqhiKzRh094TJQyazCgmcS2
         /t/e64O9zWGQg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9B322C04E34;
        Mon, 23 Jan 2023 13:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] ENETC MAC Merge cleanup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167448001662.10090.11580039630545061099.git-patchwork-notify@kernel.org>
Date:   Mon, 23 Jan 2023 13:20:16 +0000
References: <20230119160431.295833-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230119160431.295833-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com
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
by David S. Miller <davem@davemloft.net>:

On Thu, 19 Jan 2023 18:04:25 +0200 you wrote:
> This is a preparatory patch set for MAC Merge layer support in enetc via
> ethtool. It does the following:
> 
> - consolidates a software lockstep register write procedure for the pMAC
> - detects per-port frame preemption capability and only writes pMAC
>   registers if a pMAC exists
> - stops enabling the pMAC by default
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] net: enetc: build common object files into a separate module
    https://git.kernel.org/netdev/net-next/c/e3972399bb57
  - [net-next,2/6] net: enetc: detect frame preemption hardware capability
    https://git.kernel.org/netdev/net-next/c/94557a9a73b4
  - [net-next,3/6] net: enetc: add definition for offset between eMAC and pMAC regs
    https://git.kernel.org/netdev/net-next/c/9c949e0b2f9c
  - [net-next,4/6] net: enetc: stop configuring pMAC in lockstep with eMAC
    https://git.kernel.org/netdev/net-next/c/219355f1b093
  - [net-next,5/6] net: enetc: implement software lockstep for port MAC registers
    https://git.kernel.org/netdev/net-next/c/12717decb570
  - [net-next,6/6] net: enetc: stop auto-configuring the port pMAC
    https://git.kernel.org/netdev/net-next/c/086cc0803550

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


