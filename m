Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5375486B28
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 22:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404514AbfHHUKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 16:10:47 -0400
Received: from kadath.azazel.net ([81.187.231.250]:39856 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404505AbfHHUKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 16:10:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=oupiFS6tcEXohv573seS8h77QHXcH4NQjg9LtVsFxPk=; b=A28VPHlbLXz6ryks3UQ0fF6VMw
        qf97dQPLdML4tWPJ6puO+2n+XT8lYz08E3Qb9oZUP6Kr/d+O4HDbpLdsSBsfo0Hav6T4M9u8qwFkt
        SwojWvrZj+npCkZbROuFWs4AaroKPoSTfev+L/CHaLiuqvBGZ5FR5Jz+unU9MPVYUxYLOaC3C9d2n
        d+1mVeid/3ZtHW1zD2BYk2Sqs6NCcoVaN9DfbOYOu3Va7oqMv4lemnapqsGb3affEp6c8TJ7M3wFg
        oQmqqxxVS92U7BXy7hl24VqW/uw3eodnlyOiJefi5wsD7S4eTtK2gUvIQc+oZ9lmefN4uv40aqK+f
        4GE7KxLQ==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:5ec5:d4ff:fe95:cee6] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1hvokG-0000L8-4Y; Thu, 08 Aug 2019 21:10:44 +0100
Date:   Thu, 8 Aug 2019 21:10:43 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Net Dev <netdev@vger.kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: Re: [PATCH net-next v1 1/8] netfilter: inlined four headers files
 into another one.
Message-ID: <20190808201042.GA4299@azazel.net>
References: <20190722201615.GE23346@azazel.net>
 <20190807141705.4864-1-jeremy@azazel.net>
 <20190807141705.4864-2-jeremy@azazel.net>
 <20190808112355.w3ax3twuf6b7pwc7@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
In-Reply-To: <20190808112355.w3ax3twuf6b7pwc7@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:5ec5:d4ff:fe95:cee6
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2019-08-08, at 13:23:55 +0200, Pablo Neira Ayuso wrote:
> On Wed, Aug 07, 2019 at 03:16:58PM +0100, Jeremy Sowden wrote:
> [...]
> > +/* Called from uadd only, protected by the set spinlock.
> > + * The kadt functions don't use the comment extensions in any way.
> > + */
> > +static inline void
> > +ip_set_init_comment(struct ip_set *set, struct ip_set_comment *comment,
> > +		    const struct ip_set_ext *ext)
>
> Not related to this patch, but I think the number of inline functions
> could be reduced a bit by exporting symbols? Specifically for
> functions that are called from the netlink control plane, ie. _uadd()
> functions. I think forcing the compiler to inline this is not useful.
> This could be done in a follow up patchset.

I'll take a look.

J.

--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl1MgbkACgkQ0Z7UzfnX
9sMH+g//Xo8lZa3oxjLdnUNKikemZiYQ/IbNiSFwwKs4WRMWMIuuXNFhtzMHtf71
A5ovtI6aylTcK5KA7Qwx4EIEHS6jMcpGXw+jMRt8UHGI6D8jIKuwj5inTXor6TvB
jkr3rfDYjRh2qLDmjQLC6L1rb8YG7U1+jlN+lHfasHgPls+NP8nhqHmfbwU9J24t
LbcajuoY88UMuqqAY2WS3qg3S/4CUZ1kpVUJIA1NUCEw8KivgvUiO+ByvtMgRR6Q
owjcCKWv90PEMS3PYzmOsykIIUSSDITpM4N3ZiIhJSh4f5/T2h6uPH/nL7pRSNqf
r+U31MEXggPkRJG1Ig19fa0yaGmDBZbzyWLE5RnbK4G+6T8+V9+e3ffNPYYH9vFE
ypLrEzc75DFF/N+mXwsWWs82weyhkt7FCqi1grjZs5zhtMciRHeN5v/lCbCZtpqb
9J7tlD+DFH+pNjPwXP8Qxm/YzMiCboVvHyCHHpKRhkxhk/QxjHJ3i5U3gG/4/dPY
QiW3e1XDj6jHSz+XDFqspcoGIEp9pVHoC58HgFdELoZo53A+kMsQ9B0KFExalPOH
lLT3SCDeu+CkVY3EU1J5vfErFTnkv77cQuNSl5UoRpT8zhV3ZQUY4wE06vWKLMNN
GGBLxuUxQdqZUbaRXvxheMnp0YSxPmYT2oIrn2rUk3UBC96Q2k4=
=uRpK
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--
