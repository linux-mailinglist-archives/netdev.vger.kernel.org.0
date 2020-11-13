Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 886302B1496
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 04:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbgKMDQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 22:16:08 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:33140 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbgKMDQI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 22:16:08 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kdPZB-0007qa-7F; Fri, 13 Nov 2020 14:16:02 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 Nov 2020 14:16:01 +1100
Date:   Fri, 13 Nov 2020 14:16:01 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Srujana Challa <schalla@marvell.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        schandran@marvell.com, pathreya@marvell.com,
        Lukasz Bartosik <lbartosik@marvell.com>
Subject: Re: [PATCH v9,net-next,12/12] crypto: octeontx2: register with linux
 crypto framework
Message-ID: <20201113031601.GA27112@gondor.apana.org.au>
References: <20201109120924.358-1-schalla@marvell.com>
 <20201109120924.358-13-schalla@marvell.com>
 <20201111161039.64830a68@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201111161039.64830a68@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 04:10:39PM -0800, Jakub Kicinski wrote:
> On Mon, 9 Nov 2020 17:39:24 +0530 Srujana Challa wrote:
> > CPT offload module utilises the linux crypto framework to offload
> > crypto processing. This patch registers supported algorithms by
> > calling registration functions provided by the kernel crypto API.
> > 
> > The module currently supports:
> > - AES block cipher in CBC,ECB,XTS and CFB mode.
> > - 3DES block cipher in CBC and ECB mode.
> > - AEAD algorithms.
> >   authenc(hmac(sha1),cbc(aes)),
> >   authenc(hmac(sha256),cbc(aes)),
> >   authenc(hmac(sha384),cbc(aes)),
> >   authenc(hmac(sha512),cbc(aes)),
> >   authenc(hmac(sha1),ecb(cipher_null)),
> >   authenc(hmac(sha256),ecb(cipher_null)),
> >   authenc(hmac(sha384),ecb(cipher_null)),
> >   authenc(hmac(sha512),ecb(cipher_null)),
> >   rfc4106(gcm(aes)).
> 
> Herbert, could someone who knows about crypto take a look at this, 
> if the intention is to merge this via net-next?

This patch seems to be quite large but it is self-contained.  How
about waiting a release cycle and then resubmitting it to linux-crypto
on its own?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
