Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 384B947EAEB
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 04:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245583AbhLXDaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 22:30:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351171AbhLXDaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 22:30:17 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 850DDC061757
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 19:30:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D516DCE222E
        for <netdev@vger.kernel.org>; Fri, 24 Dec 2021 03:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1D2B4C36AEC;
        Fri, 24 Dec 2021 03:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640316613;
        bh=I48vj2DZf9ABiIa8IxrxYXinQiuh4MBunTnQ7DPBrqM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Izn/TsokJyHjlGjH5L1P4EUVJ8MmtsEGWMRhG9VueWRD2Srrw83/RvTJDSF5ZrW5v
         dEYYwc3u8w7S8+LnrUgjTwq8bd9aG5cWllYdnkUJrP3JWqQ/haYyEhA/GIR1WJfxBr
         Qc9AWVXO6+bJV5MoNxuRSukB58mYyIifUZiezgrnbkoAi2s+gdAJAnoTWgDql5oqZo
         6hjk35MWyMytG/YKzurQLdhDgBphtzBLnBxcjLFagmeP5iQCYrbpGjH+Ji70IqOhGS
         2bZhGJpW0jWx74xnPdQkJnZsGHiNFH0wpGPmmFhzTGE9lLOIot541ZqCt+1q7YQrZc
         uwnqZI0Ksgh7g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EFFBDEAC06F;
        Fri, 24 Dec 2021 03:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] udp: using datalen to cap ipv6 udp max gso segments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164031661297.11818.12735840556675530099.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Dec 2021 03:30:12 +0000
References: <20211223222441.2975883-1-lixiaoyan@google.com>
In-Reply-To: <20211223222441.2975883-1-lixiaoyan@google.com>
To:     Coco Li <lixiaoyan@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, willemb@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 23 Dec 2021 22:24:40 +0000 you wrote:
> The max number of UDP gso segments is intended to cap to
> UDP_MAX_SEGMENTS, this is checked in udp_send_skb().
> 
> skb->len contains network and transport header len here, we should use
> only data len instead.
> 
> This is the ipv6 counterpart to the below referenced commit,
> which missed the ipv6 change
> 
> [...]

Here is the summary with links:
  - [net,1/2] udp: using datalen to cap ipv6 udp max gso segments
    https://git.kernel.org/netdev/net/c/736ef37fd9a4
  - [net,2/2] selftests: Calculate udpgso segment count without header adjustment
    https://git.kernel.org/netdev/net/c/5471d5226c3b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


