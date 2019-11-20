Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7B7103FC6
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 16:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732406AbfKTPpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 10:45:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:43918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731014AbfKTPpb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 10:45:31 -0500
Received: from localhost.localdomain (unknown [77.139.212.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3FD820692;
        Wed, 20 Nov 2019 15:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574264731;
        bh=0x7wnAM/xM+nqAilDk6fMJYh3Ipp+4mYWBHyZefHCMg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jJieJVn7RLkIb5FcCFrbvuscldFFIy5fspS/qCEtkMcHteGdDP7Bny3oTgc/xfKIY
         mRlOf4OfZN+cURZru2ILKKB7sQem8FHXzAn7vTr8omcmu2J5hvSkJjHlxI9g1C7qyn
         cIhA4CyO0QPH2xCs3HrHcdXlQ2H39sgGiWw/QQCg=
Date:   Wed, 20 Nov 2019 17:45:22 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        ilias.apalodimas@linaro.org, lorenzo.bianconi@redhat.com,
        mcroce@redhat.com, jonathan.lemon@gmail.com
Subject: Re: [PATCH v5 net-next 0/3] add DMA-sync-for-device capability to
 page_pool API
Message-ID: <20191120154522.GC21993@localhost.localdomain>
References: <cover.1574261017.git.lorenzo@kernel.org>
 <20191120163708.3b37077a@carbon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="raC6veAxrt5nqIoY"
Content-Disposition: inline
In-Reply-To: <20191120163708.3b37077a@carbon>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--raC6veAxrt5nqIoY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Wed, 20 Nov 2019 16:54:16 +0200
> Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>=20
> > Do not change naming convention for the moment since the changes will
> > hit other drivers as well. I will address it in another series.
>=20
> Yes, I agree, as I also said over IRC (freenode #xdp).
>=20
> The length (dma_sync_size) API addition to __page_pool_put_page() is
> for now confined to this driver (mvneta).  We can postpone the API-name
> discussion, as you have promised here (and on IRC) that you will
> "address it in another series".  (Guess, given timing, the followup
> series and discussion will happen after the merge window...)

Right, I will work on it after next merging window.

Regards,
Lorenzo

>=20
> --=20
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>=20

--raC6veAxrt5nqIoY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXdVfjwAKCRA6cBh0uS2t
rDaKAP9nHpchuj/WddpUaslyu8HLqmvsLweb/8Sjcl0In/SUWgEA1otIM/0eedjU
NJ/LEmqYBTpBxgm6B1MKcYWuo+RGDAw=
=31++
-----END PGP SIGNATURE-----

--raC6veAxrt5nqIoY--
