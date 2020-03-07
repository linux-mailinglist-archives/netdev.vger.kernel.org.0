Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8272017CB91
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 04:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgCGDpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 22:45:40 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:53907 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726300AbgCGDpj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 22:45:39 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48Z9P72Ttgz9s3x;
        Sat,  7 Mar 2020 14:45:27 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1583552734;
        bh=/uBtVQlQdI3TPN7OTG8f8ITHXiSieBJKrtT8V3oon2A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YerQZWqLuMkiMOSXMx2KT4g62g9aftk7QDkaeudjiWExGFkC5gpsQzcwT8ti6XJPr
         xwNgn5metkp7YNF+wTZ/82m7suteYmZSIG1w5zREnZ6uP/UwhCMV+voAcvhD3CtvCn
         HkLM5YM8G95jqNf7I/hZtDj8kInPBzzBiqAR+Wq3C0gTZ9dYGksTgwZ63e0bpVJtzd
         cS8I2knNeWnjP34ShwuZ2c0BVwKh3KsKAUnDqkPlJWO3aS7G9Y1BHe6AiTLLsuc3x4
         aFk/2y8vk9AOSwdcyNTJi+Zke811C+SUyXTrUpg2Ri6As0uLArFsPdKNbUBdQfaxF8
         CvohOyL6evlfQ==
Date:   Sat, 7 Mar 2020 14:45:06 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     sameo@linux.intel.com
Cc:     David Miller <davem@davemloft.net>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        johannes@sipsolutions.net
Subject: Re: linux-next: the nfc-next tree seems to be old
Message-ID: <20200307144506.7585f0f5@canb.auug.org.au>
In-Reply-To: <20200305.180823.1274906337509861200.davem@davemloft.net>
References: <20200130105538.7b07b150@canb.auug.org.au>
        <20200306104825.068268eb@canb.auug.org.au>
        <20200305.180823.1274906337509861200.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/zzr+wf8CgUL20Essy6WdNE/";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/zzr+wf8CgUL20Essy6WdNE/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 05 Mar 2020 18:08:23 -0800 (PST) David Miller <davem@davemloft.net>=
 wrote:
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 6 Mar 2020 10:48:25 +1100
>=20
> > On Thu, 30 Jan 2020 10:55:38 +1100 Stephen Rothwell <sfr@canb.auug.org.=
au> wrote: =20
> >>
> >> Hi Samuel,
> >>=20
> >> I noticed that the nfc-next tree has not changed since June 2018 and
> >> has been orphaned in May 2019, so am wondering if the commits in it are
> >> still relevant or should I just remove the tree from linux-next. =20
> >=20
> > Since I have had no response, I will remove it tomorrow. =20
>=20
> We've been integrating NFC patches directly into my networking tree for
> a while now, so this is indeed the thing to do.

I have removed it now.

--=20
Cheers,
Stephen Rothwell

--Sig_/zzr+wf8CgUL20Essy6WdNE/
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl5jGMIACgkQAVBC80lX
0GxjlQf/QXcx752LzbAakMG6nS8i2OKAXSyrt/QZ33QeMOyKno1Gxl/gyjOjCXsw
zX4VWlKD9OA+J3QoRBABuNKh0fy82Je2RRPpdZTNKHXINJ+Wh3Kw31l9cRTrJET+
SnYTDD9zwMz72/9mprfgYVXC6Xdp1zvR6F8vFGjy/pcFcHpPcc0iv5/6cojgEQEE
kQcxPQGxJQBmaar3ge+Uvqyog6pL7MV79W3hgY7grvhx+fSPqgvbxWoy6MscsoMo
XSRnWjcKvhDRfBB7rEkcHBBTGGvXJNiA9KQGUqH+1oxvd/d7VeQqvqMBn/4BX5Ml
GKuRWAoY6Dpz19eVS04m1JvDv/WzrQ==
=OluB
-----END PGP SIGNATURE-----

--Sig_/zzr+wf8CgUL20Essy6WdNE/--
