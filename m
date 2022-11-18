Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8EE62F43E
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 13:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241432AbiKRMKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 07:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241659AbiKRMKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 07:10:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A98E8FF8F
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 04:10:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CD8E624C3
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 12:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0594EC4314C;
        Fri, 18 Nov 2022 12:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668773417;
        bh=cvCsoydDZk9nCyz3ZF7b0ATeuc81l0oQ+Rvo3zx5yJQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Y4ZVmBqMORXHZDtw4ALbHzdft2FSeX2e5UU4wkWU9et66MgKkLROyZElrNjS0gLzf
         bKYfX2/h0LJmbYmwE6Y/p6P4ly/lb3rHfshsO9oRi9KNYSaS72zGnGvbEKeUMJ1dPh
         8Nend7K2PIYA4hcbZSgJbblfNg1KttdJTM+t/mWZ3NO6eF5FWvOC5nvHlxIFf9xXkR
         7dpI9T8y9sPdHCMRckFdEVQ/lPXS5DyMtuOx+kJ2sAfVWbf5xEr7q2Xi+cO1g9Pjsc
         /K4SIIHRSvh34HS9qqsNUuWvzKU4E08RVYHSjr9bi/UhOok4uRHnGgBQTSxNPvUdWZ
         ImBSn5C9QUA8Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DDFA9E50D71;
        Fri, 18 Nov 2022 12:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethernet: mtk_eth_soc: do not overwrite mtu
 configuration running reset routine
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166877341690.19277.8350790502217063566.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Nov 2022 12:10:16 +0000
References: <17649664984df04f4855dfeb4f50adead5db422c.1668641530.git.lorenzo@kernel.org>
In-Reply-To: <17649664984df04f4855dfeb4f50adead5db422c.1668641530.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lorenzo.bianconi@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 17 Nov 2022 00:35:04 +0100 you wrote:
> Restore user configured MTU running mtk_hw_init() during tx timeout routine
> since it will be overwritten after a hw reset.
> 
> Reported-by: Felix Fietkau <nbd@nbd.name>
> Fixes: 9ea4d311509f ("net: ethernet: mediatek: add the whole ethernet reset into the reset process")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next] net: ethernet: mtk_eth_soc: do not overwrite mtu configuration running reset routine
    https://git.kernel.org/netdev/net-next/c/b677d6c7a695

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


