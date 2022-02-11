Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2064B22A2
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 11:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236561AbiBKJ7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 04:59:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231577AbiBKJ7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 04:59:40 -0500
X-Greylist: delayed 1346 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 11 Feb 2022 01:59:39 PST
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB5B1A6
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 01:59:39 -0800 (PST)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nISMY-0004VI-5e; Fri, 11 Feb 2022 20:37:11 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Feb 2022 20:37:10 +1100
Date:   Fri, 11 Feb 2022 20:37:10 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ayush Sawal <ayush.sawal@chelsio.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        secdev@chelsio.com
Subject: Re: [PATCH V2] MAINTAINERS: Update maintainers for chelsio crypto
 drivers
Message-ID: <YgYuRuc8vOLjsUup@gondor.apana.org.au>
References: <20220204084736.105975-1-ayush.sawal@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204084736.105975-1-ayush.sawal@chelsio.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 04, 2022 at 02:17:36PM +0530, Ayush Sawal wrote:
> This updates the maintainer info for chelsio crypto drivers.
> 
> V2:
> This updates the maintainers for CXGB4 INLINE CRYPTO DRIVER.
> 
> Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
> ---
>  MAINTAINERS | 2 --
>  1 file changed, 2 deletions(-)

If this is supposed to go through the crypto tree you need to
cc the crypto list.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
