Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE4951ED19
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 12:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbiEHKyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 06:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233102AbiEHKyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 06:54:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ADF3B86F
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 03:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B98356109E
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 10:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0F38AC385A4;
        Sun,  8 May 2022 10:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652007015;
        bh=GCB0C9EANHSr+QYI4PebM04k670FjHv+zvq8d/CCzSo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VRB66WLUoJhr32yOlICE8+tkyDP8R6NX+yOrh18EhCa6DYdXOSNAoKZ2Sh5ly5Pkn
         4GZv9Do+JCw/fwY5np2OEbZyV4bY3lB5JzJMTpziE1EqxmkK0vgnBl7ZwHzmMWzfZJ
         /NoFXX+JxskvooRuKT452hb0PZnI5gsJc3XaQXgbe36EM+JFaRDC+cN1/+HlTlv6TA
         ZO/bXDZ4ca0OCRfsQCozlaltmyaWaQdwJqW1X5J9vUgML+5rWEYh8Fxgi8fK1yrg0e
         lR1+xaQiBp7M7z3lNdnsmYsmzrUak7CB8xh2Z2nPv1Bj4CEjBBaF3+qqkGU/4IOi9u
         aGmz0BJewCHiQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E28FDE5D087;
        Sun,  8 May 2022 10:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/10] mlxsw: A dedicated notifier block for router
 code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165200701492.399.4822548195944966662.git-patchwork-notify@kernel.org>
Date:   Sun, 08 May 2022 10:50:14 +0000
References: <20220508080823.32154-1-idosch@nvidia.com>
In-Reply-To: <20220508080823.32154-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, petrm@nvidia.com,
        mlxsw@nvidia.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Sun,  8 May 2022 11:08:13 +0300 you wrote:
> Petr says:
> 
> Currently all netdevice events are handled in the centralized notifier
> handler maintained by spectrum.c. Since a number of events are involving
> router code, spectrum.c needs to dispatch them to spectrum_router.c. The
> spectrum module therefore needs to know more about the router code than it
> should have, and there is are several API points through which the two
> modules communicate.
> 
> [...]

Here is the summary with links:
  - [net-next,01/10] mlxsw: spectrum: Tolerate enslaving of various devices to VRF
    https://git.kernel.org/netdev/net-next/c/7cf0f96df1d8
  - [net-next,02/10] mlxsw: spectrum_router: Add a dedicated notifier block
    https://git.kernel.org/netdev/net-next/c/0a27cb1692de
  - [net-next,03/10] mlxsw: spectrum: Move handling of VRF events to router code
    https://git.kernel.org/netdev/net-next/c/4f8afb680f13
  - [net-next,04/10] mlxsw: spectrum: Move handling of HW stats events to router code
    https://git.kernel.org/netdev/net-next/c/f40e600b369e
  - [net-next,05/10] mlxsw: spectrum: Move handling of router events to router code
    https://git.kernel.org/netdev/net-next/c/ba81954cd526
  - [net-next,06/10] mlxsw: spectrum: Move handling of tunnel events to router code
    https://git.kernel.org/netdev/net-next/c/75ef4342282a
  - [net-next,07/10] mlxsw: spectrum: Update a comment
    https://git.kernel.org/netdev/net-next/c/05a8d7d4fadf
  - [net-next,08/10] mlxsw: spectrum_router: Take router lock in router notifier handler
    https://git.kernel.org/netdev/net-next/c/c353fb0d4c93
  - [net-next,09/10] selftests: lib: Add a generic helper for obtaining HW stats
    https://git.kernel.org/netdev/net-next/c/32fb67a3e7a6
  - [net-next,10/10] selftests: forwarding: Add a tunnel-based test for L3 HW stats
    https://git.kernel.org/netdev/net-next/c/813f97a26860

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


