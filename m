Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC4A502829
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 12:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352221AbiDOKW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 06:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352273AbiDOKWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 06:22:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C611FAC05A
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 03:20:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81753B82DED
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 10:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 15610C385A5;
        Fri, 15 Apr 2022 10:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650018011;
        bh=zrHn80ZJwcUyg8IVPomtkMdXnfS3/MjfhhkXrqJv6mU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ElUib0kG81GAMlEeapiCmWXTXGUSFavKf3vvOAjrIJH+cmmK4d9eygtPQX6HreHAG
         XwxieEVmPx3JpTJ1t6iuqKvPNWatV5CMYKBSJ8vlHlvlcrJl61FkJJV4VRLjxOJzYV
         nHVQhj1bWzB9XKK2EmMzXzboeTODWZCTgFi8OrQHAleyU/cEg1LjspOCeYqZgMb3Ng
         Ek0hSCGhpFQSB/QbLkTAF9c7cG4jJPyzREEpV0uK6yi4tbY6MaFA2SbkS5cBbmOIDY
         /o5O4fVV4Wd7gI4cu/w5I3ov1x4DVc1QwlC07lRLYbnNc7XaV3q84YoFK/JExreTjf
         MVrXbVy9cmpDA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EEEDDE8DD6A;
        Fri, 15 Apr 2022 10:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/packet: fix packet_sock xmit return value checking
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165001801097.12692.4030872547263934849.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Apr 2022 10:20:10 +0000
References: <20220414084925.22731-1-liuhangbin@gmail.com>
In-Reply-To: <20220414084925.22731-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, davem@davemloft.net, fbl@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Thu, 14 Apr 2022 16:49:25 +0800 you wrote:
> packet_sock xmit could be dev_queue_xmit, which also returns negative
> errors. So only checking positive errors is not enough, or userspace
> sendmsg may return success while packet is not send out.
> 
> Move the net_xmit_errno() assignment in the braces as checkpatch.pl said
> do not use assignment in if condition.
> 
> [...]

Here is the summary with links:
  - [net] net/packet: fix packet_sock xmit return value checking
    https://git.kernel.org/netdev/net/c/29e8e659f984

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


