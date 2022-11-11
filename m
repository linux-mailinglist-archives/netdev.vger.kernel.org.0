Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B94396338A8
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 10:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232646AbiKVJh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 04:37:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232748AbiKVJh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 04:37:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30EC810CD;
        Tue, 22 Nov 2022 01:37:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA754B81601;
        Tue, 22 Nov 2022 09:37:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDE05C433C1;
        Tue, 22 Nov 2022 09:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669109842;
        bh=RtXvZ0p1DP/VjpMADc1HaXxLba69hdFVNPBuDmoWC7s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eQQLa7wz8Va2cZW3GNLqUJXVzNbevBPDOzgi34cXw68HqcI6g7CcdHOgjyUuZYODR
         O212GMyq35vvp8www4x5WSLnICf8g5+mIRD9SJ2nLiqH0RmgiULkDPHCgFmn74/1e5
         MSZH+qzJOLh/Bch9pJly+6VKvlC2jAw6WicLo6PXZI1ue9Ea7IlM6F+vDediSIfGY+
         AqRTX+q+8iI5v99OM43eFDcD8UfAb4F//zG6afqBmPI5EwkvH54UxfoU5Y/XDL3Ivn
         ti1BKLkqd/E0OtjX6lQCoLfyZzXfXjqYjPpJHq09MCuBVFr0M/V/nOMx0OP1Ekp/7N
         Hy1LvXGJY2aMA==
Date:   Fri, 11 Nov 2022 01:56:25 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, daniel@makrotopia.org,
        krzysztof.kozlowski+dt@linaro.org,
        angelogioacchino.delregno@collabora.com
Subject: Re: [PATCH v4 net-next 2/8] dt-bindings: net: mediatek: add WED RX
 binding for MT7986 eth driver
Message-ID: <Y22duSNJT/4MbDof@localhost.localdomain>
References: <cover.1667687249.git.lorenzo@kernel.org>
 <2192d3974d30b1d0b8f4277c42cdb02f6feffbb9.1667687249.git.lorenzo@kernel.org>
 <20221110200926.GA885371-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Kig+5iN2ab7nhHx7"
Content-Disposition: inline
In-Reply-To: <20221110200926.GA885371-robh@kernel.org>
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DATE_IN_PAST_96_XX,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Kig+5iN2ab7nhHx7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Sat, Nov 05, 2022 at 11:36:17PM +0100, Lorenzo Bianconi wrote:
> > Document the binding for the RX Wireless Ethernet Dispatch core on the
> > MT7986 ethernet driver used to offload traffic received by WLAN NIC and
> > forwarded to LAN/WAN one.
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  .../arm/mediatek/mediatek,mt7622-wed.yaml     | 52 +++++++++++++++++++
> >  .../soc/mediatek/mediatek,mt7986-wo-ccif.yaml | 51 ++++++++++++++++++
>=20
> Are these blocks used for anything not networking related? If not, can=20
> you move them to bindings/net/. Can be a follow up patch if not=20
> respinning this again.

I was discussing about this with Krzysztof and he suggested to put
mt7986-wo-ccif.yaml in bindings/soc but I am fine both ways.
I will move them in bindings/net/ if I need to respin the series
otherwise I will post a follow-up patch.

Regards,
Lorenzo

>=20
> Reviewed-by: Rob Herring <robh@kernel.org>

--Kig+5iN2ab7nhHx7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY22dtgAKCRA6cBh0uS2t
rBbZAP9hbo5ogUlDzpmGLInxxC89ivIwLOtkvZzX1vOg8JgufAEA9tHhLVddaNef
sa4nGmd3gfhd+bzCszLvNWc5FZfJAwA=
=P86E
-----END PGP SIGNATURE-----

--Kig+5iN2ab7nhHx7--
