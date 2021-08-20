Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E90D3F2C7E
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 14:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240598AbhHTMxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 08:53:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:40594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240260AbhHTMxJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 08:53:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9E083610CC;
        Fri, 20 Aug 2021 12:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629463951;
        bh=PvLygdkRwhGOuqZPClClVkX9QulBbtkOMymA4jk7Tbg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sM/eiOXcKxk39Cl2RoLJzg2I6WznjGAKvRK0HvHXKMDtRvzB/7i4LkF6P+DEqvwiD
         ojQ/62/Rzzs5wRGxodE3e2cKoZ4ByCFf0kRC0aA/I0LBBykkQgFioN0QvHBTru8Y3G
         jgLrFmzWR/87bOy3Ww3la8cAdWvDJJ7fw6dchkeM7h8UwEPKXayoDstlL1WVuZE7MM
         uk+MAVWHhpNtYBl3Eqb9DA7wGJcORz9e3fPiV7Zex/EILTJxfz5jAVs/EMkzyMwJvN
         uQSqoRMlrVVqc3OfBrVN1U95QdKcaJuq1tpyDuxZJTDLD8W0inZJDnAsTsdqIuOnl8
         IAUg0UaemoQEA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9324160A6B;
        Fri, 20 Aug 2021 12:52:31 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/6] batman-adv: Start new development cycle
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162946395159.27725.6381822484284696109.git-patchwork-notify@kernel.org>
Date:   Fri, 20 Aug 2021 12:52:31 +0000
References: <20210820083300.32289-2-sw@simonwunderlich.de>
In-Reply-To: <20210820083300.32289-2-sw@simonwunderlich.de>
To:     Simon Wunderlich <sw@simonwunderlich.de>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 20 Aug 2021 10:32:55 +0200 you wrote:
> This version will contain all the (major or even only minor) changes for
> Linux 5.15.
> 
> The version number isn't a semantic version number with major and minor
> information. It is just encoding the year of the expected publishing as
> Linux -rc1 and the number of published versions this year (starting at 0).
> 
> [...]

Here is the summary with links:
  - [1/6] batman-adv: Start new development cycle
    https://git.kernel.org/netdev/net-next/c/53972e43d4a7
  - [2/6] batman-adv: Move IRC channel to hackint.org
    https://git.kernel.org/netdev/net-next/c/71d41c09f1fa
  - [3/6] batman-adv: Switch to kstrtox.h for kstrtou64
    https://git.kernel.org/netdev/net-next/c/70eeb75d4c4d
  - [4/6] batman-adv: Check ptr for NULL before reducing its refcnt
    https://git.kernel.org/netdev/net-next/c/6340dcbd6194
  - [5/6] batman-adv: Drop NULL check before dropping references
    https://git.kernel.org/netdev/net-next/c/79a0bffb835a
  - [6/6] batman-adv: bcast: remove remaining skb-copy calls
    https://git.kernel.org/netdev/net-next/c/808cfdfad579

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


