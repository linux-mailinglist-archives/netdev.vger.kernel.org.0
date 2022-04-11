Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7606D4FBA97
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 13:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245263AbiDKLNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 07:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346046AbiDKLNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 07:13:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F5841173
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 04:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE8996158E
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 11:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 34747C385A4;
        Mon, 11 Apr 2022 11:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649675414;
        bh=90YLOsi47e1MDfjEWlCaOjyLzy1CntUJzLUKCG8ODYg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Aae7WZf30Ie9DAbbQ2GZE6BgvgFRft6ia5dBLKiXPI824tJ0cqbzDcnsz1jJcUzRQ
         h+prQyyr24C/vLhtTzzc1UXEZTmh143e1+7QvaYJLWX4xJIp5yc24RtbdfIUOdcxJp
         GLufVlVOoPLhEMXkaDZUeGPZ/hHAZWkqdeTTQifqosrNHaCmJ9S9fbQWiFPUh+wWHk
         Q75X+JuMZQwoawO60ceDilK6ODEd3mJJ++f64E2Ld0RgodjNy8VxA8LjsdwLdscsvl
         IMk5MMxbfOJweroXkVvXZNZivv2WXEXmm5Tq/IyKZAUpLJ8tupnN7A3FiiS5h9Ezc6
         Z13y0wwvXW/+g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1D518E85B76;
        Mon, 11 Apr 2022 11:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8] mptcp: Miscellaneous changes for 5.19
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164967541411.25321.8414956012124589263.git-patchwork-notify@kernel.org>
Date:   Mon, 11 Apr 2022 11:10:14 +0000
References: <20220408194601.305969-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20220408194601.305969-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
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

On Fri,  8 Apr 2022 12:45:53 -0700 you wrote:
> Four separate groups of patches here:
> 
> Patch 1 optimizes flag checking when releasing mptcp socket locks.
> 
> Patches 2 and 3 update the packet scheduler when subflow priorities
> change.
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] mptcp: optimize release_cb for the common case
    https://git.kernel.org/netdev/net-next/c/65a569b03ca8
  - [net-next,2/8] mptcp: reset the packet scheduler on incoming MP_PRIO
    https://git.kernel.org/netdev/net-next/c/43f5b111d1ff
  - [net-next,3/8] mptcp: reset the packet scheduler on PRIO change
    https://git.kernel.org/netdev/net-next/c/0e203c324752
  - [net-next,4/8] mptcp: add pm_nl_pernet helpers
    https://git.kernel.org/netdev/net-next/c/c682bf536cf4
  - [net-next,5/8] mptcp: diag: switch to context structure
    https://git.kernel.org/netdev/net-next/c/6b9ea5c81ea2
  - [net-next,6/8] mptcp: remove locking in mptcp_diag_fill_info
    https://git.kernel.org/netdev/net-next/c/e8887b716142
  - [net-next,7/8] mptcp: listen diag dump support
    https://git.kernel.org/netdev/net-next/c/4fa39b701ce9
  - [net-next,8/8] selftests/mptcp: add diag listen tests
    https://git.kernel.org/netdev/net-next/c/f2ae0fa68e28

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


