Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B885A2DA6EE
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 04:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgLODlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 22:41:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:47060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726359AbgLODk4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 22:40:56 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608003608;
        bh=IWujZ07ARRteAp9EqpsD2l7fc4a25cVrqo0WJwO8PrY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YPzOr1BEla6VOcH8iQ0kZKm4S0nH1NRSzPkr9HlJz78xqJGsq3deYYZud/bq85g/h
         cAmMWdQJKjmUtLyXvXNF3bQ1xS6kCBFawTdIZAW+kk1kGNBQ1Ta5mIqm7jG29781W5
         sCUXjzRS/kFmYoeuVPaNLXaEhfCSuX0GRsi2NoGqhY5dzSDQxApz5xUVGFKfrA2MH4
         XKOJu1e2J7LixdIJqrcUzpHkTWMOhUeoN0MbBf9tpuyc0Q4TSMPfD16c/AgF3LNiC+
         6lcv1Y67SSIWkaNgjtJ8ioFLU25uUuMB//VnFpwZPtrHTwqFi4WXCRsQmOcYy1aPqF
         oA3OwqDmmadYw==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] nfc/pn533/usb: convert comma to semicolon
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160800360879.3580.5811260204240217306.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Dec 2020 03:40:08 +0000
References: <20201214134314.4618-1-zhengyongjun3@huawei.com>
In-Reply-To: <20201214134314.4618-1-zhengyongjun3@huawei.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 14 Dec 2020 21:43:14 +0800 you wrote:
> Replace a comma between expression statements by a semicolon.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  drivers/nfc/pn533/usb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [-next] nfc/pn533/usb: convert comma to semicolon
    https://git.kernel.org/netdev/net-next/c/102f19d611ac

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


