Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78EEA3FC6B7
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 14:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241537AbhHaLlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 07:41:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:37064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231849AbhHaLlB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 07:41:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9838060FED;
        Tue, 31 Aug 2021 11:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630410006;
        bh=cVCVaYoqk8Yve9jZiOy8+LFnwy02469IuMZO/9+OpVI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=E73p9teP9HIZA1afVz+XOJE+PKi2JNE/icix88lHYjLriRIga4cy7y5SUQgI5urcH
         MX5rnLN9JU+JLRfwPuelIxenct8biq1K0KotC1KMjIiVvvVFV1fyXHMOsScywnYorw
         YAbDDP21EGZZGl47m1R+EiWLdpAV03SLjgdT93B93lZX3VW3M+cZriwLGX4dyuG2nB
         3QB0JunLJZu3Z1f33qxIXno6QDsJuFtJiqRuAmzFqL77R1Yna4yAaOqb3AXrhLPBFr
         b+va4v1y6rj572GLDtIMXvDHkIvMXOQKsDGFZH3TXejiGf+Mc8m0rvZIYvfsZ0itYu
         4MMhpXI/MSXWQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8FEB460A6F;
        Tue, 31 Aug 2021 11:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: w5100: check return value after calling
 platform_get_resource()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163041000658.19308.3570016800269326977.git-patchwork-notify@kernel.org>
Date:   Tue, 31 Aug 2021 11:40:06 +0000
References: <20210831084018.1358605-1-yangyingliang@huawei.com>
In-Reply-To: <20210831084018.1358605-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 31 Aug 2021 16:40:18 +0800 you wrote:
> It will cause null-ptr-deref if platform_get_resource() returns NULL,
> we need check the return value.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/ethernet/wiznet/w5100.c | 2 ++
>  1 file changed, 2 insertions(+)

Here is the summary with links:
  - [net-next] net: w5100: check return value after calling platform_get_resource()
    https://git.kernel.org/netdev/net-next/c/a39ff4a47f3e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


