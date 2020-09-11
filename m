Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C60D265864
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 06:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725616AbgIKEga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 00:36:30 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:58514 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725468AbgIKEg3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 00:36:29 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kGamq-0006L6-JW; Fri, 11 Sep 2020 14:35:49 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Sep 2020 14:35:48 +1000
Date:   Fri, 11 Sep 2020 14:35:48 +1000
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
Subject: Re: [PATCH v3 7/7] crypto: arc4 - mark ecb(arc4) skcipher as obsolete
Message-ID: <20200911043548.GA5677@gondor.apana.org.au>
References: <20200831151649.21969-1-ardb@kernel.org>
 <20200831151649.21969-8-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200831151649.21969-8-ardb@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 31, 2020 at 06:16:49PM +0300, Ard Biesheuvel wrote:
>
> @@ -12,6 +12,7 @@
>  #include <crypto/internal/skcipher.h>
>  #include <linux/init.h>
>  #include <linux/module.h>
> +#include <linux/sched.h>

This needs kernel.h too for the pr_warn_ratelimited.  I'll add
it when I apply the series.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
