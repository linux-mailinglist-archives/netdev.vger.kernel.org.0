Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD2FE60842F
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 06:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbiJVEOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 00:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbiJVEOs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 00:14:48 -0400
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B691B7BA;
        Fri, 21 Oct 2022 21:14:43 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1om5tU-004uUP-Ft; Sat, 22 Oct 2022 12:14:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 22 Oct 2022 12:14:32 +0800
Date:   Sat, 22 Oct 2022 12:14:32 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc:     Thomas Graf <tgraf@suug.ch>, Florian Westphal <fw@strlen.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH][Resend] rhashtable: make test actually random
Message-ID: <Y1NuKJ7iIey450tn@gondor.apana.org.au>
References: <5894765.lOV4Wx5bFT@eto.sf-tec.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5894765.lOV4Wx5bFT@eto.sf-tec.de>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 21, 2022 at 03:47:03PM +0200, Rolf Eike Beer wrote:
> The "random rhlist add/delete operations" actually wasn't very random, as all
> cases tested the same bit. Since the later parts of this loop depend on the
> first case execute this unconditionally, and then test on different bits for the
> remaining tests. While at it only request as much random bits as are actually
> used.
> 
> Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
> ---
>  lib/test_rhashtable.c | 58 ++++++++++++++++---------------------------
>  1 file changed, 22 insertions(+), 36 deletions(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
