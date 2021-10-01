Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA31241F760
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 00:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355854AbhJAWVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 18:21:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:50178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230171AbhJAWVw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 18:21:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3E10B61A8E;
        Fri,  1 Oct 2021 22:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633126807;
        bh=YbdgR2br21vkb23aznK4+NOSi64mqjNQxW+FIHL+M0s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iChqU2l2T2CmgW+6cLyOFC59hiRQGPeqSSXxV8mxfkLmm1yo+g6ayo1h7Kev8f3Od
         U9gPIBm43Fvk7nGMS8VOcY8w9S1CDLt3a+IFbQg/sqHS72C+FoN5BZB9iCfKHP48uH
         Fvndx14BWlWhZHGpFlffDbvPbaCdDkXHg3eUdC3Cunx9AIx/RpvUWIMyWOXlqTHIwv
         3FEb1iqzge6PlbjnfBzpXX7fwoBF2YqsSaEwCfpzl1UgjMotlFu6Ife82pGxafyRbz
         tL6POglZogfjvJn8KSZ8zAQDaADXZDrMqk5zzImtjAt1Y1rW0MMYiqH4WKDFmQxXQ2
         SI9wpo1yxSDhw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2FF3660A3C;
        Fri,  1 Oct 2021 22:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] MAINTAINERS: Remove Bin Luo as his email bounces
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163312680719.6540.12150777799410591414.git-patchwork-notify@kernel.org>
Date:   Fri, 01 Oct 2021 22:20:07 +0000
References: <045a32ccf394de66b7899c8b732f44dc5f4a1154.1632978665.git.leonro@nvidia.com>
In-Reply-To: <045a32ccf394de66b7899c8b732f44dc5f4a1154.1632978665.git.leonro@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, leonro@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 30 Sep 2021 08:12:43 +0300 you wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> The emails sent to luobin9@huawei.com bounce with error:
>  "Recipient address rejected: Failed recipient validation check."
> 
> So let's remove his entry and change the status of hinic driver till
> someone in Huawei will step-in to maintain it again.
> 
> [...]

Here is the summary with links:
  - [net] MAINTAINERS: Remove Bin Luo as his email bounces
    https://git.kernel.org/netdev/net/c/5cfe5109a1d7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


