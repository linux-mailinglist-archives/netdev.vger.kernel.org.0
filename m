Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED76306B6B
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 04:12:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbhA1DK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 22:10:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:50120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231124AbhA1DKx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 22:10:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 3B54564DD7;
        Thu, 28 Jan 2021 03:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611803413;
        bh=8EL1M/Nma2E4dQUUH60sv/NfkeGh0m9679p+OUzs3EY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ha1qZi0KeXOkt3m2EW4c94bTuupTByoDy6I/Yg9nezgAxjSG++k0O+7Fpq1fNjNkJ
         8BGecltcLJXFZILeTFRvGv0AdP9T5Vr6DslCqbtwJCySvmBgGQddXpcj+uUXpbXUT8
         +TMGvoSpwMTse8EsyDPS7KdA95TjXoHf6u9b7rnZsxK2b2xJZckNSFqw/xlkw/7O51
         ajE/mJrt5LoZJ/XTwNgZSAlBEN2puFvK1+zZsGhnIut4LF5JKNqMymkZ4AGAoUUO6t
         Lwim7GDagHPyncF4PBHeW4+HS2PCLdIZ4YG9tdAIXlNb3ZxUHRu3uMBt6OFaBTajRF
         PGqXvGWvaZEVQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2E8636531E;
        Thu, 28 Jan 2021 03:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: can-next 2021-01-27
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161180341318.2345.1124105230249277561.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Jan 2021 03:10:13 +0000
References: <20210127092227.2775573-1-mkl@pengutronix.de>
In-Reply-To: <20210127092227.2775573-1-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (refs/heads/master):

On Wed, 27 Jan 2021 10:22:15 +0100 you wrote:
> Hello Jakub, hello David,
> 
> this is a pull request of 12 patches for net-next/master.
> 
> The first two patches are by me and fix typos on the CAN gw protocol and the
> flexcan driver.
> 
> [...]

Here is the summary with links:
  - pull-request: can-next 2021-01-27
    https://git.kernel.org/netdev/net-next/c/df9d80470a0c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


