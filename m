Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4F95598A3
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 13:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbiFXLkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 07:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbiFXLkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 07:40:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C6C68038
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 04:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68201621D2
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 11:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B6009C3411C;
        Fri, 24 Jun 2022 11:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656070814;
        bh=u7SavGs/BDt9kgn7UeI3xNCQGOJTT+Tjy44jRgFBxIY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RQG+ub/Gp90Z6FlSKGNRz57w2/FfyAFIfR60A2AVAN3BhIeGeJ518IE+APF2hZK3h
         m3EREcl+HGnP4b3Xvg28lpxQ9UebU+8aQ/IuGlCpoIRxX5lYEuLfTFTw9/VYSARv9Q
         HGg3782rT4Hw6WnsO0juztA9KaacwtTqwQ9bGEpC9W8+Ew3OENIRS1Ebbs3wmqS6Oe
         O3M6cqp2eZzx3KmfdqgimWhLSPYTbvKzUifbBEtgk/4DTMWe0uyoyOt6areEhTgdU7
         QEgT/3bRHHQKeDaXJYWJVr2J16ltSQIWDz99fcefAR4lrjaYaopoW6wekes/LNdcf6
         cWe7mH7ZiVEww==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8EE50E85C6D;
        Fri, 24 Jun 2022 11:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8] mlxsw: Unified bridge conversion - part 3/6
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165607081458.3787.15946530564012816529.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Jun 2022 11:40:14 +0000
References: <20220623071737.318238-1-idosch@nvidia.com>
In-Reply-To: <20220623071737.318238-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, petrm@nvidia.com,
        amcohen@nvidia.com, mlxsw@nvidia.com
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

On Thu, 23 Jun 2022 10:17:29 +0300 you wrote:
> This is the third part of the conversion of mlxsw to the unified bridge
> model.
> 
> Like the second part, this patchset does not begin the conversion, but
> instead prepares the FID code for it. The individual changes are
> relatively small and self-contained with detailed description and
> motivation in the commit message.
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] mlxsw: spectrum_fid: Maintain {port, VID}->FID mappings
    https://git.kernel.org/netdev/net-next/c/fddf42c34349
  - [net-next,2/8] mlxsw: spectrum_fid: Update FID structure prior to device configuration
    https://git.kernel.org/netdev/net-next/c/d97da68e543b
  - [net-next,3/8] mlxsw: spectrum_fid: Rename mlxsw_sp_fid_vni_op()
    https://git.kernel.org/netdev/net-next/c/893b5c307a48
  - [net-next,4/8] mlxsw: spectrum_fid: Pass FID structure to mlxsw_sp_fid_op()
    https://git.kernel.org/netdev/net-next/c/97a2ae0f0c23
  - [net-next,5/8] mlxsw: spectrum_fid: Pass FID structure to __mlxsw_sp_fid_port_vid_map()
    https://git.kernel.org/netdev/net-next/c/2c091048015d
  - [net-next,6/8] mlxsw: spectrum: Use different arrays of FID families per-ASIC type
    https://git.kernel.org/netdev/net-next/c/04e85970ceea
  - [net-next,7/8] mlxsw: spectrum: Rename MLXSW_SP_RIF_TYPE_VLAN
    https://git.kernel.org/netdev/net-next/c/027c92e00ef9
  - [net-next,8/8] mlxsw: spectrum: Change mlxsw_sp_rif_vlan_fid_op() to be dedicated for FID RIFs
    https://git.kernel.org/netdev/net-next/c/7dd196480664

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


