Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 390DF6A6971
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 10:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbjCAJFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 04:05:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbjCAJEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 04:04:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F6839CFA;
        Wed,  1 Mar 2023 01:04:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 868626126D;
        Wed,  1 Mar 2023 09:04:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC2FC433EF;
        Wed,  1 Mar 2023 09:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677661492;
        bh=z21i2bbgNle1vRUEVDDjhe6+QJGLMIv8uol1hWtOW1o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rafZEzwch6hhuYeCBElLaflPtGxRFYkogh1e7gU7FsVSDet+Tf8owF0/NhlAUFOIF
         JbFaw/YvY0PtzTOnxmXDE9ClYlSZqbLX2okqUVTgDDaNz8LLB+JU5ylpJUxW2YGWwB
         T4XJ6BYjhshCe4BCkpyueHPgWof0AHm3bwIPAunMvIgMayz5Ya2TfoJBoLMwRPZwvf
         40tfSGL5D0igO0r9B1X+1YCPfbje6Yh9jrgoNoIeW0akX4yEnvHwI/CozPSvs7kFTU
         W5QCJD8nKqGM6KTy/ex2tyIJ1LZFL7B1VVeNb9e7fpJIp15DykPUPsOw+FEsBsudQ3
         ZW6jzh60b/PoA==
Date:   Wed, 1 Mar 2023 10:04:48 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        saeedm@nvidia.com, tariqt@nvidia.com, leon@kernel.org,
        shayagr@amazon.com, akiyano@amazon.com, darinzon@amazon.com,
        sgoutham@marvell.com, lorenzo.bianconi@redhat.com, toke@redhat.com
Subject: Re: [RFC net-next 1/6] tools: ynl: fix render-max for flags
 definition
Message-ID: <Y/8VMKdFt8Y5cQpg@lore-desk>
References: <cover.1677153730.git.lorenzo@kernel.org>
 <0252b7d3f7af70ce5d9da688bae4f883b8dfa9c7.1677153730.git.lorenzo@kernel.org>
 <20230223090937.53103f89@kernel.org>
 <Y/6LQH4hU/gYROKO@lore-desk>
 <20230228152820.566b6052@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="khxZ9ndY9zi3kzKY"
Content-Disposition: inline
In-Reply-To: <20230228152820.566b6052@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--khxZ9ndY9zi3kzKY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Wed, 1 Mar 2023 00:16:16 +0100 Lorenzo Bianconi wrote:
> > > I think it also needs to be fixed to actually walk the elements=20
> > > and combine the user_value()s rather than count them and assume
> > > there are no gaps. =20
> >=20
> > Do you mean get_mask()?
>=20
> Yup, get_mask() predates the ability to control the values of enum
> entries individually so while at it we should fix it.

ack, I will add a separated patch to the series.

Regards,
Lorenzo

--khxZ9ndY9zi3kzKY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY/8VMAAKCRA6cBh0uS2t
rBIXAP4uvFJ0g0DEdF+4uvxHNdfpisPKoKBB9VT/9LBQnbPgYwD9EBis27NK54py
f7T5YByEHGXaVLGKfPSkrUdinxB2+go=
=RzvK
-----END PGP SIGNATURE-----

--khxZ9ndY9zi3kzKY--
