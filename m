Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCE94B48C4
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 10:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730086AbfIQIIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 04:08:18 -0400
Received: from kadath.azazel.net ([81.187.231.250]:41648 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728126AbfIQIIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 04:08:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=gZKi6+ZUItRY1/oiPj+n4pc1jyqCcF37HUzaNXju3yw=; b=NkDeEFeUa9jULjCQikgCtLQkli
        fjH55J+i6MbA/BelO9RZDRU76bO8hAZrbuxYOJPsgHisPdYHYzvp3UQ9bVVZPGrHaBdRPN1q/U77/
        p52sapewD6zqG9+el3W1x5ojNpJ7Y49pPsScCHO8KDD2YxsiAJiXoG3kv7eq0BgWLNa8EeELLgGym
        8HlJFEp4LDten9Awe8Uyej9drHx04C+PmLx1NYftXexkHerlYpE7216RYecM3HeQ1ZEStZcEcUIdT
        DNJg8uFwV8Xp2akPpu4zTR9uHwrelWN8ZwI8Jo45NjSqcd8BGwsQXMG5kPXK5ew1yFjcepF9rUknd
        0CUdWFrA==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iA8Wx-0000yM-Ao; Tue, 17 Sep 2019 09:08:11 +0100
Date:   Tue, 17 Sep 2019 09:08:10 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Adam Borowski <kilobyte@angband.pl>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: bridge: drop a broken include
Message-ID: <20190917080809.GB29776@azazel.net>
References: <20190916000517.45028-1-kilobyte@angband.pl>
 <20190916130811.GA29776@azazel.net>
 <20190917050946.kmzajvqh3kjr4ch5@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="XOIedfhf+7KOe/yw"
Content-Disposition: inline
In-Reply-To: <20190917050946.kmzajvqh3kjr4ch5@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--XOIedfhf+7KOe/yw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2019-09-17, at 07:09:46 +0200, Pablo Neira Ayuso wrote:
> On Mon, Sep 16, 2019 at 02:08:12PM +0100, Jeremy Sowden wrote:
> > On 2019-09-16, at 02:05:16 +0200, Adam Borowski wrote:
> > > This caused a build failure if CONFIG_NF_CONNTRACK_BRIDGE is set but
> > > CONFIG_NF_TABLES=n -- and appears to be unused anyway.
> [...]
> > There are already changes in the net-next tree that will fix it.
>
> If the fix needs to go to -stable 5.3 kernel release, then you have to
> point to the particular commit ID of this patch to fix this one.
> net-next contains 5.4-rc material. I'd appreciate also if you can help
> identify the patch with a Fixes: tag.

Yup, will do.

J.

--XOIedfhf+7KOe/yw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl2AlEEACgkQ0Z7UzfnX
9sN4FhAAs8izAczjcPdPRP1qxg6nCZmnN1mB84VCINEFtdjFD1yLCVxp2+BxGsxm
MYn8IfJ5K4skIxXsT2AMGfa4dVagCS+iWiKhzfoN7jhQIOaH1Yi7mJpI1Rii2lDA
CwJ8Dcm4qZCP3yJvu8PF6jtqbZZzktBMHoPvhgKJwrRtyjr0ap18BRtw1bc7sUBj
iUBZbneLnIqWg8njv/6Yu7PK8k341Ei6D9VujgqqsXrdt2dWXNR9uO/0t0G5EOmn
EbUaYwt1NUg5fP4gqYnc0DrirBw64+J7yuvw58zheCQX0z057siz585dC4XaxJpe
7CcrJFlvwLrjLva7B5xXqwgUEb/HbD1VUQWYiHHxyMr0DrBep+Vc7YMr8Bt1n+Gz
cgQI3lf1aJXL1u1SsbebiWNH1aeupUlGA7mBVNZQpuOSs7jxsVR3OuMGZzsOVV4j
dWFI7bHU5L847xeIQ8OciZvUqY0Dbvyp0sBLCrExcfApE/nIl4dsH5YxPuED0SGL
At/8Z3Td0F6GG9WZCL1zq+HRDf2t8vK2UczAN0FnngqpwSaytuqcUyhIsZwmraPb
XMxNLCvCMlPi5XGgejdjZBPx1uN703IR8ObjnCP6UMsy0Hd8Yh7BiSPeu711KB8k
qpYadp75hgizh/oZNVMN+0FKfFqI7bJvl5gLgFoPg4qci1yqzdY=
=Q6zo
-----END PGP SIGNATURE-----

--XOIedfhf+7KOe/yw--
