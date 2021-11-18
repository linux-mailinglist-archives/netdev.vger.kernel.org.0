Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1FC455B49
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 13:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344575AbhKRMNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 07:13:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:41062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344562AbhKRMNK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 07:13:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 5DDC861872;
        Thu, 18 Nov 2021 12:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637237410;
        bh=GZbxhNldEXuP5OlD2n0kvI+Bk4Vnu1JlO1mGFAwIZEI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MY8W9a+4zT62AcPtLwA15CnyfDFN3S/ghtbhq2XTA20hqftB1NGJVa3zf2c96kHv6
         m9cqc/Qq3Z/G45PEVRrtjG7q7f/BaId7DmVGRdSuNaRtUFSdVMjSi/xgaHDOcBhwTT
         lokxJ94JkHiEM4RPHdpj+iM0ziUw3fOMbIlyNqrK8lWBs+/QLFxuQanHiaomYYX7DO
         +/PUwu6e0P0CIsMhF55CZwEbunQwbBgeBjaAi8kb7Nd9b/IfPFlRiBhIPNiGTJHIgn
         qapb9+7fDGzlDMWdfqaOuz0uW1u3QR4K409ZN1cD147G5PPEtn25G5uUUQ7+68xpss
         O9QncvC9cl30Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5479A60BE1;
        Thu, 18 Nov 2021 12:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] mctp/test: Update refcount checking in route
 fragment tests
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163723741034.26371.15754239803598879874.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Nov 2021 12:10:10 +0000
References: <20211118065723.2808020-1-jk@codeconstruct.com.au>
In-Reply-To: <20211118065723.2808020-1-jk@codeconstruct.com.au>
To:     Jeremy Kerr <jk@codeconstruct.com.au>
Cc:     netdev@vger.kernel.org, matt@codeconstruct.com.au,
        davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 18 Nov 2021 14:57:23 +0800 you wrote:
> In 99ce45d5e, we moved a route refcount decrement from
> mctp_do_fragment_route into the caller. This invalidates the assumption
> that the route test makes about refcount behaviour, so the route tests
> fail.
> 
> This change fixes the test case to suit the new refcount behaviour.
> 
> [...]

Here is the summary with links:
  - [net-next] mctp/test: Update refcount checking in route fragment tests
    https://git.kernel.org/netdev/net-next/c/f6ef47e5bdc6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


