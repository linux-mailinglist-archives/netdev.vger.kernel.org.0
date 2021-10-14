Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 094D242CF90
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 02:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbhJNAcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 20:32:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:48522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229590AbhJNAcL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 20:32:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 814BF61154;
        Thu, 14 Oct 2021 00:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634171407;
        bh=iaeOSHxp5/Uueb51lF/gvCSbqpLWfu5M0JjHk+S45S0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cqggUHPyD+kqnVu0oHEO1cxW+MqX4J5dXXmVwWTHCbnXK9X9v2sxyk0dzh3l804xN
         1zB8a4LYZgS9ajy58AgcrrQJPe8jeNPQKXH1KtOymVgVWmlDA02BhN9Lm1vq0Ygi6i
         itEYjKPc6MXmiEpEptMsAKOSBFN8EQXwL5oDl924uirkbLRQYuVmtHU9U6QgzTwdit
         XEFV6zFt6iq5FP/EZ0GUNW3lvW//UPYV+5VPaXP8dyEe9CMpTF7sAIbmEkunwUVSJU
         gepA4k26Rtf6cRKkfGEvjFDQxjXqOOGjnGlGM+Q3MzLCQwkEhkmtf+tRs17xOxiKB7
         MlrZ2/G/Risyg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7171960A39;
        Thu, 14 Oct 2021 00:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] Revert "net: procfs: add seq_puts() statement for
 dev_mcast"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163417140745.5859.6286901829490167450.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Oct 2021 00:30:07 +0000
References: <20211013001909.3164185-1-vladimir.oltean@nxp.com>
In-Reply-To: <20211013001909.3164185-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        yajun.deng@linux.dev, matthieu.baerts@tessares.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 13 Oct 2021 03:19:09 +0300 you wrote:
> This reverts commit ec18e8455484370d633a718c6456ddbf6eceef21.
> 
> It turns out that there are user space programs which got broken by that
> change. One example is the "ifstat" program shipped by Debian:
> https://packages.debian.org/source/bullseye/ifstat
> which, confusingly enough, seems to not have anything in common with the
> much more familiar (at least to me) ifstat program from iproute2:
> https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/tree/misc/ifstat.c
> 
> [...]

Here is the summary with links:
  - [net] Revert "net: procfs: add seq_puts() statement for dev_mcast"
    https://git.kernel.org/netdev/net/c/1f922d9e374f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


