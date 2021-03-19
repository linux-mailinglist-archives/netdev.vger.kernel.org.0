Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F35763425D9
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 20:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbhCSTKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 15:10:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:41862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230288AbhCSTKJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 15:10:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 593BF6197A;
        Fri, 19 Mar 2021 19:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616181009;
        bh=RsEpAri9lxBgB8P8z0avudv4Fmv/TcIh9NQ984pk+RM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZLBu9qq0VF22iJYP4xSX47IJJk4E4ORXAkbrw/KZFyt2oOVV3A5TIP/Tigh5TLWlD
         QO8RR7MxkoIuAf77trdRi6P92UCLL7MwaoEo3VT36j7EbKrRDKxHNpgWNyzJDmFzKO
         K/+IfelrI4YY5rQ9vNScuW/imzdL1yxb5pOSGscUjd4DKOSITB2ESBhoE1U0krLrfC
         Ny7r2tYLd9faS4upRB9uaDPfnOFqgRq1eGorllYWy5A4GYaM60iDyUIMmm4RcTwHFh
         WSkBN7zTkMWc8Psfb1vMuJXgrqwB2yCZ0/xZLVp69ivAYJyltsu4hgXtCvgw56Mf2R
         T/AbDbvEdkixA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4B247626EC;
        Fri, 19 Mar 2021 19:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] net: hinic; make some cleanup for hinic
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161618100930.534.8400720173558238232.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Mar 2021 19:10:09 +0000
References: <1616135785-122085-1-git-send-email-huangdaode@huawei.com>
In-Reply-To: <1616135785-122085-1-git-send-email-huangdaode@huawei.com>
To:     Daode Huang <huangdaode@huawei.com>
Cc:     luobin9@huawei.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 19 Mar 2021 14:36:21 +0800 you wrote:
> This set try to remove the unnecessary output message, add a blank line,
> remove the dupliate word and change the deprecated strlcp functions in
> hinic driver, for details, please refer to each patch.
> 
> Daode Huang (4):
>   net: hinic: Remove unnecessary 'out of memory' message
>   net: hinic: add a blank line after declarations
>   net: hinic: remove the repeat word "the" in comment.
>   net: hinic: convert strlcpy to strscpy
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] net: hinic: Remove unnecessary 'out of memory' message
    https://git.kernel.org/netdev/net-next/c/c199fdb8abf5
  - [net-next,2/4] net: hinic: add a blank line after declarations
    https://git.kernel.org/netdev/net-next/c/44401b677a52
  - [net-next,3/4] net: hinic: remove the repeat word "the" in comment.
    https://git.kernel.org/netdev/net-next/c/e2f84fd17557
  - [net-next,4/4] net: hinic: convert strlcpy to strscpy
    https://git.kernel.org/netdev/net-next/c/79d65cab7f85

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


