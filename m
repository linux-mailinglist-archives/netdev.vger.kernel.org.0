Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2D166DD9B
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 13:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236334AbjAQMaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 07:30:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236635AbjAQMaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 07:30:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C5F36FE5
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 04:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FAA4B815CF
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 12:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DDABEC433F0;
        Tue, 17 Jan 2023 12:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673958616;
        bh=arrWd+RlUCdVmeQvCMVUK/6IMuFezKEV92OmSvujvcU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bGLiMWkUT0BZ4vvF7JlnofOe8w5c5JaRckpsLZzss4NNJr9e9WGmPLpmZe4+bxwa6
         b6IyXULQ5IMQLIZ37TgIvBJ800jUxLl2ShwywVzX2InsRt6WXzEgUo6JM6Kobhp5/r
         gFTumFWl2w4qGIRzWR/DixzfFoJsypKvLhcNfd/qF/QYosGVSAvqshmTzJcvKjvV3U
         jz1x25tAyHkdhiYUTC9tfr2wS12Yxc3zolEA+GkemuW1CVm8UzLqwWl9QUHI8zTm0S
         54+YH0PYOBTM6e48rFYATZp6DoUUMgtsMp9RU7vBIarnTcyiR3PT6tntFnkfsr9K0C
         Enf2S+CT8C0nA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C09D7C41670;
        Tue, 17 Jan 2023 12:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: mdio: cavium: Remove unneeded simicolons
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167395861678.19746.4112297442495962201.git-patchwork-notify@kernel.org>
Date:   Tue, 17 Jan 2023 12:30:16 +0000
References: <20230115164203.510615-1-andrew@lunn.ch>
In-Reply-To: <20230115164203.510615-1-andrew@lunn.ch>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, michael@walle.cc, lkp@intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Sun, 15 Jan 2023 17:42:03 +0100 you wrote:
> The recent refactoring to split C22 and C45 introduced two unneeded
> semiconons which the kernel test bot reported. Remove them.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: 93641ecbaa1f ("net: mdio: cavium: Separate C22 and C45 transactions")
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> 
> [...]

Here is the summary with links:
  - [net-next] net: mdio: cavium: Remove unneeded simicolons
    https://git.kernel.org/netdev/net-next/c/0c68c8e5ec68

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


