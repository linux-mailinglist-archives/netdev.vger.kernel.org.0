Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72B064A8396
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 13:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbiBCMKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 07:10:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55692 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239506AbiBCMKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 07:10:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B608A61750
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 12:10:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2637BC340ED;
        Thu,  3 Feb 2022 12:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643890209;
        bh=p3sKqPx0L6dqBUrX/NKTElyN4gOokRLn1/yQ+h7cWpo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=V2CrqL1SxTosNlRSArXfa/F0KrhjWdPMIvNq0NPhC8+meHqdG7xlRKQmA0wJn5v3g
         b3NO4sUY0OJElIY9dyV0DluCZ0c7VUIkEWZzY2OnQoNLuh9ZdouW6itac4GTnh8d03
         nN9NZv5gs20aiXI+G/rUXpvKgWOvxPOhTUJhWuspZX2yx58YWEMu1WwZHkTATNdRER
         59R3Dnqj/mcm5UKBzZNuWBXPRDep5JuXpIKBH1hMvJHe0YP/i3rMzA0Z0KyTG5MW8i
         TglqqP9gQkuLPKpsZACV5CmmJWDKBJlgvt/Njay57u3qU2NNy8pLfcYhZoamI3U4zg
         NS4GN3x61iYJA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 09CD7E6BAC6;
        Thu,  3 Feb 2022 12:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH v3] page_pool: Refactor page_pool to enable
 fragmenting after allocation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164389020903.26884.1681096827552466800.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Feb 2022 12:10:09 +0000
References: <164364711160.2192.13812169156456875778.stgit@localhost.localdomain>
In-Reply-To: <164364711160.2192.13812169156456875778.stgit@localhost.localdomain>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     netdev@vger.kernel.org, hawk@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, kuba@kernel.org,
        alexanderduyck@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 31 Jan 2022 08:40:01 -0800 you wrote:
> From: Alexander Duyck <alexanderduyck@fb.com>
> 
> This change is meant to permit a driver to perform "fragmenting" of the
> page from within the driver instead of the current model which requires
> pre-partitioning the page. The main motivation behind this is to support
> use cases where the page will be split up by the driver after DMA instead
> of before.
> 
> [...]

Here is the summary with links:
  - [net-next,v3] page_pool: Refactor page_pool to enable fragmenting after allocation
    https://git.kernel.org/netdev/net-next/c/52cc6ffc0ab2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


