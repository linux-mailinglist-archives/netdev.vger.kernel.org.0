Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11AD663FF71
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 05:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231904AbiLBEUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 23:20:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbiLBEUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 23:20:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E81A4D15A6;
        Thu,  1 Dec 2022 20:20:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9BFD7B820D5;
        Fri,  2 Dec 2022 04:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4B75CC433D7;
        Fri,  2 Dec 2022 04:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669954817;
        bh=mJJCaKvnmgG7UPA54zSpnH2jj4arqkKMPDOumHntA7w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QD9fgm4Wo/WX5gDldS043gI7TKh+6oYWX6DbWP1n/pfiQoJjkfm4hMmToGtHkVIdc
         ldgnrMI3NSgoZhQ+xyl1VJWPSqDObO40q0ZZa2yKCcQNXnRgs52emOjC8IyU3H1bcj
         GFdp4zA5dnk4WbP7+SWTeStjmgjVcg/8F2XpVMEPnSl21aeIxYzDRmTRvmSHuoY1db
         GADStGHvNnD9BXpLvcqiKuOQfg+mqpfaq195i3ieFhzwHNuY8/sCqZ1DmJ+gMNsDdl
         P4QpMZSGcPulBJyOqWFC9sWYnBcPQHxpt4sKks2ysuYkfS+kRe7XwamMNZsIAKD75U
         Ihm4z11zogSkw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 358D8E29F38;
        Fri,  2 Dec 2022 04:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/11] mptcp: PM listener events + selftests cleanup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166995481721.23610.10721074683556586652.git-patchwork-notify@kernel.org>
Date:   Fri, 02 Dec 2022 04:20:17 +0000
References: <20221130140637.409926-1-matthieu.baerts@tessares.net>
In-Reply-To: <20221130140637.409926-1-matthieu.baerts@tessares.net>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        mathew.j.martineau@linux.intel.com, pabeni@redhat.com,
        shuah@kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, mptcp@lists.linux.dev,
        netdev@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 30 Nov 2022 15:06:22 +0100 you wrote:
> Thanks to the patch 6/11, the MPTCP path manager now sends Netlink events when
> MPTCP listening sockets are created and closed. The reason why it is needed is
> explained in the linked ticket [1]:
> 
>   MPTCP for Linux, when not using the in-kernel PM, depends on the userspace PM
>   to create extra listening sockets before announcing addresses and ports. Let's
>   call these "PM listeners".
> 
> [...]

Here is the summary with links:
  - [net-next,01/11] selftests: mptcp: run mptcp_inq from a clean netns
    https://git.kernel.org/netdev/net-next/c/b4e0df4cafe1
  - [net-next,02/11] selftests: mptcp: removed defined but unused vars
    https://git.kernel.org/netdev/net-next/c/b71dd705179c
  - [net-next,03/11] selftests: mptcp: uniform 'rndh' variable
    https://git.kernel.org/netdev/net-next/c/787eb1e4df93
  - [net-next,04/11] selftests: mptcp: clearly declare global ns vars
    https://git.kernel.org/netdev/net-next/c/de2392028a19
  - [net-next,05/11] selftests: mptcp: declare var as local
    https://git.kernel.org/netdev/net-next/c/5f17f8e315ad
  - [net-next,06/11] mptcp: add pm listener events
    https://git.kernel.org/netdev/net-next/c/f8c9dfbd875b
  - [net-next,07/11] selftests: mptcp: enhance userspace pm tests
    https://git.kernel.org/netdev/net-next/c/7dff74f5716e
  - [net-next,08/11] selftests: mptcp: make evts global in userspace_pm
    https://git.kernel.org/netdev/net-next/c/1cc94ac1af4b
  - [net-next,09/11] selftests: mptcp: listener test for userspace PM
    https://git.kernel.org/netdev/net-next/c/6c73008aa301
  - [net-next,10/11] selftests: mptcp: make evts global in mptcp_join
    https://git.kernel.org/netdev/net-next/c/a3735625572d
  - [net-next,11/11] selftests: mptcp: listener test for in-kernel PM
    https://git.kernel.org/netdev/net-next/c/178d023208eb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


