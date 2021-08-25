Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32FBE3F7352
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 12:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240050AbhHYKbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 06:31:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:41390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239722AbhHYKaz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 06:30:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BEEC6613D2;
        Wed, 25 Aug 2021 10:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629887409;
        bh=P9LeGNpYtRMypCeBAIJrGYzOky/Fu1rdyq86nuvBXNg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BVuIemoR/H7BQilv9N1Y1/srlRWi+L6T7cSYcJSP+PlD3nRYLZLopMvAy1ycXJawJ
         WMzs8luNK0crUX/v2DeT4yg9Rk2s+E8o7Y0lfak053fIVM84vN6A9okYgMw63b20sG
         HYSjXU94kGc7/PZ+LbK8XlRng3AgRD3qs6/J356XjIu1hCB7caOw9Z6PBOQuXTb3fZ
         sSaI01nzlMPNyfgbURcR9GCLpXUeE7rpWiwW+nhceZrKVD9TAEzOptSz18zlfWLXgH
         M7uRvZrR/lIOSD78BBe83mn0niYjmARfzFvvfGrl3ag0msNKnbJx6DphSB/67tqSi9
         rSX6C2O8Wlf2w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B2C2060A12;
        Wed, 25 Aug 2021 10:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: can-next 2021-08-25
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162988740972.13655.13745617074443045095.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Aug 2021 10:30:09 +0000
References: <20210825093516.448231-1-mkl@pengutronix.de>
In-Reply-To: <20210825093516.448231-1-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (refs/heads/master):

On Wed, 25 Aug 2021 11:35:12 +0200 you wrote:
> Hello Jakub, hello David,
> 
> this is a pull request of 4 patches for net-next/master.
> 
> The first patch is by Cai Huoqing, and enables COMPILE_TEST for the
> rcar CAN drivers.
> 
> [...]

Here is the summary with links:
  - pull-request: can-next 2021-08-25
    https://git.kernel.org/netdev/net-next/c/45bc6125d142
  - [net-next,2/4] can: rcar_canfd: rcar_canfd_handle_channel_tx(): fix redundant assignment
    https://git.kernel.org/netdev/net-next/c/1d38ec497414
  - [net-next,3/4] can: mscan: mpc5xxx_can: mpc5xxx_can_probe(): use of_device_get_match_data to simplify code
    https://git.kernel.org/netdev/net-next/c/a4583c1deb1b
  - [net-next,4/4] can: mscan: mpc5xxx_can: mpc5xxx_can_probe(): remove useless BUG_ON()
    https://git.kernel.org/netdev/net-next/c/cbe8cd7d83e2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


