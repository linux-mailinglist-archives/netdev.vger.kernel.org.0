Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF2A74070
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 22:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387539AbfGXUw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 16:52:26 -0400
Received: from mga07.intel.com ([134.134.136.100]:49762 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726458AbfGXUw0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 16:52:26 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jul 2019 13:52:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,304,1559545200"; 
   d="asc'?scan'208";a="368915315"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga005.fm.intel.com with ESMTP; 24 Jul 2019 13:52:24 -0700
Message-ID: <8134ff55ff4b2c190adc48503dafdfde018fc84d.camel@intel.com>
Subject: Re: [net-next 6/6] e1000e: disable force K1-off feature
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To:     David Miller <davem@davemloft.net>
Cc:     kai.heng.feng@canonical.com, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, aaron.f.brown@intel.com
Date:   Wed, 24 Jul 2019 13:52:16 -0700
In-Reply-To: <20190723.140444.1126474066269131522.davem@davemloft.net>
References: <20190723173650.23276-1-jeffrey.t.kirsher@intel.com>
         <20190723173650.23276-7-jeffrey.t.kirsher@intel.com>
         <20190723.140444.1126474066269131522.davem@davemloft.net>
Organization: Intel
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-e+Wr+5sy43BnqLbqi93W"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-e+Wr+5sy43BnqLbqi93W
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2019-07-23 at 14:04 -0700, David Miller wrote:
> From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Date: Tue, 23 Jul 2019 10:36:50 -0700
>=20
> > diff --git a/drivers/net/ethernet/intel/e1000e/hw.h
> > b/drivers/net/ethernet/intel/e1000e/hw.h
> > index eff75bd8a8f0..e3c71fd093ee 100644
> > --- a/drivers/net/ethernet/intel/e1000e/hw.h
> > +++ b/drivers/net/ethernet/intel/e1000e/hw.h
> > @@ -662,6 +662,7 @@ struct e1000_dev_spec_ich8lan {
> >  	bool kmrn_lock_loss_workaround_enabled;
> >  	struct e1000_shadow_ram
> > shadow_ram[E1000_ICH8_SHADOW_RAM_WORDS];
> >  	bool nvm_k1_enabled;
> > +	bool disable_k1_off;
> >  	bool eee_disable;
>=20
> I don't see any code actually setting this boolean, how does it work?

So either this patch is missing a bit of code OR this is not needed for
the Linux driver.  Either way this patch needs changes or needs to be
dropped, so I am dropping this patch from the series until I get
further information from the client driver team.

I will be re-submitting this series, minus this patch.

--=-e+Wr+5sy43BnqLbqi93W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl04xQAACgkQ5W/vlVpL
7c6nDg/+JQsuf4MWO3fG0N+UFqb+g8AmGIxZSRREyh7N33a9WUEwL+AAM9mNJnbB
y7PL6SNVIP5deWP4aOyRvU6J9rFC/K2i6W8ioONUmsko0ukZKMf6AothiXtBxxbR
rRkfWCGQqjMwQWjoGkiW87NdpoCA62UwEcTMzWfAqaq9ijpXZCCKVmWokZEBGL8a
GhdBA17lh3nFdM7CeTJC+aWvwEM6OUjJJGBIcNjhYNmgX2m13B3uZOti/dSUbKUH
0zlhJmPbSZdId9qG6Jnz8b9wUyoTGC++lOmVX7hlwwgUwaz0VC2G/tBuM+veDZS8
9Nvaumyw79vv4LjpJySZf3S71dEvgD+nhSQg+0/0TsT17hkI0W26xHgLdWd0hR/Y
4pYHKI35H4TtQgCP8//5F2bixK8Lp+43nemLsZi6i2N9RmdX6Ak5qb2cvPUBpvz7
x8gvXOsoT2/zkejN9sV0R4Vil0PjqfgMBYPy9jswDQ7S0B5vFMuZF55hBn+B3fZr
QC8Z3DosT9sa2zK0AIc1Mi3ycYUadBJRQ3ZT3yAxRYNc2Ms2ltT17S5noF3djR2X
Nn6ffK2ez9wnQ0S9KkDe5SesFZkwKyMHsKgkgKUEbJWOfNzCiECEFbbatpBlTToA
q15EfBjbHUKS2MSAQzX/1r4rSUkcMrOLWu1PPnJDxJFGNIllV6c=
=Gyva
-----END PGP SIGNATURE-----

--=-e+Wr+5sy43BnqLbqi93W--

