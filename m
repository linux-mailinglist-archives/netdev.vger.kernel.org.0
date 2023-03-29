Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D98E76CD41C
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 10:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbjC2IKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 04:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbjC2IKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 04:10:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9128426A5
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 01:10:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21BCCB82151
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 08:10:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B24F5C433A0;
        Wed, 29 Mar 2023 08:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680077427;
        bh=aZZMoQORPJLMTv3i9EEdmTtHMyLLkEm8RH8CBgDLN90=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ojfCo1OqS3HbZcyGKvBWssNgetj3X2cKY3dG+6+7tIwqSGY1XC57ZhLQNuUEqJEnv
         KII7/a2XZsBOJPiZxzEaoQLoTYPvakQ3sOsuMM1N3ov4BhR/DBKlwXM0N7zf3pFhCa
         o4aLWhz7TomE5Sdzq3ewT5bBYxb8bD6OCAExFB2nC9DIYWU2Z51xm3yZgABfjxas5S
         kqKAq+fMDlkHln6KXWu1sqbErRJdnxRfpDbpwoGtEQSU+trhZRo+Fmom2mDxuKCAyn
         Q9puqjpux0Ypl2oJK21o0os6PRK0g+cnvR5XIESX931VG0OMqKWMNZvjKN6bhjN6G0
         WDdSllT2ewjrQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 97CEEE4F0DB;
        Wed, 29 Mar 2023 08:10:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/6] sfc: support TC decap rules
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168007742661.16006.10917682225413087784.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Mar 2023 08:10:26 +0000
References: <cover.1679912088.git.ecree.xilinx@gmail.com>
In-Reply-To: <cover.1679912088.git.ecree.xilinx@gmail.com>
To:     <edward.cree@amd.com>
Cc:     linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, ecree.xilinx@gmail.com,
        netdev@vger.kernel.org, habetsm.xilinx@gmail.com,
        michal.swiatkowski@linux.intel.com, simon.horman@corigine.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 27 Mar 2023 11:36:02 +0100 you wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> This series adds support for offloading tunnel decapsulation TC rules to
>  ef100 NICs, allowing matching encapsulated packets to be decapsulated in
>  hardware and redirected to VFs.
> For now an encap match must be on precisely the following fields:
>  ethertype (IPv4 or IPv6), source IP, destination IP, ipproto UDP,
>  UDP destination port.  This simplifies checking for overlaps in the
>  driver; the hardware supports a wider range of match fields which
>  future driver work may expose.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/6] sfc: document TC-to-EF100-MAE action translation concepts
    https://git.kernel.org/netdev/net-next/c/edd025ca0887
  - [net-next,v3,2/6] sfc: add notion of match on enc keys to MAE machinery
    https://git.kernel.org/netdev/net-next/c/b9d5c9b7d8a4
  - [net-next,v3,3/6] sfc: handle enc keys in efx_tc_flower_parse_match()
    https://git.kernel.org/netdev/net-next/c/b7f5e17b3bb9
  - [net-next,v3,4/6] sfc: add functions to insert encap matches into the MAE
    https://git.kernel.org/netdev/net-next/c/2245eb0086d8
  - [net-next,v3,5/6] sfc: add code to register and unregister encap matches
    https://git.kernel.org/netdev/net-next/c/746224cdef01
  - [net-next,v3,6/6] sfc: add offloading of 'foreign' TC (decap) rules
    https://git.kernel.org/netdev/net-next/c/17654d84b47c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


