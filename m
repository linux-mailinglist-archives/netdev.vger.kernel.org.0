Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73DD6543A43
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 19:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbiFHRZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 13:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbiFHRZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 13:25:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E04010E7;
        Wed,  8 Jun 2022 10:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DBA02B82993;
        Wed,  8 Jun 2022 17:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 87B1FC3411E;
        Wed,  8 Jun 2022 17:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654708813;
        bh=SEMqWNdvfmUHVUwlNMuxFKbyjzN3CT/bKBHPFAkJ6AI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=m2ueckspZU7+hVTXTkVxHo7OfCqJMLZU/ehV9E2Z6H5UxsCp04mxGHbZR6btioWTc
         mOo2M/gaNXHS/DOrYH5aaHYlXiJx1QBER2FLaY7zxsskg4c44DH0Ix8UWjaFL2ddzP
         1dtWJUInKETkv7mmgNWeP5KNUbymMIgJKDekG0SB8zHmEsRW8/+XAdPZe7X0BLBOao
         AnIalvbekFHbHO2r0UVaR6PEmaj9bDBQWGnye7lx3+4iXqLyEWDI/NHETRXE01782s
         pKijD1KotjVvyuaMJ3qCIT3J/nk2WIGam9g0oYRp3mO6NDkBTLBcqkiVowqnL8fppF
         u8Ep+F2qZ9yJA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6BF30E737FA;
        Wed,  8 Jun 2022 17:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/3] net: unexport some symbols that are annotated __init
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165470881343.3397.14744681431745529039.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Jun 2022 17:20:13 +0000
References: <20220606045355.4160711-1-masahiroy@kernel.org>
In-Reply-To: <20220606045355.4160711-1-masahiroy@kernel.org>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, pabeni@redhat.com, andrew@lunn.ch,
        dsahern@kernel.org, david.lebrun@uclouvain.be,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        herbert@gondor.apana.org.au, yoshfuji@linux-ipv6.org,
        linux@armlinux.org.uk, steffen.klassert@secunet.com,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  6 Jun 2022 13:53:52 +0900 you wrote:
> This patch set fixes odd combinations
> of EXPORT_SYMBOL and __init.
> 
> Checking this in modpost is a good thing and I really wanted to do it,
> but Linus Torvalds imposes a very strict rule, "No new warning".
> 
> I'd like the maintainer to kindly pick this up and send a fixes pull request.
> 
> [...]

Here is the summary with links:
  - [1/3] net: mdio: unexport __init-annotated mdio_bus_init()
    https://git.kernel.org/netdev/net/c/35b42dce6197
  - [2/3] net: xfrm: unexport __init-annotated xfrm4_protocol_init()
    https://git.kernel.org/netdev/net/c/4a388f08d878
  - [3/3] net: ipv6: unexport __init-annotated seg6_hmac_init()
    https://git.kernel.org/netdev/net/c/5801f064e351

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


