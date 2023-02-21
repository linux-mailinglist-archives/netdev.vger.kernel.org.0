Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA6069DA06
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 05:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbjBUEFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 23:05:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232686AbjBUEFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 23:05:41 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08CE13D6A
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 20:05:39 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pUJuA-00Dmae-Ek; Tue, 21 Feb 2023 12:05:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 21 Feb 2023 12:05:26 +0800
Date:   Tue, 21 Feb 2023 12:05:26 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     David George <David.George@sophos.com>
Cc:     Sri Sakthi <srisakthi.s@gmail.com>,
        "steffen.klassert@secunet.com" <steffen.klassert@secunet.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Srisakthi Subramaniam <Srisakthi.Subramaniam@sophos.com>,
        Vimal Agrawal <Vimal.Agrawal@sophos.com>
Subject: Re: xfrm: Pass on correct AF value to xfrm_state_find
Message-ID: <Y/RDBnFoROo5+xcm@gondor.apana.org.au>
References: <CA+t5pP=6E4RvKiPdS4fm_Z2M2BLKPkd6jewtF0Y_Ci_w-oTb+w@mail.gmail.com>
 <Y+8Pg5JzOBntLcWA@gondor.apana.org.au>
 <CA+t5pP=NRQUax5ogB32dZN74Mk2qq_ZY7OgNro8JmckVkQsQyw@mail.gmail.com>
 <Y+861os+ZbBWVvvi@gondor.apana.org.au>
 <LO0P265MB604061D3617058B2B07D534CE0A49@LO0P265MB6040.GBRP265.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <LO0P265MB604061D3617058B2B07D534CE0A49@LO0P265MB6040.GBRP265.PROD.OUTLOOK.COM>
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,HELO_DYNAMIC_IPADDR2,
        PDS_RDNS_DYNAMIC_FP,RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 20, 2023 at 11:28:07AM +0000, David George wrote:
>
> This doesn't work on transport SAs as I mentioned (see __xfrm_init_state()).

OK I wasn't aware of this.  This definitely looks buggy.  We need
to fix this bogus check.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
