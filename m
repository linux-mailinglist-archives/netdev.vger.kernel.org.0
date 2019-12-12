Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C90411C5D1
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 07:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbfLLGIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 01:08:23 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:54204 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726784AbfLLGIX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Dec 2019 01:08:23 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1ifHe9-0003qw-8Q; Thu, 12 Dec 2019 14:08:21 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1ifHe6-0002vB-W1; Thu, 12 Dec 2019 14:08:19 +0800
Date:   Thu, 12 Dec 2019 14:08:18 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, sfr@canb.auug.org.au
Subject: Re: [PATCH 1/2] crypto: arm/curve25519 - add arch-specific key
 generation function
Message-ID: <20191212060818.w4orbhieq66btymf@gondor.apana.org.au>
References: <20191211102455.7b55218e@canb.auug.org.au>
 <20191211092640.107621-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211092640.107621-1-Jason@zx2c4.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 10:26:39AM +0100, Jason A. Donenfeld wrote:
> Somehow this was forgotten when Zinc was being split into oddly shaped
> pieces, resulting in linker errors. The x86_64 glue has a specific key
> generation implementation, but the Arm one does not. However, it can
> still receive the NEON speedups by calling the ordinary DH function
> using the base point.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  arch/arm/crypto/curve25519-glue.c | 7 +++++++
>  1 file changed, 7 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
