Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E26F127EF6E
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 18:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730969AbgI3QjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 12:39:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:41168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbgI3QjN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 12:39:13 -0400
Received: from localhost (unknown [176.207.245.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B974F20789;
        Wed, 30 Sep 2020 16:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601483952;
        bh=aWUVJSc8HA5FfTbndrNQEu3zYoNBgEGsIYWLYsUiAUI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cofxsPZipFAPiFHdiMQ4ScxWDOypkxVQfFEXByFp/3lFwnVfYRXN3WFZwErv5i0L2
         D32rJn2KrhgeUDJMp4bv0izkCNHnBsK13L5c7W9SYxNrJMxUx1XQ4PFbsfgGIsDQOf
         fTaUWIuAfg+GkfBd/Ple97Qo3sQ/A1er2RB8MCYo=
Date:   Wed, 30 Sep 2020 18:39:07 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        sameehj@amazon.com, john.fastabend@gmail.com, daniel@iogearbox.net,
        ast@kernel.org, shayagr@amazon.com, brouer@redhat.com,
        echaudro@redhat.com, lorenzo.bianconi@redhat.com,
        dsahern@kernel.org
Subject: Re: [PATCH v3 net-next 00/12] mvneta: introduce XDP multi-buffer
 support
Message-ID: <20200930163907.GF17959@lore-desk>
References: <cover.1601478613.git.lorenzo@kernel.org>
 <20200930093130.3c589423@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="m1UC1K4AOz1Ywdkx"
Content-Disposition: inline
In-Reply-To: <20200930093130.3c589423@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--m1UC1K4AOz1Ywdkx
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Wed, 30 Sep 2020 17:41:51 +0200 Lorenzo Bianconi wrote:
> > This series introduce XDP multi-buffer support. The mvneta driver is
> > the first to support these new "non-linear" xdp_{buff,frame}. Reviewers
> > please focus on how these new types of xdp_{buff,frame} packets
> > traverse the different layers and the layout design. It is on purpose
> > that BPF-helpers are kept simple, as we don't want to expose the
> > internal layout to allow later changes.
>=20
> This does not apply cleanly to net-next =F0=9F=A4=94

Hi Jakub,

patch 12/12 ("bpf: cpumap: introduce xdp multi-buff support") is based on c=
ommit
efa90b50934c ("cpumap: Remove rcpu pointer from cpu_map_build_skb signature=
")
already in bpf-next. I though it was important to add patch 12/12 to the
series. Do you have other conflicts?

Regards,
Lorenzo

--m1UC1K4AOz1Ywdkx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCX3S0qQAKCRA6cBh0uS2t
rJcYAQDf1cbDgfFlPSXM7VjfbALTz6zH4ajq6Kc9lEoHeuixPQEAioU+4G63hFZ2
qXwYITtjv2mITspLgDYLpPfCVT+0TgQ=
=OaRH
-----END PGP SIGNATURE-----

--m1UC1K4AOz1Ywdkx--
