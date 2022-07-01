Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68EEE563198
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 12:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236653AbiGAKkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 06:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236552AbiGAKkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 06:40:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D49567B356
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 03:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A9EAB82F84
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 10:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4330DC341CB;
        Fri,  1 Jul 2022 10:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656672015;
        bh=Y/IyYdnwlU5YXog/iXF2zmT8FwqXXaefka/9wvcnFgg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NJuXEAtUMGt2PdFUFAF15IrtmHWXo6KUzaAhMNsm3Ba0tUkyrnWASP7ljf1gZuLyU
         6JyPoqA7h0xFTA5dULgZ4J3nWaYeuPRzYNRECVUNRXuI8aLBvxyd76z1Bl72yFsvaB
         oq1+O3yKGYehidIE9RcQ6c/LogrJSidvUzRAZBYozFzN7G8YTmQfHodGkxOHzVm9ps
         8RhO0Kvvd+DWm1nWNe6LfZGvTa4kKZ0pgDUsKmJlKpK0uF65KaiLyK6YYCCNxrq1pn
         mKyG+TOfh+X+3yqaupzG9mt0jDd4+0wr+eEYNpW+LGC8Y3gxGwJgjcjw79rVWFIwlv
         eaX7u8Gb3dGvw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2407EE49BBC;
        Fri,  1 Jul 2022 10:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates
 2022-06-30
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165667201514.26485.7770729375287574254.git-patchwork-notify@kernel.org>
Date:   Fri, 01 Jul 2022 10:40:15 +0000
References: <20220630214940.3036250-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220630214940.3036250-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org, sassmann@redhat.com
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

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Thu, 30 Jun 2022 14:49:38 -0700 you wrote:
> This series contains updates to i40e driver only.
> 
> Lukasz adds reporting of packets dropped for being too large into the Rx
> dropped statistics.
> 
> Norbert clears VF filter and MAC address to resolve issue with older VFs
> being unable to change their MAC address.
> 
> [...]

Here is the summary with links:
  - [net,1/2] i40e: Fix dropped jumbo frames statistics
    https://git.kernel.org/netdev/net/c/1adb1563e7b7
  - [net,2/2] i40e: Fix VF's MAC Address change on VM
    https://git.kernel.org/netdev/net/c/fed0d9f13266

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


