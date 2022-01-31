Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0BD04A467B
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 13:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344263AbiAaMAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 07:00:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344762AbiAaL7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 06:59:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04AFDC0604C2;
        Mon, 31 Jan 2022 03:50:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA12EB82A9B;
        Mon, 31 Jan 2022 11:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7F102C340EE;
        Mon, 31 Jan 2022 11:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643629809;
        bh=6p/gtaayLGveSScLQp0xSMI/GwfWD2KW/zq9TPyCCGw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pSCLwJSOwIRCbVUbLEIEJNbwCGGOn43x3RfxAe+orupUNtuNGW7WL7vQKB/sboqoH
         NdAE6hY/zABk1gZZZJhqT72p7t0HNKEjExKmvych/mg3oA82xXb6lt5aEj1XfB13pz
         xb2S+xVajjmiIo1JcQyq4rWyYj5LWNM5RmzzUE/HzJga2cNIFH2jbQEQIb0HiDN4by
         4BkQ52Naz8E6INsgapshXsh1IaozxudBWt+U4lUwBIsivq5nAVGTOBfW7t1o9mBSra
         p4AZfDPyMalgLMJcIM655Tw6AarTq7JMedrh+6i5hnIeMcqD78DPmVz27vAw0Rdjil
         J6IB6Q4uymDHA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6553FE6BB38;
        Mon, 31 Jan 2022 11:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 0/2] Remove some dead code in the Renesas Ethernet drivers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164362980941.13015.9613384188127281317.git-patchwork-notify@kernel.org>
Date:   Mon, 31 Jan 2022 11:50:09 +0000
References: <20220129115517.11891-1-s.shtylyov@omp.ru>
In-Reply-To: <20220129115517.11891-1-s.shtylyov@omp.ru>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 29 Jan 2022 14:55:15 +0300 you wrote:
> Here are 2 patches against DaveM's 'net-next.git' repo. The Renesas drivers
> call their ndo_stop() methods directly and they always return 0, making the
> result checks pointless, hence remove them...
> 
> Sergey Shtylyov (2):
>   ravb: ravb_close() always returns 0
>   sh_eth: sh_eth_close() always returns 0
> 
> [...]

Here is the summary with links:
  - [v2,1/2] ravb: ravb_close() always returns 0
    https://git.kernel.org/netdev/net-next/c/be94a51f3e5e
  - [v2,2/2] sh_eth: sh_eth_close() always returns 0
    https://git.kernel.org/netdev/net-next/c/e7d966f9ea52

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


