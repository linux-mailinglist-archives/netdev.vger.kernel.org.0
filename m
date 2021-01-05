Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6F6F2EAF5E
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 16:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728430AbhAEPtF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 10:49:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:35018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727992AbhAEPtF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 10:49:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 856B72070C;
        Tue,  5 Jan 2021 15:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609861704;
        bh=exjbVXJp44u+pVE6fQ5+LZ7JcUb4ur3YJ8VVpBtZA/E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gMRuCgsYekpNaoOTme7BOK9BV4pd7gsOFdyDiEVCa4L97sPaGG7c5xNcmISFOhh18
         7WIEBCovZf9nMpVrKZafXj1Ch/Sd28l5gh/6wm4lpx5UIFhpicBXqmlG0v4GLpgAU2
         zBoYOYkU8MfArhPNSyUt9B8Lfz78obrgmu5D9AHJi//KPeUIwkRm+xCaf9y0cceDrU
         722lR8FPtXsRzLGu42WosALrUJO8pUaSBrtXM3mvtsHg6ERA/VLS06N9864Yn50r3K
         ZZfLaM9sEJR+fSgby2mq9c6DgYi+khhvHYwdu1mUROSxvVwG5L+nI8JDQT2XJ5kJD2
         Z9Q1LEZyyU+dg==
Date:   Tue, 5 Jan 2021 15:47:56 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        alsa-devel@alsa-project.org, Kiran Patil <kiran.patil@intel.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Martin Habets <mhabets@solarflare.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>, lee.jones@linaro.org
Subject: Re: [resend/standalone PATCH v4] Add auxiliary bus support
Message-ID: <20210105154756.GF4487@sirena.org.uk>
References: <20201218180310.GD5333@sirena.org.uk>
 <20201218184150.GY552508@nvidia.com>
 <20201218203211.GE5333@sirena.org.uk>
 <20201218205856.GZ552508@nvidia.com>
 <20201221185140.GD4521@sirena.org.uk>
 <20210104180831.GD552508@nvidia.com>
 <20210104211930.GI5645@sirena.org.uk>
 <20210105001341.GL552508@nvidia.com>
 <20210105134256.GA4487@sirena.org.uk>
 <20210105143627.GT552508@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Y1L3PTX8QE8cb2T+"
Content-Disposition: inline
In-Reply-To: <20210105143627.GT552508@nvidia.com>
X-Cookie: I'm ANN LANDERS!!  I can SHOPLIFT!!
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Y1L3PTX8QE8cb2T+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 05, 2021 at 10:36:27AM -0400, Jason Gunthorpe wrote:
> On Tue, Jan 05, 2021 at 01:42:56PM +0000, Mark Brown wrote:

> > You're missing the point there.  I2C is enumerated by firmware in
> > exactly the same way as the platform bus is, it's not discoverable from
> > the hardware (and similarly for a bunch of other buses).  If we were to

> No, I understand how I2C works and I think it is fine as is because
> the enumeration outcome is all standard. You always end up with a
> stable I2C device address (the name) and you always end up with the
> I2C programming API. So it doesn't matter how I2C gets enumerated, it
> is always an I2C device.

I don't follow this logic at all, sorry - whatever the platonic ideal of
what a platform device actually turns out to be when we get down to
using the hardware it's the same hardware which we interact with in the
same way no matter how we figured out that it was present.

--Y1L3PTX8QE8cb2T+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl/0iisACgkQJNaLcl1U
h9BB8wf+Nvnu4y6NJYvpzLoo2IgcymvT/prWQ1KEuyqHcAvdeu1xjdLu9OAfjsoy
pMF/Jm/JOZ0IFRHxXoUZFJV9xvCMn872QTO0DcCPdR+fM5h77AYQK8rgtimD/Ub8
EFDtt/K2ISvp4cA+YV9ERnZwi+LGpbUY9r5D9KYUJP4U+qJO1MgMq6YfXqrB2shL
l1ZUB5CF1y5gsuHe4oIT7h510NcjGaOhz8heNjXlfVM2w4gyZjgXvitT9uIxmIzC
TkqwF419JQgTFrNq6BsGB/19WH6AyMEokj987mDVEmeOJsvmZMRtExB4bL0UfgD/
PA6KL84AFXMSXgjzqeapAd8MOcTBnw==
=jQX1
-----END PGP SIGNATURE-----

--Y1L3PTX8QE8cb2T+--
