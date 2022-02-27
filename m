Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E473E4C5A99
	for <lists+netdev@lfdr.de>; Sun, 27 Feb 2022 12:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbiB0LKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 06:10:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiB0LKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 06:10:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2189C5B3C6
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 03:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9614DB80B99
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 11:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1FB16C340F3;
        Sun, 27 Feb 2022 11:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645960215;
        bh=qxADYOxjuqm/Xh0hS1JlEz2ehKIBPj98/lmFwf0jIdg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AoyZ78wn9FTpssZwsnB5um+C4mkDQmq4r+hQDozY10N5gMRAz5kQnagVShqy64UH5
         oK+5ojNVUPkLYGcVtrglivuI6KNUIkBzMCg+6nP7p94HT6dZmfTCZqhZsJ6s9UnTbC
         39JyRgQxWF+Q52vizIARtH3QSbDgXNlWHKJ2zGIOVGe1GWJKWYUp5yES0UY2Qp6Tx1
         /lbCJgQtO2v9rFB0RVLprQXCkgNUuL6RgW4tj5lQbd+57dSXCZUmj9VUeeunsmAzwt
         ifg9CPWYHVOdXwOtuC8R3z0obLCL+rp34IF8Y1FrQoEh/YFEozPYOFzYZSDBtFjkDL
         H4fpHNKc3f1xA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F3B4CEAC095;
        Sun, 27 Feb 2022 11:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v8 0/8] new Fungible Ethernet driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164596021499.1414.9086192213854184539.git-patchwork-notify@kernel.org>
Date:   Sun, 27 Feb 2022 11:10:14 +0000
References: <20220225025902.40167-1-dmichail@fungible.com>
In-Reply-To: <20220225025902.40167-1-dmichail@fungible.com>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 24 Feb 2022 18:58:54 -0800 you wrote:
> This patch series contains a new network driver for the Ethernet
> functionality of Fungible cards.
> 
> It contains two modules. The first one in patch 2 is a library module
> that implements some of the device setup, queue managenent, and support
> for operating an admin queue. These are placed in a separate module
> because the cards provide a number of PCI functions handled by different
> types of drivers and all use the same common means to interact with the
> device. Each of the drivers will be relying on this library module for
> them.
> 
> [...]

Here is the summary with links:
  - [net-next,v8,1/8] PCI: Add Fungible Vendor ID to pci_ids.h
    https://git.kernel.org/netdev/net-next/c/e8eb9e32999d
  - [net-next,v8,2/8] net/fungible: Add service module for Fungible drivers
    https://git.kernel.org/netdev/net-next/c/e1ffcc66818f
  - [net-next,v8,3/8] net/funeth: probing and netdev ops
    https://git.kernel.org/netdev/net-next/c/ee6373ddf3a9
  - [net-next,v8,4/8] net/funeth: ethtool operations
    https://git.kernel.org/netdev/net-next/c/21c5ea95da9e
  - [net-next,v8,5/8] net/funeth: devlink support
    https://git.kernel.org/netdev/net-next/c/d1d899f24428
  - [net-next,v8,6/8] net/funeth: add the data path
    https://git.kernel.org/netdev/net-next/c/db37bc177dae
  - [net-next,v8,7/8] net/funeth: add kTLS TX control part
    https://git.kernel.org/netdev/net-next/c/a3662007a12e
  - [net-next,v8,8/8] net/fungible: Kconfig, Makefiles, and MAINTAINERS
    https://git.kernel.org/netdev/net-next/c/749efb1e6d73

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


