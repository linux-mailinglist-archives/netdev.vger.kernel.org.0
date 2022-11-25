Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80069638653
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 10:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiKYJat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 04:30:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbiKYJag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 04:30:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C0B93AC0F
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 01:30:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0ACC462325
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 09:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6160DC433D7;
        Fri, 25 Nov 2022 09:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669368616;
        bh=mVx3nEYt4lHxkJfJwVsoodBCCUvtnKLWyXQVISxc1dI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=e6I/0ipmht3Gn0DoKAfx5z0/rXqkJvRqWIxbgsdyiH0HIkyU9pswc4Nk/rIJJBcJB
         P20k+Xy1xQ8oJJ3E7SotvOcZ/ocFpKb7ALgC/pncFuFkmn+aQNyLmZi98S/mmkJ6hU
         NbJ+spUNbKtJMXgEz44VtVZK0H4po1vnZIwQ4wAq0Bd3sTmLVQJ+wghgxyujR8zMXB
         HWwlnZxIn/v90XyTqS38/hh4KyO2KIDZ6pSgpObN69B3kv4UEcLKEharRLl45Usoma
         wtxOSiptgRaoj7NeMT6DoYwvJS5oXmFt/ExW+Yg2F8AM523l+0n/cpHt5dGTqirVYv
         v3nn2FUW6+wUw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 472D1E29F3C;
        Fri, 25 Nov 2022 09:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] aquantia: Do not purge addresses when setting the number
 of rings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166936861628.29074.4364525643484358603.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Nov 2022 09:30:16 +0000
References: <20221123101008.224389-1-ibakolla@redhat.com>
In-Reply-To: <20221123101008.224389-1-ibakolla@redhat.com>
To:     Izabela Bakollari <ibakolla@redhat.com>
Cc:     irusskikh@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 23 Nov 2022 11:10:08 +0100 you wrote:
> IPV6 addresses are purged when setting the number of rx/tx
> rings using ethtool -G. The function aq_set_ringparam
> calls dev_close, which removes the addresses. As a solution,
> call an internal function (aq_ndev_close).
> 
> Fixes: c1af5427954b ("net: aquantia: Ethtool based ring size configuration")
> 
> [...]

Here is the summary with links:
  - [net] aquantia: Do not purge addresses when setting the number of rings
    https://git.kernel.org/netdev/net/c/2a8389113051

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


