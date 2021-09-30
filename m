Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7155241DA04
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 14:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350973AbhI3Mlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 08:41:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:42766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349006AbhI3Mlu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 08:41:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C1EBA613D1;
        Thu, 30 Sep 2021 12:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633005607;
        bh=QsG73VYBDOPXP+3imCXm5dfX+jobbd6t4W1nRchRJnk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FFdlVKZZOR8xeUivSeSCI9vUGcva9DwoD8puuPiftAHuVHk8OQX77r3yP3gpiZtwq
         ZMPBE1cgbvTiwtgU9k8T5GkO9j+P+xIMF5wJh/FTnUACJ3z4w4gr7csvdGN6FPvZji
         P9IYoS9UqT4cGoRIz59YcHfjzcF/WWpoGIwT/6ZKPkbmN/u+3TlqWpS+JYISnTb8ih
         7U+fhrlYKpn3B80JgflkaQiCmdkN44gY9rTEXkit2RlZh+Q4pMEYXp5oHSMtJ6ooLf
         yPlhcMKr0a6NnOK2kdC7nj6X0LyY+7uvd1/pPsqshu7e9vMUl4QL6cWTclbtnqBztD
         wJAR7VDuOJLCg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B467E60A7E;
        Thu, 30 Sep 2021 12:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dev_addr_list: handle first address in
 __hw_addr_add_ex
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163300560773.27982.1109794630423909883.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Sep 2021 12:40:07 +0000
References: <20210929153224.1290487-1-kuba@kernel.org>
In-Reply-To: <20210929153224.1290487-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, gnaaman@drivenets.com,
        syzbot+7a2ab2cdc14d134de553@syzkaller.appspotmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 29 Sep 2021 08:32:24 -0700 you wrote:
> struct dev_addr_list is used for device addresses, unicast addresses
> and multicast addresses. The first of those needs special handling
> of the main address - netdev->dev_addr points directly the data
> of the entry and drivers write to it freely, so we can't maintain
> it in the rbtree (for now, at least, to be fixed in net-next).
> 
> Current work around sprinkles special handling of the first
> address on the list throughout the code but it missed the case
> where address is being added. First address will not be visible
> during subsequent adds.
> 
> [...]

Here is the summary with links:
  - [net] net: dev_addr_list: handle first address in __hw_addr_add_ex
    https://git.kernel.org/netdev/net/c/a5b8fd657881

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


