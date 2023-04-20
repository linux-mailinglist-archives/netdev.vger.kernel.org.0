Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D25C6E8B41
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 09:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234012AbjDTHS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 03:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbjDTHS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 03:18:57 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC37B1713
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 00:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1681975135; x=1713511135;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+zH90kNpKLzfeUXhi7S3n8fr7iwj7Y5BIVulhDAzrQE=;
  b=tZqmNZxjUlO7gAe+Sj6tEHSokMkD4kBX6Esnp0AYwXX766dZX8KUPKWT
   6MqYtYgfN7cnjD3TivVH+tEIIpBgrVGA9gWjX8+yCOafzdnFRdlDxl3LW
   gcGXuM3BnFJp0VtDcowY5X3I/yjO2+99Hjfj4NVQx9zY18NpSPDUSCK5E
   U3mLrNGX1wrS1Gn1evARxfua7FoCo/j9ic1WqKCSu3jivHdgPfLQVjCdD
   +2XMaHFmwDb5jHnu6d7QFu/yX1YxR34TCJOt+S7HrHRrgXgKQUq9sf7tS
   pS7zQ0JGk27hwvJoQByFIr+QM9Rb1/w7hPx5oZVy2e4/VyYgrN4tOacFt
   A==;
X-IronPort-AV: E=Sophos;i="5.99,211,1677567600"; 
   d="asc'?scan'208";a="148016186"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Apr 2023 00:18:54 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 20 Apr 2023 00:18:53 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Thu, 20 Apr 2023 00:18:52 -0700
Date:   Thu, 20 Apr 2023 08:18:35 +0100
From:   Conor Dooley <conor.dooley@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Simon Horman <simon.horman@corigine.com>,
        <daire.mcnamara@microchip.com>, <nicolas.ferre@microchip.com>,
        <claudiu.beznea@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] net: macb: Shorten max_tx_len to 4KiB - 56 on mpfs
Message-ID: <20230420-absinthe-broiler-b992997c6cc5@wendy>
References: <20230417140041.2254022-1-daire.mcnamara@microchip.com>
 <20230417140041.2254022-2-daire.mcnamara@microchip.com>
 <ZD6pCdvKdGAJsN3x@corigine.com>
 <20230419180222.07d78b8a@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fv5Y7vJfpqPhiijh"
Content-Disposition: inline
In-Reply-To: <20230419180222.07d78b8a@kernel.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--fv5Y7vJfpqPhiijh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Jaukb, Simon,

On Wed, Apr 19, 2023 at 06:02:22PM -0700, Jakub Kicinski wrote:
> On Tue, 18 Apr 2023 16:28:25 +0200 Simon Horman wrote:

[readding the context]

> > > static const struct macb_config sama7g5_gem_config =3D {
> > > @@ -4986,8 +4985,17 @@ static int macb_probe(struct platform_device *=
pdev)
> > >       bp->tx_clk =3D tx_clk;
> > >       bp->rx_clk =3D rx_clk;
> > >       bp->tsu_clk =3D tsu_clk;
> > > -     if (macb_config)
> > > +     if (macb_config) {
> > > +             if (hw_is_gem(bp->regs, bp->native_io)) {
> > > +                     if (macb_config->max_tx_length)
> > > +                             bp->max_tx_length =3D macb_config->max_=
tx_length;
> > > +                     else
> > > +                             bp->max_tx_length =3D GEM_MAX_TX_LEN;
> > > +             } else {
> > > +                     bp->max_tx_length =3D MACB_MAX_TX_LEN;
> > > +             }

> > no need to refresh the patch on my account.
> > But can the above be simplified as:
> >=20
> >                if (macb_is_gem(bp) && hw_is_gem(bp->regs, bp->native_io=
))
> >                        bp->max_tx_length =3D macb_config->max_tx_length;
> >                else
> >                        bp->max_tx_length =3D MACB_MAX_TX_LEN;
>=20
> I suspect that DaveM agreed, because patch is set to Changes Requested
> in patchwork :)=20
>=20
> Daire, please respin with Simon's suggestion.

I'm feeling a bit stupid reading this suggestion as I am not sure how it
is supposed to work :(

Firstly, why macb_is_gem() and hw_is_gem()? They both do the same thing,
except last time around we established that macb_is_gem() cannot return
anything other than false at this point.
What have I missed here?

Secondly, is it guaranteed that macb_config::max_tx_length is even
set?

Also, another question...
Is it even possible for `if (macb_config)` to be false?
Isn't it either going to be set to &default_gem_config or to
match->data, no? The driver is pretty inconsistent about if it checks
whether macb_config is non-NULL before accessing it, but from reading
=2Eprobe, it seems to be like it is always set to something valid at this
point.

(btw Daire, Nicolas' email has no h in it)

Cheers,
Conor.

--fv5Y7vJfpqPhiijh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZEDnSwAKCRB4tDGHoIJi
0hGTAP9zlviFlQlp2QgXaprhHDJjHCXPkHkdpc33e0TUxmHRHAEA+SOVWdg1sTe5
FW0ZfRuaZLJp7j5Ls3z8huxx9EyRDQI=
=zej9
-----END PGP SIGNATURE-----

--fv5Y7vJfpqPhiijh--
