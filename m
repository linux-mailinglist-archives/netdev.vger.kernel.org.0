Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0524C12E6
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 13:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240523AbiBWMkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 07:40:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240513AbiBWMkk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 07:40:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62BDEA1BC4;
        Wed, 23 Feb 2022 04:40:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 057ECB81F50;
        Wed, 23 Feb 2022 12:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A4319C340F1;
        Wed, 23 Feb 2022 12:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645620010;
        bh=8zGZuYHjDc2s+YCXnv+Yx/y4iztbPs9D87pbWAyf+Ww=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lM1W7a+2NButRD+rPh0q7hy1/cjFRVKjq2B05LeXUdQFzRDMSjfp9aKe8KgqxrJGP
         1xhdjUQNrEHIZN0W2LKP+bNhl1P8oFGi8Ny49UDXSzwJ3JUTVQJyXLLQfW7gBp/1Tt
         AZ0dybPOLrK4tTsgAYS99cf57TEgCILYULoCzqE+J/YmF3ZZG9OHcob24WHyhHRnvc
         98JDdvA0VknOvjemUfvlizhGWXBghdh1NgM2pDbBJgFJi1GQ4Bw68YChtTEVApLhhr
         +YbAZjjXYm/ALN1JODmNhiiD+3rOidJsv0TJ12hDfuRL4xi2DWclG4ICpoT6+Ob2hQ
         YdQiEDjl/DkgQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8A341E6D544;
        Wed, 23 Feb 2022 12:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] MAINTAINERS: add myself as co-maintainer for Realtek DSA
 switch drivers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164562001056.25344.14926417332581028267.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Feb 2022 12:40:10 +0000
References: <20220222161408.577783-1-alvin@pqrs.dk>
In-Reply-To: <20220222161408.577783-1-alvin@pqrs.dk>
To:     =?utf-8?b?QWx2aW4gxaBpcHJhZ2EgPGFsdmluQHBxcnMuZGs+?=@ci.codeaurora.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsi@bang-olufsen.dk, linus.walleij@linaro.org
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

On Tue, 22 Feb 2022 17:14:08 +0100 you wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> Adding myself (Alvin Šipraga) as another maintainer for the Realtek DSA
> switch drivers. I intend to help Linus out with reviewing and testing
> changes to these drivers, particularly the rtl8365mb driver which I
> authored and have hardware access to.
> 
> [...]

Here is the summary with links:
  - [net] MAINTAINERS: add myself as co-maintainer for Realtek DSA switch drivers
    https://git.kernel.org/netdev/net/c/404ba13a6588

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


