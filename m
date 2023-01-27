Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A53EF67E529
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 13:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234195AbjA0M2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 07:28:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234184AbjA0M1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 07:27:51 -0500
Received: from smtp.chopps.org (smtp.chopps.org [54.88.81.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AFAC4525B
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 04:27:23 -0800 (PST)
Received: from ja.int.chopps.org.chopps.org (172-222-091-149.res.spectrum.com [172.222.91.149])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by smtp.chopps.org (Postfix) with ESMTPSA id 115BC7D11E;
        Fri, 27 Jan 2023 12:27:21 +0000 (UTC)
References: <20230126102933.1245451-1-chopps@labn.net>
 <20230126163350.1520752-1-chopps@chopps.org>
 <Y9OpfMipCnPafoPL@gondor.apana.org.au>
User-agent: mu4e 1.8.13; emacs 28.2
From:   Christian Hopps <chopps@chopps.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Christian Hopps <chopps@chopps.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>, devel@linux-ipsec.org,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        chopps@labn.net
Subject: Re: [PATCH ipsec-next v2] xfrm: fix bug with DSCP copy to v6 from
 v4 tunnel
Date:   Fri, 27 Jan 2023 07:22:40 -0500
In-reply-to: <Y9OpfMipCnPafoPL@gondor.apana.org.au>
Message-ID: <m2sffw17ti.fsf@ja.int.chopps.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Herbert Xu <herbert@gondor.apana.org.au> writes:

> On Thu, Jan 26, 2023 at 11:33:50AM -0500, Christian Hopps wrote:
>> When copying the DSCP bits for decap-dscp into IPv6 don't assume the
>> outer encap is always IPv6. Instead, as with the inner IPv4 case, copy
>> the DSCP bits from the correctly saved "tos" value in the control block.
>>
>> Fixes: 227620e29509 ("[IPSEC]: Separate inner/outer mode processing on input")
>
> Please fix this Fixes header as that commit did not introduce
> this bug.

This was a suggested add from Eyal that I was initially hesitant to add. He justified it b/c this commit purported to add support for mixed versions and this is a bug in that new functionality. It is useful to have that tracked which is why I added it. Is there a better way to track that?

Thanks,
Chris.


