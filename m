Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15E5D56C675
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 05:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbiGIDkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 23:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiGIDkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 23:40:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1BD9820E2;
        Fri,  8 Jul 2022 20:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98BCCB82A4F;
        Sat,  9 Jul 2022 03:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 539ADC341C8;
        Sat,  9 Jul 2022 03:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657338014;
        bh=eqIPTMCzmxzPuhSkv0pqgey36p+OCo5TODcucNYkfJ0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R06RgvuVjkpCd3vaglnm+TVGeUBGjcJEZ5I7AbCgcg+giR7YlvMzDkfeHaKLNxLKU
         wdijXohDzwmzahey+fNTkKiDSI14TEff2Ao93asP4RQK2VMpX3+y5//Xz9t6UE1RCm
         K3exxDiO0YLQr/GkyIasgkHMKUhMBuxaMejQJo0xXOKxCJ4u7pDwCy4fAY6pHLLmu8
         LGZ82uZu3q5DUoB3fU7gA+tudGD1HGc8wCFSvwrc+gRRmmAsDzhbLTViVOlcyVFAwN
         AHTfeD854/l4Pni3iQU+tFAE+yRgvf+HE99Gvuq8om4PiEvEfbYErs6ZwbdIePqg0K
         TB3ZJm4IArd3Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2C5C9E45BDE;
        Sat,  9 Jul 2022 03:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/2] selftests: forwarding: Install two missing tests
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165733801417.11477.8086295338965656189.git-patchwork-notify@kernel.org>
Date:   Sat, 09 Jul 2022 03:40:14 +0000
References: <20220707135532.1783925-1-martin.blumenstingl@googlemail.com>
In-Reply-To: <20220707135532.1783925-1-martin.blumenstingl@googlemail.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        vladimir.oltean@nxp.com, linux-kernel@vger.kernel.org,
        pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, shuah@kernel.org
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

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  7 Jul 2022 15:55:30 +0200 you wrote:
> For some distributions (e.g. OpenWrt) we don't want to rely on rsync
> to copy the tests to the target as some extra dependencies need to be
> installed. The Makefile in tools/testing/selftests/net/forwarding
> already installs most of the tests.
> 
> This series adds the two missing tests to the list of installed tests.
> That way a downstream distribution can build a package using this
> Makefile (and add dependencies there as needed).
> 
> [...]

Here is the summary with links:
  - [1/2] selftests: forwarding: Install local_termination.sh
    https://git.kernel.org/netdev/net/c/437ac2592c09
  - [2/2] selftests: forwarding: Install no_forwarding.sh
    https://git.kernel.org/netdev/net/c/cfbba7b46aef

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


