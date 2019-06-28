Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8DE5995B
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 13:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbfF1LoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 07:44:17 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:35393 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726564AbfF1LoR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 07:44:17 -0400
Received: from [5.158.153.52] (helo=linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <kurt.kanzenbach@linutronix.de>)
        id 1hgpIb-0002So-1B; Fri, 28 Jun 2019 13:44:13 +0200
Date:   Fri, 28 Jun 2019 13:44:12 +0200
From:   Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Benedikt Spranger <b.spranger@linutronix.de>,
        netdev@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [RFC PATCH 1/1] Documentation: net: dsa: b53: Describe b53
 configuration
Message-ID: <20190628114412.3qqsnneeji5wxzi4@linutronix.de>
References: <39b134ed-9f3e-418a-bf26-c1e716018e7e@gmail.com>
 <20190627101506.19727-1-b.spranger@linutronix.de>
 <20190627101506.19727-2-b.spranger@linutronix.de>
 <5fe6c1b8-6273-be3d-cf75-6efdd7f9b27d@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bcamcvmd4uhx7w3s"
Content-Disposition: inline
In-Reply-To: <5fe6c1b8-6273-be3d-cf75-6efdd7f9b27d@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--bcamcvmd4uhx7w3s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Thu, Jun 27, 2019 at 09:38:16AM -0700, Florian Fainelli wrote:
> On 6/27/19 3:15 AM, Benedikt Spranger wrote:
> > Document the different needs of documentation for the b53 driver.
> >
> > Signed-off-by: Benedikt Spranger <b.spranger@linutronix.de>
> > ---
> >  Documentation/networking/dsa/b53.rst | 300 +++++++++++++++++++++++++++
> >  1 file changed, 300 insertions(+)
> >  create mode 100644 Documentation/networking/dsa/b53.rst
> >
> > diff --git a/Documentation/networking/dsa/b53.rst b/Documentation/networking/dsa/b53.rst
> > new file mode 100644
> > index 000000000000..5838cf6230da
> > --- /dev/null
> > +++ b/Documentation/networking/dsa/b53.rst
> > @@ -0,0 +1,300 @@
> > +.. SPDX-License-Identifier: GPL-2.0
> > +
> > +==========================================
> > +Broadcom RoboSwitch Ethernet switch driver
> > +==========================================
> > +
> > +The Broadcom RoboSwitch Ethernet switch family is used in quite a range of
> > +xDSL router, cable modems and other multimedia devices.
> > +
> > +The actual implementation supports the devices BCM5325E, BCM5365, BCM539x,
> > +BCM53115 and BCM53125 as well as BCM63XX.
> > +
> > +Implementation details
> > +======================
> > +
> > +The driver is located in ``drivers/net/dsa/bcm_sf2.c`` and is implemented as a
> > +DSA driver; see ``Documentation/networking/dsa/dsa.rst`` for details on the
> > +subsystemand what it provides.
>
> The driver is under drivers/net/dsa/b53/
>
> s/ethernet/Ethernet/ for your global submission.
>
> What you are describing is not entirely specific to the B53 driver
> (maybe with the exception of having a VLAN tag on the DSA master network
> device, since B53 puts the CPU port tagged in all VLANs by default), and
> therefore the entire document should be written with the general DSA
> devices in mind, and eventually pointing out where B53 differs in a
> separate document.

That's true. It makes sense to split the documentation into a generic
and the b53 specific part.

Thanks a lot, Bene, for doing this. It's really helpful.

Thanks,
Kurt

--bcamcvmd4uhx7w3s
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl0V/YwACgkQeSpbgcuY
8KYxORAAuBTdvWuo1aXxQPR+PX9Pq7GUiuvSKGxMs+lCpD7E0xlKqVzYtOi8H46O
2KdY3nep733E7W3ATECq6cUtn750w9ArE1Y8OaogAC9bsfY3/nI4FzkbeRfNozpc
70ONWn81D2C2plr8rLZLGDVyuRJISVZk+y2YBxvXhZ0lWn/MAOA81dqe1cq1rrBc
Hvf7xO5pHTg7/68u4RK11JoCAcZtw63AvnIE+YCBt3rG12unzc4Gl1e914WnCe7s
STG7sJ2rPhVECNtRuKjMvfx8R2d5SyzjUAj7Mo32qzf2ZkcxI4JTiNPVzyDysuIS
4XCbuLxlev2UrOJGMZPMA6X7E2KF2q1buzSCNIlqT/SsOHbtdI/rN2PQl377NvfV
5KABiMh4+xKlMS9/51l4EhWY3tKJ5ZHA6wjaSj9bhGPJRjUi5dqga6+j0zKeKVWr
RGqTHnt2bYaKBw2CO94DznwtiDmHmYMUvwgqS1bbvWXj9M1EzlG5GTuXppvwgcCi
iwxg11LD1ItkIfEPhVcdwO1pQmJLCf3bczAyLkVIJ4RdePFFGrLwetLLUYNmWjLA
kZyjak7k/r9KGtkYCdHu8HMC6Cks/lJahiM02cllzgFov7IlRYrlVNeBQhf4kgob
FI/Er+1lOKzsmEbPg5PDyoE45rA6sNcfbk9WsdvQ2d0M7abaFMY=
=j7bp
-----END PGP SIGNATURE-----

--bcamcvmd4uhx7w3s--
