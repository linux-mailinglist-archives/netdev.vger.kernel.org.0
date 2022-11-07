Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B74561EDFF
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 10:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbiKGJAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 04:00:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiKGJAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 04:00:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B40C12AFA;
        Mon,  7 Nov 2022 01:00:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3BC12B80E6B;
        Mon,  7 Nov 2022 09:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D5B48C433D7;
        Mon,  7 Nov 2022 09:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667811614;
        bh=4iQF982dX9qc45dSDY4MdBxVjSNki9VdNDupV7NMNYY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hYkJSSjW4ZmuPXQ5YP72b/bOOixg6QNiHVylSoBPVwF4Cz4r+KQOiJZA3P/Pmtmom
         D84Zz4Y4rrtPMnD+JFivfRflGgRdq6KkDFnc58Jmi5OABI48tBSjtonQLr7HIlSH4f
         ZdAx3goHlNJB532Sgf5BwX8UCu+NfjZ13Kd6VKc7FHQC4b91DWLcYRvqpgPY37TgMA
         zjVLCXJrQ62gh3cIDeimfDJnWtbOyihdOedVheSVj9nqSYxcwhKpw++yyyi1N1/j2h
         jcc4EnslzH8evsOX1k6rjjUgy9Mz7ZqF7nDWw/mw5/3bI/PMYrXPJ0WI5qwmS2joAP
         j2ZWAml5/RFXQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C29E6C41671;
        Mon,  7 Nov 2022 09:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 1/3] net: hinic: Convert the cmd code from decimal
 to hex to be more readable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166781161479.8122.7153521073218166910.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Nov 2022 09:00:14 +0000
References: <20221103080525.26885-1-cai.huoqing@linux.dev>
In-Reply-To: <20221103080525.26885-1-cai.huoqing@linux.dev>
To:     Cai Huoqing <cai.huoqing@linux.dev>
Cc:     kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, shaozhengchao@huawei.com,
        mqaio@linux.alibaba.com, bin.chen@corigine.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Thu,  3 Nov 2022 16:05:09 +0800 you wrote:
> The print cmd code is in hex, so using hex cmd code intead of
> decimal is easy to check the value with print info.
> 
> Signed-off-by: Cai Huoqing <cai.huoqing@linux.dev>
> ---
> v1->v2:
> 	1.Add net-next prefix.
> 	The comments link: https://lore.kernel.org/lkml/20221027110241.0340abdf@kernel.org/
> v2->v3:
> 	1.Merge PATCH 3/3 to this series.
> v3->v4:
> 	1.Revert the empty lines.
> 	The comments link: https://lore.kernel.org/lkml/20221102203640.1bda5d74@kernel.org/
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/3] net: hinic: Convert the cmd code from decimal to hex to be more readable
    https://git.kernel.org/netdev/net-next/c/ac33d7ae8f71
  - [net-next,v4,2/3] net: hinic: Add control command support for VF PMD driver in DPDK
    https://git.kernel.org/netdev/net-next/c/13265568a863
  - [net-next,v4,3/3] net: hinic: Add support for configuration of rx-vlan-filter by ethtool
    https://git.kernel.org/netdev/net-next/c/2acf960e3be6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


