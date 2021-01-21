Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0EE72FE168
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 06:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbhAUFPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 00:15:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:45804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725986AbhAUFBB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 00:01:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 3D97C238EE;
        Thu, 21 Jan 2021 05:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611205208;
        bh=PjFNlP+CcWjHHVS7IHita5SQveqaOoYnlNs30GqEvQ4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IjxvyswJL80YueU/E9LcQrzVfrsgAD+WtCKx0xrDMVeaZB4ly8pRsW2iLXXDKz2hr
         Z14LVYIhPcQqbQOMKWalXL0BKDg4KbUPSLAD5rJnav5YIe74xY4wRujiRQqT875zIp
         rfj+1fDk5bPgGbRpQjYxjQT75onVy6TRFCmul2xXZkSY6B9pSoDBYgNbvVNHRhNoxM
         qqfLlwpIMRZwTgyNVExt68M77bAjVQ9X6gXqoS2OnTHsuJEMKYvOilqWkIkXFlqquA
         SrPDZeJgXkBLtrPRYYWzWczKW9pHDLIVIWvaeZZP4QojtxIxU2tbXAiIkVsu1Y8SU2
         qzAmmI3xzNclg==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 2F164600E0;
        Thu, 21 Jan 2021 05:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: Fix off by one in dsa_loop_port_vlan_add()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161120520818.24300.9003059059327075476.git-patchwork-notify@kernel.org>
Date:   Thu, 21 Jan 2021 05:00:08 +0000
References: <YAbyb5kBJQlpYCs2@mwanda>
In-Reply-To: <YAbyb5kBJQlpYCs2@mwanda>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 19 Jan 2021 17:53:35 +0300 you wrote:
> The > comparison is intended to be >= to prevent reading beyond the
> end of the ps->vlans[] array.  It doesn't affect run time though because
> the ps->vlans[] array has VLAN_N_VID (4096) elements and the vlan->vid
> cannot be > 4094 because it is checked earlier.
> 
> Fixes: 98cd1552ea27 ("net: dsa: Mock-up driver")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: Fix off by one in dsa_loop_port_vlan_add()
    https://git.kernel.org/netdev/net-next/c/646188c9550f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


