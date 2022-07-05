Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3A08566268
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 06:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbiGEE33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 00:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbiGEE32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 00:29:28 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1382117B;
        Mon,  4 Jul 2022 21:29:26 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1o8aBK-00EVKV-7S; Tue, 05 Jul 2022 14:29:03 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 05 Jul 2022 12:29:02 +0800
Date:   Tue, 5 Jul 2022 12:29:02 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Taehee Yoo <ap420073@gmail.com>, linux-crypto@vger.kernel.org,
        davem@davemloft.net, borisp@nvidia.com, john.fastabend@gmail.com,
        daniel@iogearbox.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 3/3] net: tls: Add ARIA-GCM algorithm
Message-ID: <YsO+DmGe7LdGUmUE@gondor.apana.org.au>
References: <20220704094250.4265-1-ap420073@gmail.com>
 <20220704094250.4265-4-ap420073@gmail.com>
 <20220704201009.34fb8aa8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220704201009.34fb8aa8@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 04, 2022 at 08:10:09PM -0700, Jakub Kicinski wrote:
>
> Is it okay if you send the crypto patches now and the TLS support after
> the merge window? They go via different trees and we can't take the TLS
> patches until we get the crypto stuff in net-next. We could work
> something out and create a stable branch that both Herbert and us would
> pull but we're getting close to the merge window, perhaps we can just
> wait?

I need to know that you guys will take the network part of the
patch in order to accept the crypto part.  We don't add algorithms
with no in-kernel users.

As long as you are happy to take the TLS part later, we can add
the crypto parts right now.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
