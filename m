Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93A0946AF49
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 01:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378590AbhLGAnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 19:43:42 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34146 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351468AbhLGAnl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 19:43:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BFE8B81644;
        Tue,  7 Dec 2021 00:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D9692C341CD;
        Tue,  7 Dec 2021 00:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638837609;
        bh=B1VP9aKvVrC9MoNBK1NK+od8ypE7G0li6i9pIJat0sU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iHyFioOoBkwE/8kBLe2fqk6Lj/YKw6o3VdJokq/HuOUouG6orBI6FgQH9hoyBE+rb
         zdF/52MjpLbKw105fPRvsDfzUugZhg9gbUPIhA3wcPrApODlbHEiQpkANEfEbFwiDX
         cmo3sHyN/rr4m0NZEJt5iu67shF2A4KuEzR5RFGcTsi9e5ZCjySpEhtpki7+6DEK2C
         0aHas4fCeN5Cq6kwEKbqyqk8CTtUvojoFZy/jsUZV7uFuPp/dOHhanqsHpSE3BSFQr
         0+Jsbi9egAaYtCE+4iEkNnTeWrnHr4Ik9suicjYs1r2IrX3VzIukkXiO/wnCKTHqR+
         Gw2qFmnTw/ypg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B93C960A4D;
        Tue,  7 Dec 2021 00:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: prestera: replace zero-length array with flexible-array
 member
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163883760975.11691.18220065065431409581.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Dec 2021 00:40:09 +0000
References: <20211204171349.22776-1-jose.exposito89@gmail.com>
In-Reply-To: <20211204171349.22776-1-jose.exposito89@gmail.com>
To:     =?utf-8?b?Sm9zw6kgRXhww7NzaXRvIDxqb3NlLmV4cG9zaXRvODlAZ21haWwuY29tPg==?=@ci.codeaurora.org
Cc:     tchornyi@marvell.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        kernel-hardening@lists.openwall.com, gustavoars@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat,  4 Dec 2021 18:13:49 +0100 you wrote:
> One-element and zero-length arrays are deprecated and should be
> replaced with flexible-array members:
> https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays
> 
> Replace zero-length array with flexible-array member and make use
> of the struct_size() helper.
> 
> [...]

Here is the summary with links:
  - net: prestera: replace zero-length array with flexible-array member
    https://git.kernel.org/netdev/net-next/c/01081be1ea8c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


