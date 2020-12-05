Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87AE22CFEE5
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 21:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgLEUld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 15:41:33 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:36658 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgLEUlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 15:41:32 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 506DF1C0B7C; Sat,  5 Dec 2020 21:40:50 +0100 (CET)
Date:   Sat, 5 Dec 2020 21:40:49 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Alex Belits <abelits@marvell.com>
Cc:     "nitesh@redhat.com" <nitesh@redhat.com>,
        "frederic@kernel.org" <frederic@kernel.org>,
        Prasun Kapoor <pkapoor@marvell.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "trix@redhat.com" <trix@redhat.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "will@kernel.org" <will@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "leon@sidebranch.com" <leon@sidebranch.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "pauld@redhat.com" <pauld@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v5 0/9] "Task_isolation" mode
Message-ID: <20201205204049.GA8578@amd>
References: <8d887e59ca713726f4fcb25a316e1e932b02823e.camel@marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
In-Reply-To: <8d887e59ca713726f4fcb25a316e1e932b02823e.camel@marvell.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> General description
>=20
> This is the result of development and maintenance of task isolation
> functionality that originally started based on task isolation patch
> v15 and was later updated to include v16. It provided predictable
> environment for userspace tasks running on arm64 processors alongside
> with full-featured Linux environment. It is intended to provide
> reliable interruption-free environment from the point when a userspace
> task enters isolation and until the moment it leaves isolation or
> receives a signal intentionally sent to it, and was successfully used
> for this purpose. While CPU isolation with nohz provides an
> environment that is close to this requirement, the remaining IPIs and
> other disturbances keep it from being usable for tasks that require
> complete predictability of CPU timing.

So... what kind of guarantees does this aim to provide / what tasks it
is useful for?

For real time response, we have other approaches.

If you want to guarantee performnace of the "isolated" task... I don't
see how that works. Other tasks on the system still compete for DRAM
bandwidth, caches, etc...

So... what is the usecase?
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl/L8FEACgkQMOfwapXb+vJE3wCfYs+cxM/a7TO3oAUetWlr1POn
XBIAn3IURI08m9SC3Yh05MPaBjmvFyYq
=Y8jH
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
