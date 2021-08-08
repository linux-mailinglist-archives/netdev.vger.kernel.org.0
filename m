Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9154C3E3A23
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 14:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbhHHMKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 08:10:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:50046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229473AbhHHMKZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Aug 2021 08:10:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 349D161004;
        Sun,  8 Aug 2021 12:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628424606;
        bh=kOmrIc6SOEnQ/VK949NAIdQ6H53pH2HJroH5/66NlFw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dczTHNgDQ7OKCA0Xy+m9DsYv1d8u0XifXWLUC4kTReoPS7TM/vFVg6mG2QDfULrp8
         WQsHrB6tfcFQHrtwmekFkXo9dltsuxHPt3gtTvfad2XA/3QyrqMZGgCKNvhT42kQPo
         wljDj5igOxhyqVKTSX2zn6ZGRJi1Wcqiom6zFe8e64Tw5AG5cAqfoNKcXMQWo2FazE
         j4xEfcuUO3ySfeH2iNDnDh6t1u7fP9ogzNpbUB4nzcSREH+mcJroiIg+0Iww6Muygi
         gycF9Xm1zESM6JU9ug39b06cg+FV5Z/rQl7lwT+0Tm1aRFzG5tfg2qOGWuGyxV7REa
         mNian4E2Rjjww==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2699D6096D;
        Sun,  8 Aug 2021 12:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] bnxt_en: PTP fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162842460615.22263.16511156778511102158.git-patchwork-notify@kernel.org>
Date:   Sun, 08 Aug 2021 12:10:06 +0000
References: <1628362995-7938-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1628362995-7938-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        gospo@broadcom.com, richardcochran@gmail.com,
        pavan.chebbi@broadcom.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Sat,  7 Aug 2021 15:03:12 -0400 you wrote:
> This series includes 2 fixes for the PTP feature.  Update to the new
> firmware interface so that the driver can pass the PTP sequence number
> header offset of TX packets to the firmware.  This is needed for all
> PTP packet types (v1, v2, with or without VLAN) to work.  The 2nd
> fix is to use a different register window to read the PHC to avoid
> conflict with an older Broadcom tool.
> 
> [...]

Here is the summary with links:
  - [net,1/3] bnxt_en: Update firmware interface to 1.10.2.52
    https://git.kernel.org/netdev/net/c/fbfee25796e2
  - [net,2/3] bnxt_en: Update firmware call to retrieve TX PTP timestamp
    https://git.kernel.org/netdev/net/c/9e26680733d5
  - [net,3/3] bnxt_en: Use register window 6 instead of 5 to read the PHC
    https://git.kernel.org/netdev/net/c/92529df76db5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


