Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9AAB45D37C
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 04:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345516AbhKYDPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 22:15:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:36320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344223AbhKYDNV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 22:13:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 6D8966112E;
        Thu, 25 Nov 2021 03:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637809810;
        bh=peu8aJnRL2sGpHhF0UpXPJwqzvF7iMplglIZ/LvPOxA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=K3WcZCyLodSreXQjVEpNckMpEX8C/lVTnObuTxOsKOlaDpT2vfXoQJhmFhthsqJUU
         3FdHGHNH1t8ghHT4W6ejG6B1OkP5tUHrt7dmwmVMExqo8mBO3TwX8ke4fK+5ExKmPH
         aV6fklQ2BLtgX09t+efVrDrDn+4IST3Ob4niHny2m98A2hIZv4ljxBS5vWzcoDzVOD
         DstlU0mEDYBGitQ3Rm24Q7dY6t2msN2BG1F28ceau+CLqUXSlngGwY1FZnNOYfOADg
         vfckEPJiYDNmhCRZcC808zqDRWaB6muIE/FptDvGQzO8o8EjhY89rui/CkF+rKI/8t
         Ov2Lju4VM+qpw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 66D0760A12;
        Thu, 25 Nov 2021 03:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: allow SO_MARK with CAP_NET_RAW
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163780981041.14115.13937606045249833452.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Nov 2021 03:10:10 +0000
References: <20211123203715.193413-1-zenczykowski@gmail.com>
In-Reply-To: <20211123203715.193413-1-zenczykowski@gmail.com>
To:     =?utf-8?q?Maciej_=C5=BBenczykowski_=3Czenczykowski=40gmail=2Ecom=3E?=@ci.codeaurora.org
Cc:     maze@google.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 23 Nov 2021 12:37:15 -0800 you wrote:
> From: Maciej Żenczykowski <maze@google.com>
> 
> A CAP_NET_RAW capable process can already spoof (on transmit) anything
> it desires via raw packet sockets...  There is no good reason to not
> allow it to also be able to play routing tricks on packets from its
> own normal sockets.
> 
> [...]

Here is the summary with links:
  - net: allow SO_MARK with CAP_NET_RAW
    https://git.kernel.org/netdev/net-next/c/079925cce1d0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


