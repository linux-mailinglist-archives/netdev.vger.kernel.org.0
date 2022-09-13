Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26A425B6D5E
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 14:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbiIMMgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 08:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232167AbiIMMfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 08:35:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B1D74F1AE;
        Tue, 13 Sep 2022 05:35:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7979DB80EAF;
        Tue, 13 Sep 2022 12:35:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A73CCC433D7;
        Tue, 13 Sep 2022 12:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663072528;
        bh=uHIBPhso38HQKEjnPuE3Q0bWh5FsM+Uxinj0JhYllyE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nB7wHUPdjoC1IC5X4AqEub0UfBrlv+rwv+kvtlii6wiH4LJdtiC1ObJojV1NNqcHr
         rzgfkRNxpR2angv+u6PykUQQhGk+GzxfwICyHUz5s6XSzPzmByMh8Rl/CodnEn76d2
         VlB1ekO71fwdrGCxOw19Hu4w61wvvXQLNpOsGzvR3yWFGPjVKUZvYRToCd25PVev8a
         MQUBzfrAT181SCeTP+6jSk1/Zz5vgod4FCjX8NuvlNH4VytQ3KVl0eiWaFD2Ky9OXU
         Jncdl5d2xDOvtM+hGDNbB9lFdV60qDfx4RHuFzzBrtjBVXp/B9757huE80mQ3smcZ9
         g9kMvHUYjZpqA==
Date:   Tue, 13 Sep 2022 14:35:24 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 02/12] dt-bindings: net: mediatek: add WED
 binding for MT7986 eth driver
Message-ID: <YyB5DNIihzwdpfnP@lore-desk>
References: <cover.1662661555.git.lorenzo@kernel.org>
 <e8e2e1134fde632b7f6aaf9d96feab471385f84c.1662661555.git.lorenzo@kernel.org>
 <20220913121149.GB3397630-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="glOFOUKnXXIJKcRM"
Content-Disposition: inline
In-Reply-To: <20220913121149.GB3397630-robh@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--glOFOUKnXXIJKcRM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Thu, Sep 08, 2022 at 09:33:36PM +0200, Lorenzo Bianconi wrote:
> > Document the binding for the Wireless Ethernet Dispatch core on the
> > MT7986 ethernet driver
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  Documentation/devicetree/bindings/net/mediatek,net.yaml | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >=20
> > diff --git a/Documentation/devicetree/bindings/net/mediatek,net.yaml b/=
Documentation/devicetree/bindings/net/mediatek,net.yaml
> > index f5564ecddb62..0116f100ef19 100644
> > --- a/Documentation/devicetree/bindings/net/mediatek,net.yaml
> > +++ b/Documentation/devicetree/bindings/net/mediatek,net.yaml
> > @@ -238,6 +238,15 @@ allOf:
> >            minItems: 2
> >            maxItems: 2
> > =20
> > +        mediatek,wed:
> > +          $ref: /schemas/types.yaml#/definitions/phandle-array
> > +          minItems: 2
> > +          maxItems: 2
> > +          items:
> > +            maxItems: 1
> > +          description:
> > +            List of phandles to wireless ethernet dispatch nodes.
>=20
> There's already a definition of this in the binding. Move it to the main=
=20
> section and put 'mediatek,wed: false' in if/then schemas for variants=20
> that don't have it.

ack, I will fix it in v2.

Regards,
Lorenzo

>=20
> Rob

--glOFOUKnXXIJKcRM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYyB5DAAKCRA6cBh0uS2t
rH5VAP9r5wu/WxhYFf8dIOlicHQDZN6wIFzX8X/7pBVxvvcwBQD+M8TRrQPqazjQ
ldlFUEfUuFbhyHyCrpeXw08o+DqluwA=
=Ef0Z
-----END PGP SIGNATURE-----

--glOFOUKnXXIJKcRM--
