Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2D059CF86
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 05:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239797AbiHWDbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 23:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239152AbiHWDaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 23:30:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD0614D244
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 20:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54C2861338
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 03:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 95B66C433D6;
        Tue, 23 Aug 2022 03:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661225416;
        bh=3t8lrezHjatKDFwl3Noe7wboUkwXKKq7Y7BWtdnOEiY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NwiuZJnBGe7ocEnmKM3EzO1+KHh8SWOVazJn2FVeSZdb42kFib4OcWmbGWfDsBeEK
         HZESjqwaxGui3kub/VDLK9OtfMnhX5w5GUynWnD91aDZzOcQJoqrubR5MzVoMIh8Rb
         ppFrFQ6gOad2G/F/lT36woTP7OazdZjFoKHBDubBIcIXRJXUwyPWe0NIGOnUQj8H75
         Zh28DlRC4XqTvB0ZL7tEQ+NjsMf6EqM5kUyVjeSql9ppDLrKoCJ/eT7zKaluW6cbvw
         Zrd14+WQRwxG+0IoGSpYg6Z+ZHXtxhMWp88B+cLkTsEvbILKoAu4EvOTcFd96U3Xf1
         k3C5wA8+dL85A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 74EF9E2A03F;
        Tue, 23 Aug 2022 03:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5][pull request] Intel Wired LAN Driver Updates
 2022-08-18 (ice)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166122541647.23241.11695164981156366186.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Aug 2022 03:30:16 +0000
References: <20220818155207.996297-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220818155207.996297-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
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
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Thu, 18 Aug 2022 08:52:02 -0700 you wrote:
> This series contains updates to ice driver only.
> 
> Jesse and Anatolii add support for controlling FCS/CRC stripping via
> ethtool.
> 
> Anirudh allows for 100M speeds on devices which support it.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] ice: Implement control of FCS/CRC stripping
    https://git.kernel.org/netdev/net-next/c/dddd406d9dbe
  - [net-next,2/5] ice: Implement FCS/CRC and VLAN stripping co-existence policy
    https://git.kernel.org/netdev/net-next/c/affa1029d66f
  - [net-next,3/5] ice: Allow 100M speeds for some devices
    https://git.kernel.org/netdev/net-next/c/39ed02a4ba52
  - [net-next,4/5] ice: Remove ucast_shared
    https://git.kernel.org/netdev/net-next/c/e1e9db57c05b
  - [net-next,5/5] ice: remove non-inclusive language
    https://git.kernel.org/netdev/net-next/c/5c603001d782

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


