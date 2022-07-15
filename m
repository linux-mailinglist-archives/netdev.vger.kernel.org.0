Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63A05575DFC
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 11:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbiGOIuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 04:50:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbiGOIug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 04:50:36 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 035DB820EC;
        Fri, 15 Jul 2022 01:50:36 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oCH1r-000o2I-Up; Fri, 15 Jul 2022 18:50:33 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 Jul 2022 16:50:32 +0800
Date:   Fri, 15 Jul 2022 16:50:32 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jason@zx2c4.com
Subject: Re: [PATCH 0/2] crypto: make the sha1 library optional
Message-ID: <YtEqWH2JzolCfLRA@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220709211849.210850-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> wrote:
> This series makes it possible to build the kernel without SHA-1 support,
> although for now this is only possible in minimal configurations, due to
> the uses of SHA-1 in the networking subsystem.
> 
> Eric Biggers (2):
>  crypto: move lib/sha1.c into lib/crypto/
>  crypto: make the sha1 library optional
> 
> crypto/Kconfig          | 1 +
> init/Kconfig            | 1 +
> lib/Makefile            | 2 +-
> lib/crypto/Kconfig      | 3 +++
> lib/crypto/Makefile     | 3 +++
> lib/{ => crypto}/sha1.c | 0
> net/ipv6/Kconfig        | 1 +
> 7 files changed, 10 insertions(+), 1 deletion(-)
> rename lib/{ => crypto}/sha1.c (100%)
> 
> 
> base-commit: 79e6e2f3f3ff345947075341781e900e4f70db81

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
