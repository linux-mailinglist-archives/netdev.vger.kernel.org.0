Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDFDD8C3E
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 11:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391910AbfJPJJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 05:09:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:42162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390073AbfJPJJ6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 05:09:58 -0400
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76FA32168B;
        Wed, 16 Oct 2019 09:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571216997;
        bh=iDCksRpugAcXUUWARGRyi7bH2s+yUDmQkSVRGQNhsts=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X1A8KUa8Xc6MkhVXutDVAohb9UeLAj9QVRP7PupzueRt4Stv5mWm+xPEILcwTNhFg
         A/yAwCixdgsMc0Ww5fEcYdUqw1g0thz0qRuEiADzHLGHP+gAH4/zXVbWV4TWQLHIc3
         57gnp2LVcKEfWDqSnvNyY6urvNfMaCLNAIuJMBqk=
Date:   Wed, 16 Oct 2019 11:09:51 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, thomas.petazzoni@bootlin.com,
        brouer@redhat.com, ilias.apalodimas@linaro.org,
        matteo.croce@redhat.com, mw@semihalf.com
Subject: Re: [PATCH v3 net-next 4/8] net: mvneta: sync dma buffers before
 refilling hw queues
Message-ID: <20191016090951.GD2638@localhost.localdomain>
References: <cover.1571049326.git.lorenzo@kernel.org>
 <e458e8e4e1d9aa936d64346ca02e432b3b0b7b34.1571049326.git.lorenzo@kernel.org>
 <20191015160151.2d227995@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="OROCMA9jn6tkzFBc"
Content-Disposition: inline
In-Reply-To: <20191015160151.2d227995@cakuba.netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--OROCMA9jn6tkzFBc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Oct 15, Jakub Kicinski wrote:
> On Mon, 14 Oct 2019 12:49:51 +0200, Lorenzo Bianconi wrote:
> > mvneta driver can run on not cache coherent devices so it is
> > necessary to sync DMA buffers before sending them to the device
> > in order to avoid memory corruptions. Running perf analysis we can
> > see a performance cost associated with this DMA-sync (anyway it is
> > already there in the original driver code). In follow up patches we
> > will add more logic to reduce DMA-sync as much as possible.
> >=20
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>=20
> Should this not be squashed into patch 2? Isn't there a transient bug
> otherwise?

We put it in a separate patch to track it in a explicit way. I will squash =
it
in the previous patch. Thx.

Regards,
Lorenzo

--OROCMA9jn6tkzFBc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXabeXQAKCRA6cBh0uS2t
rE+qAQD1jpNlvFH1OmmzXzavhopTCCNVb3M8RBW0EKQUj/QaawEAiE/RuXKAiauw
UWUnR6+OLLVLQ/xnhc55I88H2/+e8QQ=
=iprY
-----END PGP SIGNATURE-----

--OROCMA9jn6tkzFBc--
