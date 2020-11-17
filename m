Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBAB42B71CE
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 23:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728736AbgKQWuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 17:50:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:46824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726182AbgKQWuF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 17:50:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605653404;
        bh=YrLaqOe9C+UDU5uAC+l1xW4/IZCVZjGK9RriFH1wbh8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IrSrS9F4OcqTHooI5n1yx3u+ObS4rX5dMDkzQu6OWZ//VAi7qyAuAiJfDsPY5jtt/
         Rv1XvkVKZZ82b5HJaVAcIydHUbWZ2MfKU9eT1y41U3Ku8m6nYb2Ad+Hn+b/AddjT+l
         svrlkd3IoE3L+krm9Q6s7V+73X0hGy/YU5wvBBXk=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net V2] net/tls: Fix wrong record sn in async mode of device
 resync
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160565340479.2978.9885735567980765309.git-patchwork-notify@kernel.org>
Date:   Tue, 17 Nov 2020 22:50:04 +0000
References: <20201115131448.2702-1-tariqt@nvidia.com>
In-Reply-To: <20201115131448.2702-1-tariqt@nvidia.com>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        saeedm@nvidia.com, moshe@nvidia.com, ttoukan.linux@gmail.com,
        borisp@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun, 15 Nov 2020 15:14:48 +0200 you wrote:
> In async_resync mode, we log the TCP seq of records until the async request
> is completed.  Later, in case one of the logged seqs matches the resync
> request, we return it, together with its record serial number.  Before this
> fix, we mistakenly returned the serial number of the current record
> instead.
> 
> Fixes: ed9b7646b06a ("net/tls: Add asynchronous resync")
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> Reviewed-by: Boris Pismenny <borisp@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net,V2] net/tls: Fix wrong record sn in async mode of device resync
    https://git.kernel.org/netdev/net/c/138559b9f99d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


