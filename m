Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47175399A0F
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 07:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbhFCFkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 01:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbhFCFkF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 01:40:05 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A4D0C06174A
        for <netdev@vger.kernel.org>; Wed,  2 Jun 2021 22:38:21 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FwZS84Lsqz9s5R;
        Thu,  3 Jun 2021 15:38:13 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1622698697;
        bh=3AA8l6yeF1h/KUuaHmWbe9gUXxJyUVXFfeXx8HjmGQE=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Ri6vmcSojt5p7c+qOa5cNadd2YfB9oNFrJH2Hk5I3J3zSysvt2wHL+M8po3Km5R6E
         eGA2K+9lHQdWtriADk1a3+qg1McbOVc7EiRqc/+CYr07GZyfSTTHDlYF+VU8XDk6aj
         P+iaxdSJkV1eBzjEUwbi058opC91kM8dWlzkGf0gmNTIZUQAihq3HROdmqxKH2zzO0
         T/zdAUeo7+xgc2tzpBEzrd5x6bsYauijTuiM+tFk9h81y4Gyxr5s+ozEwkZM0RdShh
         gVvYOsi1Uf8sAVLoFTUbpuq5QrJqHKGE2rosz0Xf3Soyt1Lt2pb78yFqf3pzl4RGvZ
         U4pSA5FOItPHg==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Geoff Levand <geoff@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/5] DMA fixes for PS3 device drivers
In-Reply-To: <cover.1622577339.git.geoff@infradead.org>
References: <cover.1622577339.git.geoff@infradead.org>
Date:   Thu, 03 Jun 2021 15:38:13 +1000
Message-ID: <875yyvh5iy.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Geoff Levand <geoff@infradead.org> writes:
> Hi,
>
> This is a set of patches that fix various DMA related problems in the PS3
> device drivers, and add better error checking and improved message logging.
>
> The gelic network driver had a number of problems and most of the changes are
> in it's sources.
>
> Please consider.

Who are you thinking would merge this?

It's sort of splattered all over the place, but is mostly networking by
lines changed.

Maybe patches 3-5 should go via networking and I take 1-2?

cheers


> The following changes since commit 8124c8a6b35386f73523d27eacb71b5364a68c4c:
>
>   Linux 5.13-rc4 (2021-05-30 11:58:25 -1000)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/geoff/ps3-linux.git for-merge-gelic
>
> for you to fetch changes up to 4adcfc9735bf8d1987d2bc82e914be154f2ffad8:
>
>   net/ps3_gelic: Cleanups, improve logging (2021-06-01 12:27:43 -0700)
>
> ----------------------------------------------------------------
> Geoff Levand (5):
>       powerpc/ps3: Add CONFIG_PS3_VERBOSE_RESULT option
>       powerpc/ps3: Warn on PS3 device errors
>       powerpc/ps3: Add dma_mask to ps3_dma_region
>       net/ps3_gelic: Add gelic_descr structures
>       net/ps3_gelic: Cleanups, improve logging
>
>  arch/powerpc/include/asm/ps3.h               |   4 +-
>  arch/powerpc/platforms/ps3/Kconfig           |   9 +
>  arch/powerpc/platforms/ps3/mm.c              |  12 +
>  arch/powerpc/platforms/ps3/system-bus.c      |   9 +-
>  drivers/net/ethernet/toshiba/ps3_gelic_net.c | 968 +++++++++++++++------------
>  drivers/net/ethernet/toshiba/ps3_gelic_net.h |  24 +-
>  drivers/ps3/ps3-vuart.c                      |   2 +-
>  drivers/ps3/ps3av.c                          |  22 +-
>  8 files changed, 598 insertions(+), 452 deletions(-)
>
> -- 
> 2.25.1
