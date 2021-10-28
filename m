Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C982B43E08D
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 14:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbhJ1MMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 08:12:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229578AbhJ1MMf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 08:12:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5DAB3610CA;
        Thu, 28 Oct 2021 12:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635423008;
        bh=iCnY6XhetDMiRDtPUq0/dekRMS/W09YCGWxJGNYUvtw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Odwg7XM2tOkhHZC0Gt9Jq+OUJt5wngx5nDDmIBYgyelePGwE/LjyPqlMHZ7wvziT5
         kLiT5UMfO6kVhN3lZoG6LUG0k65rTbObsEk9irlq/pkmWmoeN419xd99MUjOECTocV
         fWGrbfVhJ4DkVUlS9Bpq6seSzTBzLgAZinJwGzZeCikqMSbAa76pEF0M37UuVhAEf3
         896UCVegVeZskc02erugJ1aWQ8MZ+sYvQD3HPM4F8jnNyLmvW9KnmFRk40Nvq4om6A
         8ZkkxlQCxmEpIF9UQlsMUJFw4DEwHKbraG9IsF7m5YUcP6aYpTnSIM7lm/0koLPrOY
         rQluTEtvH2XdA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4E0C160A17;
        Thu, 28 Oct 2021 12:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/2] Fixes for SMC
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163542300831.24410.16037512111805568581.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Oct 2021 12:10:08 +0000
References: <20211028071344.11168-1-tonylu@linux.alibaba.com>
In-Reply-To: <20211028071344.11168-1-tonylu@linux.alibaba.com>
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        jacob.qi@linux.alibaba.com, xuanzhuo@linux.alibaba.com,
        guwen@linux.alibaba.com, dust.li@linux.alibaba.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 28 Oct 2021 15:13:43 +0800 you wrote:
> There are some fixes for SMC.
> 
> v1->v2:
> - fix wrong email address.
> 
> Tony Lu (1):
>   net/smc: Fix smc_link->llc_testlink_time overflow
> 
> [...]

Here is the summary with links:
  - [net,v2,1/2] net/smc: Fix smc_link->llc_testlink_time overflow
    https://git.kernel.org/netdev/net/c/c4a146c7cf5e
  - [net,v2,2/2] net/smc: Correct spelling mistake to TCPF_SYN_RECV
    https://git.kernel.org/netdev/net/c/f3a3a0fe0b64

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


