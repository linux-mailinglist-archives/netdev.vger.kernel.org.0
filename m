Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACB736BA69
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 22:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241726AbhDZUA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 16:00:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:47406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241643AbhDZUAz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Apr 2021 16:00:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3F08761359;
        Mon, 26 Apr 2021 20:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619467210;
        bh=TSP9laMO4J+RyNDorr3aO5dlTm3tpcLkmZhZFedDnnc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LGdYLZrHot33o7+u42dI7PJYWLMwidaL1Vedk4aFQAoIBd/gTOgH4FDP57mzfl+ku
         tzY/jOu7TaIdND59qitwGamvCvM4y6jXh8zfkhS1el+RUlyEmPQny/ITMw1hJs60It
         Ucfusx4/ecFeruN0ZQbv+Ehx6snjnIJNt/CnP6+x3BUBLBFFZXLm4VuMUnj4Nydwi3
         T8TtQWbqS32znhpgHC/a+K5A8bKVvjccujatDwg1h+1HxsEBA6P4sqKr30orE4dVv8
         uVEG00bXOiTdZoCdJpeAkX6H4fl9xfBmCUJKd4AtPNsQMw8ruH1ojdEBVNkBoYOeR3
         is/mztaC9P+4A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 33868609B0;
        Mon, 26 Apr 2021 20:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: can-next 2021-04-26
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161946721020.23958.12763756415417873021.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Apr 2021 20:00:10 +0000
References: <20210426065452.3411360-1-mkl@pengutronix.de>
In-Reply-To: <20210426065452.3411360-1-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (refs/heads/master):

On Mon, 26 Apr 2021 08:54:48 +0200 you wrote:
> Hello Jakub, hello David,
> 
> this is a pull request of 4 patches for net-next/master.
> 
> the first two patches are from Colin Ian King and target the
> etas_es58x driver, they add a missing NULL pointer check and fix some
> typos.
> 
> [...]

Here is the summary with links:
  - pull-request: can-next 2021-04-26
    https://git.kernel.org/netdev/net-next/c/d0c5d18da2da
  - [net-next,2/4] can: etas_es58x: Fix a couple of spelling mistakes
    https://git.kernel.org/netdev/net-next/c/1c9690dd308e
  - [net-next,3/4] can: add a note that RECV_OWN_MSGS frames are subject to filtering
    https://git.kernel.org/netdev/net-next/c/924e464f4a8a
  - [net-next,4/4] can: proc: fix rcvlist_* header alignment on 64-bit system
    https://git.kernel.org/netdev/net-next/c/e6b031d3c37f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


