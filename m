Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA69C4FBC61
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 14:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346105AbiDKMs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 08:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346065AbiDKMs0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 08:48:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1AEC2898B
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 05:46:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92305616AC
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 12:46:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7377AC385A4;
        Mon, 11 Apr 2022 12:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649681168;
        bh=2V1ENK41ZMdnWbDRLtpKtWTNIKuHFwV3p2Hm8oqLZN0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WrdEq5wIQ2JtAuZpymzhJixQ/FmugS65qyd9KPlw6DMkukciipMnaYltCbFFwOiWT
         J5gO4y/ruLCJ6qE7yU95dhw//f4TTgRmRnevZlQMXnxKwqvItFYfG0fS73zhZR4lhe
         eKLGdHle08EbvQV7ghapunJ4vVRvNxAYh7nVoYzxOIAhQo/MNktx3r8cIcEp0C85wA
         EeXR8SXEMgSannRsfxhyBcXiFQrymOMegHMVvW60dLmVWjwqzxL6cPNK85sm+bw/cO
         W6zV7yolqpHrx3R4M2HNZMRPcfxILWHhbFFoxSeAYv1DLMNNganmHXiu8B3rFvTTW2
         4IChg6Cv7F0AQ==
Date:   Mon, 11 Apr 2022 14:46:03 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        thomas.petazzoni@bootlin.com, linux@armlinux.org.uk,
        jbrouer@redhat.com, jdamato@fastly.com, andrew@lunn.ch
Subject: Re: [PATCH v3 net-next 1/2] net: page_pool: introduce ethtool stats
Message-ID: <YlQjC7qpFXU7vmiH@lore-desk>
References: <cover.1649528984.git.lorenzo@kernel.org>
 <628c0a6d9bdbc547c93fcd4ae2e84d08af7bc8e1.1649528984.git.lorenzo@kernel.org>
 <CAC_iWj+wGjx4uAmtkvP=kJsD1uBKsxUXPfy8YS8Abhz=ooLmkg@mail.gmail.com>
 <YlQe8QysuyGRtxAx@lore-desk>
 <CAC_iWj+fk4hkpBQE6SnusVHFJMoq3u40Hn2VK7uCmUADXM2MPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="0ZYe2Sfv5yxtwWa2"
Content-Disposition: inline
In-Reply-To: <CAC_iWj+fk4hkpBQE6SnusVHFJMoq3u40Hn2VK7uCmUADXM2MPQ@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--0ZYe2Sfv5yxtwWa2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Apr 11, Ilias Apalodimas wrote:
> On Mon, 11 Apr 2022 at 15:28, Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> >
> > > Hi Lorenzo,
> >
> > Hi Ilias,
> >
> > >
> > > [...]
> > >
> > > >
> > > >         for_each_possible_cpu(cpu) {
> > > >                 const struct page_pool_recycle_stats *pcpu =3D
> > > > @@ -66,6 +87,47 @@ bool page_pool_get_stats(struct page_pool *pool,
> > > >         return true;
> > > >  }
> > > >  EXPORT_SYMBOL(page_pool_get_stats);
> > > > +
> > > > +u8 *page_pool_ethtool_stats_get_strings(u8 *data)
> > > > +{
> > > > +       int i;
> > > > +
> > > > +       for (i =3D 0; i < ARRAY_SIZE(pp_stats); i++) {
> > > > +               memcpy(data, pp_stats[i], ETH_GSTRING_LEN);
> > > > +               data +=3D ETH_GSTRING_LEN;
> > > > +       }
> > > > +
> > > > +       return data;
> > >
> > > Is there a point returning data here or can we make this a void?
> >
> > it is to add the capability to add more strings in the driver code after
> > running page_pool_ethtool_stats_get_strings.
>=20
> But the current driver isn't using it.  I don't have too much
> experience with how drivers consume ethtool stats, but would it make
> more sense to return a length instead of a pointer? Maybe Andrew has
> an idea.

yes, but it is for future usage. Returning a pointer modified by a
local routine is a common approach in the kernel (not sure about ethtool)
and it seems straightforward to me but len is fine as well. Opinions?

Regards,
Lorenzo

>=20
> Thanks
> /Ilias
> >
> > >
> > > > +}
> > > > +EXPORT_SYMBOL(page_pool_ethtool_stats_get_strings);
> > > > +
> > > > +int page_pool_ethtool_stats_get_count(void)
> > > > +{
> > > > +       return ARRAY_SIZE(pp_stats);
> > > > +}
> > > > +EXPORT_SYMBOL(page_pool_ethtool_stats_get_count);
> > > > +
> > > > +u64 *page_pool_ethtool_stats_get(u64 *data, struct page_pool_stats=
 *stats)
> > > > +{
> > > > +       int i;
> > > > +
> > > > +       for (i =3D 0; i < ARRAY_SIZE(pp_stats); i++) {
> > > > +               *data++ =3D stats->alloc_stats.fast;
> > > > +               *data++ =3D stats->alloc_stats.slow;
> > > > +               *data++ =3D stats->alloc_stats.slow_high_order;
> > > > +               *data++ =3D stats->alloc_stats.empty;
> > > > +               *data++ =3D stats->alloc_stats.refill;
> > > > +               *data++ =3D stats->alloc_stats.waive;
> > > > +               *data++ =3D stats->recycle_stats.cached;
> > > > +               *data++ =3D stats->recycle_stats.cache_full;
> > > > +               *data++ =3D stats->recycle_stats.ring;
> > > > +               *data++ =3D stats->recycle_stats.ring_full;
> > > > +               *data++ =3D stats->recycle_stats.released_refcnt;
> > > > +       }
> > > > +
> > > > +       return data;
> > >
> > > Ditto
> >
> > same here.
> >
> > Regards,
> > Lorenzo
> >
> > >
> > > > +}
> > > > +EXPORT_SYMBOL(page_pool_ethtool_stats_get);
> > > >  #else
> > > >  #define alloc_stat_inc(pool, __stat)
> > > >  #define recycle_stat_inc(pool, __stat)
> > > > --
> > > > 2.35.1
> > > >
> > >
> > > Thanks
> > > /Ilias

--0ZYe2Sfv5yxtwWa2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYlQjCwAKCRA6cBh0uS2t
rOheAQCEeevQI5OKg/G5yi384wiJEon92a/uvLqzpQub9DpoPQEA6WtteJG0IZ5B
teUplprgththo4xdI6GslgJYjp9ZqQk=
=XyWG
-----END PGP SIGNATURE-----

--0ZYe2Sfv5yxtwWa2--
