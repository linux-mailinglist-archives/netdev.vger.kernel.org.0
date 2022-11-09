Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D08C62336E
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 20:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiKIT0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 14:26:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiKIT0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 14:26:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B97625E87;
        Wed,  9 Nov 2022 11:26:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F410B81FFF;
        Wed,  9 Nov 2022 19:26:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E64CBC433D6;
        Wed,  9 Nov 2022 19:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668022006;
        bh=1uX18a8b8mPXxN5TnmlJgYzF03jqyQEV0omJHBCIyXE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OgSLDwZ9WUIAjy8gtH8PDiAZjB2YWerWP2uX+FTQKuzwFcdq1Dts1HsZrLcw+L7Oc
         X3WmX++VNKxhY8a3BGRd/JY2J57Gj/65zrX4OomoBIhrnSitCsu0c4eMe9SPZCxatX
         NjW9nLpSu8AO6MiRjW2/T3yhJmQgbA+Qua0yJ3qbIdSfj6xeWzoRxSV1pYTv5Six6m
         9rknHUiYc4SQm1K9IC1gsTtrgByXrLfUdVHBeR7gQDo/KfFs6L1pcC6ffWJoIcacNL
         BSHIpMDeneB+3KliAllGpIU/59P0SEprpMGhluttyShFqmBdMpuf4wNKyKE/wL5EWu
         zyfVCMoyTrCrg==
Date:   Wed, 9 Nov 2022 20:26:42 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Matthias Brugger <matthias.bgg@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        linux-mediatek@lists.infradead.org, Bo.Jiao@mediatek.com,
        sujuan.chen@mediatek.com, ryder.Lee@mediatek.com,
        evelyn.tsai@mediatek.com, devicetree@vger.kernel.org,
        robh+dt@kernel.org, daniel@makrotopia.org,
        krzysztof.kozlowski+dt@linaro.org,
        angelogioacchino.delregno@collabora.com, kvalo@kernel.org
Subject: Re: [PATCH v4 net-next 0/8] introduce WED RX support to MT7986 SoC
Message-ID: <Y2v+8nhgWq6IfyFS@localhost.localdomain>
References: <cover.1667687249.git.lorenzo@kernel.org>
 <Y2vBTBUw47sshA+E@localhost.localdomain>
 <20221109110538.431355ba@kernel.org>
 <f1a5c144-1d16-a65e-f629-c9d13946377a@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="S5LjoUW9NbQdQQuu"
Content-Disposition: inline
In-Reply-To: <f1a5c144-1d16-a65e-f629-c9d13946377a@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--S5LjoUW9NbQdQQuu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Nov 09, Matthias Brugger wrote:
>=20
>=20
> On 09/11/2022 20:05, Jakub Kicinski wrote:
> > On Wed, 9 Nov 2022 16:03:40 +0100 Lorenzo Bianconi wrote:
> > > I noticed today the series state is 'Awaiting Upstream'. I am wonderi=
ng if
> > > this series is expected to go through a different tree, e.g. wireless=
 one
> > > (adding Kalle in cc). In this particular case the series changes only
> > > the mtk ethernet driver and mt76 is built since we modify a common in=
clude (but
> > > there are no changes in mt76). My personal opinion is this series is =
suited to
> > > go through net-next tree but I would be fine even if it goes through =
Kalle's
> > > one. Any opinions?
> >=20
> > Works either way, we'll see what Kalle says.
> > Let me bring it back to Under review in the meantime.
> >=20
> > While I have you - no acks for the bindings yet? On previous versions?
>=20
> Please beware that the first patch should go through my tree. Let me know
> when things got merged and I'll take it.

ack thx, will do.

Regards,
Lorenzo

>=20
> Regards,
> Matthias

--S5LjoUW9NbQdQQuu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY2v+7wAKCRA6cBh0uS2t
rCsyAP9272Hnz5+yaK/90Ld+WMW0zZhHhJNYYB7TKa71vtQtIAEAl5CSBEJjAYbc
lTOlqm5D7q5UUL4WATo1dBQocBJ+2QI=
=ONj/
-----END PGP SIGNATURE-----

--S5LjoUW9NbQdQQuu--
