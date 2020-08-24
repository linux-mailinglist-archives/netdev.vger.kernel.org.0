Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79A1C24FF2E
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 15:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbgHXNli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 09:41:38 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:58388 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727107AbgHXNgA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 09:36:00 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kACca-0006ak-7V; Mon, 24 Aug 2020 23:34:49 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 24 Aug 2020 23:34:48 +1000
Date:   Mon, 24 Aug 2020 23:34:48 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Eric Biggers <ebiggers@google.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH v2 7/7] crypto: arc4 - mark ecb(arc4) skcipher as obsolete
Message-ID: <20200824133448.GA5019@gondor.apana.org.au>
References: <20200824133001.9546-1-ardb@kernel.org>
 <20200824133001.9546-8-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824133001.9546-8-ardb@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 24, 2020 at 03:30:01PM +0200, Ard Biesheuvel wrote:
>
> +config CRYPTO_USER_ENABLE_OBSOLETE
> +	bool "Enable obsolete cryptographic algorithms for userspace"
> +	depends on CRYPTO_USER

That should be CRYPTO_USER_API which is the option for af_alg.
CRYPTO_USER is the configuration interface which has nothing to
do with af_alg.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
