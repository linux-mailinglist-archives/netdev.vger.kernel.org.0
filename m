Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6638A349DCD
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 01:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbhCZAaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 20:30:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:36660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229669AbhCZAaL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 20:30:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 889A061A01;
        Fri, 26 Mar 2021 00:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616718610;
        bh=LdGVXMwlNxo18R1ZDCxDv33Ba2P+L597E+9D9J6RFzA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FmBycWtAkmEowEfSOzWE324QFGisW8JZu8rtBDmouxqo1hILOrdvQxFbr0kBSJsAJ
         j23FGr6zZQ9hocnmmQJcz6XSRsIjrsQ5OiwEn8huQkgfzy0ivpkzjlRVq+C62NKDRK
         PuPZErK50vWQQps6GWKaC4ich+B3NnrHtFGqwsFY1AayUkZz3ujMa3nASvtLCecqEO
         XYnta2s7EqIJ50R8hOb/Cz7VQODNPzKhz9eG54wKmwzgJt3ncBVjmtLdhyiwG/YtDi
         XBG2kvXzDD7ob2V+AuQ8WScM+gpxNR3N8TdxunTYWEV8A+DKa4PbslMHuuTO76DJ45
         dzRwVEAMMKMeQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 747356096E;
        Fri, 26 Mar 2021 00:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH resend 0/4] nfc: fix Resource leakage and endless loop
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161671861047.2256.9727486806659792945.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Mar 2021 00:30:10 +0000
References: <20210325035113.49323-1-nixiaoming@huawei.com>
In-Reply-To: <20210325035113.49323-1-nixiaoming@huawei.com>
To:     Xiaoming Ni <nixiaoming@huawei.com>
Cc:     linux-kernel@vger.kernel.org, kiyin@tencent.com,
        stable@vger.kernel.org, gregkh@linuxfoundation.org,
        sameo@linux.intel.com, linville@tuxdriver.com, davem@davemloft.net,
        kuba@kernel.org, mkl@pengutronix.de, stefan@datenfreihafen.org,
        matthieu.baerts@tessares.net, netdev@vger.kernel.org,
        wangle6@huawei.com, xiaoqian9@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu, 25 Mar 2021 11:51:09 +0800 you wrote:
> fix Resource leakage and endless loop in net/nfc/llcp_sock.c,
>  reported by "kiyin(尹亮)".
> 
> Link: https://www.openwall.com/lists/oss-security/2020/11/01/1
> 
> Xiaoming Ni (4):
>   nfc: fix refcount leak in llcp_sock_bind()
>   nfc: fix refcount leak in llcp_sock_connect()
>   nfc: fix memory leak in llcp_sock_connect()
>   nfc: Avoid endless loops caused by repeated llcp_sock_connect()
> 
> [...]

Here is the summary with links:
  - [resend,1/4] nfc: fix refcount leak in llcp_sock_bind()
    https://git.kernel.org/netdev/net/c/c33b1cc62ac0
  - [resend,2/4] nfc: fix refcount leak in llcp_sock_connect()
    https://git.kernel.org/netdev/net/c/8a4cd82d62b5
  - [resend,3/4] nfc: fix memory leak in llcp_sock_connect()
    https://git.kernel.org/netdev/net/c/7574fcdbdcb3
  - [resend,4/4] nfc: Avoid endless loops caused by repeated llcp_sock_connect()
    https://git.kernel.org/netdev/net/c/4b5db93e7f2a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


