Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 659A48B71A
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 13:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727558AbfHMLg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 07:36:59 -0400
Received: from kadath.azazel.net ([81.187.231.250]:60518 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbfHMLg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 07:36:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=lXORjW+EvERLqzo6SjmX1Ws1O3ILhH8iZsNJou9jpik=; b=sYeZ7bztCLU1VNvu8eU4lJaUsB
        eL8d2nHGJMYek9v4OYQq8rsgDiWQuQGfOSq8nrNfot6tLCvqfqQpEwKE+wpxnY5hukI3ZioUSF4Cx
        vH10nTG6L5bk3Ze8lRr6Bcty2/Lz33e12BUOqjFNmiFr5+3N3js9USTrejEjgwOKyyIDP6AiCLHVS
        HYdBdGsMS2JN0sj05OYmKeKeSkR2QNdiYDNQ8IBj54TJ0NMxpihBsRFnMR0jlx5esthXi7gW96lU+
        dtXxLhjfeRCFgC5iEjpJ8iMoUCoXWr+pHo57xy+yyBKBnUj/Yb2x5vKnLidBgg9ScJ/90q/gpNS7Y
        MWVCXQrg==;
Received: from pnakotus.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:208:9bff:febe:32] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1hxV6n-0006G1-4R; Tue, 13 Aug 2019 12:36:57 +0100
Date:   Tue, 13 Aug 2019 12:36:57 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Net Dev <netdev@vger.kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [PATCH net-next v1 0/8] netfilter: header compilation fixes
Message-ID: <20190813113657.GB4840@azazel.net>
References: <20190722201615.GE23346@azazel.net>
 <20190807141705.4864-1-jeremy@azazel.net>
 <20190813095529.aisgjjwl6rzt5xeh@salvia>
 <20190813100424.GA4840@azazel.net>
 <20190813101403.ly5z5q6xvyno3xdd@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="gj572EiMnwbLXET9"
Content-Disposition: inline
In-Reply-To: <20190813101403.ly5z5q6xvyno3xdd@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:208:9bff:febe:32
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--gj572EiMnwbLXET9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2019-08-13, at 12:14:03 +0200, Pablo Neira Ayuso wrote:
> On Tue, Aug 13, 2019 at 11:04:24AM +0100, Jeremy Sowden wrote:
> > On 2019-08-13, at 11:55:29 +0200, Pablo Neira Ayuso wrote:
> > > Would you mind if - before pushing this out - I do this string
> > > replacement for the patch subject?
> > >
> > > s/added/add
> > > s/removed/remove
> > > s/inlined/inline
> > >
> > > I was told present tense is preferred for description. Otherwise, I'll
> > > leave them as is.
> >
> > I adopted past tenses because at the point at which one is reading
> > the description of a commit, one is usually reading about old
> > behaviour and what has been done to change it.  However, I wasn't
> > aware that there was a preference and I am happy to switch to the
> > present tense instead, so by all means feel free to change them.
>
> This is not in the Documentation tree, or I could not find this in a
> quick git grep:
>
> https://kernelnewbies.org/PatchPhilosophy
>
> "In patch descriptions and in the subject, it is common and preferable
> to use present-tense, imperative language. Write as if you are telling
> git what to do with your patch."
>
> I remember though that maintainers have been asking for this in the
> past.

Thanks for the pointer.

J.

--gj572EiMnwbLXET9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl1SoNUACgkQ0Z7UzfnX
9sME5A/9EloKPh1FzFH1mpNfCz5dYSuzZRlCVkSQ9L+MB+ys221pxeswOeGQ77aM
S3XGyTirwyRquakbz+bqvEN+ZurS59nUyG4jdyFu7qAJB8V3DQUWwH+m7PdXvGwR
BP/KAl+QiKQkDfHzuzNHd3AcCZGVHXmw2sWcqzG4RYSu+e9S7fsa1k2N+C0b/MjP
Tv28b7yQjD+GcM94CeTpR61Gt3RcyBk72+dxH8eym6ZEk6LtD7KgzX3iJW7XIpqO
ePxwmEDGl5r40p2TCVj6H293vPCgXAUod7oFtgNY+xfmL7N/bbFIBFnNqMU+XIQb
5ompei+eKH4GIasrvr/mdyRug80uoO1xp8cAeA7sSaJpuNkkT24xSANeejaqpM5D
0WXVbt0OmUzC2tZFw0olCWDtqNpyoyLXCX7acVXFKvOsYadi9FPoZQmbFroj31Ju
3y9cckpzyP5bnONbHfcajKeZu8xznprD4l006KCbEaz2nIbCwsdT0vdboqHERkH/
0/Sa2uQP7ZaeZ0eUEA10cg2QvAZDMavrfD/qghFxnbPhmMuF8azDF4krwIxu6LtH
8glVhNGC8BnQNJTGSGc17UNv/n/V5rTisGwwxAFuCZwPVUEkNndSg4t2TKm/xEuo
s8jKSplCH/yAUNzCRe3XQyyc8MF95rzeRxGIzCNPISicixmLink=
=4z5Y
-----END PGP SIGNATURE-----

--gj572EiMnwbLXET9--
