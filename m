Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEE6C2B2943
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 00:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbgKMXkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 18:40:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:53174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725866AbgKMXkI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 18:40:08 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605310805;
        bh=WqIh+dgQqB6NL2dtYMfmZsyAtKrLsONEZNn9WpfdPdk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SpN+mtrOGJTl0u8VMQzlXiR3BweUcyTGWr8l7BC6fH14/d435m00oPOpDT0/f7gx2
         +FpBgLFDkIx6TlAE42SxQKsFRLEd0yI5v59Xwn2YWW8QvmwyBU1BqXKbYanGwbzYqD
         V9Vto8OMHCJe4gIli91st30XihatKyK+aIoxvePU=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] sfc: further EF100 encap TSO features
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160531080578.10871.12954000777553668321.git-patchwork-notify@kernel.org>
Date:   Fri, 13 Nov 2020 23:40:05 +0000
References: <eda2de73-edf2-8b92-edb9-099ebda09ebc@solarflare.com>
In-Reply-To: <eda2de73-edf2-8b92-edb9-099ebda09ebc@solarflare.com>
To:     Edward Cree <ecree@solarflare.com>
Cc:     linux-net-drivers@solarflare.com, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 12 Nov 2020 15:18:01 +0000 you wrote:
> This series adds support for GRE and GRE_CSUM TSO on EF100 NICs, as
>  well as improving the handling of UDP tunnel TSO.
> 
> Edward Cree (3):
>   sfc: extend bitfield macros to 19 fields
>   sfc: correctly support non-partial GSO_UDP_TUNNEL_CSUM on EF100
>   sfc: support GRE TSO on EF100
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] sfc: extend bitfield macros to 19 fields
    https://git.kernel.org/netdev/net-next/c/dc8d2512e697
  - [net-next,2/3] sfc: correctly support non-partial GSO_UDP_TUNNEL_CSUM on EF100
    https://git.kernel.org/netdev/net-next/c/42bfd69a9fdd
  - [net-next,3/3] sfc: support GRE TSO on EF100
    https://git.kernel.org/netdev/net-next/c/c5122cf58412

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


