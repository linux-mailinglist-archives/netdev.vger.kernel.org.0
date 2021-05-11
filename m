Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB69E37AF1A
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 21:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232107AbhEKTLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 15:11:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231439AbhEKTLl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 15:11:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1CE661626;
        Tue, 11 May 2021 19:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620760234;
        bh=e54D+JL7G0fBmcvlSsTLoGw5QlbnsspS2RdH8ESWbLg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Mw2rodQrteAc7YOIRxIl2TsI0vlaRbRWOhWt/N3R4Vou6GUuZDCD0NY9j4YljQgyz
         atAwkCCqXc7HLwaXvYrqa8MLJosjjgC6Vbl5U/bdQt//JGlf/pmueW8BN+WKUCJtx2
         BS7AVC2k75NT+WJMh+9tQslurOQ5EpMhdgc+9ZFQnX6JuHFpOR3FDSwPgEToJC/HUz
         J7CShSGPDmGMCgjDcf17jxx09XhC+3VYRKeGQb7dYwGFrjA2EeNyThD+mMW3jpOsnS
         AjuQ3F6zLxMXRGH+ZrHo0qo9EjHKK5XbhHXyLIhe/NSobmMHDYae2fShv+00Tl6f9Y
         WQv0lV53C0T4g==
Date:   Tue, 11 May 2021 21:10:28 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Jonathan Corbet <corbet@lwn.net>, Andrew Lunn <andrew@lunn.ch>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 5/5] docs: networking: device_drivers: fix bad usage of
 UTF-8 chars
Message-ID: <20210511211028.557de948@coco.lan>
In-Reply-To: <YJrRcgmrqJLSOjR5@casper.infradead.org>
References: <cover.1620744606.git.mchehab+huawei@kernel.org>
        <95eb2a48d0ca3528780ce0dfce64359977fa8cb3.1620744606.git.mchehab+huawei@kernel.org>
        <YJq9abOeuBla3Jiw@lunn.ch>
        <8735utdt6z.fsf@meer.lwn.net>
        <YJrRcgmrqJLSOjR5@casper.infradead.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Tue, 11 May 2021 19:48:18 +0100
Matthew Wilcox <willy@infradead.org> escreveu:

> On Tue, May 11, 2021 at 12:24:52PM -0600, Jonathan Corbet wrote:
> > Andrew Lunn <andrew@lunn.ch> writes:
> >  =20
> > >> -monitoring tools such as ifstat or sar =E2=80=93n DEV [interval] [n=
umber of samples]
> > >> +monitoring tools such as `ifstat` or `sar -n DEV [interval] [number=
 of samples]` =20
> > >
> > > ...
> > > =20
> > >>  For example: min_rate 1Gbit 3Gbit: Verify bandwidth limit using net=
work
> > >> -monitoring tools such as ifstat or sar =E2=80=93n DEV [interval] [n=
umber of samples]
> > >> +monitoring tools such as ``ifstat`` or ``sar -n DEV [interval] [num=
ber of samples]`` =20
> > >
> > > Is there a difference between ` and `` ? Does it make sense to be
> > > consistent? =20
> >=20
> > This is `just weird quotes` =20

Gah, sorry for that! I sent a wrong version of this patch...
i40e.rst should also be using:

	monitoring tools such as ``ifstat`` or ``sar -n DEV [interval] [number of =
samples]``=20

I'll fix it on the next spin.

>=20
> umm ... `this` is supposed to be "interpreted text"
> https://docutils.sourceforge.io/docs/ref/rst/restructuredtext.html#inline=
-markup
>=20
> Maybe we don't actually interpret it.

Well, if we use it as something like :ref:`foo`, it is then interpreted ;-)

using `foo` on Sphinx produces, in practice, the same effect as
``foo`` (at least on the initial versions): it also sets the font to
monospace and stops parsing other markups inside the `interpreted text`
string.=20

I remember that, at the very beginning, I did some ReST conversions
using `foo`. Then, I realized that this actually wrong, from the
definition PoV, and started using ``foo``.

>=20
> > This is ``literal text`` set in monospace in processed output.
> >=20
> > There is a certain tension between those who want to see liberal use of
> > literal-text markup, and those who would rather have less markup in the
> > text overall; certainly, it's better not to go totally nuts with it. =20
>=20
> I really appreciate the work you did to reduce the amount of
> markup that's needed!

In the specific case of using things like: ``command -n``, I would
put it on a literal block, either like the proposed path, or as:

	monitoring tools such as::

		ifstat

	or::
		sar -n DEV [interval] [number of samples]

ifstat is there using the same monospaced font just for
consistency purposes.

See, if you use just: sar -n

The Sphinx output could convert the hyphen to a dash.

Btw, if there was two hyphens, like: "ifstat --help"

This would be converted into "ifstat =E2=80=93help", using the EN DASH UTF-8
character.

So, I strongly recommend that programs (specially when followed
by arguments) to always use a literal block markup.


Thanks,
Mauro
