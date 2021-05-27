Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0145A3938F4
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 01:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236499AbhE0XLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 19:11:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:35268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233726AbhE0XLi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 19:11:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E2539613D8;
        Thu, 27 May 2021 23:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622157004;
        bh=8DPtCAVF0uI3s0NCf2naz9oTqn6DuY1tjJMLH+LNcGk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MNSPdEkJ+Asqhm9/tYlJLHXiFkhLLRp3xateSCtfUVFCGXyVgWMOQNINP81O14Si/
         KKc4AhlBn6EF7QyZf8eS6rbE2TR3oq8zfediwo+uSk3xP6XIeedEphFlgwKYacFvjf
         3vcepIJTB7ACSJGkqKcmBv9sutOoJ92JHjkiIr4H9HsU9q5UpmpQKNjvohXpIfsEeu
         ipaMrBoMIfuBDbijXPg9igKTp7Ns7eZMOaECiR7EN6v9kTKnUoX1sHw3fqC2Knaa2y
         gGmbtHFLFdwF2g9+k3PK/65d54K/uiiVGqWmEjMZ4LwRlJLgKBJkmwxi2mZfIEz2dz
         pA5kMdTIgYzKQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D01CD609F5;
        Thu, 27 May 2021 23:10:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/4] add 4 RX/TX queue support for Mikrotik 10/25G
 NIC
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162215700484.22947.15283379800823112526.git-patchwork-notify@kernel.org>
Date:   Thu, 27 May 2021 23:10:04 +0000
References: <20210527144423.3395719-1-gatis@mikrotik.com>
In-Reply-To: <20210527144423.3395719-1-gatis@mikrotik.com>
To:     Gatis Peisenieks <gatis@mikrotik.com>
Cc:     chris.snook@gmail.com, davem@davemloft.net, kuba@kernel.org,
        hkallweit1@gmail.com, jesse.brandeburg@intel.com,
        dchickles@marvell.com, tully@mikrotik.com, eric.dumazet@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 27 May 2021 17:44:19 +0300 you wrote:
> More RX/TX queues on a network card help spread the CPU load among
> cores and achieve higher overall networking performance.
> This patch set adds support for 4 RX/TX queues available on
> Mikrotik 10/25G NIC.
> 
> v4:
>     - addressed comments from Jakub Kicinski:
>       - split up the change in more manageable chunks
>       - changed member order in structs for tighter packing
>       - fixed style issues
>     - reverted to calling napi_alloc_skb only from within poll
>       as before
> v3:
>     - fix kernel-doc complaints on comments as pointed out by
>       David Miller
> v2:
>     - rebase on net-next master as requested by David Miller
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/4] atl1c: detect NIC type early
    https://git.kernel.org/netdev/net-next/c/bf3be85dbe59
  - [net-next,v4,2/4] atl1c: move tx napi into tpd_ring
    https://git.kernel.org/netdev/net-next/c/20a1b6bdca15
  - [net-next,v4,3/4] atl1c: prepare for multiple rx queues
    https://git.kernel.org/netdev/net-next/c/8042824a3c0b
  - [net-next,v4,4/4] atl1c: add 4 RX/TX queue support for Mikrotik 10/25G NIC
    https://git.kernel.org/netdev/net-next/c/057f4af2b171

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


