Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFCB3E4229
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 11:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234183AbhHIJKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 05:10:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:59054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234227AbhHIJKZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 05:10:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8B4A661078;
        Mon,  9 Aug 2021 09:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628500205;
        bh=h+XEUfaFQsQxuoURSDe7j2eiWVZJtbFulXijWl864cs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tiym9iTmDA7/SE70AfWEiKBWBIvB8MynQkYpWyuz4BwpgV6LA1AKEIT2v32fHyVC+
         JfOP2z5WUv6X/YTMwGxkX99W+99Na2HU6rFY7lvIGun1eY6pwblpDMqySR39n15fXY
         AD1VWUAxv1zopIfgQVbrN0lYn18OwQfK4/ESfzBlZ5XZ5xZXbJu8zmgETrv1yP1wZG
         KVup06dO9oFkYka5dIBdMoB6RL5Vd2PCzTDJoKhcSVCh6QTR2kjcntwlizV456zdhE
         bLacJxl5gJZ+x6fEQ5aQ6Al/AKVQD4MeFZ4nv4Ws212sV9vwMjh694w0czyTi5CMF2
         kKwaFc1m35bEA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7D7EF60A12;
        Mon,  9 Aug 2021 09:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net V2] page_pool: mask the page->signature before the
 checking
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162850020550.22991.7583122589223288921.git-patchwork-notify@kernel.org>
Date:   Mon, 09 Aug 2021 09:10:05 +0000
References: <1628213947-39384-1-git-send-email-linyunsheng@huawei.com>
In-Reply-To: <1628213947-39384-1-git-send-email-linyunsheng@huawei.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
        ilias.apalodimas@linaro.org, mcroce@microsoft.com,
        willy@infradead.org, alexander.duyck@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@openeuler.org, chenhao288@hisilicon.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 6 Aug 2021 09:39:07 +0800 you wrote:
> As mentioned in commit c07aea3ef4d4 ("mm: add a signature in
> struct page"):
> "The page->signature field is aliased to page->lru.next and
> page->compound_head."
> 
> And as the comment in page_is_pfmemalloc():
> "lru.next has bit 1 set if the page is allocated from the
> pfmemalloc reserves. Callers may simply overwrite it if they
> do not need to preserve that information."
> 
> [...]

Here is the summary with links:
  - [net,V2] page_pool: mask the page->signature before the checking
    https://git.kernel.org/netdev/net/c/0fa32ca438b4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


