Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1650D4FF82A
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 15:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235959AbiDMNxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 09:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236012AbiDMNwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 09:52:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7560E1FCFF;
        Wed, 13 Apr 2022 06:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D19DB824E7;
        Wed, 13 Apr 2022 13:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B492EC385A8;
        Wed, 13 Apr 2022 13:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649857811;
        bh=DCTDHXeYXtY6CD6rXE7A7+cVtUZihsD7A9lv2ehyoSg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cBQ8cgCAux2+t1dSuJ2P0jMwVsi5frnUVHRQAjA2BIk2yULXAP+L5BhUvcpv3BA8E
         XKnblPvNQXyu5/RhpZT+0OTjxoLL/Xh0fgG3CFJxodrGCzPxXYVbwu5yw/GcCL/2kd
         fF7Yfs3WSPLOpe1wnI9cz0SWTm0P2/DSernSwjuMWCRyuSyB0ZlKjM/nfDyT0Zc6il
         7GHNheWZBP+003n0eUwVlrnmvbu5SmjoIV0lQy2zCa4Hqxr+wefAejaUdoKMjHkSLz
         6ke9jNnGkOlbh70ZpmlmZYJwQx1QN6J7mjSLsK8q6u+RQ3yDdKC2xN/RZV8j5LsihT
         d5NpijsST2vfA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 94721E73CC8;
        Wed, 13 Apr 2022 13:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: realtek: don't parse compatible string for
 RTL8366S
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164985781159.18805.15294686114984287368.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Apr 2022 13:50:11 +0000
References: <20220412155749.1835519-1-alvin@pqrs.dk>
In-Reply-To: <20220412155749.1835519-1-alvin@pqrs.dk>
To:     =?utf-8?b?QWx2aW4gxaBpcHJhZ2EgPGFsdmluQHBxcnMuZGs+?=@ci.codeaurora.org
Cc:     linus.walleij@linaro.org, alsi@bang-olufsen.dk, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 12 Apr 2022 17:57:49 +0200 you wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> This switch is not even supported, but if someone were to actually put
> this compatible string "realtek,rtl8366s" in their device tree, they
> would be greeted with a kernel panic because the probe function would
> dereference NULL. So let's just remove it.
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: realtek: don't parse compatible string for RTL8366S
    https://git.kernel.org/netdev/net/c/8e925de60dda

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


