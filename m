Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B851F4616F1
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 14:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236615AbhK2NtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 08:49:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234965AbhK2NrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 08:47:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23F84C09CE4A;
        Mon, 29 Nov 2021 04:30:12 -0800 (PST)
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3696B81059;
        Mon, 29 Nov 2021 12:30:10 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id 65AE16056B;
        Mon, 29 Nov 2021 12:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638189009;
        bh=xBZToKG2iJtssPl3f6j1oRQafI/jbLxU2kDJsv4QJc4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rvUn0PMonSRWkgieIAMHrI6YNuztFtnIU2XhIUergEjp9LWOI90FrC+ZlGY+l7fSW
         KLlbNMXCNOx3N5yVrL2REfiQOi/b5tvaB+2caFLpUV/ZShr0aAspUiGLlq6CgrEQNc
         P3C//bvdotZfUAKKGXq0ybd1DMahk0is1po0iGduzNJh6D9BLlzFA9qFaHylRcxvc7
         3jo6wo+Y91irjnmG6Xi6fPp5MSI7nZqQ9D/1PcTikuKA8rUEWm7DZ0ee/k4zY5bd50
         hJrMbRZWozN/wdx5NtG/b8ObMCUqq6PRvcH2VxGl/kjKoWxu1dLkyY9XlcP+f2GaPY
         tq1iS+NDJI/0A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5761B60A4D;
        Mon, 29 Nov 2021 12:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: vxlan: add macro definition for number of
 IANA VXLAN-GPE port
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163818900935.24631.5026053121542489873.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Nov 2021 12:30:09 +0000
References: <20211127093405.47218-1-huangguangbin2@huawei.com>
In-Reply-To: <20211127093405.47218-1-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, wangjie125@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lipeng321@huawei.com, chenhao288@hisilicon.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 27 Nov 2021 17:34:03 +0800 you wrote:
> This series add macro definition for number of IANA VXLAN-GPE port for
> cleanup.
> 
> Hao Chen (2):
>   net: vxlan: add macro definition for number of IANA VXLAN-GPE port
>   net: hns3: use macro IANA_VXLAN_GPE_UDP_PORT to replace number 4790
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: vxlan: add macro definition for number of IANA VXLAN-GPE port
    https://git.kernel.org/netdev/net-next/c/ed618bd80947
  - [net-next,2/2] net: hns3: use macro IANA_VXLAN_GPE_UDP_PORT to replace number 4790
    https://git.kernel.org/netdev/net-next/c/e54b708c5441

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


