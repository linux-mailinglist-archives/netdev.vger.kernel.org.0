Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C08916CD41B
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 10:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbjC2IKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 04:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbjC2IKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 04:10:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FB9E1996
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 01:10:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E402FB8214E
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 08:10:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A7A38C4339E;
        Wed, 29 Mar 2023 08:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680077426;
        bh=kpW/S+4voE5Mpl1zzAnFN4v+qHkTH5PWBdkvkOAbhIY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TDqsqaHW43Be8WxyllXsYMSXW0B+zO2uUjsYnGp7ISwHN434oV2rXJT4wTtIOFPsV
         EDaau5ryFa8K/mVwhiLUC9oCAI0B5U3/WYxAITWZOkdlmmNiIWoVOyg3541WXQtDsp
         IUdZO7cWq7K/Y+tcYoluGBuGyZ5SoBAM2wh1gla3w7NGN/JLh80HH+AY8dgC36//a8
         mHgArL/yFmzSNBefNPF+5SRQ0hFUwz7e/Dg/kYtcIGF31reAvFxrLO3t4l0i1UBkbh
         3mfBX/XPpSewmNbZgqtB4yRq3sdlo5PTgLHB8i+5Mn0QDGyk45s2OBEyZu4wCOrhe4
         /ZsjtTHq0IWcA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 903FAE50D76;
        Wed, 29 Mar 2023 08:10:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/2] macvlan: Allow some packets to bypass broadcast queue
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168007742658.16006.9794796649627218191.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Mar 2023 08:10:26 +0000
References: <ZCJXefIhSrd7Hm2Z@gondor.apana.org.au>
In-Reply-To: <ZCJXefIhSrd7Hm2Z@gondor.apana.org.au>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     netdev@vger.kernel.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue, 28 Mar 2023 10:56:57 +0800 you wrote:
> This patch series allows some packets to bypass the broadcast
> queue on receive.  Currently all multicast packets are queued
> on receive and then processed in a work queue.  This is to avoid
> an unbounded amount of work occurring in the receive path, as
> one broadcast packet could easily translate into 4,000 packets.
> 
> However, for multicast packets with just one receiver (possible
> for IPv6 ND), this introduces unnecessary latency as the packet
> will go to exactly one device.
> 
> [...]

Here is the summary with links:
  - [1/2] macvlan: Skip broadcast queue if multicast with single receiver
    https://git.kernel.org/netdev/net-next/c/d45276e75e90
  - [2/2] macvlan: Add netlink attribute for broadcast cutoff
    https://git.kernel.org/netdev/net-next/c/954d1fa1ac93

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


