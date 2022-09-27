Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07FA85EB678
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 02:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiI0AuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 20:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiI0AuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 20:50:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F42357DF;
        Mon, 26 Sep 2022 17:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3F0561509;
        Tue, 27 Sep 2022 00:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 24098C433D7;
        Tue, 27 Sep 2022 00:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664239818;
        bh=gA6xK8jQhdoyfhLelrqWDu28pRfxAf7wlOMy80cRlw0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eydX4WFxsYKFIgLjgJSLyTvHaf+v/P7hxg7TdawGEGutphmcbQYKEoL5x4OWNhVMS
         M85tk5lj+PzazIFv1dnyAzABGvKBSFnj7CnfwljtAweyDVLEruxk0JEpOLqECA3pd/
         a3m2uqgGPZCp9bz7i71v5U5vNBNy9B6zUTnZew6Zvv55h9S7iD+H5Tkr03zUeZBju8
         5cMcukKEv7rjqm3/s6VTOLVdSLihPy/v5fLOeTPLMxiKXLf/HjpQf4tEHiPbVLO+XG
         M6p6rcE4S9LqbvC/WCvUZOM8J7U74dNFwBPCakHvEdu5SBBtq7Qdsf3KhIL2Dd/ndB
         nXbFXgocV060g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 01AA4C04E59;
        Tue, 27 Sep 2022 00:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 00/13] net: sunhme: Cleanups and logging
 improvements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166423981800.26881.7010083147710284911.git-patchwork-notify@kernel.org>
Date:   Tue, 27 Sep 2022 00:50:18 +0000
References: <20220924015339.1816744-1-seanga2@gmail.com>
In-Reply-To: <20220924015339.1816744-1-seanga2@gmail.com>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, nbowler@draconx.ca,
        eike-kernel@sf-tec.de, zheyuma97@gmail.com,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 23 Sep 2022 21:53:26 -0400 you wrote:
> This series is a continuation of [1] with a focus on logging improvements (in
> the style of commit b11e5f6a3a5c ("net: sunhme: output link status with a single
> print.")). I have included several of Rolf's patches in the series where
> appropriate (with slight modifications). After this series is applied, many more
> messages from this driver will come with driver/device information.
> Additionally, most messages (especially debug messages) have been condensed onto
> one line (as KERN_CONT messages get split).
> 
> [...]

Here is the summary with links:
  - [net-next,v2,01/13] sunhme: remove unused tx_dump_ring()
    https://git.kernel.org/netdev/net-next/c/8247ab50c2ad
  - [net-next,v2,02/13] sunhme: Remove version
    https://git.kernel.org/netdev/net-next/c/6478c6e99455
  - [net-next,v2,03/13] sunhme: forward the error code from pci_enable_device()
    https://git.kernel.org/netdev/net-next/c/acb3f35f920b
  - [net-next,v2,04/13] sunhme: Return an ERR_PTR from quattro_pci_find
    https://git.kernel.org/netdev/net-next/c/d6f1e89bdbb8
  - [net-next,v2,05/13] sunhme: Regularize probe errors
    https://git.kernel.org/netdev/net-next/c/5b3dc6dda6b1
  - [net-next,v2,06/13] sunhme: switch to devres
    https://git.kernel.org/netdev/net-next/c/914d9b2711dd
  - [net-next,v2,07/13] sunhme: Convert FOO((...)) to FOO(...)
    https://git.kernel.org/netdev/net-next/c/03290907a5d1
  - [net-next,v2,08/13] sunhme: Clean up debug infrastructure
    https://git.kernel.org/netdev/net-next/c/30931367ba80
  - [net-next,v2,09/13] sunhme: Convert printk(KERN_FOO ...) to pr_foo(...)
    https://git.kernel.org/netdev/net-next/c/0bc1f45410ea
  - [net-next,v2,10/13] sunhme: Use (net)dev_foo wherever possible
    https://git.kernel.org/netdev/net-next/c/8acf878f29d0
  - [net-next,v2,11/13] sunhme: Combine continued messages
    https://git.kernel.org/netdev/net-next/c/24cddbc3ef11
  - [net-next,v2,12/13] sunhme: Use vdbg for spam-y prints
    https://git.kernel.org/netdev/net-next/c/26657c70b91c
  - [net-next,v2,13/13] sunhme: Add myself as a maintainer
    https://git.kernel.org/netdev/net-next/c/77ceb3731e12

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


