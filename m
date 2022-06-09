Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0293D5449C2
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 13:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236028AbiFILKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 07:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbiFILKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 07:10:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA401F67;
        Thu,  9 Jun 2022 04:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18589B82D01;
        Thu,  9 Jun 2022 11:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B4845C3411B;
        Thu,  9 Jun 2022 11:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654773014;
        bh=angQ9HgEabaRWnSSsP84W4WjFN02l2ikuHAuguZUxZc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EpJ4Pj1dOd0aoG4OPpTAuHCDXbH9fry1o9YdEq6b0Zbb5vegpYfBQMhO09M7IjZXm
         wf8MKz73kZVPEXQwWywNXAzGcV/A5JACuqUvGKJC0LicEYJVeQ1apKkuxiaFwC7L2I
         bktb1m2ryzrNZqdaU7OOOcHz9GyW+V6H3lz0mWh2JYwl6L+pR/YIU4Erix+hf8Gd9C
         MLVT/rOGF8ryN1iHlECPEaSAKk8f1XXgv/slwu560KjV3fIXslFaL1jyhMHmXyxIQr
         ti6sHqHzWOmI9bQFL+WUUTCHmew8GLuqfq5MbxohK8Z44YNuWpYDpbgkroiwroH6Kv
         GKBZP0wUGFwAw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9D0AFE737ED;
        Thu,  9 Jun 2022 11:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next 0/8] vmxnet3: upgrade to version 7
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165477301463.8270.15863308665525214047.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Jun 2022 11:10:14 +0000
References: <20220608032353.964-1-doshir@vmware.com>
In-Reply-To: <20220608032353.964-1-doshir@vmware.com>
To:     Ronak Doshi <doshir@vmware.com>
Cc:     netdev@vger.kernel.org, pv-drivers@vmware.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 7 Jun 2022 20:23:45 -0700 you wrote:
> vmxnet3 emulation has recently added several new features including
> support for uniform passthrough(UPT). To make UPT work vmxnet3 has
> to be enhanced as per the new specification. This patch series
> extends the vmxnet3 driver to leverage these new features.
> 
> Compatibility is maintained using existing vmxnet3 versioning mechanism as
> follows:
>  - new features added to vmxnet3 emulation are associated with new vmxnet3
>    version viz. vmxnet3 version 7.
>  - emulation advertises all the versions it supports to the driver.
>  - during initialization, vmxnet3 driver picks the highest version number
>  supported by both the emulation and the driver and configures emulation
>  to run at that version.
> 
> [...]

Here is the summary with links:
  - [v3,net-next,1/8] vmxnet3: prepare for version 7 changes
    https://git.kernel.org/netdev/net-next/c/55f0395fcace
  - [v3,net-next,2/8] vmxnet3: add support for capability registers
    https://git.kernel.org/netdev/net-next/c/6f91f4ba046e
  - [v3,net-next,3/8] vmxnet3: add support for large passthrough BAR register
    https://git.kernel.org/netdev/net-next/c/543fb6740541
  - [v3,net-next,4/8] vmxnet3: add support for out of order rx completion
    https://git.kernel.org/netdev/net-next/c/2c5a5748105a
  - [v3,net-next,5/8] vmxnet3: add command to set ring buffer sizes
    (no matching commit)
  - [v3,net-next,6/8] vmxnet3: limit number of TXDs used for TSO packet
    https://git.kernel.org/netdev/net-next/c/d2857b99a74b
  - [v3,net-next,7/8] vmxnet3: use ext1 field to indicate encapsulated packet
    https://git.kernel.org/netdev/net-next/c/60cafa0395c2
  - [v3,net-next,8/8] vmxnet3: update to version 7
    https://git.kernel.org/netdev/net-next/c/acc38e041bd3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


