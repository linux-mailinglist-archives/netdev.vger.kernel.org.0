Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB71839E909
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 23:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbhFGVV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 17:21:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:53728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230463AbhFGVV4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 17:21:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4A5A361208;
        Mon,  7 Jun 2021 21:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623100804;
        bh=drDz5rzH693vO68IMto8JatvrK5kPM1PUmcH2W4U2/o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=K089cnZXaN/txOhb/fuN9Vdp/1Y+az7dtb1Z7hcGK2NddqkYtpKS26cBiJgl5KhnQ
         VSAAoRvid/jH4tL5yO7mjZopuh9J82oSBy4cgHVVXuTSbMbviAQuiBeVoFytO3jec/
         eb+oGFYTMmLSqm8bvZsU+cHJzYEdF9pfgu85ZC0bzwHjHLFWmFRRzw6gRtwrM3mTB8
         /gg9TEH6nPLlNaqpb05MVU86FT4kd3gQJ1QBc6HdxSuyjafoyPCzCSTU8MsIBV1no5
         6eTzB/aiw6rjL2KFMIoLGF0nkgXoDj7i5MKCPhgkUJyJEHFZw1Rok+LnDEBr62+n7Q
         5q/2ylIveD8OA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3EC0860A1B;
        Mon,  7 Jun 2021 21:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ipv4: Fix spelling mistakes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162310080425.4243.503492647736528773.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Jun 2021 21:20:04 +0000
References: <20210607150109.2856253-1-zhengyongjun3@huawei.com>
In-Reply-To: <20210607150109.2856253-1-zhengyongjun3@huawei.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 7 Jun 2021 23:01:09 +0800 you wrote:
> Fix some spelling mistakes in comments:
> Dont  ==> Don't
> timout  ==> timeout
> incomming  ==> incoming
> necesarry  ==> necessary
> substract  ==> subtract
> 
> [...]

Here is the summary with links:
  - [net-next] ipv4: Fix spelling mistakes
    https://git.kernel.org/netdev/net-next/c/974d8f86cd60

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


