Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07CFC1F8028
	for <lists+netdev@lfdr.de>; Sat, 13 Jun 2020 03:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgFMBQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 21:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbgFMBQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 21:16:24 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABFD3C03E96F;
        Fri, 12 Jun 2020 18:16:23 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49kKRk1335z9s1x;
        Sat, 13 Jun 2020 11:16:18 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1592010979;
        bh=Z8bpJxqMYOJjEOL8kAouZ0Tnset6ZaifQm+OWjMnE3c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WSNy1HhnvDNuNHJXSiing8QUUG2tTEWOyuYoEUr0QhdJ+PEQcSVJF2YT9dOdcsqWn
         IcSDsPLo3hcznA3kZSW1mIkBgILU4tyrEEFmAJf2ACVArHMAJtNuPzWL264nX8cG9F
         CsUu+ANolKzmTaTg51R/RnXPaS6Q0yfZuraYemCMQmk1kJNYxjPv+q1QYVpxlqrWJA
         d2zVFKpGcpDwpIRNM4IniKQlqFMDx6zduqAg0TlbBkksgT7oOPAR5ux7LSPs5VH2ic
         PJyU7kVCML0+vIVMSbTB+ddTIL70VLcrPLMQes/2AWN0/U5MliDHVO8vFYRfp4eUyc
         v4N48/ZsWop0Q==
Date:   Sat, 13 Jun 2020 11:16:16 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>
Subject: Re: linux-next: build warning after merge of the net-next tree
Message-ID: <20200613111616.79a01f31@canb.auug.org.au>
In-Reply-To: <61CC2BC414934749BD9F5BF3D5D94044986D9CE3@ORSMSX112.amr.corp.intel.com>
References: <20200525224004.799f54d4@canb.auug.org.au>
        <61CC2BC414934749BD9F5BF3D5D94044986D9CE3@ORSMSX112.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/not5Ox0bWa61KpS2MinXQkn";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/not5Ox0bWa61KpS2MinXQkn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 27 May 2020 01:15:09 +0000 "Kirsher, Jeffrey T" <jeffrey.t.kirsher@=
intel.com> wrote:
>
> > -----Original Message-----
> > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > Sent: Monday, May 25, 2020 05:40
> > To: David Miller <davem@davemloft.net>; Networking
> > <netdev@vger.kernel.org>
> > Cc: Linux Next Mailing List <linux-next@vger.kernel.org>; Linux Kernel =
Mailing
> > List <linux-kernel@vger.kernel.org>; Lifshits, Vitaly <vitaly.lifshits@=
intel.com>;
> > Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> > Subject: linux-next: build warning after merge of the net-next tree
> >=20
> > Hi all,
> >=20
> > After merging the net-next tree, today's linux-next build (sparc64
> > defconfig) produced this warning:
> >=20
> > drivers/net/ethernet/intel/e1000e/netdev.c:137:13: warning: 'e1000e_che=
ck_me'
> > defined but not used [-Wunused-function]  static bool e1000e_check_me(u=
16
> > device_id)
> >              ^~~~~~~~~~~~~~~
> >=20
> > Introduced by commit
> >=20
> >   e086ba2fccda ("e1000e: disable s0ix entry and exit flows for ME syste=
ms")
> >=20
> > CONFIG_PM_SLEEP is not set for this build.
> >  =20
> [Kirsher, Jeffrey T]=20
>=20
> Vitaly informed me that he has a fix that he will be sending me, I will m=
ake sure to expedite it.

I am still getting this warning.

--=20
Cheers,
Stephen Rothwell

--Sig_/not5Ox0bWa61KpS2MinXQkn
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl7kKOAACgkQAVBC80lX
0GyhvwgAl+qSXPDU0zhIr1Y0zDu2dsKFBTKu8mPHb1kov+Z0NndX3P42FpX0WHL7
0iy6EVbjxSFWkQc4SquUXT+kboRSPIIQEUI8LIoovwVxD6hl0orN4JULRdGpXg/E
Jy0m32cpLS4QI0ktXEQcwav7yaxXYeVD01ZXGSRJXjjKVn5uq/G/KIT3SC9Cw/jk
Wo+d8J+0922wPFw5/F3okEE8Zi+ueEChkPXsEdE2kx26CJMn/IiTYu2+Hxcg7XWo
CXeMzHRpK6SEcaLCpcTZyhnCgImeVGysnqK06T/DCselm0JB8heyJtEtarnKmYKc
CGjztYHrILRZYZoPLUQ8z+UAtRU6bg==
=xzp1
-----END PGP SIGNATURE-----

--Sig_/not5Ox0bWa61KpS2MinXQkn--
