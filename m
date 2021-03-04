Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5105A32C9DA
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 02:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348587AbhCDBNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 20:13:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:57276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241917AbhCDBKs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 20:10:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 567CF64F18;
        Thu,  4 Mar 2021 01:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614820207;
        bh=zhH2OwSYwVnS4wedkUwvuQosl1JTIDPki78bDhVJm8c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kwI77vmIYhmnSUstlBo1l3bNRSZpo79WC9/NWjc2QT+VkC/LTIMIoe8/VYgOKACdi
         WOvIDCdSIaf1OXIQ2sK7D7bQXRYZLzlw+8FjhYutjXg2fNMcHXDqeV743lPVT3nI6d
         R81G16xLs/wvBv4Xi4g6+vtx1jfrV1ox9NQw+O5b7ihToXecNm9ANjKJDeUnXxGfQA
         WxgCkagLOq0Uc1tpCmRxjs8Tm/TuVWm4zgrBnKD+MqQ6AFPON5SO3cwZnY9VykaYaE
         28S4+ydAbnGPAtksB1NG6cD4H5BBVuK+VAxIO3x8e1BeW6wjCnQfShmpmTxf+E3RP6
         TD/vHloYg/8Xg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4751B609EA;
        Thu,  4 Mar 2021 01:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] rtnetlink: using dev_base_seq from target net
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161482020728.32353.15022486090724084553.git-patchwork-notify@kernel.org>
Date:   Thu, 04 Mar 2021 01:10:07 +0000
References: <20210302101607.18560-1-zhangkaiheb@126.com>
In-Reply-To: <20210302101607.18560-1-zhangkaiheb@126.com>
To:     zhang kai <zhangkaiheb@126.com>
Cc:     davem@davemloft.net, kuba@kernel.org, drt@linux.ibm.com,
        sukadev@linux.ibm.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue,  2 Mar 2021 18:16:07 +0800 you wrote:
> Signed-off-by: zhang kai <zhangkaiheb@126.com>
> ---
>  net/core/rtnetlink.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - rtnetlink: using dev_base_seq from target net
    https://git.kernel.org/netdev/net/c/a9ecb0cbf037

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


