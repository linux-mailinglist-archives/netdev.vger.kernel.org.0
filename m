Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B050068CF3C
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 07:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbjBGGFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 01:05:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjBGGFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 01:05:11 -0500
Received: from formenos.hmeau.com (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F2EDEF99
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 22:05:09 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pPH5v-008MXH-M9; Tue, 07 Feb 2023 14:04:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 07 Feb 2023 14:04:43 +0800
Date:   Tue, 7 Feb 2023 14:04:43 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Hyunwoo Kim <v4bel@theori.io>
Cc:     steffen.klassert@secunet.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        imv4bel@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH] af_key: Fix heap information leak
Message-ID: <Y+Hp+0LzvScaUJV0@gondor.apana.org.au>
References: <20230204175018.GA7246@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230204175018.GA7246@ubuntu>
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,PDS_RDNS_DYNAMIC_FP,
        RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 04, 2023 at 09:50:18AM -0800, Hyunwoo Kim wrote:
> Since x->calg etc. are allocated with kmalloc, information
> in kernel heap can be leaked using netlink socket on
> systems without CONFIG_INIT_ON_ALLOC_DEFAULT_ON.
> 
> Signed-off-by: Hyunwoo Kim <v4bel@theori.io>
> ---
>  net/key/af_key.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Please explain exactly what is leaked and how.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
