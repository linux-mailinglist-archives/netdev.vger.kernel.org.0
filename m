Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 554541429CB
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 12:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726728AbgATLrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 06:47:42 -0500
Received: from mail.katalix.com ([3.9.82.81]:42666 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726573AbgATLrm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jan 2020 06:47:42 -0500
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id DED2886AC9;
        Mon, 20 Jan 2020 11:47:40 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=katalix.com; s=mail;
        t=1579520861; bh=BfS4Z0hKvvI1DSLc7cXKtnt02mlzwlHBPNcinOzvdzM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TAQmNBXyPzbzjNx2L2ryH4y2Ewy3YzpKEAeuwvr5SbzFnERdWiEM7VPxwZdTJVxPf
         5w+gYAjzYjLY/bVXMNHjxX9PTXOpi6Bny2319bt2DjSNLfut7GdQUBSlKrIW289ewm
         igyRnX7wLLTKU+HeoZzkB3NT3TcgtTZpMr3GzNfLThdspkGXXy5mKO8Ft0CQDsoKz8
         6QjL9bno07DKbI/iFdQXkOPZIhb2y/9+AaSXm+uaWKgYV6aSuk51LpP51ALit/bbb/
         cjUCAynuLCcQucMBWpyp7lajHvFAE5LBbHQoFxvI/glyHllckc+XYw5v8cUpnRsftr
         c+sDhNwsN2pOw==
Date:   Mon, 20 Jan 2020 11:47:40 +0000
From:   Tom Parkin <tparkin@katalix.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Ridge Kennedy <ridge.kennedy@alliedtelesis.co.nz>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] l2tp: Allow duplicate session creation with UDP
Message-ID: <20200120114740.GA12373@jackdaw>
References: <20200115223446.7420-1-ridge.kennedy@alliedtelesis.co.nz>
 <20200116123854.GA23974@linux.home>
 <20200116131223.GB4028@jackdaw>
 <20200116190556.GA25654@linux.home>
 <20200116212332.GD4028@jackdaw>
 <20200117163627.GC2743@linux.home>
 <20200117192912.GB19201@jackdaw>
 <20200118175224.GB12036@linux.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
In-Reply-To: <20200118175224.GB12036@linux.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Sat, Jan 18, 2020 at 18:52:24 +0100, Guillaume Nault wrote:
> On Fri, Jan 17, 2020 at 07:29:12PM +0000, Tom Parkin wrote:
> > On  Fri, Jan 17, 2020 at 17:36:27 +0100, Guillaume Nault wrote:
> > > To summarise, my understanding is that global session IDs would follow
> > > the spirit of RFC 3931 and would allow establishing multiple L2TPv3
> > > connections (tunnels) over the same 5-tuple (or 3-tuple for IP encap).
> > > Per socket session IDs don't, but would allow fixing Ridge's case.
> >=20
> > I'm not 100% certain what "per socket session IDs" means here.  Could
> > you clarify?
> >=20
> By "per socket session IDs", I mean that the session IDs have to be
> interpreted in the context of their parent tunnel socket (the current
> l2tp_udp_recv_core() approach). That's opposed to "global session IDs"
> which have netns-wide significance (the current l2tp_ip_recv()
> approach).
>

OK, thanks for confirming.

--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAl4lk1cACgkQlIwGZQq6
i9BgHwf+OqW7YHZ7pHv2vD92dc6krU2gVkLMhrnl53uBQJbqq8WcQga0LuvLDzoT
+oMvgm8wArKueKMK1mSYDWIceQRW2gqLMuw4ZpFZ9a5DQUvWnJtWsSg+FNL0U5RK
T3JzgrMBXW5zRTM5nHfvrRxV2lVpSYnFPt0C5U5h0Rp7URPbHzcWM4xuxAZLVWm5
EUnLUqgoFYvSjQriKeKKRh9mFv0kiKIBKrVOtzHdSW31GC+elMa/gfhNxHtIddEY
0gsyeFJlbwuiX7+o7wmxAOFjcLiaPJz9cJdJ6RPvLkInTaYJFD2/mNng9Jk/TvIK
AZ5C09yo99+qMSX19WqkudKKEjEw2A==
=zmex
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--
