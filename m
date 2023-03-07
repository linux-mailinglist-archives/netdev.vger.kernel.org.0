Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B53816AD4C8
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 03:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbjCGCgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 21:36:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbjCGCgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 21:36:35 -0500
Received: from stravinsky.debian.org (stravinsky.debian.org [IPv6:2001:41b8:202:deb::311:108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48BE341B7E;
        Mon,  6 Mar 2023 18:36:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
        s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=c+uKi3uKQIn7P5Qi2hP7gbUIY92VwWVqjxDVLjoSzuE=; b=uZ0bwoUzBIFLAch0SfwSUb8rPf
        OM0pbHspCWdnexCiFYsSBgAZzD5VrVihUZ6AfBwp+0llxOTUb/vExt5r8dxLDw3oHPAFW8YQJP1Xh
        2gQOZAB9BOzU19doGM1uXVeU+GDKgXW+7i8MJvu7j7RR7Ej8XWA2FJhMLOv6hkmmTyChMYn+vkht2
        t6H28R3PEC9baIGvIkCv+CYMFcPsCdm74k1S2H72bEBtLIyALnLNYJvSRTtr7bugf/MfkYWdzFVZR
        Z5xzgpvZqXZXH/c9TPnflKty/FRvmJ6oauFM8C3ZI35pR2u8yj0lofxI3Ka+sE3LaP6nDGeFVGGbd
        hnyiZ7fQ==;
Received: from authenticated user
        by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <kibi@debian.org>)
        id 1pZNB9-002Ki7-Gm; Tue, 07 Mar 2023 02:35:52 +0000
Date:   Tue, 7 Mar 2023 03:35:49 +0100
From:   Cyril Brulebois <kibi@debian.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] wifi: ath11k_pci: add a soft dependency on qrtr-mhi
Message-ID: <20230307023549.qoiru6roecng4rd6@mraw.org>
Organization: Debian
References: <20221202130600.883174-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="bhlnwtrwaoldqj6y"
Content-Disposition: inline
In-Reply-To: <20221202130600.883174-1-hch@lst.de>
X-Debian-User: kibi
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--bhlnwtrwaoldqj6y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hallo Christoph,

Christoph Hellwig <hch@lst.de> (2022-12-02):
> While ath11k_pci can load without qrtr-mhi, probing the actual hardware
> will fail when qrtr and qrtr-mhi aren't loaded with
>=20
>    failed to initialize qmi handle: -517
>=20
> Add a MODULE_SOFTDEP statement to bring the module in (and as a hint
> for kernel packaging) for those cases where it isn't autoloaded already
> for some reason.

That's indeed a very helpful hint, which helped us fix support for this
module in a Debian Installer context (where we don't ship each and every
module built in the linux-image package, but some limited selection).

  https://salsa.debian.org/kernel-team/linux/-/merge_requests/667


Cheers,
--=20
Cyril Brulebois (kibi@debian.org)            <https://debamax.com/>
D-I release manager -- Release team member -- Freelance Consultant

--bhlnwtrwaoldqj6y
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEtg6/KYRFPHDXTPR4/5FK8MKzVSAFAmQGowUACgkQ/5FK8MKz
VSDQsRAAr1yV7/CFuJqS14vw+F/uJW5o4307UNu++7FuLl7W6GP9YQaNdMcasT+6
85/LJavcjS7njkVGFcxiWVK74KLq42guPPw9c7fjv7CfD2qgruGjQtaq4dDnrskO
qBXR2+TvhJdq2IlU630M5upAmqGk7Uxn+02Pc2pVv7Qu2kZNt7Vjx9Er9ULnKO5d
6z6yT4/rI/K0ltVRymb581+x1ZZEu18ja6khoyKFbHplBNIChULwDrh2uxKenNHX
G8n19Rki07ckWubXzR7Fnudss5B7shCY0UWd96X8TDHAV4yTfvoPYlxOAaCLugGq
8MBAK0B5/PDXSaoV+O8Oxg08muYXJOLGA1SmuByz+SdeiqISTnnnbUh0gLzVu45v
XlZzMhhgEfroRTEl1ASa8MkfxZLlR/7flFteKFe4hf/DLERJKV3xUICZg4y4XQM+
jWbiLL7COVHpmCYgIk+rgdfzUZV6ruXfapdRwyctQMsCsZl3oZSyIikISuEveCDl
pR67Yn9OoGRFqwXuTR7/Ol0LRejiMzdhZjlJLQmtQBD3kWOAIZVmb55xLbjN0pUJ
LQNekbwOvmeZPDFuPHIgW+Tq79xT7kwk/Qk9msrsQn55rIZprAIxW4x/19DqVuyy
GkhqZb4Nwrp7ESbvia3uj9KWRLNdGTzQR/mSJZzoX1VFuMNzNHE=
=vdrE
-----END PGP SIGNATURE-----

--bhlnwtrwaoldqj6y--
