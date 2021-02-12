Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 207BB31A58A
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 20:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbhBLTkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 14:40:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:44076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230053AbhBLTkr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 14:40:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id E89E864DF0;
        Fri, 12 Feb 2021 19:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613158807;
        bh=ONaC5prI5fNR+UruLROnfPOwi4GWX9oMpgdydVtGgXo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Dxvvf1yf6cJRubw3Dt//8PS1sqoIlzCPchP63mM8WOr9i4UQHolQxG4LysvmeusjL
         K/ShTULWzKr6mxAgY7g63YX9cIb92ZkHXnIhSSujFbc+ND4Ze7lNvG6rAZ+5cHiTHk
         IRJMSUSnkVMnscbAEUInWKnmBEv7F0228b1MqSW7oBiPo4cIKVVSqR51jWztAinHnO
         df9otC2KCI9N0oHizg9m8i8+CtdnuZ4P01+HblBeQjCPKvRgHONYQfWwAYXmel1wmQ
         dMB83QspykLG64F5apBwTrpDj/PwiM1mFku8p23tk5UpCiZGdmFwiFXQG0poX5OcVc
         7weX3fcqjHcXQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DBAB860A2C;
        Fri, 12 Feb 2021 19:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] libbpf: use AF_LOCAL instead of AF_INET in xsk.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161315880689.31593.137242158686388901.git-patchwork-notify@kernel.org>
Date:   Fri, 12 Feb 2021 19:40:06 +0000
References: <20210209221826.922940-1-sdf@google.com>
In-Reply-To: <20210209221826.922940-1-sdf@google.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Tue,  9 Feb 2021 14:18:26 -0800 you wrote:
> We have the environments where usage of AF_INET is prohibited
> (cgroup/sock_create returns EPERM for AF_INET). Let's use
> AF_LOCAL instead of AF_INET, it should perfectly work with SIOCETHTOOL.
> 
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  tools/lib/bpf/xsk.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [bpf-next] libbpf: use AF_LOCAL instead of AF_INET in xsk.c
    https://git.kernel.org/bpf/bpf-next/c/1e0aa3fb05f8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


