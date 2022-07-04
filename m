Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C470565075
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 11:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232655AbiGDJKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 05:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbiGDJKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 05:10:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2A2E1D2
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 02:10:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 658EFB80E13
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 09:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 359BFC341CE;
        Mon,  4 Jul 2022 09:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656925816;
        bh=mDnAMix83Z+3VeBq3bb5W/Eb3xniNM1AHSjlo27x7oU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PO1ZWdb1/MUR4lZ6KOeeUbdAbJpfJai8eT/pFg8WAIZa3mJWV7gy1LMH86tzm3vJf
         QwYIN65aid3c3li6bJxxXLYPUaekoIDaRHEClIhLj0d/C5+TqzNOB16nLIOVyJKLEy
         lRkotfPVMQUP3q4XQmY5fv8wtkUDoQzeePrgYT34h+xuDb4ja8nZtMh7NyLShzgqgp
         iBTTVpyVBLZUuj/CseChM5QzYUAe+l/pFctorRbgI2cJ1jaXiqhcu1nMNfpo+OpjS0
         1gtjjvqbM+31IZchoUe1TeEUuxRJzEXVCZRPdpArbEt6dqmjqKi09rqTE7Lo6NH6cB
         csdhaAcUrZb6w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1CFEBE45BDE;
        Mon,  4 Jul 2022 09:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 00/13] mlxsw: Unified bridge conversion - part 6/6
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165692581610.32669.14651472023440335107.git-patchwork-notify@kernel.org>
Date:   Mon, 04 Jul 2022 09:10:16 +0000
References: <20220704061139.1208770-1-idosch@nvidia.com>
In-Reply-To: <20220704061139.1208770-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, petrm@nvidia.com,
        amcohen@nvidia.com, mlxsw@nvidia.com
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon,  4 Jul 2022 09:11:26 +0300 you wrote:
> This is the sixth and final part of the conversion of mlxsw to the
> unified bridge model. It transitions the last bits of functionality that
> were under firmware's responsibility in the legacy model to the driver.
> The last patches flip the driver to the unified bridge model and clean
> up code that was used to make the conversion easier to review.
> 
> Patchset overview:
> 
> [...]

Here is the summary with links:
  - [net-next,v2,01/13] mlxsw: Configure egress VID for unicast FDB entries
    https://git.kernel.org/netdev/net-next/c/53d7ae53d807
  - [net-next,v2,02/13] mlxsw: spectrum_fid: Configure VNI to FID classification
    https://git.kernel.org/netdev/net-next/c/8cfc7f7707c1
  - [net-next,v2,03/13] mlxsw: Configure ingress RIF classification
    https://git.kernel.org/netdev/net-next/c/fea20547d5b5
  - [net-next,v2,04/13] mlxsw: spectrum_fid: Configure layer 3 egress VID classification
    https://git.kernel.org/netdev/net-next/c/d4b464d20bc1
  - [net-next,v2,05/13] mlxsw: spectrum_router: Do not configure VID for sub-port RIFs
    https://git.kernel.org/netdev/net-next/c/2c3ae763eb70
  - [net-next,v2,06/13] mlxsw: Configure egress FID classification after routing
    https://git.kernel.org/netdev/net-next/c/058de325a4fb
  - [net-next,v2,07/13] mlxsw: Add support for VLAN RIFs
    https://git.kernel.org/netdev/net-next/c/662761d8987d
  - [net-next,v2,08/13] mlxsw: Add new FID families for unified bridge model
    https://git.kernel.org/netdev/net-next/c/d4324e3194c7
  - [net-next,v2,09/13] mlxsw: Add support for 802.1Q FID family
    https://git.kernel.org/netdev/net-next/c/bf73904f5fba
  - [net-next,v2,10/13] mlxsw: Add ubridge to config profile
    https://git.kernel.org/netdev/net-next/c/e9cf8990faea
  - [net-next,v2,11/13] mlxsw: Enable unified bridge model
    https://git.kernel.org/netdev/net-next/c/77b7f83d5c25
  - [net-next,v2,12/13] mlxsw: spectrum_fid: Remove flood_index() from FID operation structure
    https://git.kernel.org/netdev/net-next/c/8928fd47782c
  - [net-next,v2,13/13] mlxsw: spectrum_fid: Remove '_ub_' indication from structures and defines
    https://git.kernel.org/netdev/net-next/c/88840d697f6e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


