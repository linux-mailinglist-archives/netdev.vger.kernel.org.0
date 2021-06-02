Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F43E397D8B
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 02:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235415AbhFBAMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 20:12:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:56052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235275AbhFBALu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 20:11:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4D5E9613DC;
        Wed,  2 Jun 2021 00:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622592608;
        bh=i3Q5NgyJXmEKHiSqLVi9V/ovNQm1xhBHzm/0trRRSqI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hnFt5oiaw8YWr3hGA5P7SdmCBS6TlGWCzvfTFoDayjz4HeG54BygA71YJ0AL3iVyG
         MXuK+7wWQfguD1uyVqE+ZILXCRlD3yBb1dvpccNkwhAsops7XQkXH7BfbtLuDeC9Vm
         KnBu0fl9TGoKNBCBOeVvh7otcruLyyE9Iw4/3MUr7S53+aG3OthKq90Ij4i5gl7p02
         h3s9QWekiGejH3Ui+4e1cY8W1+GnS+kqKmZJwmR8taUD2kJBkfLJ4yBIAxi8psWCWw
         GIqjs0vhkoBOGyvMJ/k58PuBdS8jNj04/ZHpUV2UhLcxorHZvz2lWUxHmgSuDWF94w
         JWhXfjVUui2NA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 46D7F60C28;
        Wed,  2 Jun 2021 00:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: Return the correct errno code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162259260828.22595.9029820843522959751.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Jun 2021 00:10:08 +0000
References: <20210601141407.4131229-1-zhengyongjun3@huawei.com>
In-Reply-To: <20210601141407.4131229-1-zhengyongjun3@huawei.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 1 Jun 2021 22:14:07 +0800 you wrote:
> When kalloc or kmemdup failed, should return ENOMEM rather than ENOBUF.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  net/ipv4/af_inet.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net: Return the correct errno code
    https://git.kernel.org/netdev/net-next/c/ca746c55a7e6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


