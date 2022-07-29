Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26CF6584ECD
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 12:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235412AbiG2KaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 06:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbiG2KaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 06:30:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA600BB5
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 03:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 618CE61E13
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 10:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B3926C433D7;
        Fri, 29 Jul 2022 10:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659090614;
        bh=iFr/2x9jr4qdGfrKyz8Bmsu5E2AO07PZ157zRphP7ow=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qoOOL5pcXycBTBakRfh0tq+AEJwRq/NXU7pVozhKl5O9sJUFP2rX1+d02BpEJaGC7
         osHsN2/AaYuB9aq9A5V0Szx37YkdOozeomznqNHZHbNi0VFWHEujRjP3ZBRQBPtAYh
         MEee1dVGTTBgUioccqKRI/h/ST7SIlFkgYvF1TpEU5nRZ8s/Yrph0yhxarFo7J9Inr
         x4V17m1oNhxao4OjdAhymgnwZwQZK1wTPGiakdSIGTDKvmtRwtYzY5wa6P9pRPVUug
         28+BdnAtHyT18dpq+nra48wS5iTQZMHYDvF/D/uhLb2T0gGqVO5Tcbs6OlNaN4A0HN
         Wm89tX41dQOxA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9AA0BC43140;
        Fri, 29 Jul 2022 10:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/9] mlxsw: Add PTP support for Spectrum-2 and newer
 ASICs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165909061462.28132.17751188607626602427.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Jul 2022 10:30:14 +0000
References: <20220727062328.3134613-1-idosch@nvidia.com>
In-Reply-To: <20220727062328.3134613-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, richardcochran@gmail.com,
        petrm@nvidia.com, amcohen@nvidia.com, danieller@nvidia.com,
        mlxsw@nvidia.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 27 Jul 2022 09:23:19 +0300 you wrote:
> This patchset adds PTP support for Spectrum-{2,3,4} switch ASICs. They
> all act largely the same with respect to PTP except for a workaround
> implemented for Spectrum-{2,3} in patch #6.
> 
> Spectrum-2 and newer ASICs essentially implement a transparent clock
> between all the switch ports, including the CPU port. The hardware will
> generate the UTC time stamp for transmitted / received packets at the
> CPU port, but will compensate for forwarding delays in the ASIC by
> adjusting the correction field in the PTP header (for PTP events) at the
> ingress and egress ports.
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] mlxsw: spectrum_ptp: Add helper functions to configure PTP traps
    https://git.kernel.org/netdev/net-next/c/37b62b282b18
  - [net-next,2/9] mlxsw: Support CQEv2 for SDQ in Spectrum-2 and newer ASICs
    https://git.kernel.org/netdev/net-next/c/42823208b946
  - [net-next,3/9] mlxsw: spectrum_ptp: Add PTP initialization / finalization for Spectrum-2
    https://git.kernel.org/netdev/net-next/c/d25ff63a181b
  - [net-next,4/9] mlxsw: Query UTC sec and nsec PCI offsets and values
    https://git.kernel.org/netdev/net-next/c/bbd300570a9e
  - [net-next,5/9] mlxsw: spectrum_ptp: Add implementation for physical hardware clock operations
    https://git.kernel.org/netdev/net-next/c/a5bf8e5e8b8d
  - [net-next,6/9] mlxsw: Send PTP packets as data packets to overcome a limitation
    https://git.kernel.org/netdev/net-next/c/24157bc69f45
  - [net-next,7/9] mlxsw: spectrum: Support time stamping on Spectrum-2
    https://git.kernel.org/netdev/net-next/c/382ad0d95793
  - [net-next,8/9] mlxsw: spectrum_ptp: Support SIOCGHWTSTAMP, SIOCSHWTSTAMP ioctls
    https://git.kernel.org/netdev/net-next/c/08ef8bc825d9
  - [net-next,9/9] mlxsw: spectrum: Support ethtool 'get_ts_info' callback in Spectrum-2
    https://git.kernel.org/netdev/net-next/c/eba28aaf2f53

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


