Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD23D441BDC
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 14:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232323AbhKANmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 09:42:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232332AbhKANml (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 09:42:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B8BF461077;
        Mon,  1 Nov 2021 13:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635774008;
        bh=dlxsBhobP7hneCUBbBAViyFggnW5CRdW1xPo4D92l+4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FsSt+Z/WtWWOJTxp8FdbNOxfoYk55vU1ENX57Ohv7EJynrCa9GYO2bY4NGWLPEuYn
         xXs95TF0OQcT7/3VprWOBpxBKj6TU/BHUQV89JjL7dVjkLn5oKXXAu5Bz/pgM8gr28
         zbli1KUA46mr+shqezCZ7imIhmNHiblR0ZfcgwNmieDaI1B0yRsYQqj3NrH9aRtd5h
         A43s44XPrFZdH45wWVp/lX1AaOx9fvoI7aEjtNzqK2gijQfPYWn+ok0WNu3GSWEEt0
         SKYCIEv3bRlIpMCCND7icvHTIXDdejxLe2+8I2jSIfOu2u79EUi6ajG6D2RQRFrae2
         FWXZE0nczVdZg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A1F58609B9;
        Mon,  1 Nov 2021 13:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v7 0/5] amt: add initial driver for Automatic
 Multicast Tunneling (AMT)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163577400865.7648.9177803656219391227.git-patchwork-notify@kernel.org>
Date:   Mon, 01 Nov 2021 13:40:08 +0000
References: <20211031160006.3367-1-ap420073@gmail.com>
In-Reply-To: <20211031160006.3367-1-ap420073@gmail.com>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        netdev@vger.kernel.org, dkirjanov@suse.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 31 Oct 2021 16:00:01 +0000 you wrote:
> This is an implementation of AMT(Automatic Multicast Tunneling), RFC 7450.
> https://datatracker.ietf.org/doc/html/rfc7450
> 
> This implementation supports IGMPv2, IGMPv3, MLDv1, MLDv2, and IPv4
> underlay.
> 
>  Summary of RFC 7450
> The purpose of this protocol is to provide multicast tunneling.
> The main use-case of this protocol is to provide delivery multicast
> traffic from a multicast-enabled network to sites that lack multicast
> connectivity to the source network.
> There are two roles in AMT protocol, Gateway, and Relay.
> The main purpose of Gateway mode is to forward multicast listening
> information(IGMP, MLD) to the source.
> The main purpose of Relay mode is to forward multicast data to listeners.
> These multicast traffics(IGMP, MLD, multicast data packets) are tunneled.
> 
> [...]

Here is the summary with links:
  - [net-next,v7,1/5] amt: add control plane of amt interface
    https://git.kernel.org/netdev/net-next/c/b9022b53adad
  - [net-next,v7,2/5] amt: add data plane of amt interface
    https://git.kernel.org/netdev/net-next/c/cbc21dc1cfe9
  - [net-next,v7,3/5] amt: add multicast(IGMP) report message handler
    https://git.kernel.org/netdev/net-next/c/bc54e49c140b
  - [net-next,v7,4/5] amt: add mld report message handler
    https://git.kernel.org/netdev/net-next/c/b75f7095d4d4
  - [net-next,v7,5/5] selftests: add amt interface selftest script
    https://git.kernel.org/netdev/net-next/c/c08e8baea78e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


