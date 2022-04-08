Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 055584F921C
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 11:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232938AbiDHJg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 05:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231565AbiDHJg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 05:36:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B00BD37BC5;
        Fri,  8 Apr 2022 02:34:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CCFA61DAF;
        Fri,  8 Apr 2022 09:34:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E113C385A3;
        Fri,  8 Apr 2022 09:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649410462;
        bh=dkChLmZ2U6SrY+w/IpSt6wIwgxrmR0TxbU9q/QExDMQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c4vF7qEbi2YzOfQ6VvUOsxEKrY7PsCc18mKFzr640NTlOw3U0/GIdtTqiNKd7Yv8T
         Tv+GepSTDxEo+H2Vf1Z9S8BjhJPFm69MhOFpJZFK+3Me1PSXW7QXOYMZMg2SDX+DCV
         4QNJnhQKc/1lQl9vNFzbbyX4c0TwEt496AKPHSNdyWXPWOwSwVWRID62U5J1n0jU0/
         uprVJx07FJQRac/uuZ05cqvENdQM4UXQMbVCLeDtVRu6IrP9C3rwV0WZNaIZPC+ROw
         NHh2aMHS5z1wX3w/eUqTmmy4DC2OkNAMHoROc7f69n4TdcnGaRzKau61UZL9sVvORo
         Ob7q2YJUe4heQ==
Date:   Fri, 8 Apr 2022 11:34:18 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v2 01/14] dt-bindings: net: mediatek: add optional
 properties for the SoC ethernet core
Message-ID: <YlABmtzBDVRehh5u@lore-desk>
References: <20220405195755.10817-1-nbd@nbd.name>
 <20220405195755.10817-2-nbd@nbd.name>
 <Yk8ddwmSiFg3pslA@robh.at.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="jTDiGlGeTX59jyR9"
Content-Disposition: inline
In-Reply-To: <Yk8ddwmSiFg3pslA@robh.at.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--jTDiGlGeTX59jyR9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Tue, Apr 05, 2022 at 09:57:42PM +0200, Felix Fietkau wrote:
> > From: Lorenzo Bianconi <lorenzo@kernel.org>
> >=20
> > Introduce dma-coherent, cci-control and hifsys optional properties to
> > the mediatek ethernet controller bindings
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > Signed-off-by: Felix Fietkau <nbd@nbd.name>
> > ---
> >  Documentation/devicetree/bindings/net/mediatek-net.txt | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >=20
> > diff --git a/Documentation/devicetree/bindings/net/mediatek-net.txt b/D=
ocumentation/devicetree/bindings/net/mediatek-net.txt
> > index 72d03e07cf7c..13cb12ee4ed6 100644
> > --- a/Documentation/devicetree/bindings/net/mediatek-net.txt
> > +++ b/Documentation/devicetree/bindings/net/mediatek-net.txt
> > @@ -41,6 +41,12 @@ Required properties:
> >  - mediatek,pctl: phandle to the syscon node that handles the ports sle=
w rate
> >  	and driver current: only for MT2701 and MT7623 SoC
> > =20
> > +Optional properties:
> > +- dma-coherent: present if dma operations are coherent
> > +- mediatek,cci-control: phandle to the cache coherent interconnect node
>=20
> There's a common property for this already. See CCI-400 binding.
>=20
> > +- mediatek,hifsys: phandle to the mediatek hifsys controller used to p=
rovide
> > +	various clocks and reset to the system.
> > +
>=20
> This series is adding a handful of new properties. Please convert the=20
> binding to DT schema first.

ack, I will converti this file to yaml format.

Regards,
Lorenzo

>=20
> Rob

--jTDiGlGeTX59jyR9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYlABmgAKCRA6cBh0uS2t
rCHGAQCQmaNe46BtAnnaU0XjfU5usUblA/08rL3VkR0T5cktfAD/RcsMuvT+pISo
W0sCkOXhxLB2IBuyswPUVSZCO0JShQE=
=mbp4
-----END PGP SIGNATURE-----

--jTDiGlGeTX59jyR9--
