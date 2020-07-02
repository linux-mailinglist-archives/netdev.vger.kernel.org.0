Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59490212338
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 14:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729104AbgGBMUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 08:20:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:39198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728808AbgGBMUf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 08:20:35 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCAE52084C;
        Thu,  2 Jul 2020 12:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593692435;
        bh=JRsQWQIRvil2lzfm5RzIfgVh20V7WVMTAsQvShOnTa8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wpVtyDSV5qRz/q/2V/M7zlrr/Ot31NlQJ+rN14P2AYrR/FUjyVIJ7WDtNYUfWAzmw
         KmomDtfuDqZVkCApnf7C+Io8hDb0ReoG78BHqmuhcpHRU0pJF4TAcsMUcIGWFubeV+
         2oSq64H9vOjMX36sTu8fbnq+9PPWAiIq+y65vYOc=
Date:   Thu, 2 Jul 2020 13:20:32 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Takashi Iwai <tiwai@suse.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Fred Oh <fred.oh@linux.intel.com>,
        lee.jones@linaro.org
Subject: Re: [net-next v4 10/12] ASoC: SOF: Introduce descriptors for SOF
 client
Message-ID: <20200702122032.GD4483@sirena.org.uk>
References: <20200629203317.GM5499@sirena.org.uk>
 <20200629225959.GF25301@ziepe.ca>
 <20200630103141.GA5272@sirena.org.uk>
 <20200630113245.GG25301@ziepe.ca>
 <936d8b1cbd7a598327e1b247441fa055d7083cb6.camel@linux.intel.com>
 <20200630172710.GJ25301@ziepe.ca>
 <20200701095049.GA5988@sirena.org.uk>
 <20200701233250.GP25301@ziepe.ca>
 <20200702111522.GA4483@sirena.org.uk>
 <20200702121147.GQ25301@ziepe.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="NtwzykIc2mflq5ck"
Content-Disposition: inline
In-Reply-To: <20200702121147.GQ25301@ziepe.ca>
X-Cookie: I'm rated PG-34!!
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--NtwzykIc2mflq5ck
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 02, 2020 at 09:11:47AM -0300, Jason Gunthorpe wrote:
> On Thu, Jul 02, 2020 at 12:15:22PM +0100, Mark Brown wrote:

> > These are very much physical devices often with distinct IPs in distinct
> > address ranges and so on, it's just that those addresses happen not to
> > be on buses it is sensible to memory map.

> But platform bus is all about memmory mapping, so how does the
> subdevice learn the address range and properly share the underlying
> transport?

Hard coding, some out of band mechanism or using an unparented register
region (the resource the code is fine, it's not going to actually look
at the registers described).

--NtwzykIc2mflq5ck
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl790RAACgkQJNaLcl1U
h9C8Ygf+Kxu/BiRuIl0FHMQzvFHOP8VbBGznBp2reGiFb41xqw2HK3BDOthnGqmA
LOAbPcshGN13wVeoNl2iiSdKVFAl74Mhx+RyfFlP43mNLeNkcd9uZYiFQR7Pfc3w
N4Vmp51ryxDeLW9KlOn6hRG562TcAyJZ4M7cj5COcKkACuE6UpUtsupa3SHTdTgy
8EayY2evuCHE91Oh2FTVrYSPDabTkApc0fvn1lsMK/dFXUDGwFc7gGdaOEaLmZfH
X13v0ATFlWHkQfI++Jx76sy3cutCvqN4bpdt1nHk/6B6zY2qNPWZ/Yv1+QdypnrJ
b9l3NJwW7f/pSYDG8x0Z8KzulshfQA==
=n1Ak
-----END PGP SIGNATURE-----

--NtwzykIc2mflq5ck--
