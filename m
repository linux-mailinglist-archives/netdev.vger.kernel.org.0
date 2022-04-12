Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21D6C4FCBD7
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 03:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243575AbiDLBWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 21:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231907AbiDLBWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 21:22:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3BE1193E2
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 18:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CD9A615C7
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 01:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7D1A2C385A3;
        Tue, 12 Apr 2022 01:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649726415;
        bh=VOBzqH/b2rAY/I2vLmOXN5jzJK7VgJlR1xdnJOqNJeA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Dj5nAOoyDQ6RfYXU6Va4pZd3vuDOZ4ERPzao1dj/LtkcSSDSDG0NzBAQYr9f628yW
         67PsuMQn4zqGXanMkLuFkV9+0ohfikrhSkobjQHV4NnNPtx6biETDt4BcigR9cXVUo
         OkoRlGgar/890j7z1lVZcGCBqog/Ep5Ed8rb8fQkcRCGiJWVlOtIp45KIbFg8tEAyb
         /V3UP0s72jSkDlr36U7GPYoAO/Cg0QdarhKTTK9RR32duW2YnMHSdIfGG8WdY8RhdL
         Fh9OGrGuUTfqs+gRYaQ8hsk/W0GantlnJHts1LAqLPPvTalonQddcXJ1NEgyaiI9g0
         LKP5/OIY7LTnA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 58E35E85B76;
        Tue, 12 Apr 2022 01:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] ipv4: Convert several tos fields to dscp_t
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164972641536.27669.11150630095148243278.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Apr 2022 01:20:15 +0000
References: <cover.1649445279.git.gnault@redhat.com>
In-Reply-To: <cover.1649445279.git.gnault@redhat.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, tchornyi@marvell.com, idosch@nvidia.com,
        petrm@nvidia.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org
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

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 8 Apr 2022 22:08:34 +0200 you wrote:
> Continue the work started with commit a410a0cf9885 ("ipv6: Define
> dscp_t and stop taking ECN bits into account in fib6-rules") and
> convert more structure fields and variables to dscp_t. This series
> focuses on struct fib_rt_info, struct fib_entry_notifier_info and their
> users (networking drivers).
> 
> The purpose of dscp_t is to ensure that ECN bits don't influence IP
> route lookups. It does so by ensuring that dscp_t variables have the
> ECN bits cleared.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] ipv4: Use dscp_t in struct fib_rt_info
    https://git.kernel.org/netdev/net-next/c/888ade8f90d7
  - [net-next,2/5] ipv4: Use dscp_t in struct fib_entry_notifier_info
    https://git.kernel.org/netdev/net-next/c/568a3f33b427
  - [net-next,3/5] netdevsim: Use dscp_t in struct nsim_fib4_rt
    https://git.kernel.org/netdev/net-next/c/20bbf32efe1e
  - [net-next,4/5] mlxsw: Use dscp_t in struct mlxsw_sp_fib4_entry
    https://git.kernel.org/netdev/net-next/c/046eabbf1991
  - [net-next,5/5] net: marvell: prestera: Use dscp_t in struct prestera_kern_fib_cache
    https://git.kernel.org/netdev/net-next/c/9f6982e9a3c2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


