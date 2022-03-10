Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35B9D4D403E
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 05:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239450AbiCJEVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 23:21:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239451AbiCJEVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 23:21:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24450FFF8F
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 20:20:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD62BB8245D
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 04:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 71CFCC340F5;
        Thu, 10 Mar 2022 04:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646886011;
        bh=N0EFcjJJtIoCAIlyGG6NxmmEdUjY0c1JT4NKXfQEhuk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QExAcW8drMpAyWvzcmmv8D8zc7FjOBp57G0puEOjMgyXjdPmslVp8QEANjgb6SHZf
         D5WxvXZ5vMoZHnXE7Yi5gspXUWZQEyOTZRnczlbecme2gF/U0t4c/bpo6aBZmyP3s8
         xeF3cWttqSreaUS7mdQRq6ZNAXjBDGGHWeq6q+0wfsqfbUdtm8z1vL0MgonXkLRrQ4
         R+Qbs41iEgyI1JHYwwgjtQ/YO8v2MwdATWtptfbbJMeIN06kQusFZ2GgBminPfsHQs
         +xc187HEj0VmTlVPypC2iGc/Eh0TMQxWJDqHHgnXvktrpXGLOHeBKo9sSxgZB99U0N
         oT0qsU+sPevuQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5D0BCF03842;
        Thu, 10 Mar 2022 04:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tcp: adjust TSO packet sizes based on min_rtt
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164688601137.11305.12450759485897561190.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Mar 2022 04:20:11 +0000
References: <20220309015757.2532973-1-eric.dumazet@gmail.com>
In-Reply-To: <20220309015757.2532973-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, soheil@google.com, ncardwell@google.com,
        ycheng@google.com, yyd@google.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  8 Mar 2022 17:57:57 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Back when tcp_tso_autosize() and TCP pacing were introduced,
> our focus was really to reduce burst sizes for long distance
> flows.
> 
> The simple heuristic of using sk_pacing_rate/1024 has worked
> well, but can lead to too small packets for hosts in the same
> rack/cluster, when thousands of flows compete for the bottleneck.
> 
> [...]

Here is the summary with links:
  - [net-next] tcp: adjust TSO packet sizes based on min_rtt
    https://git.kernel.org/netdev/net-next/c/65466904b015

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


