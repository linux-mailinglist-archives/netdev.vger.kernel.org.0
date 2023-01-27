Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4903A67E1D1
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 11:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231968AbjA0KiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 05:38:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbjA0KiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 05:38:24 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A1A84B57
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 02:38:07 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pLM7A-004gW0-F3; Fri, 27 Jan 2023 18:37:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Jan 2023 18:37:48 +0800
Date:   Fri, 27 Jan 2023 18:37:48 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Christian Hopps <chopps@chopps.org>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>, devel@linux-ipsec.org,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        chopps@labn.net
Subject: Re: [PATCH ipsec-next v2] xfrm: fix bug with DSCP copy to v6 from v4
 tunnel
Message-ID: <Y9OpfMipCnPafoPL@gondor.apana.org.au>
References: <20230126102933.1245451-1-chopps@labn.net>
 <20230126163350.1520752-1-chopps@chopps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230126163350.1520752-1-chopps@chopps.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 26, 2023 at 11:33:50AM -0500, Christian Hopps wrote:
> When copying the DSCP bits for decap-dscp into IPv6 don't assume the
> outer encap is always IPv6. Instead, as with the inner IPv4 case, copy
> the DSCP bits from the correctly saved "tos" value in the control block.
> 
> Fixes: 227620e29509 ("[IPSEC]: Separate inner/outer mode processing on input")

Please fix this Fixes header as that commit did not introduce
this bug.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
