Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDF5E4C3E81
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 07:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237902AbiBYGkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 01:40:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237900AbiBYGko (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 01:40:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6556749911
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 22:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7B2A61AB0
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 06:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5212DC340E8;
        Fri, 25 Feb 2022 06:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645771211;
        bh=2QIh1cITo7wY9LraW64PVdQqxOjWSDLTE3pciUi3a0Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=N0b6xiCCSzwi5EY8nsXZVLuuxISSmOayiIq0gzcJ2ehPWedvLqh2DxIKNdK1v5oUd
         9TXOM+lxKyCTqFwozh/3cYieYc2eGTqFIytVl6sk1XIfyBvhN+dpRnkY82svtxrUNH
         oOhz7AP5UFyWuICmrBo3M5q0L5okMpdfsaQvj0A50Dw3rTWvi8oOt6U3ocSW+zbPHm
         tYAUV/9S9bg0HTcUEoOBvjqgAJpvidRPczMlM25jS0RhcyTNI3cSv0QTm7IJKecUUx
         dshGx/EekBTqccqO2PNYGPvUep0qNpNIo0aaaI95bNZm2V2E9ERC7rly/yhG6e9P0R
         g0Q5BBLYePNDA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2E3F7EAC081;
        Fri, 25 Feb 2022 06:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] mptcp: Fixes for 5.17
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164577121118.6076.5592393879706573680.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Feb 2022 06:40:11 +0000
References: <20220225005259.318898-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20220225005259.318898-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
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

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 24 Feb 2022 16:52:56 -0800 you wrote:
> Patch 1 fixes an issue with the SIOCOUTQ ioctl in MPTCP sockets that
> have performed a fallback to TCP.
> 
> Patch 2 is a selftest fix to correctly remove temp files.
> 
> Patch 3 fixes a shift-out-of-bounds issue found by syzkaller.
> 
> [...]

Here is the summary with links:
  - [net,1/3] mptcp: accurate SIOCOUTQ for fallback socket
    https://git.kernel.org/netdev/net/c/07c2c7a3b622
  - [net,2/3] selftests: mptcp: do complete cleanup at exit
    https://git.kernel.org/netdev/net/c/63bb8239d805
  - [net,3/3] mptcp: Correctly set DATA_FIN timeout when number of retransmits is large
    https://git.kernel.org/netdev/net/c/877d11f0332c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


