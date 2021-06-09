Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4133A0A0F
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 04:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232821AbhFICb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 22:31:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:55634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230444AbhFICb5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 22:31:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B512E6128A;
        Wed,  9 Jun 2021 02:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623205803;
        bh=PARdrkRjxakvMMymGfKkxFhEapnRH2kfvbyg5msrzDo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kBge/D+px3rl7oxIvuSwDgS5F0zQONSTetEPu8/OUi16IZCxpcUbIQDNFAHXppu3V
         OaPNj8lTS+slmulnErgFFlLcX4P4Sr4jh0hkhSJXxq26AuQveoOzjpCrb66KNgt7It
         W1+lRaYOOvZJqFN/3CaxXiqE90vW/u9vMSHSvvDCVzvLEC6a+mvePcDTotnKrueyDq
         41sb0xDhnBi7uqsdGY3dn2F3CGzJK97O+uPUoKSujBdc94TH7Pp2hJDaQcYE3T6oD8
         VKcrV7FYcSghHEwO/eF+zqa+dnze/KJw8/M4FxxDB/N6eXoRITmjinOTjyZ6x5rW6Y
         cIcJZSu36Ilbg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A7F0160BE2;
        Wed,  9 Jun 2021 02:30:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: appletalk: fix some mistakes in grammar
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162320580368.4034.9799798999462632567.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Jun 2021 02:30:03 +0000
References: <20210609015257.15262-1-13145886936@163.com>
In-Reply-To: <20210609015257.15262-1-13145886936@163.com>
To:     None <13145886936@163.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gushengxian@yulong.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue,  8 Jun 2021 18:52:57 -0700 you wrote:
> From: gushengxian <gushengxian@yulong.com>
> 
> Fix some mistakes in grammar.
> 
> Signed-off-by: gushengxian <gushengxian@yulong.com>
> ---
>  net/appletalk/ddp.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Here is the summary with links:
  - net: appletalk: fix some mistakes in grammar
    https://git.kernel.org/netdev/net-next/c/2aa8eca6cbb5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


