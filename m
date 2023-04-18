Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3004F6E6FD8
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 01:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbjDRXMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 19:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbjDRXMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 19:12:21 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BF2F2735
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 16:12:21 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id DEE2B1FD75;
        Tue, 18 Apr 2023 23:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1681859539; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=waE7A728naQFyyAVCxHtvhwlRiruslrajoz7qGq82oI=;
        b=nOgGw+txzLsDvPWLceMpZHBFMCtArgXJWH38OrBGPJhCQzyAd/9yezX2hh8WcrBwsR1Qaq
        z4HSQsJI8p7UWpjBcswr4q19V9qBvdaJ5dWXfrAtMjwDyiHP5KxhQGy8vp9B7Xd3pJj4h9
        Jm4JvL4vKtXe92k4E1UrL67cbNGon5o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1681859539;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=waE7A728naQFyyAVCxHtvhwlRiruslrajoz7qGq82oI=;
        b=sIq4fyceGGp7HDXNryc4nxRgq1trsthI+1zFtTNX2gxwiNfT+bxELJDZcob4B3hbLe8asJ
        aGSd4k/X8sTVgHDw==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 9BB732C141;
        Tue, 18 Apr 2023 23:12:19 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 7182260517; Wed, 19 Apr 2023 01:12:19 +0200 (CEST)
Date:   Wed, 19 Apr 2023 01:12:19 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH ethtool-next v1] ethtool: remove ixgb support
Message-ID: <20230418231219.qdztd4gpcbk3hdwh@lion.mk-sys.cz>
References: <20230323195424.1623401-1-jesse.brandeburg@intel.com>
 <bb32154b-142a-bafb-57be-e4a7bb8e37fe@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tcwsksnaxzgzbob3"
Content-Disposition: inline
In-Reply-To: <bb32154b-142a-bafb-57be-e4a7bb8e37fe@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--tcwsksnaxzgzbob3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 23, 2023 at 04:41:50PM -0700, Florian Fainelli wrote:
> On 3/23/23 12:54, Jesse Brandeburg wrote:
> > The ixgb driver is no longer in use so just remove the associated code.
> > The product was discontinued in 2010.
>=20
> That is the case with most of the pretty dumping tools that ethtool
> contains, yet we kept them because people might still have those Ethernet
> NICs around, why should we treat ixgb differently here? The amount of
> maintenance for this file is basically close to zero.

I agree with Florian. Unless there is an actual problem with the code,
keeping it does no harm and might actually help someone. People tend to
use all kinds of ancient hardware that vendors would like to believe to
be long gone.

Michal

--tcwsksnaxzgzbob3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmQ/I88ACgkQ538sG/LR
dpWhnAf9ELDr8fCIC7UFs9iH1pzngofW5HiQyGAEfG7WRA18pzzol9JdsyDwlz6o
5qeFWGHh0glQii4XWh01RwBu5N2QTinZ89aLVTLsd3qo2TxcqRaSv17f7pivMKsO
R1HvGhduOHtNrrzmhF2aOJZadxCocM3vGVFWDvYD4ESLbSvQXPcIQyDU2QWJ/vsf
oYT6y//MzjE0zMxOmDdHPL2rjF0X6g+Zm5w5UL7bKbAP3J0ryDEWMMfBwviv6GPN
9z2yju81p1H/TiYrFYFGLZlXFxWDAZPz9YNkqPS94kUjiuCa1JL6i7sHoM7hU9cT
NptJD4LGfyAOOWz0jdpM/fC7S0wnTQ==
=+axI
-----END PGP SIGNATURE-----

--tcwsksnaxzgzbob3--
