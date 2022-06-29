Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E15C156007D
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 14:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233453AbiF2Mu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 08:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233438AbiF2MuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 08:50:25 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38805326C0
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 05:50:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3F747CE26B0
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 12:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 44B7BC341D2;
        Wed, 29 Jun 2022 12:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656507020;
        bh=OR75pV5bq83Og4Ei7qCf1qdyosXRxYstjVOb1hnjuB8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RO0Y1irrfkud4zW0/pmNkTbY0TlfLijy+s0lnKyj2tHi3IFWgcEBG12QJl530gFyE
         MOk7KaxShbq7hDppFd1eAqBDVALfZ6sETuGQTznFYgi+xTXS0raeqd39NnwfO1fKNS
         1bQviW6vTernFCypVw0FsoYFkutOmf2wCix74BaalNh6PmzfLmAYZKAy1ZG06fGmEV
         0TCbxLFLJNjEDXp9UIK8f0fCTSWzItsI3sOaBO6QhSTXFlmpXTP5vmSbKCrcWqJp6S
         dUUTkcscwTjDwjkz9Uqu4xCDEAbh4MYzt4VP3+e4Di0kzTQN6hsfd6RmAIOPOdPHAz
         G8PCKsb9PyiJg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1FBEFE49BBA;
        Wed, 29 Jun 2022 12:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/10] mlxsw: Unified bridge conversion - part 5/6
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165650702012.9231.18075354679202882162.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Jun 2022 12:50:20 +0000
References: <20220629094007.827621-1-idosch@nvidia.com>
In-Reply-To: <20220629094007.827621-1-idosch@nvidia.com>
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
by David S. Miller <davem@davemloft.net>:

On Wed, 29 Jun 2022 12:39:57 +0300 you wrote:
> This is the fifth part of the conversion of mlxsw to the unified bridge
> model.
> 
> The previous part that was merged in commit d521bc0a0f7c ("Merge branch
> 'mlxsw-unified-bridge-conversion-part-4-6'") converted the flooding code
> to use the new APIs of the unified bridge model. As part of this
> conversion, the flooding code started accessing the port group table
> (PGT) directly in order to allocate MID indexes and configure the ports
> via which a packet needs to be replicated.
> 
> [...]

Here is the summary with links:
  - [net-next,01/10] mlxsw: Align PGT index to legacy bridge model
    https://git.kernel.org/netdev/net-next/c/4abaa5cc4d7c
  - [net-next,02/10] mlxsw: spectrum_switchdev: Rename MID structure
    https://git.kernel.org/netdev/net-next/c/eede53a49b3c
  - [net-next,03/10] mlxsw: spectrum_switchdev: Rename MIDs list
    https://git.kernel.org/netdev/net-next/c/eaa0791aed8b
  - [net-next,04/10] mlxsw: spectrum_switchdev: Save MAC and FID as a key in 'struct mlxsw_sp_mdb_entry'
    https://git.kernel.org/netdev/net-next/c/0ac985436eb9
  - [net-next,05/10] mlxsw: spectrum_switchdev: Add support for maintaining hash table of MDB entries
    https://git.kernel.org/netdev/net-next/c/5d0512e5cf74
  - [net-next,06/10] mlxsw: spectrum_switchdev: Add support for maintaining list of ports per MDB entry
    https://git.kernel.org/netdev/net-next/c/d2994e130585
  - [net-next,07/10] mlxsw: spectrum_switchdev: Implement mlxsw_sp_mc_mdb_entry_{init, fini}()
    https://git.kernel.org/netdev/net-next/c/ea0f58d6c543
  - [net-next,08/10] mlxsw: spectrum_switchdev: Add support for getting and putting MDB entry
    https://git.kernel.org/netdev/net-next/c/7434ed6102c1
  - [net-next,09/10] mlxsw: spectrum_switchdev: Flush port from MDB entries according to FID index
    https://git.kernel.org/netdev/net-next/c/4c3f7442770b
  - [net-next,10/10] mlxsw: spectrum_switchdev: Convert MDB code to use PGT APIs
    https://git.kernel.org/netdev/net-next/c/e28cd993b9a4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


