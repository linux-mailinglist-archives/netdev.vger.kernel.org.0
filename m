Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6105F318C9
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 02:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfFAA23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 20:28:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:27140 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725883AbfFAA23 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 20:28:29 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 May 2019 17:28:28 -0700
X-ExtLoop1: 1
Received: from bareed-mobl1.amr.corp.intel.com ([10.251.11.190])
  by orsmga007.jf.intel.com with ESMTP; 31 May 2019 17:28:28 -0700
Message-ID: <dd86d140bdd83fbd3bf8bd6256b94b815e7db9d7.camel@intel.com>
Subject: Re: [net-next 00/13][pull request] Intel Wired LAN Driver Updates
 2019-05-31
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Date:   Fri, 31 May 2019 17:28:27 -0700
In-Reply-To: <20190531.170238.2103466000677539047.davem@davemloft.net>
References: <20190531081518.16430-1-jeffrey.t.kirsher@intel.com>
         <20190531.170238.2103466000677539047.davem@davemloft.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-OjFqsiEuk3vIaMpy1COO"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-OjFqsiEuk3vIaMpy1COO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2019-05-31 at 17:02 -0700, David Miller wrote:
> From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Date: Fri, 31 May 2019 01:15:05 -0700
>=20
> > This series contains updates to the iavf driver.
>=20
> Pulled, thanks Jeff.
>=20
> I do agree with Joe that the debug logging macro can be improved.
> Please take a look at his feedback.

Yeah, I saw his feedback, Joe's suggestion is what we have used in the
past, so I am not sure of why the change for iavf.  I am investigating why
the change was made.

--=-OjFqsiEuk3vIaMpy1COO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAlzxxqsACgkQ5W/vlVpL
7c6diw//XgSIu7HjQQg4EivAiMweg1AjIhw6oaLNbHbudViT7jOTRhsT8ni5k69r
hy4SmpvbYQjrpOZgjw7V0FcgrcaMyQE4rNTPYMhj4Mvq0+GBIAzlgeobXvW3pKBD
QBX1ZfhrqD0V0nLB6srPw1DhcAZExVIOzIC1n51lkHahcZC8W35UbSs5TQ53MTPr
fcGzuGS5iNSNsYVR8Ozc7LkNsD0JF5iJDAdABjcW29JQ+CYJqM4B33B9/NW599/W
E9Dd5X0g5vEnTWlXvEqPD76Aj7PTBJpflhS1stUVpbJirwiu/9+OopBJY9+dHZgp
v25WwjGPcT1lu2RGGhQ39KNuG2HnzUjbrDd8AvN60PWtqDtnRpqJuecDM5ehOV/a
GM9u7yFdb4QiYcl/fUt1UPYrUKHCLivQlSZMBwwmRAvPm3ZWbR6AQ685RUuFS2+C
rf1D9xGlgvBU3sLRYEwMPnPriLirnFa4c8CzHwofKIV2km+DHELgk55aB75HxjW2
/GZaeh+QHOoyYtUkRzX0S3vBqKMVxBBYmapu8wGC1Sw8rYWBe4GU1+QCT4Xdnxg5
tL1rhJsyA6BedSAfMjK1snJmx5ZAhnEv6a5EHB1Lg/nJpCDRqkEUpFVKWwj/USNV
OA1tD0BCCv5eW80EBF+URlBc2CHVBvPqN76slc/20TkOvQExnv8=
=OplK
-----END PGP SIGNATURE-----

--=-OjFqsiEuk3vIaMpy1COO--

