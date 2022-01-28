Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B161A49F1BE
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 04:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345684AbiA1DUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 22:20:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345661AbiA1DUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 22:20:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2480C061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 19:20:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 616C7B8244C
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 03:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 30385C340EA;
        Fri, 28 Jan 2022 03:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643340014;
        bh=GvDnKgslGag3vPcbqdy2ysWxug67f8X+rcgUpbT4/CM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LzdM35ksSbP1wBfV/jodc4wnXIfdlO6i4IdWeknclKnw6avFiLVnyXhmJwUlCbAqX
         7+XEyFodI+3KBMngSHm7sY1yqcChWC9F2vXD5u2PtmawWZoadfJSPdp0j15HKwA2J3
         uw63SrwL5vMDTWDr9P/aUEYzVNR47tgJh3KEMhcCwB8OYWHbCzaTXuG6i3haI6CZxO
         XdLk0Sn25sOOwAO3fcPfrBWeLZ+I9aDun/WeCx9a5Tj18XrsBmYq+fLnWbAHJA8wmI
         j/b+SdxNnlTsoJRJEKMS0ZUCpFC0hpfYsPye1ALHglqHOajNjXS8Z7rvUzndW6HzrI
         i5IeHxzjqymIw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1ED46E5D089;
        Fri, 28 Jan 2022 03:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next RESEND 01/17] net/mlx5e: Move code chunk setting encap
 dests into its own function
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164334001411.1685.13356722940879696600.git-patchwork-notify@kernel.org>
Date:   Fri, 28 Jan 2022 03:20:14 +0000
References: <20220127204007.146300-2-saeed@kernel.org>
In-Reply-To: <20220127204007.146300-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        roid@nvidia.com, ozsh@nvidia.com, saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Saeed Mahameed <saeedm@nvidia.com>:

On Thu, 27 Jan 2022 12:39:51 -0800 you wrote:
> From: Roi Dayan <roid@nvidia.com>
> 
> Split setting encap dests code chunk out of mlx5e_tc_add_fdb_flow()
> to make the function smaller for maintainability and reuse.
> For symmetry do the same for mlx5e_tc_del_fdb_flow().
> While at it refactor cleanup to first check for encap flag like
> done when setting encap dests.
> 
> [...]

Here is the summary with links:
  - [net-next,RESEND,01/17] net/mlx5e: Move code chunk setting encap dests into its own function
    https://git.kernel.org/netdev/net-next/c/39542e234b52
  - [net-next,RESEND,02/17] net/mlx5e: Pass attr arg for attaching/detaching encaps
    https://git.kernel.org/netdev/net-next/c/c118ebc98233
  - [net-next,RESEND,03/17] net/mlx5e: Move counter creation call to alloc_flow_attr_counter()
    https://git.kernel.org/netdev/net-next/c/df67ad625b9e
  - [net-next,RESEND,04/17] net/mlx5e: TC, Move pedit_headers_action to parse_attr
    https://git.kernel.org/netdev/net-next/c/09bf97923224
  - [net-next,RESEND,05/17] net/mlx5e: TC, Split pedit offloads verify from alloc_tc_pedit_action()
    https://git.kernel.org/netdev/net-next/c/918ed7bf7626
  - [net-next,RESEND,06/17] net/mlx5e: TC, Pass attr to tc_act can_offload()
    https://git.kernel.org/netdev/net-next/c/8be9686d2479
  - [net-next,RESEND,07/17] net/mlx5e: TC, Refactor mlx5e_tc_add_flow_mod_hdr() to get flow attr
    https://git.kernel.org/netdev/net-next/c/ff9931670079
  - [net-next,RESEND,08/17] net/mlx5e: TC, Reject rules with multiple CT actions
    https://git.kernel.org/netdev/net-next/c/3b49a7edec1d
  - [net-next,RESEND,09/17] net/mlx5e: TC, Hold sample_attr on stack instead of pointer
    https://git.kernel.org/netdev/net-next/c/eeed226ed110
  - [net-next,RESEND,10/17] net/mlx5e: CT, Don't set flow flag CT for ct clear flow
    https://git.kernel.org/netdev/net-next/c/efe6f961cd2e
  - [net-next,RESEND,11/17] net/mlx5e: Refactor eswitch attr flags to just attr flags
    https://git.kernel.org/netdev/net-next/c/e5d4e1da6556
  - [net-next,RESEND,12/17] net/mlx5e: Test CT and SAMPLE on flow attr
    https://git.kernel.org/netdev/net-next/c/84ba8062e383
  - [net-next,RESEND,13/17] net/mlx5e: TC, Store mapped tunnel id on flow attr
    https://git.kernel.org/netdev/net-next/c/73a3f1bcab1e
  - [net-next,RESEND,14/17] net/mlx5e: CT, Remove redundant flow args from tc ct calls
    https://git.kernel.org/netdev/net-next/c/a572c0a748e6
  - [net-next,RESEND,15/17] net/mlx5: Remove unused TIR modify bitmask enums
    https://git.kernel.org/netdev/net-next/c/9059b04b4108
  - [net-next,RESEND,16/17] net/mlx5: Introduce software defined steering capabilities
    https://git.kernel.org/netdev/net-next/c/8348b71ccd92
  - [net-next,RESEND,17/17] net/mlx5: VLAN push on RX, pop on TX
    https://git.kernel.org/netdev/net-next/c/60dc0ef674ec

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


