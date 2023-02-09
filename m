Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3740B6901F1
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 09:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjBIINI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 03:13:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjBIINH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 03:13:07 -0500
Received: from formenos.hmeau.com (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF98136FFD
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 00:13:01 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pQ22f-009CJV-Vp; Thu, 09 Feb 2023 16:12:31 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 09 Feb 2023 16:12:29 +0800
Date:   Thu, 9 Feb 2023 16:12:29 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Hyunwoo Kim <v4bel@theori.io>
Cc:     Sabrina Dubroca <sd@queasysnail.net>, steffen.klassert@secunet.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, imv4bel@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH] xfrm: Zero padding when dumping algos and encap
Message-ID: <Y+Sq7bgaDPsRSkPb@gondor.apana.org.au>
References: <20230204175018.GA7246@ubuntu>
 <Y+Hp+0LzvScaUJV0@gondor.apana.org.au>
 <20230208085434.GA2933@ubuntu>
 <Y+N4Q2B01iRfXlQu@gondor.apana.org.au>
 <Y+Oggx0YBA3kLLcw@hog>
 <Y+QriSfj3OYBj6J6@gondor.apana.org.au>
 <20230209053416.GA5032@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230209053416.GA5032@ubuntu>
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,PDS_RDNS_DYNAMIC_FP,
        RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 09:34:16PM -0800, Hyunwoo Kim wrote:
>
> Can the x->encap patch do this?

Yes I think it should be sufficient.

> Subject: [PATCH] af_key: Fix heap information leak
> 
> Since x->encap of pfkey_msg2xfrm_state() is not
> initialized to 0, kernel heap data can be leaked.
> 
> Fix with kzalloc() to prevent this.
> 
> Signed-off-by: Hyunwoo Kim <v4bel@theori.io>
> ---
>  net/key/af_key.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
