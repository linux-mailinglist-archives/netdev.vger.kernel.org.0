Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1EF8334952
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 22:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbhCJVAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 16:00:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:32830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232006AbhCJVAO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 16:00:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 5C0E364FF3;
        Wed, 10 Mar 2021 21:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615410013;
        bh=qIAWh9SSKA78ewa23j3Jt1gBN4bbmU6BOi9JPBhaqhw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fsIWirspNoC8I5yiVOt3M0YXDlPrvd4EthgFzypQnJyKPFJnHCMFzYyoOist5dLJX
         6gxwlycg+71hnSntUTr3N2xB58Wa/ivgKkvPxdOYgyhFse+aJU1EuJXGCcvFEMqAxt
         6x6qM9HxMCEmJNTRa8m/mV4u1S7wuaEwMelugnTmpmJ8uPH5EykMD59gUagowNkueb
         6K1uQ/6EX6Rr0FclWdQ81eYCnGjOZ60ICH1exkUqUQ2jImss9KUX21q5mrZs56O/w3
         ji0bk/yH52zQBWTuiuJo5MvGGHEcUINo9om6aGr2tuz9FDvPcueEntf3CnshZC+zrm
         fidTO7hNjpm8w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4EC41609B8;
        Wed, 10 Mar 2021 21:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] sched: act_sample: Implement stats_update callback
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161541001331.4631.13725630386371468055.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Mar 2021 21:00:13 +0000
References: <20210310103320.2531933-1-idosch@idosch.org>
In-Reply-To: <20210310103320.2531933-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com, idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 10 Mar 2021 12:33:20 +0200 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Implement this callback in order to get the offloaded stats added to the
> kernel stats.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next] sched: act_sample: Implement stats_update callback
    https://git.kernel.org/netdev/net-next/c/58c04397f74b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


