Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F23A39E8EC
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 23:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbhFGVMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 17:12:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:47454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230421AbhFGVL5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 17:11:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DFDCC61289;
        Mon,  7 Jun 2021 21:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623100205;
        bh=ObgwjNVbrkaqtOwHHGYpfKl8pQ5y/vkjg82aqDfVl+M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Q11X96Q/9kt0hvwKMcnthvbGkoIMAwlgXAJHOdysY+L//7URyovk31E/f2b9EEmEg
         nWN1B5+33rYwj/OKmIzcmPpr0FsucYxmL+SuKkdsa1osg05MDn/7QJOeiBdd84+cii
         mgitORgo8DFhAB15s4xF1KlVtRAbX9HIU1GO5+aYkf+x9Q9Y+T8UuB1ZR6IF7LZ/4k
         HwooluxqACkZCzavbWhRBxPucvmceVWkFgGdchGrhMCVHrHPE1jNebnMp/+pxcm248
         ts+E+7rm0sPDTCopBnW0VkOnfWWbjBeKUpcBPFLALJlTSSOH2kmV+D6UJZb+aR6+9R
         X4UrGxxRyy2vQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D3965609F1;
        Mon,  7 Jun 2021 21:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: mvpp2: check return value after calling
 platform_get_resource()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162310020586.31357.3568954403358088036.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Jun 2021 21:10:05 +0000
References: <20210607143602.4000092-1-yangyingliang@huawei.com>
In-Reply-To: <20210607143602.4000092-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        mw@semihalf.com, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 7 Jun 2021 22:36:02 +0800 you wrote:
> It will cause null-ptr-deref if platform_get_resource() returns NULL,
> we need check the return value.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 4 ++++
>  1 file changed, 4 insertions(+)

Here is the summary with links:
  - [net-next] net: mvpp2: check return value after calling platform_get_resource()
    https://git.kernel.org/netdev/net-next/c/0bb51a3a3857

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


