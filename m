Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6026750286C
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 12:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352359AbiDOKnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 06:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352388AbiDOKmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 06:42:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE9A92E681
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 03:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86D6EB82DEA
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 10:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2CFBDC385A5;
        Fri, 15 Apr 2022 10:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650019212;
        bh=Lo/W3msLIDn0toThWa+wPJLD3Tta0knEYqk5b7NiUsc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Jhg5QNRIeb1IcJU7As6XMbASg+piTVEf7CujTlPTZhOTd+aPa50z9lesoYpp2fY7u
         4UFdgvX0vaUSTp9STYI7udrVIRVfcAOoRGDvwuAhiALZFEjMfwKs/EPIV5yvWXmxmZ
         TfRjq2tnyvh9r/YQl6F81O0sLml8lphcGvRmoa++ofsvu59e13SpRgcPa3mxpnsoIq
         UoFBX6HWblXNaVRAzf4pV8nD0eOgqt4ltyf5AuLJs81l48KdvNdh6PKvu+xTSMSN7/
         c9VkALIvLRYz8zihEy+MRyy8nSJ4k3bVhOTxAYnaJNo6hc77RxPHRampmjtnjquOU+
         LrmdzX3FCM2yw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 118D8E8DD6A;
        Fri, 15 Apr 2022 10:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/4][pull request] Intel Wired LAN Driver Updates
 2022-04-14
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165001921206.21438.10383101278275867241.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Apr 2022 10:40:12 +0000
References: <20220414161522.2320694-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220414161522.2320694-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
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

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Thu, 14 Apr 2022 09:15:18 -0700 you wrote:
> This series contains updates to ice driver only.
> 
> Maciej adjusts implementation in __ice_alloc_rx_bufs_zc() for when
> ice_fill_rx_descs() does not return the entire buffer request and fixes a
> return value for !CONFIG_NET_SWITCHDEV configuration which was preventing
> VF creation.
> 
> [...]

Here is the summary with links:
  - [net,1/4] ice: xsk: check if Rx ring was filled up to the end
    https://git.kernel.org/netdev/net/c/d1fc4c6feac1
  - [net,2/4] ice: allow creating VFs for !CONFIG_NET_SWITCHDEV
    https://git.kernel.org/netdev/net/c/aacca7a83b97
  - [net,3/4] ice: fix crash in switchdev mode
    https://git.kernel.org/netdev/net/c/d201665147ae
  - [net,4/4] ice: Fix memory leak in ice_get_orom_civd_data()
    https://git.kernel.org/netdev/net/c/7c8881b77908

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


