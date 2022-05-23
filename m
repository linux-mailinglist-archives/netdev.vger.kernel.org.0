Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA8F53106F
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 15:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234370AbiEWKuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 06:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234343AbiEWKuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 06:50:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 539774CD5A;
        Mon, 23 May 2022 03:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8D70B81032;
        Mon, 23 May 2022 10:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 64358C34116;
        Mon, 23 May 2022 10:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653303012;
        bh=RLHeGFzVSDV11EwgnKw/aguWyzZ0qKFGVx4BKotalhQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O8ti3r6uJUFy8dfOhEOy6P1H6Op4O7M1vLHPJMCAZ9TZXpvamhD3Wu+rfaTuyaI1g
         pqIInk2M5nusQ1TvCAWViS+tbNM2JDgYSVoTEcZu4f1MbGK12m3WYn+P67Zkpp/AQX
         U7H8Ap020mgKB31JfFBJPb/ANG5gh3WnEjoqwklT6w2S8nlk+2vg1rtwvY4Zf/eMhz
         wusL14kllR3jsIIg5QOadHSLTXYWGzGbCqp0aGqcKWTEBnJRX2BuZq5BuZVNWbhT6a
         JnRDTqOjfXFfY9hCaJrOAcU8pXxK0HiS5lq8z+Q124slpW87roZnRwG3bZwokK+YqF
         8TSp3gVdIXIGg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4A8B9F03943;
        Mon, 23 May 2022 10:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] eth: de4x5: remove support for Generic DECchip &
 DIGITAL EtherWORKS PCI/EISA
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165330301230.7594.1301485592206225247.git-patchwork-notify@kernel.org>
Date:   Mon, 23 May 2022 10:50:12 +0000
References: <20220519031345.2134401-1-kuba@kernel.org>
In-Reply-To: <20220519031345.2134401-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, corbet@lwn.net, tsbogend@alpha.franken.de,
        mpe@ellerman.id.au, benh@kernel.crashing.org, paulus@samba.org,
        sburla@marvell.com, vburru@marvell.com, aayarekar@marvell.com,
        arnd@arndb.de, zhangyue1@kylinos.cn, linux-doc@vger.kernel.org,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-parisc@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 18 May 2022 20:13:45 -0700 you wrote:
> Looks like almost all changes to this driver had been tree-wide
> refactoring since git era begun. There is one commit from Al
> 15 years ago which could potentially be fixing a real bug.
> 
> The driver is using virt_to_bus() and is a real magnet for pointless
> cleanups. It seems unlikely to have real users. Let's try to shed
> this maintenance burden.
> 
> [...]

Here is the summary with links:
  - [net-next] eth: de4x5: remove support for Generic DECchip & DIGITAL EtherWORKS PCI/EISA
    https://git.kernel.org/netdev/net-next/c/32c53420d2a0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


