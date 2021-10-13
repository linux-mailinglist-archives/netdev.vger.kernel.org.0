Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3063D42CAEC
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 22:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhJMU3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 16:29:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:51316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229462AbhJMU3N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 16:29:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9572260ED4;
        Wed, 13 Oct 2021 20:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634156825;
        bh=WzPpCqbIaU8Yjzurw6WdxtOLIiYPLLjEr2x0eJGm70M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c25QnCbpiya+dme+pIyczl7QnqiZLi71xvWE2MS/gSUhL6LlnphZVcuzTdhtGLKMD
         47D6mLpAKPVWKopu1WiTP/Cn50z0/FSU+SolVAvEjwHWFME1q4W9MnJqqJfS3XSCK9
         t2+linuqGz7AxmJpxLyro11CORnAYRjlnieWx7NDSSg9Pnmb1EgY3oiQIz2WQ3zX+w
         W06/FEONbknB47+2KsV1mLBSidI4to7gVixyzIfhNVL4TCzFHAFoNYBPOYVpATiMsE
         aKztnmbpbEjXNBbuJuM3Yt+PDLUdye9sRdajbiClAP9Lq6b+XQhiW4q31nH+kzWwIp
         eCgVzY7vtMtEw==
Date:   Wed, 13 Oct 2021 13:27:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Anders Roxell <anders.roxell@linaro.org>
Cc:     bbrezillon@kernel.org, arno@natisbad.org, schalla@marvell.com,
        sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        hkelam@marvell.com, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] include: marvell: octeontx2: build error: unknown type
 name 'u64'
Message-ID: <20211013132704.75fa98ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211013084020.44352ee0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211013135743.3826594-1-anders.roxell@linaro.org>
        <20211013084020.44352ee0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Oct 2021 08:40:20 -0700 Jakub Kicinski wrote:
> On Wed, 13 Oct 2021 15:57:43 +0200 Anders Roxell wrote:
> > Building an allmodconfig kernel arm64 kernel, the following build error
> > shows up:
> > 
> > In file included from drivers/crypto/marvell/octeontx2/cn10k_cpt.c:4:
> > include/linux/soc/marvell/octeontx2/asm.h:38:15: error: unknown type name 'u64'
> >    38 | static inline u64 otx2_atomic64_fetch_add(u64 incr, u64 *ptr)
> >       |               ^~~
> > 
> > Include linux/types.h in asm.h so the compiler knows what the type
> > 'u64' are.
> > 
> > Fixes: af3826db74d1 ("octeontx2-pf: Use hardware register for CQE count")
> > Signed-off-by: Anders Roxell <anders.roxell@linaro.org>  
> 
> Yes, please! I've been carrying same patch locally. Any expectations on
> who should apply the patch? I'm gonna send a PR with networking fixes
> to Linus tomorrow, happy to take it via netdev if that's okay.

I realized the breakage only exists in net-next so applied 
the fix there. Thanks!
