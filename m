Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40AFC521265
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 12:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237498AbiEJKoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 06:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231309AbiEJKoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 06:44:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BE3F286FFA;
        Tue, 10 May 2022 03:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A49DD61790;
        Tue, 10 May 2022 10:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0AA0AC385A6;
        Tue, 10 May 2022 10:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652179213;
        bh=EHD5jt5sWyKaNSKhBgZoFlrvLc0kk1Tv6Qen37JCPzw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hVwFcw2Mn9OHACWfFp9eSmBtyeYQtpJ0rR9LecQt24MkPkgFl6b8jEbgzgsbaYBfV
         C6Ln0QGViJeAHr70i99JR0AwhZrht1nlVgkvJVGej4Zaep6J0f5vhxBDKl/Px8l8be
         tU0yd8rqBvdh1qqqPlKkmsqjTLTtIhgUPruIpodZ3lVdIOGgoZIGXjXUdTBGeYN83k
         zXeaE73PD7UksPcuz4Wn2st5gRV0cGKB+gr3SqscI1ei3edNrNw//ae6UZLOZhZ3yz
         HZkjDC30Xp/JAKxFR6cRkTu983NkEOE70lsGvWAQ/jubo0Dso93J/YdvZTDAfUeX4K
         qEggR8iDnPIGg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DB39EE8DCCE;
        Tue, 10 May 2022 10:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] decnet: Use container_of() for struct dn_neigh casts
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165217921289.11394.178390152550838154.git-patchwork-notify@kernel.org>
Date:   Tue, 10 May 2022 10:40:12 +0000
References: <20220508102217.2647184-1-keescook@chromium.org>
In-Reply-To: <20220508102217.2647184-1-keescook@chromium.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     davem@davemloft.net, lkp@intel.com, kuba@kernel.org,
        pabeni@redhat.com, yajun.deng@linux.dev, zhengyongjun3@huawei.com,
        morbo@google.com, linux-decnet-user@lists.sourceforge.net,
        netdev@vger.kernel.org, nathan@kernel.org, ndesaulniers@google.com,
        trix@redhat.com, linux-kernel@vger.kernel.org
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
by Paolo Abeni <pabeni@redhat.com>:

On Sun,  8 May 2022 03:22:17 -0700 you wrote:
> Clang's structure layout randomization feature gets upset when it sees
> struct neighbor (which is randomized) cast to struct dn_neigh:
> 
> net/decnet/dn_route.c:1123:15: error: casting from randomized structure pointer type 'struct neighbour *' to 'struct dn_neigh *'
> 			gateway = ((struct dn_neigh *)neigh)->addr;
> 				   ^
> 
> [...]

Here is the summary with links:
  - decnet: Use container_of() for struct dn_neigh casts
    https://git.kernel.org/netdev/net/c/dc5306a8c0ea

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


