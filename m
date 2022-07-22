Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C76A57E12D
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 14:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234757AbiGVMA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 08:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234110AbiGVMAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 08:00:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E55C311C07
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 05:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6853D61E87
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 12:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BF0D4C341CA;
        Fri, 22 Jul 2022 12:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658491217;
        bh=v9YFvjHiNCBwU2GNdfcDuNfm9LClrkQPvU1mZJpW4AU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vJMdC31ZKgAo6BX/VOeJdCq529BHXy7zSDNcZ1R25ZywGhOBQTXr4sAa1WjEDsk7z
         PBF1RJ+UfJpQEmV08zLoc6lh5Fmdy51gJR16g6ebFSpee4b1YtmryiO2gZgAEmwGwg
         vETIeNtj9BNv8nzIZvgvpBb3x7/aQwr0DQI6o0LCRMgNmUYYG0SFEcobjOiKml66w3
         dV8TMDuULM+RarR+D8Aa7DYrgRFFs9g2JZdDhSky+Sudw96liR8yBphkAG5bSpN49h
         rzKWR5dFF0k3y93d/53hn8+CqmU/3ZS2MjravW5kWXkg9oRO1AzcEWSKBLfKLctDy6
         ZJ0cWGUmYVKAg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A51F9E451B3;
        Fri, 22 Jul 2022 12:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next 0/9] sfc: VF representors for EF100
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165849121766.11142.16399433309185575568.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Jul 2022 12:00:17 +0000
References: <cover.1658341691.git.ecree.xilinx@gmail.com>
In-Reply-To: <cover.1658341691.git.ecree.xilinx@gmail.com>
To:     <ecree@xilinx.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        linux-net-drivers@amd.com, netdev@vger.kernel.org,
        ecree.xilinx@gmail.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 20 Jul 2022 19:29:23 +0100 you wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> This series adds representor netdevices for EF100 VFs, as a step towards
>  supporting TC offload and vDPA usecases in future patches.
> In this first series is basic netdevice creation and packet TX; the
>  following series will add the RX path.
> 
> [...]

Here is the summary with links:
  - [v3,net-next,1/9] sfc: update EF100 register descriptions
    https://git.kernel.org/netdev/net-next/c/8ca353da9c10
  - [v3,net-next,2/9] sfc: detect ef100 MAE admin privilege/capability at probe time
    https://git.kernel.org/netdev/net-next/c/95287e1b4e5c
  - [v3,net-next,3/9] sfc: add skeleton ef100 VF representors
    https://git.kernel.org/netdev/net-next/c/08135eecd07f
  - [v3,net-next,4/9] sfc: add basic ethtool ops to ef100 reps
    https://git.kernel.org/netdev/net-next/c/5687eb3466a9
  - [v3,net-next,5/9] sfc: phys port/switch identification for ef100 reps
    https://git.kernel.org/netdev/net-next/c/e1479556f808
  - [v3,net-next,6/9] sfc: determine representee m-port for EF100 representors
    https://git.kernel.org/netdev/net-next/c/da56552d04c5
  - [v3,net-next,7/9] sfc: support passing a representor to the EF100 TX path
    https://git.kernel.org/netdev/net-next/c/02443ab8c931
  - [v3,net-next,8/9] sfc: hook up ef100 representor TX
    https://git.kernel.org/netdev/net-next/c/f72c38fad234
  - [v3,net-next,9/9] sfc: attach/detach EF100 representors along with their owning PF
    https://git.kernel.org/netdev/net-next/c/84e7fc2591f7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


