Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83A7811C5D9
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 07:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbfLLGIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 01:08:52 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:54236 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726784AbfLLGIw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Dec 2019 01:08:52 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1ifHec-0003t1-Po; Thu, 12 Dec 2019 14:08:50 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1ifHeb-0002vX-AV; Thu, 12 Dec 2019 14:08:49 +0800
Date:   Thu, 12 Dec 2019 14:08:49 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 1/2] crypto: arm/curve25519 - add arch-specific key
 generation function
Message-ID: <20191212060849.jwlpbg5m75xopq3d@gondor.apana.org.au>
References: <20191211102455.7b55218e@canb.auug.org.au>
 <20191211092640.107621-1-Jason@zx2c4.com>
 <CAKv+Gu80vONMAuv=2OpSOuZHvVv22quRxeNtbxnSkFBz_DvfbQ@mail.gmail.com>
 <CAHmME9r09=YNw1MmnzoRLA4szJ9zz-uV4Hut4dFZKHDwG8Qp6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9r09=YNw1MmnzoRLA4szJ9zz-uV4Hut4dFZKHDwG8Qp6A@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 01:07:43PM +0100, Jason A. Donenfeld wrote:
>
> Herbert - can you pick this up for 5.5-rc2 rather than 5.6?

Yes I'll be pushing this patch for 5.5.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
