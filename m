Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C705F3D5881
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 13:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233477AbhGZKtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 06:49:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:44218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233285AbhGZKti (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 06:49:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E57F660F4F;
        Mon, 26 Jul 2021 11:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627299006;
        bh=scI/lrQg6vZIdbtUexTUEvSfegVzPAnwK5gG8KgnkXM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FH2UzXP9QXVfQrlyZ4hmEksWSX1PI4rkkXlZsNUC7WJGRqbSRbM3nrZdQK2KJKNrH
         xDTB6i5aauWQqCs+sZ3p2hutVNhbEFdoMAneOVKbNOYFS09YgEHaJYPcY6mc01scp/
         cjuNfHt6LwGJgxZbr42tWgU9PcoHju92khB4sm1cl77D7LeAZmIgZgRKbcW/glFQqR
         q+O/nC8en+KVWO7tFTbefNcV9fK9qJCvNdFHAK/CCaeQbOkPAjcxShM91pZQJkS8kh
         sAF86O++k+mzdTRTPw1198Q3h7Fr5L0YDQkyQzk5H+Vcb1lPTmgI+wZwenfTDqMc04
         09RJax8YppN4g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DBE9260A6C;
        Mon, 26 Jul 2021 11:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: mhi: Improve MBIM packet counting
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162729900689.28679.16618024913038272626.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Jul 2021 11:30:06 +0000
References: <20210726053003.29857-1-richard.laing@alliedtelesis.co.nz>
In-Reply-To: <20210726053003.29857-1-richard.laing@alliedtelesis.co.nz>
To:     Richard Laing <richard.laing@alliedtelesis.co.nz>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        loic.poulain@linaro.org, ryazanov.s.a@gmail.com,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 26 Jul 2021 17:30:03 +1200 you wrote:
> Packets are aggregated over the MBIM link and currently the MHI net
> device will count each aggregated packet rather then the actual
> packets themselves.
> 
> If a protocol handler module is specified, use that to count the
> packets rather than directly in the MHI net device. This is in line
> with the behaviour of the USB net cdc_mbim driver.
> 
> [...]

Here is the summary with links:
  - net: mhi: Improve MBIM packet counting
    https://git.kernel.org/netdev/net-next/c/e129f6b5aeb3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


