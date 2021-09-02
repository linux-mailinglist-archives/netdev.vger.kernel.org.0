Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8753FEC6C
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 12:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343646AbhIBKwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 06:52:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:36240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245510AbhIBKvD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 06:51:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7D541610CE;
        Thu,  2 Sep 2021 10:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630579805;
        bh=6ZC72MkkUiRA7idv+wrbolVrOjl4rY32njlxwN5wTgE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=H4fl9VoFhPtlEd54b2qRnF4WV1/VyfDP2OFtnue/pdIHBZpX3wbTGeIkl4YugLXTD
         Ny2tCoFEKOesZoFEgfBpsoeq93/df8ec1EUntWw4Vpx97O4bPSSioHhEiPrKPptVNp
         JuxD6NuTjm7VQtSSUhoNuY51Aa6e49D7WZB7EfgMhdqfatYaqw500Augnowq/HJ9lQ
         a92obewjMtyGTlyw8Q4vEFbuiT6DoTMMuqBdO2yELRwQPXwRysqbFXCaDimxf0Bvg4
         5gGRFUrtHkBKBb0A/bmSEDGAD1v1+lRaOQvIq8fi8g4Klz+Re9JnsHoEt2lRBUhe7S
         qFPwAbbBSHQvQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6D58960982;
        Thu,  2 Sep 2021 10:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Set fc_nlinfo in nh_create_ipv4, nh_create_ipv6
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163057980544.19226.5142981830562504937.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Sep 2021 10:50:05 +0000
References: <20210902052014.605249-1-contact@proelbtn.com>
In-Reply-To: <20210902052014.605249-1-contact@proelbtn.com>
To:     Ryoga Saito <contact@proelbtn.com>
Cc:     dsahern@kernel.org, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  2 Sep 2021 05:20:14 +0000 you wrote:
> This patch fixes kernel NULL pointer dereference when creating nexthop
> which is bound with SRv6 decapsulation. In the creation of nexthop,
> __seg6_end_dt_vrf_build is called. __seg6_end_dt_vrf_build expects
> fc_lninfo in fib6_config is set correctly, but it isn't set in
> nh_create_ipv6, which causes kernel crash.
> 
> Here is steps to reproduce kernel crash:
> 
> [...]

Here is the summary with links:
  - Set fc_nlinfo in nh_create_ipv4, nh_create_ipv6
    https://git.kernel.org/netdev/net/c/9aca491e0dcc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


