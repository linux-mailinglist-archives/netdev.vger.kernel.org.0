Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A900C57E5FC
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 19:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236350AbiGVRvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 13:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232071AbiGVRvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 13:51:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C73D1DF4E;
        Fri, 22 Jul 2022 10:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFABA622AD;
        Fri, 22 Jul 2022 17:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 472E3C341C7;
        Fri, 22 Jul 2022 17:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658512213;
        bh=wHaZaaF2mMWggUujrSARDN0rOhNqeujykUZCSsvKmbE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FTm81Y7hvARErtQe3poiHqtHnf7Cbf9kRtQGV2S0hR3czqS717jkNd9/O0rh52R6E
         3yOCYU1Hht475wgZdgbH/T1JyI+Gx2GrttM3zOjWWFHo/MFQ88z+56VD7Tqbsi6Whp
         EjUSlBZJkwSHuf5F9oci3ovY0tsVrKU6h7Uq9QnRMg1SodpIoADfi0ezuZrUVGE+JF
         C4RSRxWyqH3lKlqxEuYVmobORoSfpQBWxz2/UlUayRXgxZtHIK6rSqr+/ALne+N7UK
         JnzJRpLw+J1whD6qS/21gvZYmn/cL/jFQ9AZX06XLvV40LvlSh6wy1TywcuMNCqy6k
         63YUKJ1UGBEYA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 28836E451B9;
        Fri, 22 Jul 2022 17:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] tools/testing/selftests/bpf/test_xdp_veth.sh: fix Couldn't
 retrieve pinned program
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165851221315.25257.5751693822882761758.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Jul 2022 17:50:13 +0000
References: <20220719082430.9916-1-jie2x.zhou@intel.com>
In-Reply-To: <20220719082430.9916-1-jie2x.zhou@intel.com>
To:     Jie2x Zhou <jie2x.zhou@intel.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, mykolal@fb.com, shuah@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        philip.li@intel.com, lkp@intel.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Tue, 19 Jul 2022 16:24:30 +0800 you wrote:
> Before change:
>  selftests: bpf: test_xdp_veth.sh
>  Couldn't retrieve pinned program '/sys/fs/bpf/test_xdp_veth/progs/redirect_map_0': No such file or directory
>  selftests: xdp_veth [SKIP]
> ok 20 selftests: bpf: test_xdp_veth.sh # SKIP
> 
> After change:
> PING 10.1.1.33 (10.1.1.33) 56(84) bytes of data.
> 64 bytes from 10.1.1.33: icmp_seq=1 ttl=64 time=0.320 ms--- 10.1.1.33 ping statistics ---
> 1 packets transmitted, 1 received, 0% packet loss, time 0ms
> rtt min/avg/max/mdev = 0.320/0.320/0.320/0.000 ms
> selftests: xdp_veth [PASS]
> 
> [...]

Here is the summary with links:
  - tools/testing/selftests/bpf/test_xdp_veth.sh: fix Couldn't retrieve pinned program
    https://git.kernel.org/bpf/bpf-next/c/f664f9c6b4a1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


