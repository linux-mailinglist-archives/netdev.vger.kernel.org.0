Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA9755E3F5
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345913AbiF1NAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 09:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231792AbiF1NAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 09:00:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C69562FE7A
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 06:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F9ADB81E14
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 13:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 39392C341CB;
        Tue, 28 Jun 2022 13:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656421216;
        bh=g5vJx1ufHS98t6VLxOeod6M2/4DouERJTvDX7gj+20w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=f2noS+P3U3nF7496Xc8Tg5Skc7utOlTKUvIUrw+S5EOcgpfyMzrlhDnaawHaYA1Ih
         76fYDwp+ZcVC42KLMk5MOE9nxHpKVFCLcwgvIimgUQzdDyS8UITtO0To7FmC2pxxoD
         gOONb3zvuu58z2CcoslgaeullLBEFzqxlCGoZu7u/0eFPA7ipL/7L8yzRoYn+oTRG3
         lMAFBk+5K9U4Pg0bu4eSaVN7ku9QXexzXtAUlMIrhoXBH/JZ0mDE+2bS2uwdA1K/+M
         0qiYACHp5A/8ErL+WOjoNpdMbHh2fzuaxbVRvFKNUxasSHw9KVwwwMzDGA4lhryxj5
         GRc3aOKo8sxag==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1B687E49F65;
        Tue, 28 Jun 2022 13:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/13] mlxsw: Unified bridge conversion - part 4/6
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165642121610.28895.9213208050951195008.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Jun 2022 13:00:16 +0000
References: <20220627070621.648499-1-idosch@nvidia.com>
In-Reply-To: <20220627070621.648499-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, petrm@nvidia.com,
        amcohen@nvidia.com, mlxsw@nvidia.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 27 Jun 2022 10:06:08 +0300 you wrote:
> This is the fourth part of the conversion of mlxsw to the unified bridge
> model.
> 
> Unlike previous parts that prepared mlxsw for the conversion, this part
> actually starts the conversion. It focuses on flooding configuration and
> converts mlxsw to the more "raw" APIs of the unified bridge model.
> 
> [...]

Here is the summary with links:
  - [net-next,01/13] mlxsw: spectrum: Add a temporary variable to indicate bridge model
    https://git.kernel.org/netdev/net-next/c/d6d9026668db
  - [net-next,02/13] mlxsw: spectrum_fid: Configure flooding table type for rFID
    https://git.kernel.org/netdev/net-next/c/93303ff828fd
  - [net-next,03/13] mlxsw: Prepare 'bridge_type' field for SFMR usage
    https://git.kernel.org/netdev/net-next/c/fad8e1b6d52d
  - [net-next,04/13] mlxsw: spectrum_fid: Store 'bridge_type' as part of FID family
    https://git.kernel.org/netdev/net-next/c/dd8c77d59708
  - [net-next,05/13] mlxsw: Set flood bridge type for FIDs
    https://git.kernel.org/netdev/net-next/c/aa845e36a069
  - [net-next,06/13] mlxsw: spectrum_fid: Configure egress VID classification for multicast
    https://git.kernel.org/netdev/net-next/c/8c2da081c8b8
  - [net-next,07/13] mlxsw: Add an initial PGT table support
    https://git.kernel.org/netdev/net-next/c/d8782ec59eb8
  - [net-next,08/13] mlxsw: Add an indication of SMPE index validity for PGT table
    https://git.kernel.org/netdev/net-next/c/a1697d11c945
  - [net-next,09/13] mlxsw: Add a dedicated structure for bitmap of ports
    https://git.kernel.org/netdev/net-next/c/d7a7b6978709
  - [net-next,10/13] mlxsw: Extend PGT APIs to support maintaining list of ports per entry
    https://git.kernel.org/netdev/net-next/c/a3a7992bc4e4
  - [net-next,11/13] mlxsw: spectrum: Initialize PGT table
    https://git.kernel.org/netdev/net-next/c/bb1bba35f50a
  - [net-next,12/13] mlxsw: spectrum_fid: Set 'mid_base' as part of flood tables initialization
    https://git.kernel.org/netdev/net-next/c/9f6f467a3cdb
  - [net-next,13/13] mlxsw: spectrum_fid: Configure flooding entries using PGT APIs
    https://git.kernel.org/netdev/net-next/c/fe94df6dc622

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


