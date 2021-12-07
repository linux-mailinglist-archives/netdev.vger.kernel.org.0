Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB24E46AF85
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 02:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378896AbhLGBDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 20:03:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347991AbhLGBDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 20:03:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32FB7C061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 17:00:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4C37B81649
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 01:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5D21AC004DD;
        Tue,  7 Dec 2021 01:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638838809;
        bh=1JvfDrVV8dtEQ7WECdog/Ki1phJyrkpcsds4d/Z4P8k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O/LiaP+h7bdyzeo9eLJEjvgdvsNF8wG96xWLbuYbod5Bs/VWnqzWaebk5lfWt0qUu
         rQkW81/6T2Ytj/877SL0IOba+h327YRiwzz3fYcBC6Ocf/CKZMffOvOpiz668PtvDv
         J0sMwjowinzYLYj5yovPOXNBxLgzCqgQrCT3OVzChrnWO3K9xAZ6M0m13rW5DpkP7+
         drsod85pCiAEwTBQJapbPmKG8zT3zGnjssR1YEqEnsZ6BPGtqM1JOjdURpMT8qYSVL
         BhLTTJoghmSd48sxaNNJb+t8jn+9WsNbRNwQklLI4JglbDEwGPl3q8pojq/unAnseg
         IWJQ8/7cNYc/Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 48CCD609DA;
        Tue,  7 Dec 2021 01:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ethtool: do not perform operations on net devices being
 unregistered
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163883880929.20652.6994089130580113681.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Dec 2021 01:00:09 +0000
References: <20211203101318.435618-1-atenart@kernel.org>
In-Reply-To: <20211203101318.435618-1-atenart@kernel.org>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com,
        mkubecek@suse.cz, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  3 Dec 2021 11:13:18 +0100 you wrote:
> There is a short period between a net device starts to be unregistered
> and when it is actually gone. In that time frame ethtool operations
> could still be performed, which might end up in unwanted or undefined
> behaviours[1].
> 
> Do not allow ethtool operations after a net device starts its
> unregistration. This patch targets the netlink part as the ioctl one
> isn't affected: the reference to the net device is taken and the
> operation is executed within an rtnl lock section and the net device
> won't be found after unregister.
> 
> [...]

Here is the summary with links:
  - [net] ethtool: do not perform operations on net devices being unregistered
    https://git.kernel.org/netdev/net/c/dde91ccfa25f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


