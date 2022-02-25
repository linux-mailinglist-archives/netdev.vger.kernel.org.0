Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D16324C431C
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 12:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239938AbiBYLKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 06:10:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239934AbiBYLKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 06:10:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB4E23931C
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 03:10:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 749AA61828
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 11:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C96ACC340EF;
        Fri, 25 Feb 2022 11:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645787413;
        bh=IrrBCyaV2f8kI4T7odQKwtdEh0a+r8Dzq5VEBcwCBks=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lIny9ByuBA4mpmQTrS5flDxVaInp/ZWvItuPmZKh8RhkGNOhc+1qrh37tBMBTXP3h
         6w6mJEo/p3+oyE5uTRWmMDWTaSc+BCWQqHGw6i+3bdUml56vmnbFhDrbsCPbB86Kr9
         HsRCloWl5EfFAfq7eEEN30atkj3izG2sx/CcYzEINCVlUv16p2JMCre2VUePb10KGL
         Kzj5lHaPLM5KNpDJF7m4XC4Cu7RYMzhVjiFtk6VtU4DWgsXmSOxFkAEE3E8ka0KW6I
         ZhDEcVcevQVjn0lb6jioh1/lgGa6HKfkrMa2XQxziczcCq8RyYWr48wskAGP3nc6sT
         u/FRXUIj2189A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ABF92E6D453;
        Fri, 25 Feb 2022 11:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull request (net): ipsec 2022-02-25
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164578741370.30964.9050783997599737730.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Feb 2022 11:10:13 +0000
References: <20220225074733.118664-1-steffen.klassert@secunet.com>
In-Reply-To: <20220225074733.118664-1-steffen.klassert@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     davem@davemloft.net, kuba@kernel.org, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org
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

This pull request was applied to netdev/net.git (master)
by Steffen Klassert <steffen.klassert@secunet.com>:

On Fri, 25 Feb 2022 08:47:27 +0100 you wrote:
> 1) Fix PMTU for IPv6 if the reported MTU minus the ESP overhead is
>    smaller than 1280. From Jiri Bohac.
> 
> 2) Fix xfrm interface ID and inter address family tunneling when
>    migrating xfrm states. From Yan Yan.
> 
> 3) Add missing xfrm intrerface ID initialization on xfrmi_changelink.
>    From Antony Antony.
> 
> [...]

Here is the summary with links:
  - pull request (net): ipsec 2022-02-25
    https://git.kernel.org/netdev/net/c/31372fe9668e
  - [2/6] xfrm: Check if_id in xfrm_migrate
    https://git.kernel.org/netdev/net/c/c1aca3080e38
  - [3/6] xfrm: Fix xfrm migrate issues when address family changes
    https://git.kernel.org/netdev/net/c/e03c3bba351f
  - [4/6] Revert "xfrm: xfrm_state_mtu should return at least 1280 for ipv6"
    https://git.kernel.org/netdev/net/c/a6d95c5a628a
  - [5/6] xfrm: fix the if_id check in changelink
    https://git.kernel.org/netdev/net/c/6d0d95a1c2b0
  - [6/6] xfrm: enforce validity of offload input flags
    https://git.kernel.org/netdev/net/c/7c76ecd9c99b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


