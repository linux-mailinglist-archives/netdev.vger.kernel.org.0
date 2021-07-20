Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D80BE3CFC07
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 16:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239482AbhGTNos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 09:44:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:41650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239978AbhGTNj1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 09:39:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 566B56120F;
        Tue, 20 Jul 2021 14:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626790805;
        bh=PNC335c+0HpNmsknjHzh1aWP1BXG4QHhYXjsSrtp0o0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VYDqNhdecU2LcTZ2hys1MO4WSS4+3mN+lhnca8DIzYVqkP2PCNz+tmIfv8Q0QCALj
         Ix5h2PAB+wigFQ/DXgleLWMLa/GoQbSRc/0mbrpsyZGfEsDhQP3iEQj/BpfudWtBaA
         voCYDhrPwX3q3RslTdLZUs0x0CaWzb06HhA57ZfoTMdJDgZ+T4FjVEqKmm0CBH140q
         4EiXthTQBuRdDlsIBvvtH5j7r8CSydx5TKN3Xq+wcrP3/lBrnRmb2ZWXGRXjpiBXwd
         6ro4xQofK6kTpq/UcmEZiyxvvvi07VpJm+I3cxHepgpNU1mCQK84qf2OUplQa+IDd4
         PH44BZS3qAFnQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4C77360A0B;
        Tue, 20 Jul 2021 14:20:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ipv4: add capability check for net
 administration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162679080530.18101.12497587424613555058.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Jul 2021 14:20:05 +0000
References: <20210720014328.378868-1-yang.yang29@zte.com.cn>
In-Reply-To: <20210720014328.378868-1-yang.yang29@zte.com.cn>
To:     None <cgel.zte@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yang.yang29@zte.com.cn,
        zealci@zte.com.cn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 19 Jul 2021 18:43:28 -0700 you wrote:
> From: Yang Yang <yang.yang29@zte.com.cn>
> 
> Root in init user namespace can modify /proc/sys/net/ipv4/ip_forward
> without CAP_NET_ADMIN, this doesn't follow the principle of
> capabilities. For example, let's take a look at netdev_store(),
> root can't modify netdev attribute without CAP_NET_ADMIN.
> So let's keep the consistency of permission check logic.
> 
> [...]

Here is the summary with links:
  - [net-next] net: ipv4: add capability check for net administration
    https://git.kernel.org/netdev/net-next/c/8292d7f6e871

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


