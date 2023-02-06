Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30C4D68B7B7
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 09:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbjBFIuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 03:50:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbjBFIuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 03:50:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3512415CB4;
        Mon,  6 Feb 2023 00:50:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95E3560DBA;
        Mon,  6 Feb 2023 08:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F15ACC4339B;
        Mon,  6 Feb 2023 08:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675673419;
        bh=VawD/EaHqKqVOZkMPGhwLh/T7LNSQjsFQoayrKLjIfI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jfSUmiTnJmJ66VPcl8Fzyqzjc0BtOLlHeb7oQdztUr48ov7hv4vE+M9H9CIL3o2PI
         E2kU+wiskZgz3pcC9qU55p2UZlNNPS+D4lCq1GENzf+iBkuegAUH6QVztJy8DutBRB
         yYkJ9fVv282f6knb1NNlEh2N4PvWr1kG1p7NOb1e897fqp7qRQ57n8UgiH4ufh6+cx
         bCwJJXMth1hFOyxHCzvFeW+1uqPsJ8W2Uy8zOJ88X7fviT2cDiicwYj3Rvk21nixdt
         WaEAHaXWt1ZSVRFTlyP1F0sgOBn8d9l47XUgFHcKdsAbUflBrP8vou9FFiq+sF5YhB
         jq0AbuXdKqzCQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D58A8E55EFD;
        Mon,  6 Feb 2023 08:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/10] Add support for PSFP in Sparx5
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167567341887.6519.10285007740594332273.git-patchwork-notify@kernel.org>
Date:   Mon, 06 Feb 2023 08:50:18 +0000
References: <20230202104355.1612823-1-daniel.machon@microchip.com>
In-Reply-To: <20230202104355.1612823-1-daniel.machon@microchip.com>
To:     Daniel Machon <daniel.machon@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com,
        joe@perches.com, richardcochran@gmail.com, casper.casan@gmail.com,
        horatiu.vultur@microchip.com, shangxiaojing@huawei.com,
        rmk+kernel@armlinux.org.uk, nhuck@google.com, error27@gmail.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
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
by David S. Miller <davem@davemloft.net>:

On Thu, 2 Feb 2023 11:43:45 +0100 you wrote:
> ================================================================================
> Add support for Per-Stream Filtering and Policing (802.1Q-2018, 8.6.5.1).
> ================================================================================
> 
> The VCAP CLM (VCAP IS0 ingress classifier) classifies streams,
> identified by ISDX (Ingress Service Index, frame metadata), and maps
> ISDX to streams.
> 
> [...]

Here is the summary with links:
  - [net-next,01/10] net: microchip: add registers needed for PSFP
    https://git.kernel.org/netdev/net-next/c/edad83e2ba1e
  - [net-next,02/10] net: microchip: sparx5: add resource pools
    https://git.kernel.org/netdev/net-next/c/bb535c0dbb6f
  - [net-next,03/10] net: microchip: sparx5: add support for Service Dual Leacky Buckets
    https://git.kernel.org/netdev/net-next/c/9bf508898983
  - [net-next,04/10] net: microchip: sparx5: add support for service policers
    https://git.kernel.org/netdev/net-next/c/1db82abf1969
  - [net-next,05/10] net: microchip: sparx5: add support for PSFP flow-meters
    https://git.kernel.org/netdev/net-next/c/d2185e79ba8f
  - [net-next,06/10] net: microchip: sparx5: add function for calculating PTP basetime
    https://git.kernel.org/netdev/net-next/c/9e02131ec272
  - [net-next,07/10] net: microchip: sparx5: add support for PSFP stream gates
    https://git.kernel.org/netdev/net-next/c/c70a5e2c3d18
  - [net-next,08/10] net: microchip: sparx5: add support for PSFP stream filters
    https://git.kernel.org/netdev/net-next/c/ae3e691f3442
  - [net-next,09/10] net: microchip: sparx5: initialize PSFP
    https://git.kernel.org/netdev/net-next/c/e116b19db202
  - [net-next,10/10] sparx5: add support for configuring PSFP via tc
    https://git.kernel.org/netdev/net-next/c/6ebf182bfdf1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


