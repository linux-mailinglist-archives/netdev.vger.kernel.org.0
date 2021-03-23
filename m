Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF608346B3D
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 22:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233739AbhCWVkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 17:40:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:60076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233517AbhCWVkJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 17:40:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B136B619CC;
        Tue, 23 Mar 2021 21:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616535608;
        bh=VSjGbjt+mugw4jjzrQCfacabpJZJ7Kd5yycsqACP9Mk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oRM0EdI+VwfPCb8WBrZ9zvz43fwhlDew5X2lLm4okeJTcy8mWT3g6ZS2GnOCwStkg
         peeE8R8Pp3j7yZPEoRsrMRMv0Ui4cuQAvedlafIRic0vZqz/FQxGNZvpj/kwmS5ZcX
         MTAoJQtMi2OeO9CdpaB4/g8FLa4Fg2ODDyo6oX8JuSjiv7xYTaTsTVcgo6qFj32PNr
         7XiQTXheF20C/xmKG8BmPD74cqvwsyj3efR2yXa5FDbWVuT3uo1qaiRSOPwNirQYMX
         V1w0hM9/8YzkWcv+6Sq9nde8jZ003aIEg1w1Jcdhis2tXWJ+iAJP1ux4VORPIkvN78
         pm2+WneFZSZlQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A0B8260A3E;
        Tue, 23 Mar 2021 21:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/sched: act_ct: clear post_ct if doing ct_clear
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161653560865.14856.6733537375300854932.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Mar 2021 21:40:08 +0000
References: <dd268092346925b34d5963debfd6df4410545828.1616436250.git.marcelo.leitner@gmail.com>
In-Reply-To: <dd268092346925b34d5963debfd6df4410545828.1616436250.git.marcelo.leitner@gmail.com>
To:     Marcelo Ricardo Leitner <mleitner@redhat.com>
Cc:     netdev@vger.kernel.org, wenxu@ucloud.cn, paulb@nvidia.com,
        yossiku@nvidia.com, ozsh@nvidia.com, dcaratti@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 22 Mar 2021 15:13:22 -0300 you wrote:
> From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> 
> Invalid detection works with two distinct moments: act_ct tries to find
> a conntrack entry and set post_ct true, indicating that that was
> attempted. Then, when flow dissector tries to dissect CT info and no
> entry is there, it knows that it was tried and no entry was found, and
> synthesizes/sets
>                   key->ct_state = TCA_FLOWER_KEY_CT_FLAGS_TRACKED |
>                                   TCA_FLOWER_KEY_CT_FLAGS_INVALID;
> mimicing what OVS does.
> 
> [...]

Here is the summary with links:
  - [net] net/sched: act_ct: clear post_ct if doing ct_clear
    https://git.kernel.org/netdev/net/c/8ca1b090e5c9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


