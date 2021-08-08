Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C94CF3E3A25
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 14:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbhHHMK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 08:10:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:50052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229504AbhHHMKZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Aug 2021 08:10:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4343460EE4;
        Sun,  8 Aug 2021 12:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628424606;
        bh=5VcRUR0j4xWYYFvu0wIfCCjWT/gfLI8XiSyTbkBzUWg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hDhNBiLnF/YkwDx7q6qzmgqxV5BBSTfHziERG+KbW9PTfchBkevDTCFhYYdeBtEfm
         g5GuJ0hbwRDM/aIr3m6XkpTwQ9FkyfQnNJf5i00fNbG2f+KAD6++EOelOBegH7rLam
         mqoXzfXdj9/EEV8xsFs7UQW/jjS/C2rJAG3yqIcbVyTb0uEn3zc/ODMbxsIdas4mxG
         6ruoy4h4x2TxoxNxa7kQnqpY9PmmPyWJAyQwCFT5HstLtOjzuoLV3V7fHBxxUfZOii
         VOtCAzX4D4QpPm/a7k8KGkBe7wCc7vaZ3xMz6c7IPxAVKrv8ucjOaL+/izkPPvIdsR
         BeAJvrbMWHXEQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 31429609B3;
        Sun,  8 Aug 2021 12:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ppp: Fix generating ifname when empty IFLA_IFNAME is
 specified
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162842460619.22263.12540809953818710205.git-patchwork-notify@kernel.org>
Date:   Sun, 08 Aug 2021 12:10:06 +0000
References: <20210807132703.26303-1-pali@kernel.org>
In-Reply-To: <20210807132703.26303-1-pali@kernel.org>
To:     =?utf-8?b?UGFsaSBSb2jDoXIgPHBhbGlAa2VybmVsLm9yZz4=?=@ci.codeaurora.org
Cc:     paulus@samba.org, davem@davemloft.net, kuba@kernel.org,
        g.nault@alphalink.fr, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat,  7 Aug 2021 15:27:03 +0200 you wrote:
> IFLA_IFNAME is nul-term string which means that IFLA_IFNAME buffer can be
> larger than length of string which contains.
> 
> Function __rtnl_newlink() generates new own ifname if either IFLA_IFNAME
> was not specified at all or userspace passed empty nul-term string.
> 
> It is expected that if userspace does not specify ifname for new ppp netdev
> then kernel generates one in format "ppp<id>" where id matches to the ppp
> unit id which can be later obtained by PPPIOCGUNIT ioctl.
> 
> [...]

Here is the summary with links:
  - ppp: Fix generating ifname when empty IFLA_IFNAME is specified
    https://git.kernel.org/netdev/net/c/2459dcb96bcb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


