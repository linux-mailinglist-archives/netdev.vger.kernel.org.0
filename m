Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8068F63349C
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 06:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231615AbiKVFAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 00:00:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiKVFAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 00:00:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D47432B190
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 21:00:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6EE8FB81982
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 05:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1FF7EC4314A;
        Tue, 22 Nov 2022 05:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669093222;
        bh=8Xr6C50ah7c0+chrZuLBILU8rzUO+czfZfzy2lW2B5s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MwcLlliPC4tQ1CF0s3j0LAXL8MCW16NdWn5DjAjCVb2lIg8HJwvEUFlA4/9JQmQki
         rJbBb2IkUK7BLhxDugmOEuw746zwFDUifLrFEk56OYAM75xJYIWm/xr8i+Nb68JG9U
         /yUSLQ4DB/p/5ivJI15G0m/WITst0u/k4PNvdwj8FpK4xyJQ27bXzSbMpdZ/F4/EPE
         z4ZOVGrMuu4FcruzuGDip5OxWxw5mzTBUvg3AhQV9K8TMNpKZojsgU2+4K9ieGTUkt
         LQy6dTxWlrpeCOtyW+winq+TuKY0j0mp/HHfDRWDMzSO2Gdf0zC5bCM37AwUsJS0ip
         yLoJz9v5brj4w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E8B60E29F40;
        Tue, 22 Nov 2022 05:00:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/4][pull request] Intel Wired LAN Driver Updates
 2022-11-18 (iavf)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166909322194.4259.1802533657614466609.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Nov 2022 05:00:21 +0000
References: <20221118222439.1565245-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20221118222439.1565245-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Fri, 18 Nov 2022 14:24:35 -0800 you wrote:
> This series contains updates to iavf driver only.
> 
> Ivan Vecera resolves issues related to reset by adding back call to
> netif_tx_stop_all_queues() and adding calls to dev_close() to ensure
> device is properly closed during reset.
> 
> Stefan Assmann removes waiting for setting of MAC address as this breaks
> ARP.
> 
> [...]

Here is the summary with links:
  - [net,1/4] iavf: Fix a crash during reset task
    https://git.kernel.org/netdev/net/c/c678669d6b13
  - [net,2/4] iavf: Do not restart Tx queues after reset task failure
    https://git.kernel.org/netdev/net/c/08f1c147b726
  - [net,3/4] iavf: remove INITIAL_MAC_SET to allow gARP to work properly
    https://git.kernel.org/netdev/net/c/bb861c14f1b8
  - [net,4/4] iavf: Fix race condition between iavf_shutdown and iavf_remove
    https://git.kernel.org/netdev/net/c/a8417330f8a5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


