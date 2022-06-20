Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA4555138D
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 11:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240157AbiFTJAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 05:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240065AbiFTJAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 05:00:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F7BDE0D9;
        Mon, 20 Jun 2022 02:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C086561372;
        Mon, 20 Jun 2022 09:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1FECCC341C4;
        Mon, 20 Jun 2022 09:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655715613;
        bh=VM/DyRE7JAp51YKWWFed2fSaBS/5HGhvhb6w/FhKPWQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cO+sD/LfrtoCH4368BEBGikhze/uCyyROQcDsKCv4mm/iB/PoSADPV6Ol/h9ezata
         ja7KBbm2AlNmPXMXP3/G0qRPJgGLm0oPktjz1trVLWUwQvtNercSwcPAyH0COGbHhp
         sMUBqvy9XEFgIpuI1w+URRvNTyFmRhzJ9u4nPPWzZkQToIoQ8CpGkPXdhhWIGGWpxM
         mt2BdsRb0bDF6ZT0joQ2iFk9rvYOlLCYdBCOdaUrWjkaG1sbcURoI1B3KoNSAcOXFM
         MrmyWDNtC9BwzAecfgNOgewtQKmaOZYlFCKib33MWWmCsnlGrWgUE93kU/tgiyLVag
         SFtHPfTHiKUZA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 070B1E7386C;
        Mon, 20 Jun 2022 09:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] ipv4: fix bind address validity regression tests
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165571561302.18430.6859728258984876078.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Jun 2022 09:00:13 +0000
References: <20220619162734.113340-1-pbl@bestov.io>
In-Reply-To: <20220619162734.113340-1-pbl@bestov.io>
To:     Riccardo Paolo Bestetti <pbl@bestov.io>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, shuah@kernel.org, cmllamas@google.com,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 19 Jun 2022 18:27:35 +0200 you wrote:
> Commit 8ff978b8b222 ("ipv4/raw: support binding to nonlocal addresses")
> introduces support for binding to nonlocal addresses, as well as some
> basic test coverage for some of the related cases.
> 
> Commit b4a028c4d031 ("ipv4: ping: fix bind address validity check")
> fixes a regression which incorrectly removed some checks for bind
> address validation. In addition, it introduces regression tests for
> those specific checks. However, those regression tests are defective, in
> that they perform the tests using an incorrect combination of bind
> flags. As a result, those tests fail when they should succeed.
> 
> [...]

Here is the summary with links:
  - [v2,net] ipv4: fix bind address validity regression tests
    https://git.kernel.org/netdev/net/c/313c502fa3b3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


