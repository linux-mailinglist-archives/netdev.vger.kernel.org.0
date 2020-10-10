Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB697289C94
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 02:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728649AbgJJAHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 20:07:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:41996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728600AbgJJAAE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 20:00:04 -0400
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602288003;
        bh=mQpnBXhnNEPuNbjoTkWJsiEu0u22Q4mDYpJZK6dOnVU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Z7k9lLalMc4ZO1r7UcjBhdFMj90vWzj6ohXcb/F+6/Y7Sf+0rNSAC6HOArJ3qKjBI
         VTXwfxEXyDRIM0sH2atgGq8x2ee8NvY7DovjbKGHqTJcOMSs+wO6X1FTLO1h0VmW/9
         Vm0dNKos/cUhNDQGuEgg7XxBgJ6c61sOShpDJ6T4=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/tls: remove a duplicate function prototype
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160228800300.25187.6616698567487971717.git-patchwork-notify@kernel.org>
Date:   Sat, 10 Oct 2020 00:00:03 +0000
References: <20201009054900.20145-1-rdunlap@infradead.org>
In-Reply-To: <20201009054900.20145-1-rdunlap@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, borisp@nvidia.com, aviadye@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  8 Oct 2020 22:49:00 -0700 you wrote:
> Remove one of the two instances of the function prototype for
> tls_validate_xmit_skb().
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Boris Pismenny <borisp@nvidia.com>
> Cc: Aviad Yehezkel <aviadye@nvidia.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> To: netdev@vger.kernel.org
> 
> [...]

Here is the summary with links:
  - [net] net/tls: remove a duplicate function prototype
    https://git.kernel.org/netdev/net/c/923527dcb4d1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


