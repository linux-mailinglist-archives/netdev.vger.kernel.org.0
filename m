Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 686506F0A66
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 19:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244070AbjD0RAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 13:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243603AbjD0RAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 13:00:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F253010DC;
        Thu, 27 Apr 2023 10:00:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DF3D63E74;
        Thu, 27 Apr 2023 17:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EC6B6C433D2;
        Thu, 27 Apr 2023 17:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682614822;
        bh=JyIySdGEmS2lvqX23RxQJW2WsiscvHOpbSP1ElxnVeI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=o2GYbH6/kS2borua9TpV7kVKhf3Vs/Qco35Yp9Tb3Va5uK4thtS7S+msIJUAgIO7a
         XK3mu8V4/eViWfMYaIu2UxzEXPvi9n3bKS5JoUaaNigdlVmceB55Dd0hdJJunZZlsJ
         DyJyr/ZGCJMBDVb9cMdA4/0O3zA6EnFMSw9bYcN8NadDF/udo/WhkwGmljoZ2ddZWQ
         xvkNqAGNsUDYc1RpNxVGAUTWljyweUX/Rej5PcYK3TXZjzwgVDl9tE4ctReSUajxyP
         7JV5Q5htudH0UMArpNxKG3ZBNOVWcdX6NynftbFkuINAO933rkM5K/3/mxD0c9ggVK
         L2zL8pfayDKSg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C4217C43158;
        Thu, 27 Apr 2023 17:00:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next V2 0/5] XDP-hints: XDP kfunc metadata for driver igc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168261482179.5377.8182484249151476104.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Apr 2023 17:00:21 +0000
References: <168182460362.616355.14591423386485175723.stgit@firesoul>
In-Reply-To: <168182460362.616355.14591423386485175723.stgit@firesoul>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, sdf@google.com, toke@redhat.com,
        netdev@vger.kernel.org, martin.lau@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, alexandr.lobakin@intel.com,
        larysa.zaremba@intel.com, xdp-hints@xdp-project.net,
        yoong.siang.song@intel.com, intel-wired-lan@lists.osuosl.org,
        pabeni@redhat.com, jesse.brandeburg@intel.com, kuba@kernel.org,
        edumazet@google.com, john.fastabend@gmail.com, hawk@kernel.org,
        davem@davemloft.net
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Tue, 18 Apr 2023 15:30:37 +0200 you wrote:
> Implement both RX hash and RX timestamp XDP hints kfunc metadata
> for driver igc.
> 
> First patch fix RX hashing for igc in general.
> 
> Last patch change test program xdp_hw_metadata to track more
> timestamps, which helps us correlate the hardware RX timestamp
> with something.
> 
> [...]

Here is the summary with links:
  - [bpf-next,V2,1/5] igc: enable and fix RX hash usage by netstack
    https://git.kernel.org/bpf/bpf-next/c/84214ab4689f
  - [bpf-next,V2,2/5] igc: add igc_xdp_buff wrapper for xdp_buff in driver
    https://git.kernel.org/bpf/bpf-next/c/73b7123de0cf
  - [bpf-next,V2,3/5] igc: add XDP hints kfuncs for RX hash
    https://git.kernel.org/bpf/bpf-next/c/8416814fffa9
  - [bpf-next,V2,4/5] igc: add XDP hints kfuncs for RX timestamp
    https://git.kernel.org/bpf/bpf-next/c/d677266755c6
  - [bpf-next,V2,5/5] selftests/bpf: xdp_hw_metadata track more timestamps
    https://git.kernel.org/bpf/bpf-next/c/bb323478767d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


