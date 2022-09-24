Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 476EB5E8BB3
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 13:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbiIXLKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Sep 2022 07:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbiIXLKv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Sep 2022 07:10:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F0D2CDC2;
        Sat, 24 Sep 2022 04:10:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F741B80064;
        Sat, 24 Sep 2022 11:10:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B84CCC433C1;
        Sat, 24 Sep 2022 11:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664017848;
        bh=moMYFsTxDis8k0ITz3KzvOmPgRf5m0VlTGmYz82WC9g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KNzFFQTAgmC215Qc8gFAd7WYEja0DsJGRuWt3OqKRO6I9cwQbJ18CzniIHWIK7z6z
         eizjMeJMg6ZDs0SH5yitGABi7hIm3Iv6Bfogp0Ca2SMZgdiTEI8Vgv3tSIs0oYj9eh
         kEsGpH5YNqr90K20eiE7sbVSaG+GwiQosEc4TNZmtRh3KNuan7bwBOtxbkPGIa2oBm
         D/zMF+SlTXxZoCBVEDw+g7aZxq433Dn1S6Wh0ANZFAXt9gruw/CNe1GkTezuPFypCd
         yE3sP0/tuds5bWVHZsM36VnY2yyMONui+sOFsIo3x0VaOdVgROT69g1EbDt/vNvu2W
         ZruT2JCt7Qnrw==
Date:   Sat, 24 Sep 2022 13:10:44 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com
Subject: Re: [PATCH v3 bpf-next 2/3] net: netfilter: add bpf_ct_set_nat_info
 kfunc helper
Message-ID: <Yy7ltMthyiWn/cYM@lore-desk>
References: <cover.1663778601.git.lorenzo@kernel.org>
 <9567db2fdfa5bebe7b7cc5870f7a34549418b4fc.1663778601.git.lorenzo@kernel.org>
 <Yy4mVv+4X/Tm3TK4@dev-arch.thelio-3990X>
 <Yy4xGT7XGGredCB2@lore-desk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zzZ6kGI1UU3X2OKk"
Content-Disposition: inline
In-Reply-To: <Yy4xGT7XGGredCB2@lore-desk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--zzZ6kGI1UU3X2OKk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> > Hi Lorenzo,
>=20
> Hi Nathan,
>=20
> >=20
> > On Wed, Sep 21, 2022 at 06:48:26PM +0200, Lorenzo Bianconi wrote:
> > > Introduce bpf_ct_set_nat_info kfunc helper in order to set source and
> > > destination nat addresses/ports in a new allocated ct entry not inser=
ted
> > > in the connection tracking table yet.
> > >=20
> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> >=20
> > This commit is now in -next as commit 0fabd2aa199f ("net: netfilter: add
> > bpf_ct_set_nat_info kfunc helper"). Unfortunately, it introduces a
> > circular dependency when I build with my distribution's (Arch Linux)
> > configuration:
> >=20
> > $ curl -LSso .config https://github.com/archlinux/svntogit-packages/raw=
/packages/linux/trunk/config
> >=20
> > $ make -skj"$(nproc)" INSTALL_MOD_PATH=3Drootfs INSTALL_MOD_STRIP=3D1 o=
lddefconfig all modules_install
> > ...
> > WARN: multiple IDs found for 'nf_conn': 99333, 114119 - using 99333
> > WARN: multiple IDs found for 'nf_conn': 99333, 115663 - using 99333
> > WARN: multiple IDs found for 'nf_conn': 99333, 117330 - using 99333
> > WARN: multiple IDs found for 'nf_conn': 99333, 119583 - using 99333
> > depmod: ERROR: Cycle detected: nf_conntrack -> nf_nat -> nf_conntrack
> > depmod: ERROR: Found 2 modules in dependency cycles!
>=20
> I guess the issue occurs when we compile both nf_conntrack and nf_nat as =
module
> since now we introduced the dependency "nf_conntrack -> nf_nat".
> Discussing with Kumar, in order to fix it, we can move bpf_ct_set_nat_inf=
o() in
> nf_nat module (with some required registration code similar to register_n=
f_conntrack_bpf()).
> What do you think?
> Sorry for the inconvenience.

Hi Nathan,

this is a PoC of what I described above:
https://github.com/LorenzoBianconi/bpf-next/commit/765d32dd08e56f5059532845=
e70d0bbfe4badda1

Regards,
Lorenzo

>=20
> Regards,
> Lorenzo
>=20
>=20
> > ...
> >=20
> > The WARN lines are there before this change but I figured they were
> > worth including anyways, in case they factor in here.
> >=20
> > If there is any more information I can provide or patches I can test,
> > please let me know!
> >=20
> > Cheers,
> > Nathan



--zzZ6kGI1UU3X2OKk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYy7ltAAKCRA6cBh0uS2t
rFSCAP0SWl2gwWs7is/1Z6XsNkBLk8wtJQ6SwCzPXbk9F8j8nQEA/ubKT67PaV1s
qIrC6oriKJuzEFI4cNfuk/RxS8KQ3wA=
=xx/x
-----END PGP SIGNATURE-----

--zzZ6kGI1UU3X2OKk--
