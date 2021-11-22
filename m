Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3D62458EB2
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 13:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239636AbhKVMxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 07:53:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:48674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239400AbhKVMxQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 07:53:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id DB94060F9D;
        Mon, 22 Nov 2021 12:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637585409;
        bh=K1u8czjpn3Kfv1CdlAi/vtn4VNiUkH7HN0GGW5X1YEY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GpXM2WwM1GMquPF6o4H6k6DjdkYdEvNFOoW0YauaknyEL6MUaq5nPG0PaSNqjP2Bg
         p2+voFQPspn8bTkO/hOSsEtipNjTTSC72MK2vBv7mUwOUWoznlyZYUIW1i8/R47JeE
         O1mk/yj20MmADh0CMbe18JiBGJLUqP3iiHxA0sHUQaIMoElUhmBRaBlNobX1vrJL4A
         FLyShS5D49P63YRkSBxQyIKv4FbFwO8jaWCx5Jsej4ucTrePGrzBZKS1cb5VsYgzBW
         5+s0b/1i11lwOqW/f1hgJHhrNieBmelRHNyDBx5+TA6VmpRdHkHnD1wi76fu5myJzg
         u3RG/CoaAW2qQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CB29960AA4;
        Mon, 22 Nov 2021 12:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2] selftests/tc-testing: match any qdisc type
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163758540982.16054.8349984035944815065.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Nov 2021 12:50:09 +0000
References: <20211119062457.16668-1-zhijianx.li@intel.com>
In-Reply-To: <20211119062457.16668-1-zhijianx.li@intel.com>
To:     Li Zhijian <zhijianx.li@intel.com>
Cc:     shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, davem@davemloft.net,
        peilin.ye@bytedance.com, cong.wang@bytedance.com,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        philip.li@intel.com, lizhijian@cn.fujitsu.com, lkp@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 19 Nov 2021 14:24:56 +0800 you wrote:
> We should not always presume all kernels use pfifo_fast as the default qdisc.
> 
> For example, a fq_codel qdisk could have below output:
> qdisc fq_codel 0: parent 1:4 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Suggested-by: Peilin Ye <peilin.ye@bytedance.com>
> Signed-off-by: Li Zhijian <zhijianx.li@intel.com>
> 
> [...]

Here is the summary with links:
  - [1/2] selftests/tc-testing: match any qdisc type
    https://git.kernel.org/netdev/net/c/bdf1565fe03d
  - [2/2] selftests/tc-testings: Be compatible with newer tc output
    https://git.kernel.org/netdev/net/c/ac2944abe4d7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


