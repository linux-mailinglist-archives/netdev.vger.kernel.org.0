Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 287E636AA6D
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 03:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231668AbhDZBkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 21:40:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:37794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231550AbhDZBkv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Apr 2021 21:40:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AAF3B611ED;
        Mon, 26 Apr 2021 01:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619401210;
        bh=3OlOuFiRkvr+T/H+9LWs4X92HLyYnu2aOQY4rm95o6s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=secRZg0CkwX6FQd9yprYRgej6pQzVpdvmt9uedOKt5ZKvWwdbNhrh0+0YilrGEGPo
         FhnIJdEl5fCblkyo84o6hM7sWnyUeR4AhNjxUOyuiV8Cxklh4QpfTsPhdyxtAQmOrZ
         yL/zj4dq5OmcwDlqvHiqATIvES0r5PM7GqoWBA/ilpmHsNu2Wy2BGqfJ7hnCv0SFhs
         L5IFC2HL61W/JtmX28QIReqhW6YDEp6LXmyxuEvrfp7R9AfWEyrgRtuQGkzVOYT3sY
         N93DhdZBFbSqd0YGGCVWHwZX24pqXcqU8Wnqi2dNg3V4yAmKEMow6QXE8J+qJQDZpo
         q4jTerubXeqwA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9F8A46094F;
        Mon, 26 Apr 2021 01:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] macvlan: Add nodst option to macvlan type source
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161940121064.11520.1501104560907483893.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Apr 2021 01:40:10 +0000
References: <2afc4d46-aa9b-a7db-d872-d02163b1f29c@jbeekman.nl>
In-Reply-To: <2afc4d46-aa9b-a7db-d872-d02163b1f29c@jbeekman.nl>
To:     Jethro Beekman <kernel@jbeekman.nl>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 25 Apr 2021 11:22:03 +0200 you wrote:
> The default behavior for source MACVLAN is to duplicate packets to
> appropriate type source devices, and then do the normal destination MACVLAN
> flow. This patch adds an option to skip destination MACVLAN processing if
> any matching source MACVLAN device has the option set.
> 
> This allows setting up a "catch all" device for source MACVLAN: create one
> or more devices with type source nodst, and one device with e.g. type vepa,
> and incoming traffic will be received on exactly one device.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] macvlan: Add nodst option to macvlan type source
    https://git.kernel.org/netdev/net-next/c/427f0c8c194b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


