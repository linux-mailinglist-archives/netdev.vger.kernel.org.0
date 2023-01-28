Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00F0767F3C7
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 02:39:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbjA1BjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 20:39:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjA1BjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 20:39:15 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD59A410A3
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 17:39:14 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pLaBC-004yfV-1T; Sat, 28 Jan 2023 09:38:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 28 Jan 2023 09:38:54 +0800
Date:   Sat, 28 Jan 2023 09:38:54 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Christian Hopps <chopps@chopps.org>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>, devel@linux-ipsec.org,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        chopps@labn.net
Subject: Re: [PATCH ipsec-next v3] xfrm: fix bug with DSCP copy to v6 from v4
 tunnel
Message-ID: <Y9R8rgir/JDh3hXt@gondor.apana.org.au>
References: <20230126102933.1245451-1-chopps@labn.net>
 <20230127225821.1909363-1-chopps@chopps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230127225821.1909363-1-chopps@chopps.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 05:58:20PM -0500, Christian Hopps wrote:
> When copying the DSCP bits for decap-dscp into IPv6 don't assume the
> outer encap is always IPv6. Instead, as with the inner IPv4 case, copy
> the DSCP bits from the correctly saved "tos" value in the control block.
> 
> Signed-off-by: Christian Hopps <chopps@labn.net>
> ---
>  net/xfrm/xfrm_input.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
