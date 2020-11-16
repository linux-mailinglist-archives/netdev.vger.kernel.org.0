Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 432942B5434
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 23:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728866AbgKPWUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 17:20:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:53370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726016AbgKPWUF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 17:20:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605565205;
        bh=+8OHjo2ZQvb0rlojpbIMc5RrI1TQPhnMSDxlq7m9cCc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=yhMnT1KRp1JdTUQXg6qtEo9K4615QmvaxIQtvRIbIcj9XNXB6F7i6tL13q1IWUu0a
         p5tI3yqUnqy7ivKekRpkMsrG1M8k5YIci8MAmJqljBnikqWt6bA//Agndn72W/6b/D
         hIrQI4DZeJZtRzNM7AV1AHoUztrtpuW64112oHjo=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] MAINTAINERS: update cxgb4 and cxgb3 maintainer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160556520528.8690.12206547593546981883.git-patchwork-notify@kernel.org>
Date:   Mon, 16 Nov 2020 22:20:05 +0000
References: <20201116104322.3959-1-rajur@chelsio.com>
In-Reply-To: <20201116104322.3959-1-rajur@chelsio.com>
To:     Raju Rangoju <rajur@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ramaraju@chelsio.com, rahul.lakkireddy@chelsio.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 16 Nov 2020 16:13:22 +0530 you wrote:
> Update cxgb4 and cxgb3 driver maintainer
> 
> Signed-off-by: Raju Rangoju <rajur@chelsio.com>
> ---
>  MAINTAINERS | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Here is the summary with links:
  - [net] MAINTAINERS: update cxgb4 and cxgb3 maintainer
    https://git.kernel.org/netdev/net/c/794e442ca39e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


