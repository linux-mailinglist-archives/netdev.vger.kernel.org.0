Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64EF16E77DC
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 12:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232769AbjDSK6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 06:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231895AbjDSK6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 06:58:08 -0400
X-Greylist: delayed 512 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 19 Apr 2023 03:57:58 PDT
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 309D883D8;
        Wed, 19 Apr 2023 03:57:57 -0700 (PDT)
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 7EED684C45;
        Wed, 19 Apr 2023 11:49:23 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1681901363; bh=iVVLIE5L1lv50wYWj5uM1b8QK2rm1y1nKcE7860TRbY=;
        h=Date:From:To:Subject:Message-ID:References:MIME-Version:
         Content-Disposition:In-Reply-To:From;
        z=Date:=20Wed,=2019=20Apr=202023=2011:49:23=20+0100|From:=20Tom=20P
         arkin=20<tparkin@katalix.com>|To:=20Samuel=20Thibault=20<samuel.th
         ibault@ens-lyon.org>,=0D=0A=09Guillaume=20Nault=20<gnault@redhat.c
         om>,=0D=0A=09James=20Chapman=20<jchapman@katalix.com>,=20edumazet@
         google.com,=0D=0A=09davem@davemloft.net,=20kuba@kernel.org,=20pabe
         ni@redhat.com,=0D=0A=09corbet@lwn.net,=20netdev@vger.kernel.org,=2
         0linux-doc@vger.kernel.org,=0D=0A=09linux-kernel@vger.kernel.org|S
         ubject:=20Re:=20[PATCH]=20PPPoL2TP:=20Add=20more=20code=20snippets
         |Message-ID:=20<20230419104923.GA13324@katalix.com>|References:=20
         <ZD5V+z+cBaXvPbQa@debian>=0D=0A=20<20230418085323.h6xij7w6d2o4kxxi
         @begin>=0D=0A=20<ZD5dqwPblo4FOex1@debian>=0D=0A=20<20230418091148.
         hh3b52zceacduex6@begin>=0D=0A=20<ZD5uU8Wrz4cTSwqP@debian>=0D=0A=20
         <20230418103140.cps6csryl2xhrazz@begin>=0D=0A=20<ZD5+MouUk8YFVOX3@
         debian>=0D=0A=20<20230418115409.aqsqi6pa4s4nhwgs@begin>=0D=0A=20<Z
         D6dON0gl3DE8mYr@debian>=0D=0A=20<20230418141820.gxueo5pz2vvre442@b
         egin>|MIME-Version:=201.0|Content-Disposition:=20inline|In-Reply-T
         o:=20<20230418141820.gxueo5pz2vvre442@begin>;
        b=InE1w+opVpnbLv6A44O5YRc+SAbWnaij3nz8QiyX+3OLYsancHsI9Q5KDHuI4a65G
         +9Rt9+kgFQRck1sWASt771vt7o1PC/w9u3H076BdlsRrT4Ck2YQs5FT68shYKfVQSg
         pnD3EJz8Y4I2LSNtVXGRRhxkUP+W1DezQfhxzJmHTMnL7/wBLP9gNCGJyMJwO9pr3D
         UbhHeMmFDCPVcoLJLAJwSmsyzmpmSRx9aHGvyUXIqiLaOFx0MnSTkp+MRkgLgWFpaT
         ES9wKa/fbXPTLcMNRaweoptkm750xTYyj2elCCv1c4HqhbTdH1teeZpz9OHjTzixFr
         3WIgY15hwLQyw==
Date:   Wed, 19 Apr 2023 11:49:23 +0100
From:   Tom Parkin <tparkin@katalix.com>
To:     Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Guillaume Nault <gnault@redhat.com>,
        James Chapman <jchapman@katalix.com>, edumazet@google.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        corbet@lwn.net, netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PPPoL2TP: Add more code snippets
Message-ID: <20230419104923.GA13324@katalix.com>
References: <ZD5V+z+cBaXvPbQa@debian>
 <20230418085323.h6xij7w6d2o4kxxi@begin>
 <ZD5dqwPblo4FOex1@debian>
 <20230418091148.hh3b52zceacduex6@begin>
 <ZD5uU8Wrz4cTSwqP@debian>
 <20230418103140.cps6csryl2xhrazz@begin>
 <ZD5+MouUk8YFVOX3@debian>
 <20230418115409.aqsqi6pa4s4nhwgs@begin>
 <ZD6dON0gl3DE8mYr@debian>
 <20230418141820.gxueo5pz2vvre442@begin>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
In-Reply-To: <20230418141820.gxueo5pz2vvre442@begin>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Tue, Apr 18, 2023 at 16:18:20 +0200, Samuel Thibault wrote:
> Guillaume Nault, le mar. 18 avril 2023 15:38:00 +0200, a ecrit:
> > On Tue, Apr 18, 2023 at 01:54:09PM +0200, Samuel Thibault wrote:
> > > Guillaume Nault, le mar. 18 avril 2023 13:25:38 +0200, a ecrit:
> > > > As I said in my previous reply, a simple L2TP example that goes unt=
il PPP
> > > > channel and unit creation is fine. But any more advanced use of the=
 PPP
> > > > API should be documented in the PPP documentation.
> > >=20
> > > When it's really advanced, yes. But here it's just about tunnel
> > > bridging, which is a very common L2TP thing to do.
> >=20
> > I can't undestand why you absolutely want this covered in l2tp.rst.
>=20
> Because that's where people working on L2TP software will look for it.

Sorry to have not commented earlier, and thank you Samuel for working
on improving the L2TP documentation.

I think documentation like l2tp.rst is best when it provides a high
level overview of how things fit together.

When it comes to actually implementing a userspace L2TP/PPP daemon,
I feel that at a certain point you're better off referring to existing
userspace code alongside the kernel sources themselves, as any summary is
inevitably going to leave gaps.  From that perspective I'd almost sooner
we didn't have the code snippet in l2tp.rst.

That said, I can't see the harm in improving the code snippet, given
that we have it already.  Having no mention of PPPIOCBRIDGECHAN given
that it can be used to implement tunnel switching is an oversight
really.

FWIW I agree the term "tunnel switching" is a bit misleading, and of
course the PPP ioctl supports bridging any flavour of channel, not
just PPPoL2TP.  However from the L2TP perspective people perhaps have
something along the lines of this IETF draft in mind:

https://datatracker.ietf.org/doc/html/draft-ietf-l2tpext-tunnel-switching-08

=2E..which we could perhaps link to to clarify the intent in the context
of the L2TP codebase?

> > Also, it's probably a desirable feature, but certainly not a common
> > thing on Linux. This interface was added a bit more than 2 years ago,
> > which is really recent considering the age of the code.
>=20
> Yes, and in ISPs we have been in need for it for something like
> decades. I can find RFC drafts around 2000.
>=20
> Or IPs have just baked their own kernel implementation (xl2tpd,
> accel-ppp, etc.)

Yes.  It's sad that support wasn't available sooner in the kernel, but
I'm not sure that's indicative of lack of desire for the feature
necessarily.

> > Appart from maybe go-l2tp, I don't know of any user.
>=20

I confirm that go-l2tp does use it :-)

--=20
Tom Parkin
Katalix Systems Ltd
https://katalix.com
Catalysts for your Embedded Linux software development

--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAmQ/xyYACgkQlIwGZQq6
i9At8QgAsFZhEpP2qxWypS68H5NKarIfFYarOkKszlZYYGSxuSFsx1uNYGc/m6dM
EfB4N00yMNLIhUU7gimjytfZXVTFYyoAZ4ZIxSdngkyJiSMkwGdccSlu/nTbCFwa
NbfC5v3e2/liDGDleT1CrpxrBD6IBNzG6PzUti3BhG8wJoODy2xyRbS2bDDFkjMr
GUF9rRVxlIt/+V8iOPKBvlib7mLPyRh7lSOELQqWVKLLosuaAtb5NW8vNfpnRLxz
2rg307GafbG/zgFJcDHKaYjUT2AaoEC44eh0laOFZgbUr9lJtSejjRIQROQQ00uJ
MngGtrhkFgaUEDs/cILtSqlU6G/nBA==
=gtf3
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--
