Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61863441B82
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 14:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231919AbhKANMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 09:12:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:46190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231808AbhKANMn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 09:12:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E5528610A2;
        Mon,  1 Nov 2021 13:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635772209;
        bh=3jws/W+ZrI8gcMVxSURCspsrhmAWOdRTcKf2eGII1ZY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c/f1t+w+AEYnjRtDJWkEXwX9i4VJAlOkfxBpm2o0VwePAAWufjN35wvhnsRGpGZZB
         kclkZAP+Qap8leVUIu9czvE+SV2Iv7F3fx5vEPLY0MmCgPuvRFuZwz6WKQVjM0aV03
         AlknHvCUcaYcqw9kIamZRkaJ16g0bJ8KMqU89MBcwTH2xLDbndwzmaprbON+htS3hP
         k4FE/RQpevfV96WqpUmZwfcMhTiKd55uIJJ90ylbs6tC+/Ev0Az880j20tV3VuFMjz
         FnrwM2FjVNx1ae5k+f2xsUosWu0+riFgODOFbZ9NSUzos+NVnfcxhDJEScIKrJF3D8
         +eL4hejevbBmw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D767560AA4;
        Mon,  1 Nov 2021 13:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2] net/ipv4/xfrm4_tunnel.c: remove superfluous header files
 from xfrm4_tunnel.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163577220987.25752.4186939341137360714.git-patchwork-notify@kernel.org>
Date:   Mon, 01 Nov 2021 13:10:09 +0000
References: <20211030072633.4158069-2-steffen.klassert@secunet.com>
In-Reply-To: <20211030072633.4158069-2-steffen.klassert@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     davem@davemloft.net, kuba@kernel.org, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Steffen Klassert <steffen.klassert@secunet.com>:

On Sat, 30 Oct 2021 09:26:32 +0200 you wrote:
> From: Mianhan Liu <liumh1@shanghaitech.edu.cn>
> 
> xfrm4_tunnel.c hasn't use any macro or function declared in mutex.h and ip.h
> Thus, these files can be removed from xfrm4_tunnel.c safely without affecting
> the compilation of the net module.
> 
> Signed-off-by: Mianhan Liu <liumh1@shanghaitech.edu.cn>
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> 
> [...]

Here is the summary with links:
  - [1/2] net/ipv4/xfrm4_tunnel.c: remove superfluous header files from xfrm4_tunnel.c
    https://git.kernel.org/netdev/net-next/c/83688aec17bf
  - [2/2] xfrm: Remove redundant fields and related parentheses
    https://git.kernel.org/netdev/net-next/c/ad57dae8a64d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


