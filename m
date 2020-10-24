Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3C2297A58
	for <lists+netdev@lfdr.de>; Sat, 24 Oct 2020 04:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1759163AbgJXCUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 22:20:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:46104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756169AbgJXCUE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 22:20:04 -0400
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603506003;
        bh=xZM7Kgv6EdndIARWlLmsDTtx8w141I10OaYgQKcciOo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=u+NKIm/142bTaJojHaXmRCXW6vFmHhg+/7cRgwzPWfyXkLGZqll1uodB8j9L/JZFt
         D6pPLw9+2wI+yt9i7aOR19SrGLgi37W7h87UR+P8lucKq8scS09yTYkrlssxOZgVhk
         Kds+FyFmcD0T8v1jbtv6TycRzW+bkXlu3wrHBB5w=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net v2] tcp: Prevent low rmem stalls with SO_RCVLOWAT.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160350600375.32519.8606091275090159974.git-patchwork-notify@kernel.org>
Date:   Sat, 24 Oct 2020 02:20:03 +0000
References: <20201023184709.217614-1-arjunroy.kdev@gmail.com>
In-Reply-To: <20201023184709.217614-1-arjunroy.kdev@gmail.com>
To:     Arjun Roy <arjunroy.kdev@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, arjunroy@google.com,
        edumazet@google.com, soheil@google.com, ncardwell@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 23 Oct 2020 11:47:09 -0700 you wrote:
> From: Arjun Roy <arjunroy@google.com>
> 
> With SO_RCVLOWAT, under memory pressure,
> it is possible to enter a state where:
> 
> 1. We have not received enough bytes to satisfy SO_RCVLOWAT.
> 2. We have not entered buffer pressure (see tcp_rmem_pressure()).
> 3. But, we do not have enough buffer space to accept more packets.
> 
> [...]

Here is the summary with links:
  - [net,v2] tcp: Prevent low rmem stalls with SO_RCVLOWAT.
    https://git.kernel.org/netdev/net/c/435ccfa894e3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


