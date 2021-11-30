Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27B8146341A
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 13:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241532AbhK3MXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 07:23:34 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:39035 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241504AbhK3MXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 07:23:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0AD58CE1990;
        Tue, 30 Nov 2021 12:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 36122C58327;
        Tue, 30 Nov 2021 12:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638274810;
        bh=ZhoV5jpLCn2HmdYVZ07CcQE3kCcCPnxf9lES4gMsZ6M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ww5Gph2j4HJoHGzKOZXKOwH/JAdKNoBoDOVJGaqN9KX+U2/RbVRVWGnPAMlI4XA0X
         Xq//eZZQqo/J5epUMRpgAhecMY3GKb/fW3KAnI1YGzkYANK6LAJGUA0wy17gf/vug5
         /hMOAKqy8a6a07J4/lmBWJvsPeUnMeDO6uAaovk5+y3IYS8X2IBTQnV5zn+aY2BKBV
         uQzJ47mRj3LDHHC56Qfvt99v/Oav00ukdOKkZGMA/USH6H5TeFL+WOYiMdO07yfPdi
         SbWqG6pTGi3IREn9KPdiNF+n1iM6otXSkEHuc6VxTro5WDwD/pieEvLmA/necPmda6
         csPE/9xyy1yMA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 15CBD60A7E;
        Tue, 30 Nov 2021 12:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] net: lantiq: fix missing free_netdev() on error in
 ltq_etop_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163827481008.28928.17311422899327673957.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Nov 2021 12:20:10 +0000
References: <20211130033837.778452-1-yangyingliang@huawei.com>
In-Reply-To: <20211130033837.778452-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org, olek2@wp.pl,
        davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 30 Nov 2021 11:38:37 +0800 you wrote:
> Add the missing free_netdev() before return from ltq_etop_probe()
> in the error handling case.
> 
> Fixes: 14d4e308e0aa ("net: lantiq: configure the burst length in ethernet drivers")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/ethernet/lantiq_etop.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [-next] net: lantiq: fix missing free_netdev() on error in ltq_etop_probe()
    https://git.kernel.org/netdev/net-next/c/2680ce7fc993

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


