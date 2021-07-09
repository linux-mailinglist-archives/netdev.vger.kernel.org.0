Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E48AC3C2906
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 20:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbhGIScu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 14:32:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:48228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229499AbhGIScs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 14:32:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E8E35613D0;
        Fri,  9 Jul 2021 18:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625855405;
        bh=LY//Hh9zGmPXn8w8Hrc0fviiKi7CeZDYnnGMR01A0yE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=l244S4lKn+ORdwUg7namMn1dqq97sXgc6erokwu09YYRlo7c867xZ7FdhsBCDr0LV
         wJi2vDAkXVegZBYDvX3Sq6Mrn/25lu2P7PrVPJH7Or3xpUltKjtqiLXs2vT1Jp2IIw
         PB0PVtm7kec8VRORc4L7Twb3S8kUt31SzKSRNaE0Yp0zMFG6cmPTEggSqBDUIToEip
         mGyhBaPQG8jGWWUeNb4temP9cJTFqKR+htGUx1Nll4AH9cWfmxz1GMHdVsCcV3oLQG
         k252L5mN2E4uVF/DcD18pvyqsYhOkD4bC0CPtARd1oXxdA5aty+nyysCswgYlKbFFg
         0Cd0rP/xqLQCA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D8DB060A4D;
        Fri,  9 Jul 2021 18:30:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tcp: call sk_wmem_schedule before sk_mem_charge in
 zerocopy path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162585540488.20680.16145619348723064737.git-patchwork-notify@kernel.org>
Date:   Fri, 09 Jul 2021 18:30:04 +0000
References: <20210709154306.2276391-1-mailtalalahmad@gmail.com>
In-Reply-To: <20210709154306.2276391-1-mailtalalahmad@gmail.com>
To:     Talal Ahmad <mailtalalahmad@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, talalahmad@google.com,
        willemb@google.com, weiwan@google.com, soheil@google.com,
        edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri,  9 Jul 2021 11:43:06 -0400 you wrote:
> From: Talal Ahmad <talalahmad@google.com>
> 
> sk_wmem_schedule makes sure that sk_forward_alloc has enough
> bytes for charging that is going to be done by sk_mem_charge.
> 
> In the transmit zerocopy path, there is sk_mem_charge but there was
> no call to sk_wmem_schedule. This change adds that call.
> 
> [...]

Here is the summary with links:
  - [net] tcp: call sk_wmem_schedule before sk_mem_charge in zerocopy path
    https://git.kernel.org/netdev/net/c/358ed6242070

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


