Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF6E47FDE4
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 15:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237212AbhL0OuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 09:50:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47194 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234125AbhL0OuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 09:50:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4ABBF6103A;
        Mon, 27 Dec 2021 14:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AF648C36AEB;
        Mon, 27 Dec 2021 14:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640616609;
        bh=INOWwOnXtGq8k57MyqfQ577Zm6nBGtmybpDS2/owTYo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZRfP+vrgOwh2KXsfn4xEPmRSRXTkXskxRdJWvGKgP5YjCE9Fyj7iRG3PhQcgcJXp6
         AnI795FVdrRDdt56h76gyZhKqIg+iXkosifdIQ2Yihui9NsXJW4bUi6a3YS/9LtgkM
         RYbuZTFafaCPHSblrlo80YXqdyft0YdmcsS3osjzK1ut4KP91vQVDTLqAbsYDH4Cga
         C5kLz85dQdhD+SV1jSqKuCJgtQCGl1WJKOTta69YGslaG7qL/BrG4YwvvuCcuHXRVu
         py5zNUB2x81q3uUdPkn8vX6M0WNMDAgb0opbSZtaaGBIlgTXaPVIdSJL2ZeeksQhbi
         aga1VK7dss1eA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 92CE3C395E6;
        Mon, 27 Dec 2021 14:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/smc: fix using of uninitialized completions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164061660959.26121.4566598631672152879.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Dec 2021 14:50:09 +0000
References: <20211227133530.4106857-1-kgraul@linux.ibm.com>
In-Reply-To: <20211227133530.4106857-1-kgraul@linux.ibm.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 27 Dec 2021 14:35:30 +0100 you wrote:
> In smc_wr_tx_send_wait() the completion on index specified by
> pend->idx is initialized and after smc_wr_tx_send() was called the wait
> for completion starts. pend->idx is used to get the correct index for
> the wait, but the pend structure could already be cleared in
> smc_wr_tx_process_cqe().
> Introduce pnd_idx to hold and use a local copy of the correct index.
> 
> [...]

Here is the summary with links:
  - [net] net/smc: fix using of uninitialized completions
    https://git.kernel.org/netdev/net/c/6d7373dabfd3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


