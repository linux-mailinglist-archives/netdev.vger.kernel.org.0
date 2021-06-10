Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 347603A3552
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 23:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbhFJVCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 17:02:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:44296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230307AbhFJVCE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 17:02:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 517A761414;
        Thu, 10 Jun 2021 21:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623358807;
        bh=Qe6MjMIWBwNwJC6mPp7zZ+4cY1H9lBsztLPquivuJRU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=G4KKfa/oSvKWq4Y8SH8jX/j8zYiHjSo2nhFB8Gu5cP54tjQXQhl3RdPCVVRXnydLh
         6NCcxOYkJJTXhZ6YgUshhuBemfwqjd+ScNzdhrc3VKgi2GQzNoKSGNDdymLWX/nG8O
         1KBHrsxYQWG1XQIs5HLZ1kiYCR+n8NJHw6GkbD0SUoyTrWjs5L8tKGt8VFOftp3rjJ
         vOThaFWIPKWe+svV06pba6dtPv7ppcizzVYEg35fC92oruE1LWpIAlIgyFzzhfkfqt
         kWUru/R9NsWTabh592aOajv5VUHnmPLBt/pxkfiX12LL0LI12BBno+DOg17inL9Da7
         uDZBflDCJ5kWQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 480B560A6C;
        Thu, 10 Jun 2021 21:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: axienet: Use
 devm_platform_get_and_ioremap_resource()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162335880729.5408.12892505475809173087.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Jun 2021 21:00:07 +0000
References: <20210610073622.4078361-1-yangyingliang@huawei.com>
In-Reply-To: <20210610073622.4078361-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        radhey.shyam.pandey@xilinx.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 10 Jun 2021 15:36:22 +0800 you wrote:
> Use devm_platform_get_and_ioremap_resource() to simplify
> code.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)

Here is the summary with links:
  - [net-next] net: axienet: Use devm_platform_get_and_ioremap_resource()
    https://git.kernel.org/netdev/net-next/c/47651c51c02f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


