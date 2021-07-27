Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 312AA3D73EB
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 13:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236396AbhG0LAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 07:00:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:60754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236345AbhG0LA3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 07:00:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E163561994;
        Tue, 27 Jul 2021 11:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627383630;
        bh=1wFQ+9y/pA/6ySLegMsxKMvwsRXbn4m1UveXkQ5FFOE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lUHzTfrJSBweArPFTlvE7HYNTO/EWfrBQ9Nu1h1d7GiDv5EhD4voMSU7frIY18pl5
         8NPiv328Ty1LO/RZhSHrzEIPJ8eZonmHxFlkhzeSj86nbVO9SSGTZKziGEKV4sUrwA
         GKfDJ0fHO/N5eSSN05bdGeqOYXM7r8HkfLlFbyOiJsQ8mt6rwixdg1PvbXTTcmWlyw
         o77/sH7jTlqaliwt8z/6ZTxdkhSRowRMTtQGkJ6h55kaIgJx1ya2q1h40xJzlsSzCm
         ESKnYXOVgfsxHrXSz7cafyMl7PQtgUqx9Oclh69ksCu/BRjHnbzz6PUWBhExl2EA2w
         HeHvMBA+7d3SA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DC60960A59;
        Tue, 27 Jul 2021 11:00:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: qed: remove unneeded return variables
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162738362989.18831.4868949380813321166.git-patchwork-notify@kernel.org>
Date:   Tue, 27 Jul 2021 11:00:29 +0000
References: <20210725151353.109586-1-wangborong@cdjrlc.com>
In-Reply-To: <20210725151353.109586-1-wangborong@cdjrlc.com>
To:     Jason Wang <wangborong@cdjrlc.com>
Cc:     aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 25 Jul 2021 23:13:53 +0800 you wrote:
> Some return variables are never changed until function returned.
> These variables are unneeded for their functions. Therefore, the
> unneeded return variables can be removed safely by returning their
> initial values.
> 
> Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
> 
> [...]

Here is the summary with links:
  - net: qed: remove unneeded return variables
    https://git.kernel.org/netdev/net-next/c/ef17e2ac2183

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


