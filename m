Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78EEC485E23
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 02:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344385AbiAFBaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 20:30:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344388AbiAFBaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 20:30:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21FADC061212;
        Wed,  5 Jan 2022 17:30:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E13A5B81EC1;
        Thu,  6 Jan 2022 01:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B0455C36B01;
        Thu,  6 Jan 2022 01:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641432609;
        bh=isteENm992qzLgODdHzA1bXXpMAKbkZy7xPe2Jcq+EE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=J5UbfLx4vKh70O9MU2mTOA5zygFACF968dU+aUN9yQ+e96AIqPHmxCqZIM9WknlXr
         HtmmEMZJSrEN0GwHxDFX3kh58wIzbAJ8rVT+11FpE46XKUMl/oUKoVWhZaRbdR+WDB
         BPbqv36XQPixXgfF5pnNCT4AtVO9mwZIdGePvrtHEndW91DU990ChkiUGOa1S+6jF2
         mMLMhG2qRUsnB8ZVNQ2dAay8XrU7WC6kvONUIKxJ/atxowY9I8/VJYHF9qQKNcNQyx
         etwnbwi27vmzljyyR/OvaS3CwAp/Eg5QQcT1TiOuyQlpLqrUDeMFGKj5j/yEVqppTE
         dOvazJ1GGccoA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9A37EF79405;
        Thu,  6 Jan 2022 01:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] net: lantiq_xrx200: improve ethernet performance
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164143260962.10802.17930451058768933162.git-patchwork-notify@kernel.org>
Date:   Thu, 06 Jan 2022 01:30:09 +0000
References: <20220104151144.181736-1-olek2@wp.pl>
In-Reply-To: <20220104151144.181736-1-olek2@wp.pl>
To:     Aleksander Jan Bajkowski <olek2@wp.pl>
Cc:     tsbogend@alpha.franken.de, hauke@hauke-m.de, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  4 Jan 2022 16:11:41 +0100 you wrote:
> This patchset improves Ethernet performance by 15%.
> 
> NAT Performance results on BT Home Hub 5A (kernel 5.10.89, mtu 1500):
> 
> 	Down		Up
> Before	539 Mbps	599 Mbps
> After	624 Mbps	695 Mbps
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] MIPS: lantiq: dma: increase descritor count
    https://git.kernel.org/netdev/net-next/c/5112e9234bbb
  - [net-next,2/3] net: lantiq_xrx200: increase napi poll weigth
    https://git.kernel.org/netdev/net-next/c/768818d772d5
  - [net-next,3/3] net: lantiq_xrx200: convert to build_skb
    https://git.kernel.org/netdev/net-next/c/e015593573b3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


