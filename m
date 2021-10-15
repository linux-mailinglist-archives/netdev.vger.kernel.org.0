Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7C5442E693
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 04:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235072AbhJOCcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 22:32:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235025AbhJOCcO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 22:32:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7D88061208;
        Fri, 15 Oct 2021 02:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634265008;
        bh=p+QPzmS5dZu17z8yn3SznLJd2MDihycY2A0EcWAH7m4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rPZT4CIwsW8+q5jB4q81URA1VlNcb3QdTaahlRYJ8Cv8//QYZ9/GtmvKt27Jd1I3i
         J4jVhRjxyxYxijQa/WSKJtdcEAf39qH/EInd7B17Qe2XuLZ+9riVQPbMawdkzVoe0e
         QjhynGgLmV0erILlsulPRYkJespnn8EltriPidRVLZrAiBKW8SEgSrk651IdymHy9H
         4uizhyt4OhQPl73PX/pQed+qe/dedL+RHNzdA79ctA1lrfZA/ySS0A+VvEmKqikF+n
         WAcbINgQNMzod99hraVAZ083mcItCGAUOgsWQN4UM5O68zd7snfj2KsIzSGZOssl9A
         Bc5Gz2a3dv/gQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7794C60A39;
        Fri, 15 Oct 2021 02:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: fealnx: fix build for UML
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163426500848.31820.18368368881396978501.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Oct 2021 02:30:08 +0000
References: <20211014050500.5620-1-rdunlap@infradead.org>
In-Reply-To: <20211014050500.5620-1-rdunlap@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, linux-um@lists.infradead.org,
        jdike@addtoit.com, richard@nod.at, anton.ivanov@cambridgegreys.com,
        davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 13 Oct 2021 22:05:00 -0700 you wrote:
> On i386, when builtin (not a loadable module), the fealnx driver
> inspects boot_cpu_data to see what CPU family it is running on, and
> then acts on that data. The "family" struct member (x86) does not exist
> when running on UML, so prevent that test and do the default action.
> 
> Prevents this build error on UML + i386:
> 
> [...]

Here is the summary with links:
  - [net-next] net: fealnx: fix build for UML
    https://git.kernel.org/netdev/net-next/c/cd2621d07d51

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


