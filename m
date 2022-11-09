Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8588E623365
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 20:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbiKITZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 14:25:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiKITZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 14:25:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2EB725EA4;
        Wed,  9 Nov 2022 11:25:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 813A2B81FFE;
        Wed,  9 Nov 2022 19:25:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFDDFC433C1;
        Wed,  9 Nov 2022 19:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668021902;
        bh=ip/AnK0Rtg2qvGWV6UUeSnQwXbFGAjeugxOFKnCk5Z0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=keKC3WFCNxQkqhrTT6a1knlNZfqPkPiX0nyW/5LmXK5yO0utwreZZFqFCf5BQLbGM
         Cm+5wCe1yLhLJn8/pPNZT8qYmx5dI7SY9/9gMi/8pVsSVdRBscnsDKpesUYGjtCxn5
         DqkIxyAok8DkQB08WzTbQidFyMbkCGG72gJ/mG5uasmb5nJHrF44sW4+aQW+BllPGJ
         US4AWToMUX0tno0GSMecMnogIAb0Jbp4VeF2K2B2rdgzD/oMSHqMFF83/c8rj7PCEK
         2l49ihD4yOE8C6/FsHPZph6y1WHXdtwyxsEe+hhsh32YRi+apN6h9uw6PQ0o/W3a8z
         KJoD5yMLFNfQQ==
Date:   Wed, 9 Nov 2022 20:24:58 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        matthias.bgg@gmail.com, linux-mediatek@lists.infradead.org,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        daniel@makrotopia.org, krzysztof.kozlowski+dt@linaro.org,
        angelogioacchino.delregno@collabora.com, kvalo@kernel.org
Subject: Re: [PATCH v4 net-next 0/8] introduce WED RX support to MT7986 SoC
Message-ID: <Y2v+igz0TJ8LSsFj@localhost.localdomain>
References: <cover.1667687249.git.lorenzo@kernel.org>
 <Y2vBTBUw47sshA+E@localhost.localdomain>
 <20221109110538.431355ba@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="LVhjj4TesPNRZPNK"
Content-Disposition: inline
In-Reply-To: <20221109110538.431355ba@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--LVhjj4TesPNRZPNK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Wed, 9 Nov 2022 16:03:40 +0100 Lorenzo Bianconi wrote:
> > I noticed today the series state is 'Awaiting Upstream'. I am wondering=
 if
> > this series is expected to go through a different tree, e.g. wireless o=
ne
> > (adding Kalle in cc). In this particular case the series changes only
> > the mtk ethernet driver and mt76 is built since we modify a common incl=
ude (but
> > there are no changes in mt76). My personal opinion is this series is su=
ited to
> > go through net-next tree but I would be fine even if it goes through Ka=
lle's
> > one. Any opinions?
>=20
> Works either way, we'll see what Kalle says.
> Let me bring it back to Under review in the meantime.

ack, thanks :)

>=20
> While I have you - no acks for the bindings yet? On previous versions?

not yet, I addressed Krzysztof's comments on v3 in v4 so I am waiting for a=
 new
review.

Regards,
Lorenzo

--LVhjj4TesPNRZPNK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY2v+hwAKCRA6cBh0uS2t
rIvsAP91ANH6T6Qn8/Kf4qbyrckYMH3nX8oIPJnxcbls+W09gAD/Sa3wgr0z46+j
pz/Fnk3FyMWn2ZAk025IeMxiRk4huwI=
=aKpZ
-----END PGP SIGNATURE-----

--LVhjj4TesPNRZPNK--
