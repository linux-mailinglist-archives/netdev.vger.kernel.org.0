Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52EBC5B3082
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 09:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231675AbiIIHqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 03:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231665AbiIIHp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 03:45:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBDB2117485;
        Fri,  9 Sep 2022 00:42:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 526F6B82350;
        Fri,  9 Sep 2022 07:40:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F31F5C4347C;
        Fri,  9 Sep 2022 07:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662709223;
        bh=389iDUll1rcT04SnumQrjv/1zA+wFA8PUQ3/MKWRUd4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GS2DQJT6dEOI2YmHu4OZUpO0jeKE8LtPhhnJYlbp/LP/tW7Ms3kIJ/rPcwRnfwgVz
         piPnB+QGjkuDLKod7RLx/T8fW/26I951aJvdWWytdTEDSU+/nJgsNQDGZwKMM1Rc+B
         k15OEJTNjOZVwjW8h2TkSHQsebPyYreqZeaFOsuBQOpH/uhWHYyMzkCJjOf1fqymmF
         BPWYbbJH8FRIuWkLs8a3Mxa5N7dXdA1Nlh8jeLWFE5w1HtGdmAl/NQa+ZwejaEFac7
         J+RTT78QLUDO7XDogK0f3BF/BXhawzEBFyMJNSSS5VmIzFBCLZYiB554MSxF4eqbCa
         Yt4pnVg7S1F6A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D8E90E1CABD;
        Fri,  9 Sep 2022 07:40:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next V2 0/2] net: lan743x: Fix to use multiqueue
 start/stop APIs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166270922288.30497.14233260513755591093.git-patchwork-notify@kernel.org>
Date:   Fri, 09 Sep 2022 07:40:22 +0000
References: <20220908082834.5070-1-Raju.Lakkaraju@microchip.com>
In-Reply-To: <20220908082834.5070-1-Raju.Lakkaraju@microchip.com>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, bryan.whitehead@microchip.com,
        UNGLinuxDriver@microchip.com, Ian.Saturley@microchip.com
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
by David S. Miller <davem@davemloft.net>:

On Thu, 8 Sep 2022 13:58:32 +0530 you wrote:
> This patch series address the fix to use multiqueue start/stop APIs and Add Rx IP and TCP checksum offload
> 
> Changes:
> ========
> V1 -> V2:
>  - Fix the sparse warnings
> 
> [...]

Here is the summary with links:
  - [net-next,V2,1/2] net: lan743x: Fix to use multiqueue start/stop APIs
    https://git.kernel.org/netdev/net-next/c/721f80c4d550
  - [net-next,V2,2/2] net: lan743x: Add support for Rx IP & TCP checksum offload
    https://git.kernel.org/netdev/net-next/c/cd6910501cfd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


