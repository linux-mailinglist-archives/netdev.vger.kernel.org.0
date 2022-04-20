Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0B28508A76
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 16:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380329AbiDTOS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 10:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379529AbiDTORW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 10:17:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F7D48E67
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 07:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F1E9B81F91
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 14:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 478E2C385A0;
        Wed, 20 Apr 2022 14:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650463813;
        bh=AqruDrVPfdTeTK7l+31IpKJgpN50++9kIINg5HAPUGU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Pyc2FRv8ZStgZxdone35ZuLpf3j9yct9afsPE1nrfi3pK/ng6xDXm6eEWVVDQgkvP
         BKuAVP84pYOZdgJO2doGco2jl6WERJ04Ohnglhj8YHXMTxm/RjSdPnEM/wftSUG4uW
         3zo3Q2XcWrtQdio3kr+LX/J803cAgkbvKnbbpivmTa5p1Vjl0G66AlnM5tRgX+14CU
         zje5Mz0/f8vQjoIPuNPM344bg2fHti4iVNCcVcOzbfd9Vzj2f17Bjm8gN11Yu3qzcF
         BZutbOvwwuL3J26Rbieu125Sg4VcHyowNFgM7boAedSyRBGQ2BGDB7Vpq6hx0p06cC
         YOv+QgbhArw5A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2F5A4E7399D;
        Wed, 20 Apr 2022 14:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] mlxsw: Line cards status tracking
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165046381319.28556.3439642580757582653.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Apr 2022 14:10:13 +0000
References: <20220419145431.2991382-1-idosch@nvidia.com>
In-Reply-To: <20220419145431.2991382-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, petrm@nvidia.com, jiri@nvidia.com,
        vadimp@nvidia.com, mlxsw@nvidia.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 19 Apr 2022 17:54:25 +0300 you wrote:
> When a line card is provisioned, netdevs corresponding to the ports
> found on the line card are registered. User space can then perform
> various logical configurations (e.g., splitting, setting MTU) on these
> netdevs.
> 
> However, since the line card is not present / powered on (i.e., it is
> not in 'active' state), user space cannot access the various components
> found on the line card. For example, user space cannot read the
> temperature of gearboxes or transceiver modules found on the line card
> via hwmon / thermal. Similarly, it cannot dump the EEPROM contents of
> these transceiver modules. The above is only possible when the line card
> becomes active.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] mlxsw: core_linecards: Introduce ops for linecards status change tracking
    https://git.kernel.org/netdev/net-next/c/de28976d2650
  - [net-next,2/6] mlxsw: core: Add bus argument to environment init API
    https://git.kernel.org/netdev/net-next/c/7b261af9f641
  - [net-next,3/6] mlxsw: core_env: Split module power mode setting to a separate function
    https://git.kernel.org/netdev/net-next/c/a11e1ec141ea
  - [net-next,4/6] mlxsw: core_env: Add interfaces for line card initialization and de-initialization
    https://git.kernel.org/netdev/net-next/c/06a0fc43bb10
  - [net-next,5/6] mlxsw: core_thermal: Add interfaces for line card initialization and de-initialization
    https://git.kernel.org/netdev/net-next/c/f11a323da46c
  - [net-next,6/6] mlxsw: core_hwmon: Add interfaces for line card initialization and de-initialization
    https://git.kernel.org/netdev/net-next/c/99a03b3193f6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


