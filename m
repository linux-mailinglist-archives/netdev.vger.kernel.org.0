Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61B8C56C932
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 13:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbiGILaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 07:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiGILaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 07:30:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 624604E87F
        for <netdev@vger.kernel.org>; Sat,  9 Jul 2022 04:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8B26B81162
        for <netdev@vger.kernel.org>; Sat,  9 Jul 2022 11:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 86420C341CB;
        Sat,  9 Jul 2022 11:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657366212;
        bh=75oJiGLXOHQ0RcjGBFR0ieEKs4kkL9wq2DDkpx2pM4c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bTabveIYGZBaXrkXsuvomE8f1njlsJbuw9sdtP9YRZ4ESwR9NSGG7ApVG+s1MyhU4
         aGlGYIWYci7V9RygeVCK4Xcsr/PXX9lHvkuNePKL7rHIVSyRhWFTa+VblXQ6mUaR8m
         iKc4f3DGNjXyUAH3111saOUKltIrfYZE2INOLPELHRMN4vVx/IRCJlBOo0EnUbCkeD
         wGUtOey/ag8SK02lQ6sAC3OGJubajNiJR9RY/k0CYO9QRk++byic+5Gqu6SCEm2KeJ
         1rQYlxY+w4qyFi1X5HUfO38ej8qdMo+J7KWKlPe3YM1NrmPcPL2bS0jfm2Ow39of/f
         AnzQ6WRHh1HLA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6D339E45BE1;
        Sat,  9 Jul 2022 11:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] nfp: fix issue of skb segments exceeds descriptor
 limitation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165736621244.28880.8660108916507978992.git-patchwork-notify@kernel.org>
Date:   Sat, 09 Jul 2022 11:30:12 +0000
References: <20220708100718.791158-1-simon.horman@corigine.com>
In-Reply-To: <20220708100718.791158-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri,  8 Jul 2022 11:07:18 +0100 you wrote:
> From: Baowen Zheng <baowen.zheng@corigine.com>
> 
> TCP packets will be dropped if the segments number in the tx skb
> exceeds limitation when sending iperf3 traffic with --zerocopy option.
> 
> we make the following changes:
> 
> [...]

Here is the summary with links:
  - [net] nfp: fix issue of skb segments exceeds descriptor limitation
    https://git.kernel.org/netdev/net/c/9c840d5f9aae

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


