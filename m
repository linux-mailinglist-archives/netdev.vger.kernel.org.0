Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0992B2CADEF
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 22:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730088AbgLAVAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 16:00:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:41308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729779AbgLAVAr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 16:00:47 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606856406;
        bh=OwYHPEelFrLZM4OpnbVKbBbEMe819vJTm/MzzFUOZSs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=P/obPXY20es4Q0SGy63W8UIRAKjJ26zuy2+Sq4EA59hlRKZ0+Zg/1HFtUH56SVqeP
         JayppYFM5r2Qahd8W1qwdRIGvUg8hyww3hOibmXt4XhSbSMGo0VWBPdKfbvTehMRcL
         /3Frvoot4uOavZeCsjVWVqtHdU82zLX14vyYBzk4=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/ipv6: propagate user pointer annotation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160685640652.20133.12792277369637209995.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Dec 2020 21:00:06 +0000
References: <20201127093421.21673-1-lukas.bulwahn@gmail.com>
In-Reply-To: <20201127093421.21673-1-lukas.bulwahn@gmail.com>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     hch@lst.de, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, kuba@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 27 Nov 2020 10:34:21 +0100 you wrote:
> For IPV6_2292PKTOPTIONS, do_ipv6_getsockopt() stores the user pointer
> optval in the msg_control field of the msghdr.
> 
> Hence, sparse rightfully warns at ./net/ipv6/ipv6_sockglue.c:1151:33:
> 
>   warning: incorrect type in assignment (different address spaces)
>       expected void *msg_control
>       got char [noderef] __user *optval
> 
> [...]

Here is the summary with links:
  - net/ipv6: propagate user pointer annotation
    https://git.kernel.org/netdev/net-next/c/9e39394faef6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


