Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 178C537992E
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 23:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbhEJVbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 17:31:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:40372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230109AbhEJVbP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 17:31:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4A5FF61554;
        Mon, 10 May 2021 21:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620682210;
        bh=EZ1ERwhmpEPE5MXC0LlPZb2cgGgpZPBT+gZph7iPMLY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Xt6oLj0lqgUHa/4Li8xf+X2ukwkcKjh3Ln80m0t29ucfzH5jw6xvPM4JEthVLkbLu
         t2W7lRRRyLhO6Etx80102GnBjbYCkj0BnMOhBj8obYB+hGvBTRCaw4OBKpeGMix0BU
         7EqQoqsp7Wrhp5fmUMsf77/AxldS0+mzSgdZeMAvVGJnBdZjUwGD0ihmvkEVXADx1a
         HbHMsMaWwT6Ew03vi7ZcoIfgV6c7ajhRgje7VtZZr7mgA/edL7DP+FaDz71D0lzgnJ
         xD1Rc1gI+V6Z1YzuAPh6q2A3D9tIGSZk6Lr4GaGaz/IsxLCtQszZDmJbBFeGTEhW4D
         /rFZVxpFXfsPA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3B78D60A48;
        Mon, 10 May 2021 21:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/nfc/rawsock.c: fix a permission check bug
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162068221023.28006.17990440223056358619.git-patchwork-notify@kernel.org>
Date:   Mon, 10 May 2021 21:30:10 +0000
References: <20210508035230.8229-1-jjjinmeng.zhou@gmail.com>
In-Reply-To: <20210508035230.8229-1-jjjinmeng.zhou@gmail.com>
To:     Jinmeng Zhou <jjjinmeng.zhou@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, shenwenbosmile@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat,  8 May 2021 11:52:30 +0800 you wrote:
> From: Jeimon <jjjinmeng.zhou@gmail.com>
> 
> The function rawsock_create() calls a privileged function sk_alloc(), which requires a ns-aware check to check net->user_ns, i.e., ns_capable(). However, the original code checks the init_user_ns using capable(). So we replace the capable() with ns_capable().
> 
> Signed-off-by: Jeimon <jjjinmeng.zhou@gmail.com>
> ---
>  net/nfc/rawsock.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net/nfc/rawsock.c: fix a permission check bug
    https://git.kernel.org/netdev/net/c/8ab78863e9ef

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


