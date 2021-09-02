Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08F093FEC49
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 12:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245609AbhIBKlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 06:41:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:60460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244843AbhIBKlE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 06:41:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CAEAE610E8;
        Thu,  2 Sep 2021 10:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630579206;
        bh=vLUT8VuKiEYyRZnKF0mUnUWMObH5g4KH0xdhR11WtQ8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AJiWRxfawpe77Ki9dlBfy7r4DcILsjdfQm3M7UYig6TRxZuola7yj6B0TfVIEsj4+
         aGNCLx5Lr3zey7PDwkpyN0q3VhsubQEO1W7jS663VO4Q+d1Azh1+n3Vwpk9bto/t53
         yswM9HfAX7EVF1fP4QY6wR9M5G3w/VdEIm4plGszwB7VeNFNwiUbX/AgAexpjsFbVw
         ZDHEWOYqX3WrtP6YlH0obVJ/Ye8gSoo6dglJQG/ysoHC5ZO0IsiB6UwQvNB9jUYGbW
         35M2DBeuAtXBZaf3gZnEIRl47H61idJEIPkmHNQo0fSD8dejiF4+/Mx0srxfQz1hcp
         MgIIV6SIlbodA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C269E609D9;
        Thu,  2 Sep 2021 10:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ipv6: change return type from int to void for
 mld_process_v2
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163057920679.13463.7886360925947769621.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Sep 2021 10:40:06 +0000
References: <20210901153449.26067-1-jiwonaid0@gmail.com>
In-Reply-To: <20210901153449.26067-1-jiwonaid0@gmail.com>
To:     Jiwon Kim <jiwonaid0@gmail.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  2 Sep 2021 00:34:49 +0900 you wrote:
> The mld_process_v2 only returned 0.
> 
> So, the return type is changed to void.
> 
> Signed-off-by: Jiwon Kim <jiwonaid0@gmail.com>
> ---
>  net/ipv6/mcast.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)

Here is the summary with links:
  - [net-next] ipv6: change return type from int to void for mld_process_v2
    https://git.kernel.org/netdev/net/c/3f22bb137eb0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


