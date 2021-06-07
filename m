Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE59F39E8E4
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 23:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbhFGVMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 17:12:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230359AbhFGVL5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 17:11:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id ACA0D6121D;
        Mon,  7 Jun 2021 21:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623100205;
        bh=5LBR3pQJZg6xIx7iEiEDDEoqe9bG5ZRXAUGNSoSQoZE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MlqatuiE7IQ8YRsURQLcsNoGp0BV/N3lt6eLFA76tYYizbL+NV/J2nWBBMA3oWG7y
         Zvz0VrHCOvKtiy7BWeop6+MDKS0YHranUp2DdE2sgfhZ/UXpVFV8UUw6WoKvjy+9Jz
         aD2V116k5QtrXjvPAd9GcpidttRKhyeL3MI/Ai32Zhqwf7JUNx3UIJN55DIOEuCUB3
         nwc+VYESQf+KS2kzrM57jSjAm4qWQtwilDxJ/oqiDEBP3zrEtG+HOXHdXnYtuncm50
         mO03j2mSUeYlfQbeJo0PCHhZRU3RsO5Q65hJ6JKupxznA/ek1+Uof+Wt1acvw9OeKt
         K+k3gcyeOdNmw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A019F60CE1;
        Mon,  7 Jun 2021 21:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: mscc: ocelot: check return value after
 calling platform_get_resource()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162310020565.31357.13399702761615635440.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Jun 2021 21:10:05 +0000
References: <20210605023148.4124956-1-yangyingliang@huawei.com>
In-Reply-To: <20210605023148.4124956-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vladimir.oltean@nxp.com, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 5 Jun 2021 10:31:48 +0800 you wrote:
> It will cause null-ptr-deref if platform_get_resource() returns NULL,
> we need check the return value.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
> v2:
>   add missing goto err_alloc_felix
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: mscc: ocelot: check return value after calling platform_get_resource()
    https://git.kernel.org/netdev/net-next/c/f1fe19c2cb3f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


