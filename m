Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9CB554425A
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 06:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237754AbiFIEKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 00:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236683AbiFIEKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 00:10:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30F1895A04
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 21:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4F7BB82BFF
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 04:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 84C34C341CB;
        Thu,  9 Jun 2022 04:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654747814;
        bh=jv58ysazWEutxgJbrPABHjGvimUtikSXSh9QU+aihT0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=E2gVDDVPI+qOC0LP5demKBwlw4jNvtLrxMmCCZ2cGxKRMkMJLfGYTLYO3euVpojNr
         pBOhga7buguhHUc4/H87qmu0CE7iWtt9s9LUaM5FMs/GGKzHaGT7/S1rNhNajafwJe
         /hZfJp27ves5n09BcGHi7wnxW9qyKYymrIeAjo0odjRRLucHokWm/gh8WrX2sNTmN8
         HNEFwVOHfIKLixI1MGwz6QpqZMEGqje4T0nIAarDq1JU1KaAIoolkhBF7kx9Ndc9fl
         aogsFZM6k7/oN5nFZvMj1anuLaK7GKwrKSKsHg+9sZUc+npS+4gA21h/ZFg7ZmmjTN
         AiMfLMm8SdkIQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 713E9E737E8;
        Thu,  9 Jun 2022 04:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/2][pull request] 40GbE Intel Wired LAN Driver
 Updates 2022-06-07
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165474781446.435.4802491825076485771.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Jun 2022 04:10:14 +0000
References: <20220607175506.696671-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220607175506.696671-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org, sassmann@redhat.com
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
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Tue,  7 Jun 2022 10:55:04 -0700 you wrote:
> This series contains updates to i40e and iavf drivers.
> 
> Mateusz adds implementation for setting VF VLAN pruning to allow user to
> specify visibility of VLAN tagged traffic to VFs for i40e. He also adds
> waiting for result from PF for setting MAC address in iavf.
> ---
> v2: Rewrote some code to avoid passing a value as a condition (patch 2)
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] i40e: Add VF VLAN pruning
    https://git.kernel.org/netdev/net-next/c/c87c938f62d8
  - [net-next,v2,2/2] iavf: Add waiting for response from PF in set mac
    https://git.kernel.org/netdev/net-next/c/35a2443d0910

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


