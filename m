Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 071265886A2
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 06:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233872AbiHCEuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 00:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiHCEuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 00:50:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0623F2BEA;
        Tue,  2 Aug 2022 21:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2ED6B82192;
        Wed,  3 Aug 2022 04:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5E3C4C433D7;
        Wed,  3 Aug 2022 04:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659502213;
        bh=0n4Gv/LGiTAmPuXcUPXzAPXu9z+BAUuhUK1p1r+ZTww=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VziFniyBOvJn4lb1oEAInkGfWWXesiIUiFdIVmc1tqj4eg2BWGUp4TjdIpQ7Dcptz
         GxNOXcvmExbvFzcszxtBeeoeXtdTMBZTSHQHTIkDWremOD28o7/dW4PZMF3PG0RszW
         7FeHENR0IZk3P9HB0/Yk5Q//dvqa/MJyRFjo27/zpJcFGYTpaopFrZj6kVTHoa/saj
         yVl+rgykotR+M8ng//sg8j2F2uPJVKX5ALw//JdQ6dqxY7NdErgUlH9DQ4aSIjk/3i
         Vpa1NrvvphapfOpR2fVv38Epavnf14Waw6NMSBQmGWR5MdcCRlsAMqPWo48fv5cC0g
         LCKHSnRQeGXLg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4544FC43143;
        Wed,  3 Aug 2022 04:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] doc: sfp-phylink: Fix a broken reference
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165950221327.10470.496233845486035537.git-patchwork-notify@kernel.org>
Date:   Wed, 03 Aug 2022 04:50:13 +0000
References: <be3c7e87ca7f027703247eccfe000b8e34805094.1659247114.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <be3c7e87ca7f027703247eccfe000b8e34805094.1659247114.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, corbet@lwn.net, linux@armlinux.org.uk,
        ioana.ciornei@nxp.com, robh@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 31 Jul 2022 07:59:00 +0200 you wrote:
> The commit in Fixes: has changed a .txt file into a .yaml file. Update the
> documentation accordingly.
> 
> While at it add some `` around some file names to improve the output.
> 
> Fixes: 70991f1e6858 ("dt-bindings: net: convert sff,sfp to dtschema")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> [...]

Here is the summary with links:
  - doc: sfp-phylink: Fix a broken reference
    https://git.kernel.org/netdev/net-next/c/6f63d04473f2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


