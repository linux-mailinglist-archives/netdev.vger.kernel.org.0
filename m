Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14B01493086
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 23:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344442AbiARWOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 17:14:00 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43112 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237483AbiARWN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 17:13:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4AD94B81719;
        Tue, 18 Jan 2022 22:13:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 525E6C340E0;
        Tue, 18 Jan 2022 22:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642544036;
        bh=FnenpFxMujhLVlT+4ugouVAkMiAJIe/6LWkpksdAr8o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FVC7svuDzJC1XdaHIrjQIQQIcV43Ovp/nePH9jrXs4xYLGoVKTqi/my9sDY6DWiO4
         p45VR5pE75Iq1ulA2SFyPdxEg8SXAwjmzc2rhLWVoyZHB+lQUr2eoYzB1TYJi7XMV1
         rPR5Ko5a0XPcn/UVMUqcBMOUrrJk6dsRNT/iMgoWlQAmOUbzrk0JyaP6dlw3P8eqd6
         AX4RJpGlWHV/ROjBh6ksFvokn1HaS5npbnQWrNVWha7dc7v9OPaBDu0uphH3nA0AY2
         cnJl3XuEhvX2rfLmyQ6HH0Uuu+mtPxq92BqH0dwnWkyejntARkc85DpSbCXAmhPm3j
         u1kwpgtAbftcA==
Date:   Tue, 18 Jan 2022 23:13:52 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v22 bpf-next 19/23] bpf: generalise tail call map
 compatibility check
Message-ID: <Yec7oLxuO8HzhmYr@lore-desk>
References: <cover.1642439548.git.lorenzo@kernel.org>
 <2e702db189683545e088b74f7d95eb396a329f64.1642439548.git.lorenzo@kernel.org>
 <20220118202308.2imtkkif4sagb22e@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="UqO+jpiAH5zkAkkz"
Content-Disposition: inline
In-Reply-To: <20220118202308.2imtkkif4sagb22e@ast-mbp.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--UqO+jpiAH5zkAkkz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, Jan 17, 2022 at 06:28:31PM +0100, Lorenzo Bianconi wrote:
> >  	seq_printf(m,
> > @@ -590,6 +589,7 @@ static void bpf_map_show_fdinfo(struct seq_file *m,=
 struct file *filp)
> >  	if (type) {
> >  		seq_printf(m, "owner_prog_type:\t%u\n", type);
> >  		seq_printf(m, "owner_jited:\t%u\n", jited);
> > +		seq_printf(m, "owner_xdp_has_frags:\t%u\n", xdp_has_frags);
>=20
> Internal flag shouldn't be printed in fdinfo.
> In particular it's not correct for non-xdp progs.

ack, I will drop owner_xdp_has_frags.

Regards,
Lorenzo

--UqO+jpiAH5zkAkkz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYec7oAAKCRA6cBh0uS2t
rGWEAP9kuIeXgv8NJgVUl+QbWOIhl3s10lu8njdFqg6amx8+AwD8DFWanaHJDQ73
RQ30cdJ1cIyZl8vJA3ydS7STm7PzcQ4=
=lyNp
-----END PGP SIGNATURE-----

--UqO+jpiAH5zkAkkz--
