Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96DF742C4F5
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 17:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233962AbhJMPmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 11:42:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:46394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229653AbhJMPmY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 11:42:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24B40610A0;
        Wed, 13 Oct 2021 15:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634139621;
        bh=vdmLIATwugYFRxhd0ViKjIyMu7ds79gJzqh8mfaqG1M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eGl+RV9H16Qt89nGVCKbFu9Xw6wcHaDjcMmJFOc+kGGuURR1rF8sZsVVoUPuq2bPH
         Tq1q7m115c/t9kbhmqYTX9G408n99YVLnR2Eesbd5ssu0rSk3HYxNWGQeaUnBWzUcH
         DnT8aQne4C5WUy2XTiry2RP4O6LrqyT7PkVEvRWDDlBFXZr2NRY2BHJu35nEVZx68A
         z9vIMa2UnQbT1tD4P4CdKU1AJ0yPQ6i7QexqUzj+f+FNBXIvaQKDotBBTfTMz3O2b5
         VdAxEBSn3fiHk6K/n/BrO++4+hMsNIhgvP62b3GI1iAMCEBEygU7HMgR8FZb76esTf
         CHrde3LiZAIWg==
Date:   Wed, 13 Oct 2021 08:40:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Anders Roxell <anders.roxell@linaro.org>
Cc:     bbrezillon@kernel.org, arno@natisbad.org, schalla@marvell.com,
        sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        hkelam@marvell.com, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] include: marvell: octeontx2: build error: unknown type
 name 'u64'
Message-ID: <20211013084020.44352ee0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211013135743.3826594-1-anders.roxell@linaro.org>
References: <20211013135743.3826594-1-anders.roxell@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Oct 2021 15:57:43 +0200 Anders Roxell wrote:
> Building an allmodconfig kernel arm64 kernel, the following build error
> shows up:
> 
> In file included from drivers/crypto/marvell/octeontx2/cn10k_cpt.c:4:
> include/linux/soc/marvell/octeontx2/asm.h:38:15: error: unknown type name 'u64'
>    38 | static inline u64 otx2_atomic64_fetch_add(u64 incr, u64 *ptr)
>       |               ^~~
> 
> Include linux/types.h in asm.h so the compiler knows what the type
> 'u64' are.
> 
> Fixes: af3826db74d1 ("octeontx2-pf: Use hardware register for CQE count")
> Signed-off-by: Anders Roxell <anders.roxell@linaro.org>

Yes, please! I've been carrying same patch locally. Any expectations on
who should apply the patch? I'm gonna send a PR with networking fixes
to Linus tomorrow, happy to take it via netdev if that's okay.
