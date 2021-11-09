Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A74644B510
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 22:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244470AbhKIWBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 17:01:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:33926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237422AbhKIWBC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 17:01:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24FCD61177;
        Tue,  9 Nov 2021 21:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636495095;
        bh=K7/RWXNmIZ4b5Efp504XvDWDV1msyyr7fkDycknssRw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X88s04fFVzqgHjNi2f0rD8hcfBwDtnZjsaw2joEHdm58Ym6WPWAyYNOkAfrJ8LnIb
         s2Na+XPYO1DNK82NWPmelXlogUdRy9EjrbwZDz7VFFC+O1INWZzHV74KW5m4ANGxFQ
         pi5VE0fneK2rIXZIbFb2M8hDhlGaIxwzJWPAnVV/3a8LRQ8rst1VqTeDfhA7yDVyUo
         BtCpV1wkjBUtOFTch4XND55d6aUt7R6499opRTRquw7HqpVUYm+ytjtDyL+OusQaqw
         tFZ90M2LtM+FDxhstRYpyQC3X147Ff+48fd9L/ioo/D/0P/VCN49RVhrJKPkSyCIa4
         mW1C/5T7TTqKg==
Date:   Tue, 9 Nov 2021 22:58:11 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, john.fastabend@gmail.com,
        dsahern@kernel.org, brouer@redhat.com, echaudro@redhat.com,
        jasowang@redhat.com, alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com
Subject: Re: [PATCH v17 bpf-next 12/23] bpf: add multi-buff support to the
 bpf_xdp_adjust_tail() API
Message-ID: <YYru8wI3XAC3P1r3@lore-desk>
References: <cover.1636044387.git.lorenzo@kernel.org>
 <fd0400802295a87a921ba95d880ad27b9f9b8636.1636044387.git.lorenzo@kernel.org>
 <20211105162941.46b807e5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YYlWcuUwcKGYtWAR@lore-desk>
 <87fss6r058.fsf@toke.dk>
 <YYl1P+nPSuMjI+e6@lore-desk>
 <20211108134059.738ce863@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GMfHRMkChqh/b365"
Content-Disposition: inline
In-Reply-To: <20211108134059.738ce863@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--GMfHRMkChqh/b365
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, 8 Nov 2021 20:06:39 +0100 Lorenzo Bianconi wrote:
> > > Not sure I get what the issue is with this either? But having a test
> > > that can be run to validate this on hardware would be great in any ca=
se,
> > > I suppose - we've been discussing more general "compliance tests" for
> > > XDP before... =20
> >=20
> > what about option 2? We can add a frag_size field to rxq [0] that is se=
t by
> > the driver initializing the xdp_buff. frag_size set to 0 means we can u=
se
> > all the buffer.
>=20
> So 0 would mean xdp->frame_sz can be used for extending frags?
>=20
> I was expecting that we'd used rxq->frag_size in place of xdp->frame_sz.
>=20
> For devices doing payload packing we will not be able to extend the
> last frag at all. Wouldn't it be better to keep 0 for the case where
> extending is not allowed?

ack, I am fine with it. I will integrate it in v18. Thanks.

Regards,
Lorenzo

--GMfHRMkChqh/b365
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYYru8wAKCRA6cBh0uS2t
rJwcAP9ZjowUOGVsaq6eqvKxwSIN2OZjO6Duwbsvk6SFqs7E8gD9Gx+fpU7dJSL/
TadXjt1knOB1fTUtGMGuKZT9e9tzuwQ=
=O8z+
-----END PGP SIGNATURE-----

--GMfHRMkChqh/b365--
