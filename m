Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16820633B74
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 12:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232671AbiKVLen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 06:34:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232756AbiKVLeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 06:34:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EA4A57B68;
        Tue, 22 Nov 2022 03:28:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD662B8190C;
        Tue, 22 Nov 2022 11:28:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D87C433D6;
        Tue, 22 Nov 2022 11:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669116494;
        bh=6NCM6m31OczIAvsK/iy/GTtUbOr+0Immp0oWffvrMeA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vgm/WLBj9j4v3l0ckOLVXUSNGoV/3JN32+v0rS4nPs3rYoclkrcLBmGgQxJcG37x4
         WdBQ8mOeCQtJda46M3vYLsmsjM7px3vF9aukN9oROquqkxIoqMTfrashC7qRVvJnvH
         zdvqBfTuugU07MSQIZhcjR9Ii69VHdR4CqziCZgVMD544U7NJuQgrwMS8novta3+bX
         +FeMRXdT60tbU3ema1UjHD1eq+stL0ALsKu4Fcmr+S5JYIEB9C5gbdXsTNJpl9Q4bU
         GW6DfQCySFTEldRVMcywvp7aP4ubepHuYEg1IQznAajvHmcfCtt4hX8nToGNabuW27
         eaePpR6OPQZuQ==
Date:   Tue, 22 Nov 2022 11:28:01 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Conor Dooley <conor@kernel.org>
Cc:     Alexander Lobakin <alobakin@pm.me>, linux-kbuild@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Schier <nicolas@fjasle.eu>,
        Jens Axboe <axboe@kernel.dk>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Derek Chickles <dchickles@marvell.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Daniel Scally <djrscally@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        NXP Linux Team <linux-imx@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/18] treewide: fix object files shared between several
 modules
Message-ID: <Y3yyQS7Q8cL+z89L@sirena.org.uk>
References: <20221119225650.1044591-1-alobakin@pm.me>
 <Y3oWYhw9VZOANneu@sirena.org.uk>
 <Y3oc2B6y0TB51+/j@spud>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="GZgMp8h7GaJD8EJs"
Content-Disposition: inline
In-Reply-To: <Y3oc2B6y0TB51+/j@spud>
X-Cookie: That's what she said.
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--GZgMp8h7GaJD8EJs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 20, 2022 at 12:26:00PM +0000, Conor Dooley wrote:
> On Sun, Nov 20, 2022 at 11:58:26AM +0000, Mark Brown wrote:
> > On Sat, Nov 19, 2022 at 11:03:57PM +0000, Alexander Lobakin wrote:

> > Your mails appear to be encrypted which isn't helping with
> > review...

> https://lore.kernel.org/all/20221119225650.1044591-1-alobakin@pm.me/

> Looks un-encrypted on lore. pm.me looks to be a protonmail domain - I
> had issues with protonmail where it picked up Maz's key via Web Key
> Directory. "Kernel.org publishes the WKD for all developers who have
> kernel.org accounts" & unfortunately proton doesn't (or didn't) offer a
> way to disable this. If someone's key is available it gets used & proton
> told me, IIRC, that not having a way to disable this is a privacy
> feature.

It wasn't obviously encrypted to my key either...=20

--GZgMp8h7GaJD8EJs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmN8skAACgkQJNaLcl1U
h9A3zwf8CWUf5xGrZknftvQzY1zcdbm1NfAH7drvcnlBKaeN5/5IAXzz0T92hgTh
KVP3hFD/dw7SQz/FJGYJKAMxHeI5GhXtWsc4QoWBvVdjnR44Xz3GtAkp2pW8dV+C
CJ5gDnRy+Q81W5Mt/c0HaFiJOFhodMEqFxJclOiIfR8Euilxob2Xa2moJku4CS5t
Bt09ghKrW8l3cTq4TxCa4dAsNc/VBcjjwaOHgmC/AHlW+WfDeZZahvWfD1SBY2T9
H1iFavcwXFQ8pPAtzLcg/8qqzw696nM0LbGFnLIG/nAdtdM7+vOncmwmIPElCLBc
uyRU0xb6uTkIlLl1ThRtzVT0GmIW+A==
=uKrw
-----END PGP SIGNATURE-----

--GZgMp8h7GaJD8EJs--
