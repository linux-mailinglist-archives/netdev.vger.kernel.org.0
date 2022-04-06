Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 194D94F639D
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 17:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236329AbiDFPs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 11:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236959AbiDFPrz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 11:47:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77743B823D
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 06:05:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33D52B8238C
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 13:05:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 855E0C385A3;
        Wed,  6 Apr 2022 13:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649250329;
        bh=c4qgaatkLILQ1szoxlluUbb290MuAWu9J72MRTfYmwI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KVbWzresDk8G6ZfvDci3bwnLOVB3rFUdaVBkILCwLaqtNs9rtX0pYEp8apyU09q1W
         irvZ0vBsImGWBorXImwJcipI1Re21h2rPa5khIqbWMmUC6FrgfVJxMldQkhZToswpU
         PYjRuVki67wSF+5eVPqMVDMLvPMEtC61ikIOqvFCcgGg6+RHeQLwVH5Uunr5Bpe/AS
         ub3x8RS/H0OZhkZA+2B0lfa0dkHKFvXmxBCz8Fzty+zP2EmNKhq24rJydg6Vu67M06
         /cFXZ5t9a3ouVgxnJrmpQYtQZ7Ch11foQc3pq02lFHW4ZeQMYXOFodFQiCGyoU6Oku
         tDFIgNeNFqLWQ==
Date:   Wed, 6 Apr 2022 15:05:26 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, thomas.petazzoni@bootlin.com,
        linux@armlinux.org.uk, jbrouer@redhat.com, jdamato@fastly.com
Subject: Re: [PATCH net-next] net: mvneta: add support for page_pool_get_stats
Message-ID: <Yk2QFmvQOSiL8WKH@lore-desk>
References: <e4a3bb0fb407ead607b85f7f041f24b586c8b99d.1649190493.git.lorenzo@kernel.org>
 <Yk2Mb9zUZZFaFLGm@lunn.ch>
 <CAC_iWjLD8_PsC=AHqR+FeH3qA-TWfWRDfah+7QHXS6dGx7AJPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="U3xKgZz54xav6m0c"
Content-Disposition: inline
In-Reply-To: <CAC_iWjLD8_PsC=AHqR+FeH3qA-TWfWRDfah+7QHXS6dGx7AJPA@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--U3xKgZz54xav6m0c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Hi Andrew
>=20
> On Wed, 6 Apr 2022 at 15:49, Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > On Tue, Apr 05, 2022 at 10:32:12PM +0200, Lorenzo Bianconi wrote:
> > > Introduce support for the page_pool_get_stats API to mvneta driver.
> > > If CONFIG_PAGE_POOL_STATS is enabled, ethtool will report page pool
> > > stats.
> >
> > Hi Lorenzo
> >
> > There are a lot of #ifdef in this patch. They are generally not
> > liked. What does the patch actually depend on? mnveta has a select
> > PAGE_POOL so the page pool itself should always be available?
>=20
> The stats are on a different Kconfig since we wanted to allow people
> opt out if they were worried about performance.  However this is not a
> 10gbit interface and I doubt there will be any measurable hit.  I
> think selecting PAGE_POOL_STATS for the driver makes sense and will
> make the code easier to follow.

Hi Andrew and Ilias,

I just kept the same approach used for mlx driver but I am fine to always
select PAGE_POOL_STATS for mvneta. I will fix it in v2.

Regards,
Lorenzo

>=20
> Thanks
> /Ilias
> >
> >           Andrew

--U3xKgZz54xav6m0c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYk2QFgAKCRA6cBh0uS2t
rA43AP4+feISK9Q/Fy/QZw7F1lF8XovS9aYAQezZdXcQZe8q6AEA25pwJfvVrzAO
XOebIfEwqV4XI238C26AWrC1MtJPtwc=
=oQ5j
-----END PGP SIGNATURE-----

--U3xKgZz54xav6m0c--
