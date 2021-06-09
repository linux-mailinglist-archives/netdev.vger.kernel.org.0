Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 148223A2046
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 00:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbhFIWmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 18:42:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:38228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229753AbhFIWmT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 18:42:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3AADA613E3;
        Wed,  9 Jun 2021 22:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623278424;
        bh=hTx9JKT9TRVILFyA0DIsrmNjuw2uBt/QSCtCrPaHJu0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Rj8/k64gD8L4ombpS7gT+R3g1883qXITPo/6Bor2GRD8G+48NtRfCJOl1oxgcaN8r
         /hUFq6ed2OX0XeX6jzULChBJa5bsxbX6+jG6H/W1ZHtJ8FeQr2a3TX3DlD+Yb38PW8
         5/PaSgoDB39sPzuFqdoCKpmvViVwUYdUgST2EguEWeaFIslmYe/LaE/vbaM1Ih7yMi
         cC7Ja137/RCQsHj4f7lT52EDoyCkPPs5qfN81wqeVVn7OAZ7DHOchEftIJxQt93yeE
         e7qodqCENH5wTV2nCiDWghnu3RBVzenaHxSIyUO5leAyo3cOr1E4SZtpdl5LJGaGtU
         pKQGxShSHJE1w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2E54260A16;
        Wed,  9 Jun 2021 22:40:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/sched: act_ct: handle DNAT tuple collision
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162327842418.25473.9226946977477541254.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Jun 2021 22:40:24 +0000
References: <87588ad6631f7d60691fddb860e075ebebeaa5ec.1623248030.git.marcelo.leitner@gmail.com>
In-Reply-To: <87588ad6631f7d60691fddb860e075ebebeaa5ec.1623248030.git.marcelo.leitner@gmail.com>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     netdev@vger.kernel.org, dcaratti@redhat.com, paulb@nvidia.com,
        yossiku@mellanox.com, ozsh@nvidia.com, cong.wang@bytedance.com,
        jhs@mojatatu.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed,  9 Jun 2021 11:23:56 -0300 you wrote:
> This this the counterpart of 8aa7b526dc0b ("openvswitch: handle DNAT
> tuple collision") for act_ct. From that commit changelog:
> 
> """
> With multiple DNAT rules it's possible that after destination
> translation the resulting tuples collide.
> 
> [...]

Here is the summary with links:
  - [net] net/sched: act_ct: handle DNAT tuple collision
    https://git.kernel.org/netdev/net/c/13c62f5371e3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


