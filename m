Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB1E284D64
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 16:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726235AbgJFONf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 10:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbgJFONf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 10:13:35 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC02C061755;
        Tue,  6 Oct 2020 07:13:35 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601993613;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7bNY+7IvY0BxuXZP41nveX41kn9y9lBubZMrI95BJDw=;
        b=wmnQ+MBlRG1wCrfkMbT4goA4tzmuYFobKthzI5UI5WecDvDhvhhP5HcmkBJIVaRR9D5q75
        7nMN/A4Hz1EfWGyV2Kt7ppcuXFhPdXXWcdlVPEcXPIZqlS4tDRNN2JhOFd138MzyWJaTKs
        YvLo43AH/s71DohKaOt2dW+oxGyn2NBjX3d9pGDmI0O+FJnYh52IEGkPwospjcXqKPPPKC
        7nPDvVjnHaRE/CJFpGKnf4gCzqWw3w1ms7UC1to0ZW0fS/tUG4hmonMbwIne0epyIj6jOa
        rcJHW31HLmYz+fhufJkqg3IyAaVY/B7EjEWD/tbkJJDEsmmvUBaBSYJ7INCE0Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601993613;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7bNY+7IvY0BxuXZP41nveX41kn9y9lBubZMrI95BJDw=;
        b=m7+uMS1oe6DwOJM+nddhZqga2mpNKFTwCCu7FzkKjWRk7r6ovh6PFSg8HdUaq7V+u6sTUf
        YYx1gZvHYlhn2zAw==
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next v6 2/7] net: dsa: Add DSA driver for Hirschmann Hellcreek switches
In-Reply-To: <20201006135631.73rm3gka7r7krwca@skbuf>
References: <20201004112911.25085-1-kurt@linutronix.de> <20201004112911.25085-3-kurt@linutronix.de> <20201004125601.aceiu4hdhrawea5z@skbuf> <87lfgj997g.fsf@kurt> <20201006092017.znfuwvye25vsu4z7@skbuf> <878scj8xxr.fsf@kurt> <20201006113237.73rzvw34anilqh4d@skbuf> <87wo037ajr.fsf@kurt> <20201006135631.73rm3gka7r7krwca@skbuf>
Date:   Tue, 06 Oct 2020 16:13:32 +0200
Message-ID: <87lfgj788j.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Tue Oct 06 2020, Vladimir Oltean wrote:
> On Tue, Oct 06, 2020 at 03:23:36PM +0200, Kurt Kanzenbach wrote:
>> So you're saying private VLANs can be used but the user or the other
>> kernel modules shouldn't be allowed to use them to simplify the
>> implementation?  Makes sense to me.
>
> It would be interesting to see if you could simply turn off VLAN
> awareness in standalone mode, and still use unique pvids per port.
> Then you would have no further restriction for VLAN-tagged traffic with
> unknown VLANs or with 8021q uppers having the same VLAN ID on multiple
> ports.

True. That needs to be tested.


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl98e4wACgkQeSpbgcuY
8KaZCQ//fEuJwtN8fFzqEN7r+5f9ZA9tPoXweRGEyzHT2LG2xT5vIJb7Fo66VDjG
/LLMsUVewzZpxQZY6ZUGCDFmoA4wrs331GElmEkUbOgogS4V3G+nYRV3MXlPnh5A
HySW5gIBQTVBJqvAbOz4UU1dbEuogA9Wm2iwOWglbuXnOM7LGbZ4Np3grguoJX+6
HRsm6Hhycuun6c3MEqtQyyAvMu1odnMm0Yc1+t9kb76zu5Fp8CsuS5/YKK12Feed
Q+y7AhjmrsSyINUoIIk8aS0cr9VWzdHexOFFvvzueQpI4Saz8sutch1i8cyV7/YQ
iobtox0bq8HBLox4AaxpRMQ3vOjbiyazoeOuzIKc4q5B8z9PTqi8pxihCtp33cmp
adIyB2hGBeJuwxFAR4HVmA+SgCx8y+I0+hs+nzFl4JkzI6Z5FikaacvHasoTsB5c
mSL2iXTUmqgDcXKDed28R0TZd7Zil40iKpp6j2FUjGd5/6pDGReZSYOiNFzBvSNh
+eJVCQupiFy/247SzIyz5wbXcHV9yQ/YHFwDomT1dMwlIRAW5DwaM0y4HGXwPbLc
Q/V0yrqAytbAcdlME+gz8ORh949hObvxy2KhMYwGKkaImcwpMKTpf5cwPpW/fDTy
qoCHdZUMmg6dBu9q+UxB4GEG7QZg9wzDbN/y4seJi60s5xo6USk=
=5PxH
-----END PGP SIGNATURE-----
--=-=-=--
