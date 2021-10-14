Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 517E942CFAC
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 02:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhJNAwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 20:52:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:60398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229663AbhJNAwL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 20:52:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0D6F161154;
        Thu, 14 Oct 2021 00:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634172607;
        bh=Q8surQ5F22zMF1d7k0z4choYbGUyTkCUFgFBre1ur84=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pqTWx/hCYNeEnoLso8fTOs2UNgwGG5qV0HbHEe4kSnefh5+AVjHnykCl7U5TdNa+w
         W/EdGV/fM5WN8FAhQuwGgNhkwzB1BJf2LF79TSx2AFpjX8ht7p6Utugew4qw9Z6CyV
         JR+HPP8e3xGZAC7bhIsGKtNqO+xSlFZGSzUQvn9cwcsjdqomDgT6PEQMDBOiCUJxKQ
         9u9FNEF+HxH1y8fLbV9ZasdMjgLpf3BGR8Ha3LwnzDtRz/SKLj+1XlS17bnbkclRlb
         IqBCIRBvtw7FUkdJSJbwWHf3OqP/v7clfKob7wwfgIkLRMfPGbXZp+xptqgOdHQ135
         hqVl2em19upMA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 00FB0609CF;
        Thu, 14 Oct 2021 00:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] fix two possible memory leak problems in NFC digital
 module
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163417260699.14585.6395298132733213197.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Oct 2021 00:50:06 +0000
References: <cover.1634111083.git.william.xuanziyang@huawei.com>
In-Reply-To: <cover.1634111083.git.william.xuanziyang@huawei.com>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     krzysztof.kozlowski@canonical.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 13 Oct 2021 15:49:53 +0800 you wrote:
> Fix two possible memory leak problems in NFC digital module.
> 
> Ziyang Xuan (2):
>   NFC: digital: fix possible memory leak in digital_tg_listen_mdaa()
>   NFC: digital: fix possible memory leak in digital_in_send_sdd_req()
> 
>  net/nfc/digital_core.c       | 9 +++++++--
>  net/nfc/digital_technology.c | 8 ++++++--
>  2 files changed, 13 insertions(+), 4 deletions(-)

Here is the summary with links:
  - [net,1/2] NFC: digital: fix possible memory leak in digital_tg_listen_mdaa()
    https://git.kernel.org/netdev/net/c/58e7dcc9ca29
  - [net,2/2] NFC: digital: fix possible memory leak in digital_in_send_sdd_req()
    https://git.kernel.org/netdev/net/c/291c932fc369

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


