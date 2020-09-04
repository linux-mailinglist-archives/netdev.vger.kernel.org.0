Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E76F25D289
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 09:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728507AbgIDHkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 03:40:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726089AbgIDHkc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 03:40:32 -0400
Received: from localhost (unknown [151.66.86.87])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F5EA206A5;
        Fri,  4 Sep 2020 07:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599205232;
        bh=FOdk5hsqjXFV4tIITIMVatNZ+qAboAjUq6pSlLuEdI4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=epUNS6oA40LG8MYE5KHRci0weVfPq0ZSbyu9tL1SbU4kMYYnf5CMg4YxyMOanAq9l
         0dA8LkUjVKsFgLQswqtkBtmnEsDZHlb94PkUiFSkyff+99b3PO1fw+stEzuNOQOkIm
         IKubT6w3j5gNsUcxuQKU7p5CqcqsrFAtPvo3d9pc=
Date:   Fri, 4 Sep 2020 09:40:27 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, brouer@redhat.com,
        echaudro@redhat.com, sameehj@amazon.com, kuba@kernel.org,
        john.fastabend@gmail.com, daniel@iogearbox.net, ast@kernel.org,
        shayagr@amazon.com
Subject: Re: [PATCH v2 net-next 0/9] mvneta: introduce XDP multi-buffer
 support
Message-ID: <20200904074027.GB2884@lore-desk>
References: <cover.1599165031.git.lorenzo@kernel.org>
 <20200904010803.nt2jfuhrbqe5cj53@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="TRYliJ5NKNqkz5bu"
Content-Disposition: inline
In-Reply-To: <20200904010803.nt2jfuhrbqe5cj53@ast-mbp.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--TRYliJ5NKNqkz5bu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Thu, Sep 03, 2020 at 10:58:44PM +0200, Lorenzo Bianconi wrote:
> > For the moment we have not implemented any self-test for the introduced=
 the bpf
> > helpers. We can address this in a follow up series if the proposed appr=
oach
> > is accepted.
>=20
> selftest has to be part of the same patch set.

sure, I will add it in v3.

Regards,
Lorenzo

--TRYliJ5NKNqkz5bu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCX1HvaAAKCRA6cBh0uS2t
rFILAPwO/r9LUFhyFy0pHYimeFVKGVwlVkQ69OqvwRCNHDUnmAEAvSAx7Y0JRWnW
vgvCAZiB2kRrJ2P8iBJl6YFIhM0Tlgc=
=1rYw
-----END PGP SIGNATURE-----

--TRYliJ5NKNqkz5bu--
