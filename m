Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD7F1F4A8B
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 03:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgFJBBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 21:01:05 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:59166 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbgFJBBE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jun 2020 21:01:04 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jip6z-0007gj-93; Wed, 10 Jun 2020 11:01:02 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 10 Jun 2020 11:01:01 +1000
Date:   Wed, 10 Jun 2020 11:01:01 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH net v3 2/3] esp: select CRYPTO_SEQIV
Message-ID: <20200610010101.GB6380@gondor.apana.org.au>
References: <20200610005402.152495-1-ebiggers@kernel.org>
 <20200610005402.152495-3-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200610005402.152495-3-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 09, 2020 at 05:54:01PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Commit f23efcbcc523 ("crypto: ctr - no longer needs CRYPTO_SEQIV") made
> CRYPTO_CTR stop selecting CRYPTO_SEQIV.  This breaks IPsec for most
> users since GCM and several other encryption algorithms require "seqiv"
> -- and RFC 8221 lists AES-GCM as "MUST" be implemented.
> 
> Just make XFRM_ESP select CRYPTO_SEQIV.
> 
> Fixes: f23efcbcc523 ("crypto: ctr - no longer needs CRYPTO_SEQIV") made
> Cc: Corentin Labbe <clabbe@baylibre.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  net/xfrm/Kconfig | 1 +
>  1 file changed, 1 insertion(+)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
