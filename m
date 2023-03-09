Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61F846B1C54
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 08:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjCIHaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 02:30:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbjCIHaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 02:30:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2F460D6C;
        Wed,  8 Mar 2023 23:30:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D65EFB81E93;
        Thu,  9 Mar 2023 07:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8FAA3C4339B;
        Thu,  9 Mar 2023 07:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678347020;
        bh=mu4O7Pvq1VNZVGOZLBf7dz+hLxR8Z6QVu2isJcMcwxE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LMA0ITtUNNBu9wowRtgErO4EczJ4X7ten37Ue68OJD9Bz32rM6EaOy3OiAzRrbgjW
         7pEd6FOwuluGqJsjhIRJNsK8+kEu3VIWjdr3sSk+XwrHFq4I3fleGJGDEJao17cW+h
         kjQr0PcY0ykrIaFfUoMM8MklPFFJaOWZOPwmEcOOjmNaejXw3lKx+9hIx8kKtnchoI
         8DTocUmhaf+S/krh2SXsiExaOZjNnJtV8N+3ENQt6jSYW4IJvJnyFAINWjXETFW2pI
         KlW7JXceHr2kevBsycJYyQMF0mzVatau6qB9vL2/540hDKToPB36nz3BScErRIENaP
         Zqtg6wtmBcILg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 72B64E68C00;
        Thu,  9 Mar 2023 07:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] eth: fealnx: bring back this old driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167834701946.22182.5252646764368734052.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Mar 2023 07:30:19 +0000
References: <20230307171930.4008454-1-kuba@kernel.org>
In-Reply-To: <20230307171930.4008454-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, stable@vger.kernel.org,
        tsbogend@alpha.franken.de, mpe@ellerman.id.au, npiggin@gmail.com,
        christophe.leroy@csgroup.eu, lukas.bulwahn@gmail.com,
        stephen@networkplumber.org, leon@kernel.org, geoff@infradead.org,
        petrm@nvidia.com, wsa+renesas@sang-engineering.com,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  7 Mar 2023 09:19:30 -0800 you wrote:
> This reverts commit d5e2d038dbece821f1af57acbeded3aa9a1832c1.
> 
> We have a report of this chip being used on a
> 
>   SURECOM EP-320X-S 100/10M Ethernet PCI Adapter
> 
> which could still have been purchased in some parts
> of the world 3 years ago.
> 
> [...]

Here is the summary with links:
  - [net] eth: fealnx: bring back this old driver
    https://git.kernel.org/netdev/net/c/8f1482080104

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


