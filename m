Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E96362B54FB
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 00:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729694AbgKPXaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 18:30:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:38940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726227AbgKPXaF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 18:30:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605569405;
        bh=hrhGHOd+8vWh9fJJG1fhWn7TWoyVgpcJuUX0QOFG7M8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=1v4iiRPFG3bNWKFEzdHmow4mnXxlbHCkdxVuyhGvSlSGrsf02LOYZ1QG0PMsM9pZW
         VgHLRivO+7jWO5PaD2tNZ9yd4j9ebAqjdd/oyk/+omv3pz1bq4Z+X2jQ97NAeDRDie
         45tl5k8u1JkB3NttBYHIeNoyO3Oz9oirFicDpHGY=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] cx82310_eth: fix error return code in cx82310_bind()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160556940487.9105.61677391575473381.git-patchwork-notify@kernel.org>
Date:   Mon, 16 Nov 2020 23:30:04 +0000
References: <1605247627-15385-1-git-send-email-zhangchangzhong@huawei.com>
In-Reply-To: <1605247627-15385-1-git-send-email-zhangchangzhong@huawei.com>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux@zary.sk,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 13 Nov 2020 14:07:07 +0800 you wrote:
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Fixes: ca139d76b0d9 ("cx82310_eth: re-enable ethernet mode after router reboot")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net] cx82310_eth: fix error return code in cx82310_bind()
    https://git.kernel.org/netdev/net/c/cfbaa8b33e02

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


