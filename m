Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBFE683868
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 22:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232099AbjAaVLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 16:11:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231731AbjAaVLi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 16:11:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E532353982;
        Tue, 31 Jan 2023 13:11:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 894FBB81EE8;
        Tue, 31 Jan 2023 21:11:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2D0A2C4339B;
        Tue, 31 Jan 2023 21:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675199495;
        bh=FtFbTECF8aJmVoN2xuSg6nQJs6CSQud4v1pc5jlGhKM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KTr3Hq/yia3qU2eskoRJ7RGtbkglsIEtWsIrEkRvDwiD1a98U7w+gdQzmq9B+NSl2
         El8SICFq6ZXAthGUV/pGuxQO3OzAcs4izzpUHikigRMrQ+V7SiLz54L5MRuO2un3YH
         yW+no/WNXEOoiUQOzMVrgRv0IVBSChtC9Hv1Gg4X0NjCYnUet61IzTX9NM0yWjuOlb
         IZ0nOE1HZfGJ13oHSWsL1YNUYcMKZZaWBG1EUOUm3oTVmkbWdE8rU1j6dbzsUkCp1E
         5zVVAE02q5koBP1xdfyug3pIHrbSdUtGHPL9G2/NRlrS7yrqrZtQnOdua3QfuJY5H3
         7h7Kndy+XioUg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0F119C072E7;
        Tue, 31 Jan 2023 21:11:35 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bluetooth 2023-01-17
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <167519949505.16885.5483010314235068928.git-patchwork-notify@kernel.org>
Date:   Tue, 31 Jan 2023 21:11:35 +0000
References: <20230118002944.1679845-1-luiz.dentz@gmail.com>
In-Reply-To: <20230118002944.1679845-1-luiz.dentz@gmail.com>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to bluetooth/bluetooth-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 17 Jan 2023 16:29:44 -0800 you wrote:
> The following changes since commit 1f3bd64ad921f051254591fbed04fd30b306cde6:
> 
>   net: stmmac: fix invalid call to mdiobus_get_phy() (2023-01-17 13:33:19 +0100)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2023-01-17
> 
> [...]

Here is the summary with links:
  - pull-request: bluetooth 2023-01-17
    https://git.kernel.org/bluetooth/bluetooth-next/c/010a74f52203

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


