Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44152520A76
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 03:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234044AbiEJBEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 21:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234032AbiEJBEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 21:04:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3F2205463
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 18:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A4B5615AC
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 01:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 81A64C385CD;
        Tue, 10 May 2022 01:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652144413;
        bh=kZoH1xnCtd79jnGOsExSyJkys01DeRpm+n+ogOTnu/A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dxPFkIjSixVoaYxKEVPIPZyr7SydOvVeb/Drbq/aBza0j1APYQu4CEvhV+yoXpzEq
         qAO+Oipcxkaeik4cJxhwj6NpFCGWpwA8l1L50VQJ3YuHQIj7X8dBCJjA5tLAXIlFOg
         dnRk9tY1i6Rs41eNfmS2TjfsP2d8dMuAl+BpHbGOuqULcJcbOUgkYmBJhUMBbKSsQW
         gfExE8KTPit1S+DOsblZzW3wpaVGc342NEg4wXSXsW4h/a3fKBj2+SNEPAat/BcBVg
         pTekGlzXPpMhGZmWH4Zc8TCDpGwm3MPEhe20SgLRvbUa3I3JgMuvftSfT3t/E1FdII
         kJEytpfMXvq9g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6BF3FF03876;
        Tue, 10 May 2022 01:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2][pull request] 100GbE Intel Wired LAN Driver
 Updates 2022-05-06
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165214441343.5782.12305116988127051057.git-patchwork-notify@kernel.org>
Date:   Tue, 10 May 2022 01:00:13 +0000
References: <20220506180052.5256-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220506180052.5256-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        marcin.szycik@linux.intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri,  6 May 2022 11:00:50 -0700 you wrote:
> Marcin Szycik says:
> 
> This patchset adds support for systemd defined naming scheme for port
> representors, as well as re-enables displaying PCI bus-info in ethtool.
> 
> bus-info information has previously been removed from ethtool for port
> representors, as a workaround for a bug in lshw tool, where the tool would
> sometimes display wrong descriptions for port representors/PF. Now the bug
> has been fixed in lshw tool [1].
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] ice: link representors to PCI device
    https://git.kernel.org/netdev/net-next/c/6384b7695953
  - [net-next,2/2] Revert "ice: Hide bus-info in ethtool for PRs in switchdev mode"
    https://git.kernel.org/netdev/net-next/c/e0c7402270d9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


