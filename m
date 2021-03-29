Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E41B434DC8E
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 01:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbhC2Xk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 19:40:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:42008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230214AbhC2XkM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 19:40:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 04B7C619AD;
        Mon, 29 Mar 2021 23:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617061212;
        bh=ZGi2tfGqjHOYhdPcozH6oWF6fXMSWG9ULd9l4eTjJSE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Wvf+dOOiIpFHcSbB3g3BFKqZJbm0On/m8MoZoJnuVifniXgjEhafmVlieHF8EgIQI
         y1LWqEa2yfA4k9g9W96HYcSowFlmLOOma1GGLvTRWIBDjDsEX+H14nJR5eTCQB4miU
         N9ywitf1BqWOhmz52kwWOcEIsel76zc1vCqXHyzvu6WOkYMddQHCol+Zu80KnZRdgD
         E3tfMsXkluYEpwQA0IfuAp+T3wUL+vmJQAhGHWgpNBTsas596n6G7TwgG7mUIzBiot
         derLbdqKkjd6Xz583+IsNL44RD1DzGZl4YfMUia05ICN9IZNUsnPqxNLKxbW0qiHq0
         bZ9YRtvmM+h1A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id ECDB660A49;
        Mon, 29 Mar 2021 23:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 1/2] net: mhi: Add support for non-linear MBIM skb
 processing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161706121196.22281.5044329628449310449.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 23:40:11 +0000
References: <1617032372-2387-1-git-send-email-loic.poulain@linaro.org>
In-Reply-To: <1617032372-2387-1-git-send-email-loic.poulain@linaro.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 29 Mar 2021 17:39:31 +0200 you wrote:
> Currently, if skb is non-linear, due to MHI skb chaining, it is
> linearized in MBIM RX handler prior MBIM decoding, causing extra
> allocation and copy that can be as large as the maximum MBIM frame
> size (32K).
> 
> This change introduces MBIM decoding for non-linear skb, allowing to
> process 'large' non-linear MBIM packets without skb linearization.
> The IP packets are simply extracted from the MBIM frame using the
> skb_copy_bits helper.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/2] net: mhi: Add support for non-linear MBIM skb processing
    https://git.kernel.org/netdev/net-next/c/d9f0713c9217
  - [net-next,v3,2/2] net: mhi: Allow decoupled MTU/MRU
    https://git.kernel.org/netdev/net-next/c/3af562a37b7f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


