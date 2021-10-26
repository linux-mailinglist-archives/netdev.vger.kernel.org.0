Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1842A43B203
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 14:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235703AbhJZMMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 08:12:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:38418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234648AbhJZMMa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 08:12:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2264A61163;
        Tue, 26 Oct 2021 12:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635250207;
        bh=LNwyzFXC6KOwxi6Szct7cZjnBOcrhTl7SNDYH9/Sg4k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ddyD/MvHaoTj0gJj442Q8KXony5MnMyauxncFO1JGoTsKXM9PJX5vnlotKE8YUk2U
         eU1emTV2kiuajbE7P5+NT/qnq2ygu69LXTQN5QEmh9Ly7XW+Eu/alsYlnrn134GGMg
         ChDtmcp4r1C0i845L69qRTFgXlFXAR2WstRpYr7cLGcABtOPKYkyqELTbYvVdZdn5C
         UjIZ/VaMaSlKa7TMJWtOFyTJZL1/OmIsyIYW2EN1IdIYIbCGHw52uhhYd3FfFAPYMa
         L2dsz42DyhTf1Kuhh1n0W/2eMoAlqgLY18fDTAPCvtXEHHho7PBZpWstg0li4HZzJy
         AiJj03XKT5H4g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1539C6096F;
        Tue, 26 Oct 2021 12:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: multicast: calculate csum of looped-back and
 forwarded packets
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163525020708.21520.9618157400402322785.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Oct 2021 12:10:07 +0000
References: <20211024201423.1367844-1-cyril.strejc@skoda.cz>
In-Reply-To: <20211024201423.1367844-1-cyril.strejc@skoda.cz>
To:     Cyril Strejc <cyril.strejc@skoda.cz>
Cc:     davem@davemloft.net, kuba@kernel.org,
        willemdebruijn.kernel@gmail.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 24 Oct 2021 22:14:25 +0200 you wrote:
> During a testing of an user-space application which transmits UDP
> multicast datagrams and utilizes multicast routing to send the UDP
> datagrams out of defined network interfaces, I've found a multicast
> router does not fill-in UDP checksum into locally produced, looped-back
> and forwarded UDP datagrams, if an original output NIC the datagrams
> are sent to has UDP TX checksum offload enabled.
> 
> [...]

Here is the summary with links:
  - [v2] net: multicast: calculate csum of looped-back and forwarded packets
    https://git.kernel.org/netdev/net/c/9122a70a6333

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


