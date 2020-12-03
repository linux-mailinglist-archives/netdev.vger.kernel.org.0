Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23A1C2CCC4C
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 03:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729487AbgLCCKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 21:10:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:46560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726602AbgLCCKr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 21:10:47 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1606961406;
        bh=QHc6CbOxkI9tfUm/Aj4CpPx51gJondiv9p2YHlYBI+c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qY6GZFwE5ewskwqLWJro5kYdr6czQlUfFwSLBYop3IYv6KdMhaTvacSHbK1mMloRT
         DNKGCp0qm0pamu4vRCWsMBgYx7SIawClkKY/56uR+c2tSnmY4oE1pjYFOg8uvHAnE8
         OiOMoIy7MuIYH2vh11X3TSi+RbanQmdsshViW74aHcccGs8I/rT6NC0LJhQ3nypaVc
         +s3Q8OHdeugeZggIDGd3byB0AZG61YUvRTesVQl+4ZuAdXOrgIjjCMMwLJMzSXHSBD
         D9dV+c+tr/UScQTIpQOlptxe8lV4nkfSFgE4GsqWiwxIVs59XMaioQUjfD95T76eGf
         dtNtT2mIpvmWQ==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/1] bareudp: constify device_type declaration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160696140686.31357.6420069308025583780.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Dec 2020 02:10:06 +0000
References: <20201202122324.564918-1-jonas@norrbonn.se>
In-Reply-To: <20201202122324.564918-1-jonas@norrbonn.se>
To:     Jonas Bonn <jonas@norrbonn.se>
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed,  2 Dec 2020 13:23:24 +0100 you wrote:
> device_type may be declared as const.
> 
> Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
> ---
>  drivers/net/bareudp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [1/1] bareudp: constify device_type declaration
    https://git.kernel.org/netdev/net-next/c/cec85994c6b4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


