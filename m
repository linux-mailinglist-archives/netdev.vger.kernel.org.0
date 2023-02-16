Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2EA698C7F
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 07:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbjBPGA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 01:00:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjBPGA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 01:00:27 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43406305D3
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 22:00:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7F6ECCE290A
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 06:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DEEB8C433EF;
        Thu, 16 Feb 2023 06:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676527219;
        bh=ShmZV82wvXe7dJI9DjmIcOCFk0P1At3d+rOcwhU+5Wc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GiQhaC+ELc8EMhlxSbBsVeOIFbio1sFfRyEg6aCVfwC84d18R6QLItB2sOcEuRxVH
         U0RCoHS2HyvnDjhuxrzrl47a+W22mPP6dAcpTSeXZFDbHQ7qew5QuUpgdjledWLX8J
         +NT0ZJax81esOUmSzk7bWvzfHV6fGYfg9N71IkYAjQRVcH+PPQnBa4mVL5OVcgnjyE
         7/hqKwEBduY6xx37ehZ/bTg6d9yfnVhKBkkqttWFVJ09zL4Nrp8ZQW4JuZXuKvXA9/
         6qJA/ORtuD/abwo2gEOkkvE9GnVp/WNhBnZ2ujv9LyR8isWKpPF+ySdy0lZifXggwz
         VUXrqeEqX9DNw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B7A5CE68D2E;
        Thu, 16 Feb 2023 06:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5][pull request] Intel Wired LAN Driver Updates
 2023-02-14 (ice)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167652721973.20381.12990243233357019561.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Feb 2023 06:00:19 +0000
References: <20230214213003.2117125-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230214213003.2117125-1-anthony.l.nguyen@intel.com>
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

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Tue, 14 Feb 2023 13:29:58 -0800 you wrote:
> This series contains updates to ice driver only.
> 
> Karol extends support for GPIO pins to E823 devices.
> 
> Daniel Vacek stops processing of PTP packets when link is down.
> 
> Pawel adds support for BIG TCP for IPv6.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] ice: Add GPIO pin support for E823 products
    https://git.kernel.org/netdev/net-next/c/634d841dbfa7
  - [net-next,2/5] ice/ptp: fix the PTP worker retrying indefinitely if the link went down
    https://git.kernel.org/netdev/net-next/c/fcc2cef37fed
  - [net-next,3/5] ice: add support BIG TCP on IPv6
    https://git.kernel.org/netdev/net-next/c/fce92dbc6117
  - [net-next,4/5] ice: Change ice_vsi_realloc_stat_arrays() to void
    https://git.kernel.org/netdev/net-next/c/d8a23ff6a755
  - [net-next,5/5] ice: Mention CEE DCBX in code comment
    https://git.kernel.org/netdev/net-next/c/13b599f15e1c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


