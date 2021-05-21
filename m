Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5D338CF2A
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 22:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbhEUUlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 16:41:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:54894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229512AbhEUUle (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 16:41:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 51F9B61057;
        Fri, 21 May 2021 20:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621629611;
        bh=3U1/RBuefFyH14BAx7UNpn8IhquklzS5IN/ma4gfKl4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aFwM0LAt6eN+ICm4YZbWhc7nF8RzzFQSw/HNkxAG3SlUQAecun5aHN9/KzmNI/zam
         rmZ+op/t100yef9WGG/Tw/9w1jdkFInFGpTrjBs4P/fCamMuRXbYDsGuT+PwB//5Pp
         NIxiFu24TskSe95K+Ho6XWcKHByIq5hHOAu+9UoBvouoqwSZZgH/XNJIrkSwisluFc
         moI7+Bi38FOhpfklyifXI7yOrcFhT0hgb2FuvP6yqsXKg7qtRGjR0tenU+TRiZWVdb
         TPgLoqpTbPBVqTjaRFpyP7Uywij8PiFRAzwREN4FEMYPwl8k6wDEvH5Us0e3RXnb+M
         9qTJQB7vZasxQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 47A136096D;
        Fri, 21 May 2021 20:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] caif_virtio: Fix some typos in caif_virtio.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162162961128.15420.5707504281277648249.git-patchwork-notify@kernel.org>
Date:   Fri, 21 May 2021 20:40:11 +0000
References: <20210521032455.28815-1-wanghai38@huawei.com>
In-Reply-To: <20210521032455.28815-1-wanghai38@huawei.com>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, jingxiangfeng@huawei.com,
        luc.vanoostenryck@gmail.com, kernel@esmil.dk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 21 May 2021 11:24:55 +0800 you wrote:
> s/patckets/packets/
> s/avilable/available/
> s/tbe/the/
> 
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---
>  drivers/net/caif/caif_virtio.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Here is the summary with links:
  - [net-next] caif_virtio: Fix some typos in caif_virtio.c
    https://git.kernel.org/netdev/net-next/c/ae8102b87b9a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


