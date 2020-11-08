Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95A722AAD15
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 20:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728038AbgKHTAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 14:00:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:40750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727570AbgKHTAF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Nov 2020 14:00:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604862005;
        bh=GiuYXeQNz1bgw3iD+yyNhx+jDPtOUXwByEXZ3HcjyTo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=d4HreiWfiJPXKEN8H+Q147dmAo5/ixHUBqFbv4kNWkBdWtMDQa0g2Adlu+S9cSIMZ
         HQQLEkZ85dnxE/di/F47uCEWFtyssu9zMVm22KTVelWD6+kl1i4yClBck/qjZeITuO
         ipeIDY8yBIkOz53t0iERlpTV2fvsEgjFdYrvwNNY=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2] man: fix spelling errors
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160486200531.27896.3635434653307547386.git-patchwork-notify@kernel.org>
Date:   Sun, 08 Nov 2020 19:00:05 +0000
References: <20201108184203.5434-1-stephen@networkplumber.org>
In-Reply-To: <20201108184203.5434-1-stephen@networkplumber.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (refs/heads/main):

On Sun,  8 Nov 2020 10:42:03 -0800 you wrote:
> Lots of little typo errors on man pages.
> Found by running codespell
> 
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> ---
>  man/man8/ip-link.8.in    | 8 ++++----
>  man/man8/ip-macsec.8     | 2 +-
>  man/man8/ip-neighbour.8  | 6 +++---
>  man/man8/ss.8            | 2 +-
>  man/man8/tc-cake.8       | 4 ++--
>  man/man8/tc-ct.8         | 2 +-
>  man/man8/tc-flower.8     | 4 ++--
>  man/man8/tc-matchall.8   | 4 ++--
>  man/man8/tc-pie.8        | 4 ++--
>  man/man8/tc-sfb.8        | 2 +-
>  man/man8/tc-tunnel_key.8 | 4 ++--
>  11 files changed, 21 insertions(+), 21 deletions(-)

Here is the summary with links:
  - [iproute2] man: fix spelling errors
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=c8424b73e15f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


