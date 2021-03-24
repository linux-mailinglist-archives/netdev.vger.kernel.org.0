Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4587348212
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 20:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237967AbhCXTk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 15:40:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:42102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237661AbhCXTkI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 15:40:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 74DC961A1B;
        Wed, 24 Mar 2021 19:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616614808;
        bh=eiRdPPdnaJWrH5QlAXI2w8AOAMjezXubZYg5yXs82Zw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=afRufvqA3hO52MwL8Nxc6JFeWKySLyfTYp/4uZpBwxSoy/WopsglXd8s/Z3TURTfV
         j0uDgxEvW6Qljt54ENh2auuizRLAzRmdbW7eD0XHISLDgs9U2RQassHJvFmjmVxI5k
         jqXkWGYoTfWJYxqaSmGx8PGMhPWk/dY2gE7hADSscj6BA6rlY2rW9jMOF/9b0zkAr0
         DeJhe2BRycJH0OxJiiBFcVfKg73scCFvliYZIS6alihj9KHgjiQpm5tY+FYWIvwsVz
         MWxoDxsSZllfQig4aCPGpkdvKdBNPmIlXkMSUlU6klTsyZWI3QHks/4IOsAoVIhsom
         lUFXxFnwUd5Cg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 61E0460A0E;
        Wed, 24 Mar 2021 19:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] [RESEND] ch_ktls: fix enum-conversion warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161661480839.20893.6199990730780156186.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Mar 2021 19:40:08 +0000
References: <20210323215302.30944-1-arnd@kernel.org>
In-Reply-To: <20210323215302.30944-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     ayush.sawal@chelsio.com, vinay.yadav@chelsio.com,
        rohitm@chelsio.com, davem@davemloft.net, kuba@kernel.org,
        arnd@arndb.de, andrew@lunn.ch, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 23 Mar 2021 22:52:50 +0100 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> gcc points out an incorrect enum assignment:
> 
> drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c: In function 'chcr_ktls_cpl_set_tcb_rpl':
> drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c:684:22: warning: implicit conversion from 'enum <anonymous>' to 'enum ch_ktls_open_state' [-Wenum-conversion]
> 
> [...]

Here is the summary with links:
  - [net-next,RESEND] ch_ktls: fix enum-conversion warning
    https://git.kernel.org/netdev/net/c/6f235a69e594

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


