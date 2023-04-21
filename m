Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B91006EAF5B
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 18:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233205AbjDUQkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 12:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233254AbjDUQj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 12:39:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C3701992
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 09:39:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26F72651DA
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 16:39:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 570F9C433EF;
        Fri, 21 Apr 2023 16:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682095197;
        bh=Iuec1gYcdrepKKZx7h2iVr8WAzkdy6oIQLDlqnfLAuM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jIzrX8W8kb1ThVl+3h54YaR+nEV292SEZyxLFOUZpl38wF6CfwBYn7qIfzAN//Frp
         Sr77/DZl7R1BB3N8dQd63VrlvTLEVwa2QRdiYKCJTZrJOPs791JpzdxTBZvyGunm4X
         /ETZhx2zokRX9v+kifqv9++/4ij9F8mUmQ0k18A/Nuq5mpUPXr1etwAZGD+QDNJMo5
         zQbv4E9VOCo9Ru4HcfEnHXgMljxQNRNnQaJrGNEGVE2xyDQteB+hljGCFXJP3drxgg
         1O0COD6rnlc6S/mQ1mjR0OuPQf6pJetnYWA6Y4POeNethM+aOku9R7l0es8+OTiQDQ
         Mu2JSnMwL+dAw==
Date:   Fri, 21 Apr 2023 17:39:52 +0100
From:   Conor Dooley <conor@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Conor Dooley <conor.dooley@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>, daire.mcnamara@microchip.com,
        nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 1/1] net: macb: Shorten max_tx_len to 4KiB - 56 on mpfs
Message-ID: <20230421-gentleman-contrite-bad775caf1c9@spud>
References: <20230417140041.2254022-1-daire.mcnamara@microchip.com>
 <20230417140041.2254022-2-daire.mcnamara@microchip.com>
 <ZD6pCdvKdGAJsN3x@corigine.com>
 <20230419180222.07d78b8a@kernel.org>
 <20230420-absinthe-broiler-b992997c6cc5@wendy>
 <ZEKYH0FblGmAOkiP@corigine.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="8sbplJ0Zql8uItbL"
Content-Disposition: inline
In-Reply-To: <ZEKYH0FblGmAOkiP@corigine.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--8sbplJ0Zql8uItbL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Simon,

On Fri, Apr 21, 2023 at 04:05:19PM +0200, Simon Horman wrote:
> On Thu, Apr 20, 2023 at 08:18:35AM +0100, Conor Dooley wrote:
> > Jaukb, Simon,
> >=20
> > On Wed, Apr 19, 2023 at 06:02:22PM -0700, Jakub Kicinski wrote:
> > > On Tue, 18 Apr 2023 16:28:25 +0200 Simon Horman wrote:
> >=20
> > [readding the context]
> >=20
> > > > > static const struct macb_config sama7g5_gem_config =3D {
> > > > > @@ -4986,8 +4985,17 @@ static int macb_probe(struct platform_devi=
ce *pdev)
> > > > >       bp->tx_clk =3D tx_clk;
> > > > >       bp->rx_clk =3D rx_clk;
> > > > >       bp->tsu_clk =3D tsu_clk;
> > > > > -     if (macb_config)
> > > > > +     if (macb_config) {
> > > > > +             if (hw_is_gem(bp->regs, bp->native_io)) {
> > > > > +                     if (macb_config->max_tx_length)
> > > > > +                             bp->max_tx_length =3D macb_config->=
max_tx_length;
> > > > > +                     else
> > > > > +                             bp->max_tx_length =3D GEM_MAX_TX_LE=
N;
> > > > > +             } else {
> > > > > +                     bp->max_tx_length =3D MACB_MAX_TX_LEN;
> > > > > +             }
> >=20
> > > > no need to refresh the patch on my account.
> > > > But can the above be simplified as:
> > > >=20
> > > >                if (macb_is_gem(bp) && hw_is_gem(bp->regs, bp->nativ=
e_io))
> > > >                        bp->max_tx_length =3D macb_config->max_tx_le=
ngth;
> > > >                else
> > > >                        bp->max_tx_length =3D MACB_MAX_TX_LEN;
> > >=20
> > > I suspect that DaveM agreed, because patch is set to Changes Requested
> > > in patchwork :)=20
> > >=20
> > > Daire, please respin with Simon's suggestion.
> >=20
> > I'm feeling a bit stupid reading this suggestion as I am not sure how it
> > is supposed to work :(

> just to clarify, my suggestion was at a slightly higher level regarding
> the arrangement of logic statements:
>=20
> 	if (a)
> 		if (b)
>=20
> 	vs
>=20
> 	if (a && b)

Ah, I do at least feel less stupid now!
There are 3 possible conditions though, you'd be left with something
like:
	if !hw_is_gem()
	else if macb_config->max_tx_length
	else
>=20
> I think your concerns are deeper and, in my reading of them, ought
> to be addressed.
>=20
> > Firstly, why macb_is_gem() and hw_is_gem()? They both do the same thing,
> > except last time around we established that macb_is_gem() cannot return
> > anything other than false at this point.
> > What have I missed here?
> >=20
> > Secondly, is it guaranteed that macb_config::max_tx_length is even
> > set?

These two were concerns about your suggestion, so they can now be
disregarded as you'd not been seriously suggesting that particular
if (false && hw_is_gem()) test ;)

> > Also, another question...
> > Is it even possible for `if (macb_config)` to be false?
> > Isn't it either going to be set to &default_gem_config or to
> > match->data, no? The driver is pretty inconsistent about if it checks
> > whether macb_config is non-NULL before accessing it, but from reading
> > .probe, it seems to be like it is always set to something valid at this
> > point.

This one though is more of a question for the drivers's maintainers -
Daire's only gone and copied what's done about 4 lines above the top of
the diff. Removing useless NULL checks, assuming they are useless, is
surely out of scope for sorting out this erratum though, no?

Cheers,
Conor.

--8sbplJ0Zql8uItbL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZEK8WAAKCRB4tDGHoIJi
0pyHAP0QHAQ1gIlnUy6++rU29nhuvd33hQ6V0Y3wtURO8ZTZdwD/Z43nm3Mye1Ac
W+v4DX9cAx5DrZ5lkMC5jfdbIeUwBAw=
=d2FD
-----END PGP SIGNATURE-----

--8sbplJ0Zql8uItbL--
