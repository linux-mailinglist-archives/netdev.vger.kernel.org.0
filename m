Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2186F03DE
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 12:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243438AbjD0KAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 06:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243136AbjD0KAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 06:00:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF4F01991;
        Thu, 27 Apr 2023 03:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F13A63C3E;
        Thu, 27 Apr 2023 10:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A50C3C433D2;
        Thu, 27 Apr 2023 10:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682589619;
        bh=ZFFpgUNG1S7uNnWTps1yUwy7bCxwxb6JuwRsPh2AiaM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jYVi8x6IHPjShPMy2cx//2TQq4k3/b69do+/FAG3T1TRufOdZq1k+s9ciDEMPkn9a
         WT7xWX9iAKwxuFdi8dUJv7lKhWCYTMmLAKqx7A7jgaa/bl4JQWgmCpFtroRDo2RY54
         99dkwHBknq4JBJZrXVjVEUUbtTPieFmsYnQtgh5UVLRHl9a1EYA01AFeMTyp3985OP
         89QkwRJ+TMmfvLLsEe8OqhEeWdAd2UDYoLc6RTe4/v+Kur/CWH+RR2qz+Pzg2N7A7a
         O5zn5IYmq4E6Mx0jzArC1quf15PcCcd9Eclik1O3aBqgArq8HC666OfLaHYWEwZCAz
         F5i83yjAWSfSw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 89008E5FFC8;
        Thu, 27 Apr 2023 10:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] ixgbe: Fix panic during XDP_TX with > 64 CPUs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168258961955.9029.7486982830815320721.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Apr 2023 10:00:19 +0000
References: <20230425170308.2522429-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230425170308.2522429-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org, jjh@daedalian.us,
        xingwanli@kuaishou.com, lishujin@kuaishou.com,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, bpf@vger.kernel.org,
        chandanx.rout@intel.com
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 25 Apr 2023 10:03:08 -0700 you wrote:
> From: John Hickey <jjh@daedalian.us>
> 
> Commit 4fe815850bdc ("ixgbe: let the xdpdrv work with more than 64 cpus")
> adds support to allow XDP programs to run on systems with more than
> 64 CPUs by locking the XDP TX rings and indexing them using cpu % 64
> (IXGBE_MAX_XDP_QS).
> 
> [...]

Here is the summary with links:
  - [net,1/1] ixgbe: Fix panic during XDP_TX with > 64 CPUs
    https://git.kernel.org/netdev/net/c/c23ae5091a8b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


