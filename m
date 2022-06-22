Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1927F5548CC
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245011AbiFVMAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 08:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241412AbiFVMAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 08:00:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D0E73D1E3
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 05:00:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E4F8B81E36
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 12:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 39E46C341C0;
        Wed, 22 Jun 2022 12:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655899218;
        bh=UlOXuFNHW25a9qyvdE4AAMvkmFZH2GOaaW/fEGtWhj8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Tgr/9hVkOk3bGKM+bzvONQDLTPQWYRCTrPNX01KLTeWkqdVoV/xNVsAa8RDrrdbuF
         Tv6SiCty3BwDfDo9dT0sJdMG7SN3+9fymO8w0YBhYQJb3sbDRs7G4JrLFc7TINMaIr
         INNoeZJpbimUmL8X78AcYzWUoUlPww5xCE94zoPJzA+acRoV9Va/nkPuxDSKvshr2t
         qd4kwAZa2X1DZ2htx+wTPoDzLDzhMtvKNptHsjLlELHiUg2WJCow5pAT4fRx77VEPc
         rtDQrQC+3ROT1TjU1YqiTBdxcSB2Wn0Havjb91zE6kmY2Gk1Hyk/in7qWq4BL1Gp+2
         zFt/Bm83YseZQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2513AE574DA;
        Wed, 22 Jun 2022 12:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/13] mlxsw: Unified bridge conversion - part 2/6
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165589921814.12203.2881774083975642813.git-patchwork-notify@kernel.org>
Date:   Wed, 22 Jun 2022 12:00:18 +0000
References: <20220621083345.157664-1-idosch@nvidia.com>
In-Reply-To: <20220621083345.157664-1-idosch@nvidia.com>
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

On Tue, 21 Jun 2022 11:33:32 +0300 you wrote:
> This is the second part of the conversion of mlxsw to the unified bridge
> model. Part 1 was merged in commit 4336487e30c3 ("Merge branch
> 'mlxsw-unified-bridge-conversion-part-1'") which includes details about
> the new model and the motivation behind the conversion.
> 
> This patchset does not begin the conversion, but rather prepares the code
> base for it.
> 
> [...]

Here is the summary with links:
  - [net-next,01/13] mlxsw: Remove lag_vid_valid indication
    https://git.kernel.org/netdev/net-next/c/22aae52076cd
  - [net-next,02/13] mlxsw: spectrum_switchdev: Pass 'struct mlxsw_sp' to mlxsw_sp_bridge_mdb_mc_enable_sync()
    https://git.kernel.org/netdev/net-next/c/21c795f8494a
  - [net-next,03/13] mlxsw: spectrum_switchdev: Do not set 'multicast_enabled' twice
    https://git.kernel.org/netdev/net-next/c/6e66d2e4b3a2
  - [net-next,04/13] mlxsw: spectrum_switchdev: Simplify mlxsw_sp_port_mc_disabled_set()
    https://git.kernel.org/netdev/net-next/c/a6f43b1dad80
  - [net-next,05/13] mlxsw: spectrum_switchdev: Add error path in mlxsw_sp_port_mc_disabled_set()
    https://git.kernel.org/netdev/net-next/c/c96a9919c79e
  - [net-next,06/13] mlxsw: spectrum_switchdev: Convert mlxsw_sp_mc_write_mdb_entry() to return int
    https://git.kernel.org/netdev/net-next/c/fd66f5184c28
  - [net-next,07/13] mlxsw: spectrum_switchdev: Handle error in mlxsw_sp_bridge_mdb_mc_enable_sync()
    https://git.kernel.org/netdev/net-next/c/0100f840750c
  - [net-next,08/13] mlxsw: Add enumerator for 'config_profile.flood_mode'
    https://git.kernel.org/netdev/net-next/c/70b34c77f127
  - [net-next,09/13] mlxsw: cmd: Increase 'config_profile.flood_mode' length
    https://git.kernel.org/netdev/net-next/c/89df3c6261f2
  - [net-next,10/13] mlxsw: pci: Query resources before and after issuing 'CONFIG_PROFILE' command
    https://git.kernel.org/netdev/net-next/c/6131d9630d98
  - [net-next,11/13] mlxsw: spectrum_fid: Save 'fid_offset' as part of FID structure
    https://git.kernel.org/netdev/net-next/c/736bf371d2d4
  - [net-next,12/13] mlxsw: spectrum_fid: Use 'fid->fid_offset' when setting VNI
    https://git.kernel.org/netdev/net-next/c/784763e59225
  - [net-next,13/13] mlxsw: spectrum_fid: Implement missing operations for rFID and dummy FID
    https://git.kernel.org/netdev/net-next/c/048fcbb71a0e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


