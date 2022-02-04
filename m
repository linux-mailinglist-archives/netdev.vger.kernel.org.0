Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A46B54A97F8
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 11:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240339AbiBDKkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 05:40:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241822AbiBDKkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 05:40:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8695CC061714
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 02:40:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83224B810AC
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 10:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 14E3AC340F2;
        Fri,  4 Feb 2022 10:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643971213;
        bh=/fgy3n1Tj8pmt9kcQaCEs7RnT03VJs6O5INjhhH1R7U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jwOX+8mtsBIRgPkF31NSbzzjx0FkcVl7Dz4al9hUvC1KKbVWv4ypgJ6WMmtnP1iFW
         b3BRUqx/7Get8YewDtiZmS9o+/CAkycEZbycluey8OE6O1jGQp0xbHbTR7AXAQ7jRL
         I2n+Z9MmEVtKE4BZqgC7kyNwGu9MXFqd0y2uyc/Ii0QpASTOmFFy0uYWBSGM+QbNrP
         OaSic0P8N6grrP69Hf/zF2gZnqP/js+50+jtM32gi6YuO+05BdMQ78wcBtxlUQa3so
         FY+WbfraGpkQo3Y4ndYiNsAUUJmnZaeWR900z2GViB+N52KWlo4CNHtgOlnITYt1bl
         kV6A1Lt5B/EHw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EDA28E6D3DD;
        Fri,  4 Feb 2022 10:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/7][pull request] 40GbE Intel Wired LAN Driver
 Updates 2022-02-03
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164397121296.5815.11134187232009697528.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Feb 2022 10:40:12 +0000
References: <20220203215140.969227-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220203215140.969227-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Thu,  3 Feb 2022 13:51:33 -0800 you wrote:
> This series contains updates to the i40e client header file and driver.
> 
> Mateusz disables HW TC offload by default.
> 
> Joe Damato removes a no longer used statistic.
> 
> Jakub Kicinski removes an unused enum from the client header file.
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] i40e: Disable hw-tc-offload feature on driver load
    https://git.kernel.org/netdev/net-next/c/647c65e14332
  - [net-next,2/7] i40e: Remove unused RX realloc stat
    https://git.kernel.org/netdev/net-next/c/79f227c4ff3e
  - [net-next,3/7] i40e: remove enum i40e_client_state
    https://git.kernel.org/netdev/net-next/c/00edb2bac29f
  - [net-next,4/7] i40e: Add sending commands in atomic context
    https://git.kernel.org/netdev/net-next/c/59b3d7350ff3
  - [net-next,5/7] i40e: Add new versions of send ASQ command functions
    https://git.kernel.org/netdev/net-next/c/74073848b0d7
  - [net-next,6/7] i40e: Add new version of i40e_aq_add_macvlan function
    https://git.kernel.org/netdev/net-next/c/b3237df9e7c8
  - [net-next,7/7] i40e: Fix race condition while adding/deleting MAC/VLAN filters
    https://git.kernel.org/netdev/net-next/c/53a9e346e159

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


