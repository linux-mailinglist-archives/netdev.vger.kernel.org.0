Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C517B39AE2C
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 00:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbhFCWly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 18:41:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:46964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229704AbhFCWlv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 18:41:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1FE6061401;
        Thu,  3 Jun 2021 22:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622760006;
        bh=eq5oVITcnOyriOj/YeyTGVhxV8NBkbowh22WDOn/I6M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Sy9numyBtjsTThqZ+CsJyxn7ke+kZC6sZCmKcCvSDlCBvJIcxKIRFi0qPR3bnlhyM
         aUZ0AYzMvFvPQQ444+lKWTElHNgsbK/j6RFpeT2p+9I39A/OL9hogOVqTLQXVaiXbS
         jAs4gy0qvZGHaWOxgfzEZmmwE0P5zKfG45Pi6rf5HmKk2IXTfHzdmwwl6o/3EHXkaP
         P+pO5lbEXHyGHmMDciKX7YerFw367QC9Hb/ahdygQLWIQenf6dGF13aaWH6MpvWCbW
         9LexBDaHKZpUy5VfterandyWB4znZTjmczB9mQ9QArEcGCyhLKpOU8wNw+8iWHnVT9
         f3+HwsNq8pI3Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0DCC460BFB;
        Thu,  3 Jun 2021 22:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethernet: rmnet: Restructure if checks to avoid
 uninitialized warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162276000605.13062.14467575723320615318.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Jun 2021 22:40:06 +0000
References: <20210603173410.310362-1-nathan@kernel.org>
In-Reply-To: <20210603173410.310362-1-nathan@kernel.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, ndesaulniers@google.com,
        sharathv@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu,  3 Jun 2021 10:34:10 -0700 you wrote:
> Clang warns that proto in rmnet_map_v5_checksum_uplink_packet() might be
> used uninitialized:
> 
> drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c:283:14: warning:
> variable 'proto' is used uninitialized whenever 'if' condition is false
> [-Wsometimes-uninitialized]
>                 } else if (skb->protocol == htons(ETH_P_IPV6)) {
>                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c:295:36: note:
> uninitialized use occurs here
>                 check = rmnet_map_get_csum_field(proto, trans);
>                                                  ^~~~~
> drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c:283:10: note:
> remove the 'if' if its condition is always true
>                 } else if (skb->protocol == htons(ETH_P_IPV6)) {
>                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c:270:11: note:
> initialize the variable 'proto' to silence this warning
>                 u8 proto;
>                         ^
>                          = '\0'
> 1 warning generated.
> 
> [...]

Here is the summary with links:
  - [net-next] net: ethernet: rmnet: Restructure if checks to avoid uninitialized warning
    https://git.kernel.org/netdev/net-next/c/118de6106735

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


