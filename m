Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30D564FF591
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 13:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbiDMLWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 07:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231664AbiDMLWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 07:22:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E38D1E3DA
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 04:20:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2599861DB3
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 11:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6E7D0C385A6;
        Wed, 13 Apr 2022 11:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649848812;
        bh=lgNYzJUDqMyAoJlIGel6zC5bsGcBKHED1wpnoeX0/TY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CfxKedNfPDnw0S/QLuDAMjstV5REe213F9B99QJv6aY/PVV4A92vUgtPAUlN3+QHC
         MesGRY/xUjVDPDKftI8XIed71m4oUpRRI6wTF8Bx7nMpqMvhA0mIMEFsyJpvqqPRzS
         0gJS4SmK1vX3SC3w+AAY3X/rFiHk2aZlLltIsBHktIuKll9QlJhHtLdTkhuVEDLVA1
         Tlv8Jnt72Dn3nsWq12yL9y/Jsk1Lo8XumlYHft53FNZ2tJG4BuPgvS8/bb7YRTw4NJ
         NmW8N4VhCpDkEgxSnIS9KoL2I0+/wXQ7h4+yBoJagxzQBXVuy2eZqZYHlRaamPArbl
         EJYLmxbSV0yng==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5141BE73CC8;
        Wed, 13 Apr 2022 11:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5][pull request] 40GbE Intel Wired LAN Driver
 Updates 2022-04-12
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164984881232.9861.14289033106095828235.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Apr 2022 11:20:12 +0000
References: <20220412183636.1408915-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220412183636.1408915-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, sassmann@redhat.com
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
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Tue, 12 Apr 2022 11:36:31 -0700 you wrote:
> This series contains updates to i40e and ice drivers.
> 
> Joe Damato adds TSO support for MPLS packets on i40e and ice drivers. He
> also adds tracking and reporting of tx_stopped statistic for i40e.
> 
> Nabil S. Alramli adds reporting of tx_restart to ethtool for i40e.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] i40e: Add support for MPLS + TSO
    https://git.kernel.org/netdev/net-next/c/b4fb2d33514a
  - [net-next,2/5] ice: Add mpls+tso support
    https://git.kernel.org/netdev/net-next/c/69e66c04c672
  - [net-next,3/5] i40e: Add tx_stopped stat
    https://git.kernel.org/netdev/net-next/c/f728fa016669
  - [net-next,4/5] i40e: Add vsi.tx_restart to i40e ethtool stats
    https://git.kernel.org/netdev/net-next/c/c8631e61f4d4
  - [net-next,5/5] i40e: Add Ethernet Connection X722 for 10GbE SFP+ support
    https://git.kernel.org/netdev/net-next/c/a941d5ee4c57

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


