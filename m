Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 476423E4378
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 12:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233926AbhHIKAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 06:00:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:52064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233710AbhHIKA1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 06:00:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A25A361078;
        Mon,  9 Aug 2021 10:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628503206;
        bh=XA+nOFFfOitAeVWCvaqWFP5rvo55hpa4rhKn4SBrmE0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HzWVWeog/W4GjDC5nhLmAuJiEXwK8a0rhdWRLqMh8Fmz1PSU9DycaswA/Df5XGah5
         Vn/vA5jCYj5ddVYJa2gCVOsD3fEPaUlMfTTCV32OSm0FoDDBjXdC3C+iBbkU5S/6A7
         bJotzoqvp8yKNZhe0MhYmH8ee5N2Wgl1OFEiJnejmvjH8/mq1P6tr8y1bu7WkVxxZD
         yFVw67UQw54/LR69S2pZMqbjTM07Ps1zxdsxrzZrQPAXilcDRJhsiwKJQvECxbhgkG
         gDgBscBX/sLogCkTt5GxtDKBa9ER22TojiL7aXv61cdOFeo+t8zObv/iyDBCDZEKmV
         GnCzQY4su+Now==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9772960A9D;
        Mon,  9 Aug 2021 10:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] net/smc: fixes 2021-08-09
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162850320661.31628.1752242837176441727.git-patchwork-notify@kernel.org>
Date:   Mon, 09 Aug 2021 10:00:06 +0000
References: <20210809090557.3121288-1-guvenc@linux.ibm.com>
In-Reply-To: <20210809090557.3121288-1-guvenc@linux.ibm.com>
To:     Guvenc Gulce <guvenc@linux.ibm.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com, kgraul@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Mon,  9 Aug 2021 11:05:55 +0200 you wrote:
> Hi Dave & Jakub,
> 
> please apply the following patch series for smc to netdev's net tree.
> One patch fixes invalid connection counting for links and the other
> one fixes an access to an already cleared link.
> 
> Thanks,
> 
> [...]

Here is the summary with links:
  - [net,1/2] net/smc: fix wait on already cleared link
    https://git.kernel.org/netdev/net/c/8f3d65c16679
  - [net,2/2] net/smc: Correct smc link connection counter in case of smc client
    https://git.kernel.org/netdev/net/c/64513d269e89

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


