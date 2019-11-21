Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0EFF105D0A
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 00:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbfKUXHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 18:07:31 -0500
Received: from mga06.intel.com ([134.134.136.31]:21670 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726038AbfKUXHb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Nov 2019 18:07:31 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Nov 2019 15:07:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,227,1571727600"; 
   d="asc'?scan'208";a="357957711"
Received: from lmhaganx-mobl.amr.corp.intel.com ([10.251.138.123])
  by orsmga004.jf.intel.com with ESMTP; 21 Nov 2019 15:07:29 -0800
Message-ID: <67dc963f41f588e09194bd251542e11b73340ee8.camel@intel.com>
Subject: Re: [net-next 05/15] ice: fix stack leakage
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     davem@davemloft.net, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Date:   Thu, 21 Nov 2019 15:07:28 -0800
In-Reply-To: <20191121142548.4bb62c55@cakuba.netronome.com>
References: <20191121074612.3055661-1-jeffrey.t.kirsher@intel.com>
         <20191121074612.3055661-6-jeffrey.t.kirsher@intel.com>
         <20191121142548.4bb62c55@cakuba.netronome.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-ykHR0X+jnocY3L/UJmC8"
User-Agent: Evolution 3.34.1 (3.34.1-1.fc31) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-ykHR0X+jnocY3L/UJmC8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2019-11-21 at 14:25 -0800, Jakub Kicinski wrote:
> On Wed, 20 Nov 2019 23:46:02 -0800, Jeff Kirsher wrote:
> > From: Jesse Brandeburg <jesse.brandeburg@intel.com>
> >=20
> > In the case of an invalid virtchannel request the driver
> > would return uninitialized data to the VF from the PF stack
> > which is a bug.  Fix by initializing the stack variable
> > earlier in the function before any return paths can be taken.
>=20
> I'd argue users may not want hypervisor stack to get leaked into the
> VMs, and therefore this should really have a fixes tag...

Added...

Fixes: 1071a8358a28 ("ice: Implement virtchnl commands for AVF support")

--=-ykHR0X+jnocY3L/UJmC8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl3XGLAACgkQ5W/vlVpL
7c4A2xAAhHk+r3CkJwlTw9KJo44PvnzX6cTIAprVS8GCFA2ARV40Vo7ECO/Bkkij
l8nKXzUs9BsDkPhkJDa6y3zW+DpY+dn0STX1orho+xbzb41oTmQaz6eTtHmns5DI
ta0bFKLrUhxm4nhpja1zF2ZlJ8kb3ATQ/1vr9aHJUCWghcvvqsr6Grklm+KL2Lwl
HW6Iv/WX+xY46pVBmUN9ChiVq9iCSESN4otiHDKsJeV6rcULNm2gRcWL7cfG6E3w
Kvq4Ij23jFBDMEUp0sDVEMj6KedIVZizSuFeiyEy+bLAqhmhdvrwaERWNqoTwb6m
++iYs57FzHS/flMGuozCy4twpwO1l0TjphR9yyTeq6zo8vNEcKIdIY1C6+rPf6HG
QE6pPStDivoKbOg5szs0uhismXHqWDGB7CYdBxX/L3mQrPS3kAUiogTS9Q6/DHVS
bhBLT3rqPksKvFwNDQqxGbGsC5Err1eOOLawt9TW4Id1zyYL13TZ4WfzCITyeO3/
/uMj1yg2dVQzc8RFiDIJOPXrBl+n74upLkzGS8pz+BX7G8AbL+EOY+lN9fQttNPk
OxGjgq4VY+W4nNpa9G8yxYPLxWOXrtsO+gG0ztYQCAkgmWI36/9Uto+V9ptR+fes
97u648bI5KMKmT0qZ+h5GEKbQWKW3Tfy2Io5RPNS77bC0+mgRag=
=vRxq
-----END PGP SIGNATURE-----

--=-ykHR0X+jnocY3L/UJmC8--

