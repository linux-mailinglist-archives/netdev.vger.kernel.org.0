Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43C3C2B64B3
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 14:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387781AbgKQNsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 08:48:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:60376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732407AbgKQNs3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 08:48:29 -0500
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 823E7221F8;
        Tue, 17 Nov 2020 13:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620908;
        bh=OS86M0fSuRYOLM26EPZccF7FmZm2Eb5pCK+q9/AU8CA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bDyIDhCvTB2jn19fp4cy1NAMyTUIp5sxOJXlNeSHlcH+YOQbGdBMkDvJrB3HVOIZe
         419kmajtMLDjUGsw6kR1ONgE3AgGYRT7kNIWr6/smOilauicF5hTuYyBGrG8RTeZTu
         N8ugy3Vbd/JkPQ7ZMA6Oa5MR2F9Pf4/ZDPSictZo=
Date:   Tue, 17 Nov 2020 13:48:08 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Leon Romanovsky <leonro@nvidia.com>
Cc:     Dave Ertman <david.m.ertman@intel.com>, gregkh@linuxfoundation.org,
        alsa-devel@alsa-project.org, tiwai@suse.de,
        linux-rdma@vger.kernel.org, jgg@nvidia.com, dledford@redhat.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ranjani.sridharan@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, fred.oh@linux.intel.com,
        parav@mellanox.com, shiraz.saleem@intel.com,
        dan.j.williams@intel.com, kiran.patil@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 01/10] Add auxiliary bus support
Message-ID: <20201117134808.GC5142@sirena.org.uk>
References: <20201113161859.1775473-1-david.m.ertman@intel.com>
 <20201113161859.1775473-2-david.m.ertman@intel.com>
 <20201117053000.GM47002@unreal>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="H8ygTp4AXg6deix2"
Content-Disposition: inline
In-Reply-To: <20201117053000.GM47002@unreal>
X-Cookie: Pause for storage relocation.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--H8ygTp4AXg6deix2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 17, 2020 at 07:30:00AM +0200, Leon Romanovsky wrote:
> On Fri, Nov 13, 2020 at 08:18:50AM -0800, Dave Ertman wrote:

> > Add support for the Auxiliary Bus, auxiliary_device and auxiliary_driver.
> > It enables drivers to create an auxiliary_device and bind an
> > auxiliary_driver to it.

> This horse was beaten to death, can we please progress with this patch?
> Create special topic branch or ack so I'll prepare this branch.

It's been about 2 working days since the patch was last posted.

--H8ygTp4AXg6deix2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl+z1JcACgkQJNaLcl1U
h9DrPAgAhoKtJY3JUvyt5umyqYMB91rbKCdWbOcvmCUH3Onp6sIN6bjvKLZEieE3
yGf9wpM7/qbfovb2WB+pv2sk+V4T6q/eEKqB9ggRpnRHGH4xLqQP3UHMWPpXYOsY
3+SemZd6NgGXAVfbOXdZWeuikkj4X9xP48T5h4YuVLFqUIjKx58grErSkvNe16hp
mbeQkw/Wobr4XZr2nFxMupK6+IcpQP34roZRYX62FAx1Gp1+322QlTRn3rboC1Hn
3B3uf6qq2HC29TmYGBS2BOntIuOVyQOKrFn8u6oKPZ73OXr+vPU2wLjs83sXJjy5
Uc/MykNHE2TvTYJXkoVnE5i1t4bryg==
=Xd9v
-----END PGP SIGNATURE-----

--H8ygTp4AXg6deix2--
