Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1829E6A63BD
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 00:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbjB1XQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 18:16:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjB1XQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 18:16:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F66D166C6;
        Tue, 28 Feb 2023 15:16:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AC9BB80E4B;
        Tue, 28 Feb 2023 23:16:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75506C433D2;
        Tue, 28 Feb 2023 23:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677626180;
        bh=ERmFCkj7IoQFdU80XQC2CBJ5rOvNvcnNl0RimI1JqJ4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YIYGkKwO2oAABs4fYhEUmuT39biIK5lYX+IThcix3phLURllIEYvain9EZesZNxMu
         As5+06AHCifpXay5DBFOYzFiRqLdq2qIvh5+CYsqL4xc+LCZdVLa+9/yD4EeJQSzU1
         qtlaMsEkm6UjBidBo3HqRb23uJEzmZAJt59mkg+K+J77CJ1VLhOISW/hv8A3jxZ8Qd
         RCwLjsU3TvvSeTnXtWCfXPhfj/QBBFpoA9RnOWqLtfe9FX+CTRZwrxl2W8E14issgZ
         TfXC1bf4Bo9M3GCD3TAw2rdyd0fGmEznAZWE/9AeMnEWUTvB9fbtuwSfjvklOeoR8e
         FEIU3CTvSsdCQ==
Date:   Wed, 1 Mar 2023 00:16:16 +0100
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
Message-ID: <Y/6LQH4hU/gYROKO@lore-desk>
References: <cover.1677153730.git.lorenzo@kernel.org>
 <0252b7d3f7af70ce5d9da688bae4f883b8dfa9c7.1677153730.git.lorenzo@kernel.org>
 <20230223090937.53103f89@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="mPqpjwl2gv4PoY0S"
Content-Disposition: inline
In-Reply-To: <20230223090937.53103f89@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--mPqpjwl2gv4PoY0S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Thu, 23 Feb 2023 13:11:33 +0100 Lorenzo Bianconi wrote:
> > +                if const['type'] =3D=3D 'flags':
> > +                    max_name =3D c_upper(name_pfx + 'mask')
> > +                    max_val =3D f' =3D {(entry.user_value() << 1) - 1}=
,'
> > +                    cw.p(max_name + max_val)
>=20
> Could you use EnumSet::get_mask instead() ?

ack, I will fix it.

>=20
> I think it also needs to be fixed to actually walk the elements=20
> and combine the user_value()s rather than count them and assume
> there are no gaps.

Do you mean get_mask()?

Regards,
Lorenzo

--mPqpjwl2gv4PoY0S
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY/6LQAAKCRA6cBh0uS2t
rNKpAQDjLvcF0WZj1TFvRCAveaKfscci8PerXmcYaBtZpl7G9wD/WEudF+M+c+iH
S0/cGCKxk8LOiXGxhjul4V9IyN/JFwo=
=K3VY
-----END PGP SIGNATURE-----

--mPqpjwl2gv4PoY0S--
