Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D41D96CD3DE
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 10:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbjC2IAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 04:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbjC2IA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 04:00:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B752103;
        Wed, 29 Mar 2023 01:00:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32151B820FD;
        Wed, 29 Mar 2023 08:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B4975C433EF;
        Wed, 29 Mar 2023 08:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680076825;
        bh=jsONW2bbKso3jFbuEI4vaV+27HAPUxIXLM70AQoX3gg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lLQxL0maR8V5vSL9YIIslrgcRLvDWgqnNv2IOBSjBhDFTsOV8vSY8CZTrdeCp8z9f
         Wr99F72Lcsc7xZVnGj8u+FYvPqMPed/O2wDf1xC2sF7dGsLfo2kb6Dd6AOJsQpsEhc
         3uxJsu2DvaqdR3mHcnQPF7DdWyFzq9fPp6kVplrp6yvsa2fNfEM+2nK2vlqjVohxEg
         XXgKH0CBXOzZPvzMPyH+ri//deE6fHuYlu3Klk6QxQHsjt93eUgr2TPKW/GvI8Bkf1
         0ppw8wkZGE8CJmGJl6uNLkgpUFMP6oKenmndodf55K78jSax/AYeJfYzucsAvz/vj/
         O38DY/C9uuYfw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9079CE4F0DB;
        Wed, 29 Mar 2023 08:00:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/3] Add support for sockmap to vsock.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168007682558.9659.6900016248016625386.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Mar 2023 08:00:25 +0000
References: <20230327-vsock-sockmap-v4-0-c62b7cd92a85@bytedance.com>
In-Reply-To: <20230327-vsock-sockmap-v4-0-c62b7cd92a85@bytedance.com>
To:     Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     stefanha@redhat.com, sgarzare@redhat.com, mst@redhat.com,
        jasowang@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, andrii@kernel.org,
        mykolal@fb.com, ast@kernel.org, daniel@iogearbox.net,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, shuah@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 27 Mar 2023 19:11:50 +0000 you wrote:
> We're testing usage of vsock as a way to redirect guest-local UDS
> requests to the host and this patch series greatly improves the
> performance of such a setup.
> 
> Compared to copying packets via userspace, this improves throughput by
> 121% in basic testing.
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/3] vsock: support sockmap
    https://git.kernel.org/netdev/net-next/c/634f1a7110b4
  - [net-next,v4,2/3] selftests/bpf: add vsock to vmtest.sh
    https://git.kernel.org/netdev/net-next/c/c7c605c982d6
  - [net-next,v4,3/3] selftests/bpf: add a test case for vsock sockmap
    https://git.kernel.org/netdev/net-next/c/d61bd8c1fd02

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


