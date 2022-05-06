Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 579AF51D5D8
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 12:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391033AbiEFKoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 06:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391029AbiEFKoB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 06:44:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253A49F
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 03:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9497615F9
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 10:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 49C6EC385A8;
        Fri,  6 May 2022 10:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651833616;
        bh=7FTICRjYcT/vW95oL7XliPW7nGWX6W7oGI2+SgGIdqM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gY8x1GM6MZWsm8Qx5dxzOpnj/t2ZdCyJvU+ZLblxuMkzHUcwbMiXnIFZnu8OeMzAD
         Ssai8L18wNshOgbVls4roJpN9s8T0Wxh9G/PQ1LwX1XTrtbSfsWtFKHcbMUGevIE6G
         eIm0+F45I1XRzZvuBSCcBOmWTnSCVE5Jao2eUpaz3MiHnYNr56uMgBcTdYBjvYHuaF
         6CjoLcfZO/pUdnQ0Kgrg5w86DZxG8nWhyOx9nTv735+y5mhHjIAL1e+Yk6vCvoynj2
         f7pWSUwgdHjAQbmqNTdbXQE5/bVN83bJ3rmI0Mv4uLfmMRr+GMQVGJXIHk+fmIPdAy
         Junf8C11Xc+ag==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 22D5FF0389D;
        Fri,  6 May 2022 10:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 00/10][pull request] 100GbE Intel Wired LAN Driver
 Updates 2022-05-05
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165183361613.1798.7098569814484775563.git-patchwork-notify@kernel.org>
Date:   Fri, 06 May 2022 10:40:16 +0000
References: <20220505200359.3080110-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220505200359.3080110-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
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
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Thu,  5 May 2022 13:03:49 -0700 you wrote:
> This series contains updates to ice driver only.
> 
> Wan Jiabing converts an open coded min selection to min_t().
> 
> Maciej commonizes on a single find VSI function and removes the
> duplicated implementation.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,01/10] ice: use min_t() to make code cleaner in ice_gnss
    https://git.kernel.org/netdev/net-next/c/187dbc15d8a7
  - [net-next,v2,02/10] ice: introduce common helper for retrieving VSI by vsi_num
    https://git.kernel.org/netdev/net-next/c/295819b562fa
  - [net-next,v2,03/10] ice: return ENOSPC when exceeding ICE_MAX_CHAIN_WORDS
    https://git.kernel.org/netdev/net-next/c/bd1ffe8e5df4
  - [net-next,v2,04/10] ice: get switch id on switchdev devices
    https://git.kernel.org/netdev/net-next/c/4b889474adc6
  - [net-next,v2,05/10] ice: add newline to dev_dbg in ice_vf_fdir_dump_info
    https://git.kernel.org/netdev/net-next/c/9880d3d6f9e3
  - [net-next,v2,06/10] ice: always check VF VSI pointer values
    https://git.kernel.org/netdev/net-next/c/baeb705fd6a7
  - [net-next,v2,07/10] ice: remove return value comment for ice_reset_all_vfs
    https://git.kernel.org/netdev/net-next/c/00be8197c974
  - [net-next,v2,08/10] ice: fix wording in comment for ice_reset_vf
    https://git.kernel.org/netdev/net-next/c/19c3e1ede517
  - [net-next,v2,09/10] ice: add a function comment for ice_cfg_mac_antispoof
    https://git.kernel.org/netdev/net-next/c/71c114e87539
  - [net-next,v2,10/10] ice: remove period on argument description in ice_for_each_vf
    https://git.kernel.org/netdev/net-next/c/4eaf1797bca1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


