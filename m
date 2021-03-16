Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41CAA33CC63
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 05:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbhCPEAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 00:00:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:59102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229453AbhCPEAK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 00:00:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1FDD4650C7;
        Tue, 16 Mar 2021 04:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615867209;
        bh=KGSgRfU/N6uHuUpWojH9qkORMrV3M4wCflYthtdT/A8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=K1gRlAttkYVVoKAueIMytMpN2agK7DkvVQHH7W/8blHipwFYdxG8LpdkKr3Te4uZB
         sQw6WKWzEjY3bVKF+vVbTO0IuCwZhEDJ7d1mxjUEe1rT+sk8SCVpFmSqVZ4rRnWGpw
         lBGC/UYJfaK7CtQJHQJEVkvvf544k1yFRRjjYIx6PNp2HhsEzaep+/SofJyncI2wU+
         R1Ta2k1hDgUFFciIAcvHlcoJZygX2aO/Lgr+1su0qiXfdqgOA6k5s6pG3vLbalqL8+
         ctnqP6Mty2tdS9o4fBBxs2ZldP/TWHvwvtIIoeu8GJqR68YKblxDkcwVwoEJdZWNVu
         A+Gk3wB+xoErw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0E4F060A19;
        Tue, 16 Mar 2021 04:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v6 0/6] net: qualcomm: rmnet: stop using C bit-fields
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161586720905.24109.6660626124396276259.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Mar 2021 04:00:09 +0000
References: <20210315215151.3029676-1-elder@linaro.org>
In-Reply-To: <20210315215151.3029676-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, sharathv@codeaurora.org,
        bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, David.Laight@ACULAB.COM,
        olteanv@gmail.com, alexander.duyck@gmail.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 15 Mar 2021 16:51:45 -0500 you wrote:
> Version 6 is the same as version 5, but has been rebased on updated
> net-next/master.  With any luck, the patches I'm sending out this
> time won't contain garbage.
> 
> Version 5 of this series responds to a suggestion made by Alexander
> Duyck, to determine the offset to the checksummed range of a packet
> using skb_network_header_len() on patch 2.  I have added his
> Reviewed-by tag to all (other) patches, and removed Bjorn's from
> patch 2.
> 
> [...]

Here is the summary with links:
  - [net-next,v6,1/6] net: qualcomm: rmnet: mark trailer field endianness
    https://git.kernel.org/netdev/net-next/c/45f3a13c8166
  - [net-next,v6,2/6] net: qualcomm: rmnet: simplify some byte order logic
    https://git.kernel.org/netdev/net-next/c/50c62a111c48
  - [net-next,v6,3/6] net: qualcomm: rmnet: kill RMNET_MAP_GET_*() accessor macros
    https://git.kernel.org/netdev/net-next/c/9d131d044f89
  - [net-next,v6,4/6] net: qualcomm: rmnet: use masks instead of C bit-fields
    https://git.kernel.org/netdev/net-next/c/16653c16d282
  - [net-next,v6,5/6] net: qualcomm: rmnet: don't use C bit-fields in rmnet checksum trailer
    https://git.kernel.org/netdev/net-next/c/cc1b21ba6251
  - [net-next,v6,6/6] net: qualcomm: rmnet: don't use C bit-fields in rmnet checksum header
    https://git.kernel.org/netdev/net-next/c/86ca860e12ec

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


