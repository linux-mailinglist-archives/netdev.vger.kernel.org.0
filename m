Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D04904CB6E0
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 07:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbiCCGU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 01:20:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiCCGU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 01:20:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C15167F87
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 22:20:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 800406187F
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 06:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DFDD5C340E9;
        Thu,  3 Mar 2022 06:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646288412;
        bh=8w8JiGDzr9CiBWB2wQ0UYVEmrp4M+IXxH8DzbmiJY3A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EhBiKkNXbNyoYqyZf9i7BaCWK2+xt4pV8qEaT3B9n+7eLFX/QgRyw8Fzn5Uhduu8O
         giDkwBA/SThHzRTsHcocAIXwqyJbVOzL/u8a8c16P2Z8YS2JmfhMqvn32wstPrs/UU
         aAEwuqSG3IkhwAKfLJ60dg+F7CnyxjcgtyQ55uXSPd3ZBFcioUx3+YmitExUjHJmTv
         TdxE+L/z2OmnY2M4TlCe6VH0by20qTwb+1RaaN1zSTnVmPvs0Kb4RC1WR264C4vW6z
         SBUI9EcvsbHPCg/zR0z3zO1wUJeNamfBno9VMmQnsXLjWXdMhfsyqFNHP58eGl2h0Z
         aTPHIJAL/f05A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CBF88EAC096;
        Thu,  3 Mar 2022 06:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/7][pull request] 40GbE Intel Wired LAN Driver
 Updates 2022-03-01
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164628841283.5215.15039723753643376506.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Mar 2022 06:20:12 +0000
References: <20220301185939.3005116-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220301185939.3005116-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
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

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Tue,  1 Mar 2022 10:59:32 -0800 you wrote:
> This series contains updates to iavf driver only.
> 
> Mateusz adds support for interrupt moderation for 50G and 100G speeds
> as well as support for the driver to specify a request as its primary
> MAC address. He also refactors VLAN V2 capability exchange into more
> generic extended capabilities to ease the addition of future
> capabilities. Finally, he corrects the incorrect return of iavf_status
> values and removes non-inclusive language.
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] iavf: Add support for 50G/100G in AIM algorithm
    https://git.kernel.org/netdev/net-next/c/d73dd1275e70
  - [net-next,2/7] iavf: refactor processing of VLAN V2 capability message
    https://git.kernel.org/netdev/net-next/c/87dba256c7a6
  - [net-next,3/7] iavf: Add usage of new virtchnl format to set default MAC
    https://git.kernel.org/netdev/net-next/c/a3e839d539e0
  - [net-next,4/7] iavf: remove redundant ret variable
    https://git.kernel.org/netdev/net-next/c/c3fec56e1267
  - [net-next,5/7] iavf: stop leaking iavf_status as "errno" values
    https://git.kernel.org/netdev/net-next/c/bae569d01a1f
  - [net-next,6/7] iavf: Fix incorrect use of assigning iavf_status to int
    https://git.kernel.org/netdev/net-next/c/8fc16be67dba
  - [net-next,7/7] iavf: Remove non-inclusive language
    https://git.kernel.org/netdev/net-next/c/0a62b2098987

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


