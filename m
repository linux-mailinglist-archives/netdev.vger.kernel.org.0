Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6A856E1336
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 19:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbjDMRK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 13:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbjDMRKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 13:10:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7195F7D85;
        Thu, 13 Apr 2023 10:10:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B9BC64031;
        Thu, 13 Apr 2023 17:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DF8C8C433D2;
        Thu, 13 Apr 2023 17:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681405818;
        bh=TTMPY+VYyqCQUJ6Kf3OMi0XvWsEMpitS3xIlaYntt/o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rNALsve5zDHrmp3o0aYNfmHMpYblt/hhzFFUmRj+5rvF9o6cdFXAq2IVoqHfBTqDd
         AvXiIvPSABYQr1o47YBnhfI062hxDaVpltx+azxLFd2CMwLPggXGX3P4PN8UCtbW5c
         vgSn0luMIByakBX8BAvgCB+Uqgw47gKiwMUynVVFny0RDJPFasFEnDJzQr89cZvOh4
         gsJbT5JtR13DiX3Gt+FdyXHEpTtHXXqPZvjIQcaTJU/mlTya6SdfpPukNItplp2Cfs
         oQu+mrd3iGpizzS+OOfAMsEUhds4wRDe6UDCoBW/gm9YHZdppH8cpbHPHavki6RUH+
         agQD6/C5gfniA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BF7B1E21ED9;
        Thu, 13 Apr 2023 17:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/4] mptcp: more fixes for 6.3
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168140581877.3344.4926518348735216178.git-patchwork-notify@kernel.org>
Date:   Thu, 13 Apr 2023 17:10:18 +0000
References: <20230411-upstream-net-20230411-mptcp-fixes-v1-0-ca540f3ef986@tessares.net>
In-Reply-To: <20230411-upstream-net-20230411-mptcp-fixes-v1-0-ca540f3ef986@tessares.net>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     mptcp@lists.linux.dev, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, dcaratti@redhat.com,
        dmytro@shytyi.net, shuah@kernel.org, martineau@kernel.org,
        geliang.tang@suse.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        stable@vger.kernel.org, cpaasch@apple.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 11 Apr 2023 22:42:08 +0200 you wrote:
> Patch 1 avoids scheduling the MPTCP worker on a closed socket on some
> edge cases. It fixes issues that can be visible from v5.11.
> 
> Patch 2 makes sure the MPTCP worker doesn't try to manipulate
> disconnected sockets. This is also a fix for an issue that can be
> visible from v5.11.
> 
> [...]

Here is the summary with links:
  - [net,1/4] mptcp: use mptcp_schedule_work instead of open-coding it
    https://git.kernel.org/netdev/net/c/a5cb752b1257
  - [net,2/4] mptcp: stricter state check in mptcp_worker
    https://git.kernel.org/netdev/net/c/d6a044373343
  - [net,3/4] mptcp: fix NULL pointer dereference on fastopen early fallback
    https://git.kernel.org/netdev/net/c/c0ff6f6da66a
  - [net,4/4] selftests: mptcp: userspace pm: uniform verify events
    https://git.kernel.org/netdev/net/c/711ae788cbbb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


