Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DEC74B23E
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 08:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731065AbfFSGkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 02:40:39 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:39020 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725881AbfFSGkj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 02:40:39 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hdUGl-0003qn-Ho; Wed, 19 Jun 2019 14:40:31 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hdUGh-0005pC-Mx; Wed, 19 Jun 2019 14:40:27 +0800
Date:   Wed, 19 Jun 2019 14:40:27 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [v2] ipsec: select crypto ciphers for xfrm_algo
Message-ID: <20190619064027.qlvdfmohlp3zmtx6@gondor.apana.org.au>
References: <20190618112227.3322313-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190618112227.3322313-1-arnd@arndb.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 01:22:13PM +0200, Arnd Bergmann wrote:
> kernelci.org reports failed builds on arc because of what looks
> like an old missed 'select' statement:
> 
> net/xfrm/xfrm_algo.o: In function `xfrm_probe_algs':
> xfrm_algo.c:(.text+0x1e8): undefined reference to `crypto_has_ahash'
> 
> I don't see this in randconfig builds on other architectures, but
> it's fairly clear we want to select the hash code for it, like we
> do for all its other users. As Herbert points out, CRYPTO_BLKCIPHER
> is also required even though it has not popped up in build tests.
> 
> Fixes: 17bc19702221 ("ipsec: Use skcipher and ahash when probing algorithms")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  net/xfrm/Kconfig | 2 ++
>  1 file changed, 2 insertions(+)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
