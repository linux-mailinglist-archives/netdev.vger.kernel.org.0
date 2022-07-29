Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCC6584B2D
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 07:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234472AbiG2Fad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 01:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234367AbiG2Fa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 01:30:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A317313DF3;
        Thu, 28 Jul 2022 22:30:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4CC92B826F2;
        Fri, 29 Jul 2022 05:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DF3C5C433B5;
        Fri, 29 Jul 2022 05:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659072619;
        bh=/5oj8sE7l+/hfD4swIIxbDOHMIBGNGjoHEyU1b/Z9SU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nLbQfOO7XR/lNfXoWLCebbMfJgp0zZT+FkN+n+hOEdiGDNp1fZ4umWWKYxRXFIYho
         Diev7K1eSAVG/aE9OK/7JyM57W56nDNUUn+5nuEqwatAQuQm26RzFmJWSAZ8pJSWAo
         9j6IduarF1iMOTD9U03jke7wzDcqUHuT2EXvCMmNIOJjX4bV4eXBk7u0NpQFlaje6G
         2px4UNcrLObW7EMOdg4B9l744T48xqL33N1PoVbKDmUncxc8TrWZTKA0pyE3ccRnPN
         WdHQdNAzM+69c6VAUvfSyoC09FuV+OGO5sQ1EKG68+K+uN8c9kO+xmZEbyQ/S3TQAk
         AGImiO6kEl0rw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C5E38C43143;
        Fri, 29 Jul 2022 05:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1] selftests: net: dsa: Add a Makefile which
 installs the selftests
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165907261980.17632.18402519783746215352.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Jul 2022 05:30:19 +0000
References: <20220727191642.480279-1-martin.blumenstingl@googlemail.com>
In-Reply-To: <20220727191642.480279-1-martin.blumenstingl@googlemail.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        vladimir.oltean@nxp.com, linux-kernel@vger.kernel.org,
        pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, shuah@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 27 Jul 2022 21:16:42 +0200 you wrote:
> Add a Makefile which takes care of installing the selftests in
> tools/testing/selftests/drivers/net/dsa. This can be used to install all
> DSA specific selftests and forwarding.config using the same approach as
> for the selftests in tools/testing/selftests/net/forwarding.
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v1] selftests: net: dsa: Add a Makefile which installs the selftests
    https://git.kernel.org/netdev/net-next/c/6ecf206d602f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


