Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78AB535D212
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 22:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238831AbhDLUae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 16:30:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:48580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245725AbhDLUa2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 16:30:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 73B4661358;
        Mon, 12 Apr 2021 20:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618259410;
        bh=UUcSWKevBqaOlZubGqhmY/xGMIEQ3gMUviGXg5dcZJ0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uX2wjAw96f0qt1ZT786fewClQxvum5THshyRqAaxRqo3p5yz2AV6hqMFofhWr/LYX
         7QsMEF1nEzIW15eexrs6/JY1Vd9BTlVgnBaILhkVSyXK1t6MKR9V4gsaYBBKQ4q8x5
         9yK61nhdFLT91m0jnLMDAK6cJ/h/kLT10csUtjPzkNsQVV40Pbvkwt9a/hSqp1ISQW
         CCf8BSXH9VJ15csC0THsm5PR19jhG4NrVRtWlhFgDkduxRX9JTiIPlT0WbPMr8BJhx
         KRVRik+W5+gXo9Oofpai84rPMYhzofFSBlhdiN1KqYaNumPJCPKhcQxzjFaDhazGKs
         tScsKcU/4ENDg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6B37360CD1;
        Mon, 12 Apr 2021 20:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] bnxt_en: Error recovery fixes.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161825941043.5277.15967651498898253707.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Apr 2021 20:30:10 +0000
References: <1618186695-18823-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1618186695-18823-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        gospo@broadcom.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sun, 11 Apr 2021 20:18:10 -0400 you wrote:
> This series adds some fixes and enhancements to the error recovery
> logic.  The health register logic is improved and we also add missing
> code to free and re-create VF representors in the firmware after
> error recovery.
> 
> Michael Chan (2):
>   bnxt_en: Treat health register value 0 as valid in
>     bnxt_try_reover_fw().
>   bnxt_en: Refactor __bnxt_vf_reps_destroy().
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] bnxt_en: Treat health register value 0 as valid in bnxt_try_reover_fw().
    https://git.kernel.org/netdev/net-next/c/17e1be342d46
  - [net-next,2/5] bnxt_en: Invalidate health register mapping at the end of probe.
    https://git.kernel.org/netdev/net-next/c/190eda1a9dbc
  - [net-next,3/5] bnxt_en: Refactor bnxt_vf_reps_create().
    https://git.kernel.org/netdev/net-next/c/ea2d37b2b307
  - [net-next,4/5] bnxt_en: Refactor __bnxt_vf_reps_destroy().
    https://git.kernel.org/netdev/net-next/c/90f4fd029687
  - [net-next,5/5] bnxt_en: Free and allocate VF-Reps during error recovery.
    https://git.kernel.org/netdev/net-next/c/ac797ced1fd0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


