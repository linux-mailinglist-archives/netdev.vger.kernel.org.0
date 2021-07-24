Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD6B3D4940
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 20:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbhGXSJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Jul 2021 14:09:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:41416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229530AbhGXSJd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Jul 2021 14:09:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2D45D60E96;
        Sat, 24 Jul 2021 18:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627152604;
        bh=T4HQLnAW2BGdvPT/AZtq6QX7bTyl8zOwmB1c3j2scSI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=D45xOC6dDygv1F6QpylPqj2mpfpBNkhKtphPZB4B6ICiSYkg2xsI9ilP1AkXQbOlW
         UHbxEerrobnGK16gMTBTw9Uq2WMkY8XDc+yptkepmUz/bF8j3sykB14PSK8wiXwRSH
         83bucAiKT27EK1at8uFpkIHCBgwJFgX5GPd2/1Iwf7OKtxTsQoh564a9JJMZWSn5vD
         OvPcIutS63phz+YHVefLF/4jE6d8EefTODMVoMb2enuAk15NAuOsgAD+2RYcAuE5N9
         7PbKg0qjAeBv3jODrZjO9BP7Tla/mi4OQ5IgvAMWEz0oQQFCOH9XGRzUgAVJn7lqgp
         6pzwmLwB+ItbA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 20FEC60A0A;
        Sat, 24 Jul 2021 18:50:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tipc: do not write skb_shinfo frags when doing decrytion
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162715260413.29151.10322274611945547748.git-patchwork-notify@kernel.org>
Date:   Sat, 24 Jul 2021 18:50:04 +0000
References: <453b10a48c21d1882bbee21fe2c84197faad75e1.1627080361.git.lucien.xin@gmail.com>
In-Reply-To: <453b10a48c21d1882bbee21fe2c84197faad75e1.1627080361.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        tipc-discussion@lists.sourceforge.net, jmaloy@redhat.com,
        tuong.t.lien@dektech.com.au, sd@queasysnail.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 23 Jul 2021 18:46:01 -0400 you wrote:
> One skb's skb_shinfo frags are not writable, and they can be shared with
> other skbs' like by pskb_copy(). To write the frags may cause other skb's
> data crash.
> 
> So before doing en/decryption, skb_cow_data() should always be called for
> a cloned or nonlinear skb if req dst is using the same sg as req src.
> While at it, the likely branch can be removed, as it will be covered
> by skb_cow_data().
> 
> [...]

Here is the summary with links:
  - [net] tipc: do not write skb_shinfo frags when doing decrytion
    https://git.kernel.org/netdev/net/c/3cf4375a0904

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


