Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15C3B3AC1FE
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 06:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232059AbhFREZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 00:25:20 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:40149 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231867AbhFREZL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 00:25:11 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 4G5m4Q0RS0z9shn; Fri, 18 Jun 2021 14:23:01 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Geoff Levand <geoff@infradead.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        "David S. Miller" <davem@davemloft.net>
In-Reply-To: <cover.1622746428.git.geoff@infradead.org>
References: <cover.1622746428.git.geoff@infradead.org>
Subject: Re: [PATCH v2 0/3] DMA fixes for PS3 device drivers
Message-Id: <162398828712.1363949.1881698849429388448.b4-ty@ellerman.id.au>
Date:   Fri, 18 Jun 2021 13:51:27 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 03 Jun 2021 19:16:56 +0000, Geoff Levand wrote:
> This is a set of patches that fix various DMA related problems in the PS3
> device drivers, and add better error checking and improved message logging.
> 
> Changes from V1:
>   Split the V1 series into two, one series with powerpc changes, and one series
>   with gelic network driver changes.
> 
> [...]

Applied to powerpc/next.

[1/3] powerpc/ps3: Add CONFIG_PS3_VERBOSE_RESULT option
      https://git.kernel.org/powerpc/c/6caebff168235b6102e5dc57cb95a2374301720a
[2/3] powerpc/ps3: Warn on PS3 device errors
      https://git.kernel.org/powerpc/c/472b440fd26822c645befe459172dafdc2d225de
[3/3] powerpc/ps3: Add dma_mask to ps3_dma_region
      https://git.kernel.org/powerpc/c/9733862e50fdba55e7f1554e4286fcc5302ff28e

cheers
