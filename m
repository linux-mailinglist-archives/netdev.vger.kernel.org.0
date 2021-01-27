Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7A93050E5
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238957AbhA0EaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:30:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:48868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405007AbhA0Bav (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 20:30:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id D552864D78;
        Wed, 27 Jan 2021 01:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611711010;
        bh=fPhVooVMbtsTdlpU4Dw31+1QBu7JFKH8CL70EoL2hzc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vCPXuxGJRpnDB73mW8x/kBV74cV+1kOxSqMUFvUmAMwtegfFeMpneJM/sU62I7J1l
         g+4jU4EuNqhbkT7h/uFmmm0hUTcViDHRGNwYRkrluNlsMxh1okkQ3aJOp9hfCCFjJJ
         FAIS2fA4lEeeM+uIoCA0TcklkaOhbB/yFl0shHwargtBPm8iYZ5OF4z3VLBRdttUIU
         5U8Y4sjhQqdBCYNzAlsfm4aqsFAe5KEVYYmEA9rPajKjLJmdjUWFW5m2Q/3j2VAnT9
         Fg6qpz3V1kec5k6R89Wnz0NjtJB7LBtL1AbMbexNpwD+6vobGHAnjPTPO17CIPNj7A
         2EEvMaZkfstZQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C5DA2652E1;
        Wed, 27 Jan 2021 01:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] bnxt_en: Convert to use netif_level() helpers.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161171101080.7397.6666688923637805406.git-patchwork-notify@kernel.org>
Date:   Wed, 27 Jan 2021 01:30:10 +0000
References: <1611642024-3166-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1611642024-3166-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        joe@perches.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 26 Jan 2021 01:20:24 -0500 you wrote:
> Use the various netif_level() helpers to simplify the C code.  This was
> suggested by Joe Perches.
> 
> Cc: Joe Perches <joe@perches.com>
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c | 34 ++++++++++-------------
>  1 file changed, 14 insertions(+), 20 deletions(-)

Here is the summary with links:
  - [net-next] bnxt_en: Convert to use netif_level() helpers.
    https://git.kernel.org/netdev/net-next/c/871127e6ab0d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


