Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23613608433
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 06:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiJVEPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 00:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiJVEPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 00:15:37 -0400
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6775B17C148;
        Fri, 21 Oct 2022 21:15:36 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1om5uM-004uVi-GA; Sat, 22 Oct 2022 12:15:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 22 Oct 2022 12:15:26 +0800
Date:   Sat, 22 Oct 2022 12:15:26 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     eike-kernel@sf-tec.de, Thomas Graf <tgraf@suug.ch>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][Resend] rhashtable: make test actually random
Message-ID: <Y1NuXkvBzsK0d+Pv@gondor.apana.org.au>
References: <5894765.lOV4Wx5bFT@eto.sf-tec.de>
 <CAHmME9oHzopzm9PjpaYsLFujY5O+mdt0_NujUcpEp764CvGU8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9oHzopzm9PjpaYsLFujY5O+mdt0_NujUcpEp764CvGU8Q@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 21, 2022 at 09:52:56PM -0400, Jason A. Donenfeld wrote:
>
> Seems reasonable to me. If it's okay with Thomas, who you CC'd, I'd
> like to take this through my random tree, as that'll prevent it from
> conflicting with a series I have out currently:
> https://lore.kernel.org/lkml/20221022014403.3881893-1-Jason@zx2c4.com/

Sure, this code rarely changes so it should be fine to go through
your tree.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
