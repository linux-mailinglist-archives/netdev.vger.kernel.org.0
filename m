Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF683052AF
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 07:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233921AbhA0GAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 01:00:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:50324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235252AbhA0DQT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 22:16:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 852F964D8D;
        Wed, 27 Jan 2021 02:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611712810;
        bh=uVUL5LV5zjFJ1Dx/Hj/BFAK8Nkjx6pIgcWyh17ZuVZQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FpREeiPtPrfzgs7a0jmNE0UNFt2oBoXhqz5FKFlfK68AyV4ilXi17AC0AN1LxW8oK
         Q4K3cn+4MsH6b5FWGurvvmNkGc/0w9t8EZH2r2uZP8EaXQO2NYVXViDimL4K/BeZQr
         D7RoPK9zVsgCJWUjxu5tHBQxetAq/SKOdR6LPxpLNnYih2TUYeH8gvb+wFwDhgrQ1B
         33j19jZOQh7qi07D2380RvzbArWG0Dn4eGqHZPjXOvX/0jDytdlLnBQPARsS17nq5o
         URovd+XcehAAoKogXNWtH8aggStpEvZPd3b2KW3Ut9cYzXlPiNWVH9Pc3c28dw0y4d
         VyELIctEfBpMw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 80C0B61FC5;
        Wed, 27 Jan 2021 02:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] selftests: add IPv4 unicast extensions tests
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161171281052.17694.6668289120391184114.git-patchwork-notify@kernel.org>
Date:   Wed, 27 Jan 2021 02:00:10 +0000
References: <20210126040834.GR24989@frotz.zork.net>
In-Reply-To: <20210126040834.GR24989@frotz.zork.net>
To:     Seth David Schoen <schoen@loyalty.org>
Cc:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        dsahern@kernel.org, gnu@toad.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 25 Jan 2021 20:08:34 -0800 you wrote:
> Add selftests for kernel behavior with regard to various classes of
> unallocated/reserved IPv4 addresses, checking whether or not these
> addresses can be assigned as unicast addresses on links and used in
> routing.
> 
> Expect the current kernel behavior at the time of this patch. That is:
> 
> [...]

Here is the summary with links:
  - [net-next,v3] selftests: add IPv4 unicast extensions tests
    https://git.kernel.org/netdev/net-next/c/9b0b7837b9f1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


