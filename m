Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7239D168A19
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 23:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728656AbgBUWty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 17:49:54 -0500
Received: from mga03.intel.com ([134.134.136.65]:60558 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726802AbgBUWty (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 17:49:54 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Feb 2020 14:49:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,470,1574150400"; 
   d="asc'?scan'208";a="316186019"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.76])
  by orsmga001.jf.intel.com with ESMTP; 21 Feb 2020 14:49:53 -0800
Message-ID: <bcb371d5aeb2c2eff5a04da222ae58b8d13df28f.camel@intel.com>
Subject: Re: [net-next 00/13][pull request] 100GbE Intel Wired LAN Driver
 Updates 2020-02-19
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Date:   Fri, 21 Feb 2020 14:49:53 -0800
In-Reply-To: <20200220.150556.296731847851540180.davem@davemloft.net>
References: <20200219220652.2255171-1-jeffrey.t.kirsher@intel.com>
         <20200220.150556.296731847851540180.davem@davemloft.net>
Organization: Intel
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-czWH5ab+WyYvjjNz9xwH"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-czWH5ab+WyYvjjNz9xwH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2020-02-20 at 15:05 -0800, David Miller wrote:
> From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Date: Wed, 19 Feb 2020 14:06:39 -0800
>=20
> > This series contains updates to the ice driver only.
>=20
> Pulled.
>=20
> Please followup with a fix for the feedback from Sergei.

I have a patch in my tree to make Sergei's suggested changes.

--=-czWH5ab+WyYvjjNz9xwH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl5QXpEACgkQ5W/vlVpL
7c4jXA/6ArMc+6lOjBDhft/XguofjFLTuFiB0iLmQE9WBk8ZcYpcFBWxuOR95Why
NO7Dw5XN8ZHKu819iw5Q/ecg6zkv6V8gTjVny9Glmcsnz2w6Y95rti152AUNbHDR
6sHxDcGnpZtkBSnxqeZME/UhWfd1jp/Z/T4s2sNrD5+cCyAF0cuA/0q4L8CwMa2X
uV8Z3klIq0iUK2Zg2TVHw21pVv6854gN2XWRXud4ngWrVj0r+s7+0m0zz6im1EAw
sh/qz19ywetkmx6men7cpHFA7naUQrMxHmbv6n5aVcVXJe7C9awSjqdGJQMqN3Yw
y7WwibY5IytRMWGXOAAI+JEjMM6yBIcW/eczGzPitIDgCIpB/tDIq4S8v4P4tHy8
kboGt9xTjcpzwAyhIKZKIykHb0DuAzVJwzqvzHMEIUYKhVJXKo4IVvilifI6x5nO
Fv7H0TYWqC5O1xmLrkM/GREXf7rCeSeIfqucFQ5en0gh01T6tg/uT6C2Dmd/Jdwr
eXU8zP6lLE8LwhV+whI5upTLVEcJtwJXfveFjutzgire8PdHEBwUjc6T57505fpN
2ddTQ/3P+juXjXG2E71hExMklMWoZmWG8J5SVPn2N1pyGLK2GSRjCajX7LPmX4q5
M/URcw37NipzOnJ8XlUSB3aT4dw06Ido6mL55Mv1m0qYa/Tgg+Y=
=M7+g
-----END PGP SIGNATURE-----

--=-czWH5ab+WyYvjjNz9xwH--

