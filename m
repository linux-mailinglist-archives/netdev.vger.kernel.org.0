Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E51A4650BDE
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 13:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbiLSMkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 07:40:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbiLSMkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 07:40:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF863A9
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 04:40:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A7B760F7C
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 12:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5F652C433EF;
        Mon, 19 Dec 2022 12:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671453616;
        bh=gOflSCTKm/enOHgWw/VIBr+n+TfyYI4SaepS/jx1l84=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HvPrhUv89GpziFCOLrG9WMZgDrmn8ONi7618RsusrU3JEHRa1HyFSBm2y2kP1Av1g
         2aJQUNtWyI3nCIni47pEOF195b175LtEBJG9suLyGFjWPlUk1sgcwqXtTFSNhn6j78
         KXl+Ht8jTe1PFustfSqS7rlmisJQQMONixJWe1Ke7XoMcyD6ezuLgxMl6hcfojFbHO
         3NacIKgLh+y3a2kVU/P7X1EcJohSEapBrrpv6z+N+uH5B3HauoP9kOlVbpdiTvWO3L
         TL5OPpjWTSWsvK2eSu56Tz+O4NDL0iOUlQgfJKmgA0INzZl7s2djF0nA1vkLN8szdK
         CLTVUYyo9WQBQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 434EEC00445;
        Mon, 19 Dec 2022 12:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: stream: purge sk_error_queue in
 sk_stream_kill_queues()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167145361627.5637.12164235110886449919.git-patchwork-notify@kernel.org>
Date:   Mon, 19 Dec 2022 12:40:16 +0000
References: <20221216162917.119406-1-edumazet@google.com>
In-Reply-To: <20221216162917.119406-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        darklight2357@icloud.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 16 Dec 2022 16:29:17 +0000 you wrote:
> Changheon Lee reported TCP socket leaks, with a nice repro.
> 
> It seems we leak TCP sockets with the following sequence:
> 
> 1) SOF_TIMESTAMPING_TX_ACK is enabled on the socket.
> 
>    Each ACK will cook an skb put in error queue, from __skb_tstamp_tx().
>    __skb_tstamp_tx() is using skb_clone(), unless
>    SOF_TIMESTAMPING_OPT_TSONLY was also requested.
> 
> [...]

Here is the summary with links:
  - [net] net: stream: purge sk_error_queue in sk_stream_kill_queues()
    https://git.kernel.org/netdev/net/c/e0c8bccd40fc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


