Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44330596E2A
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 14:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239313AbiHQMGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 08:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239337AbiHQMFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 08:05:55 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23F8F86891
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 05:05:49 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id C5EE420204;
        Wed, 17 Aug 2022 12:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1660737941; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z1oXUmvFXmWF2hmU3BwNfQUH42oPKZCz7V1eRqZnwdw=;
        b=XV9WCHihsDVT3fFElfIplFbrMsitc32nOkcfb3YJeskwx+wqllSWKdl7/iwaCBgpAldTxY
        T3I12X913KqAnolNehIe0M++vriYyuC8a6rQa2s4LpWPIcB1Oj9Ml89x5AuxgxKI8J7672
        M9v6/k5Jk3ecfsZf6GAAQGbCU4s+q5Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1660737941;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z1oXUmvFXmWF2hmU3BwNfQUH42oPKZCz7V1eRqZnwdw=;
        b=LvWugYvewPSuXjv/iiXtlZnA8oJQqOwcQzJS9VJSZU1bw11A7IqJTHUyJuW9Fa6c19ZMfQ
        oCLlngzL9NT5MjBg==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id A27A22C178;
        Wed, 17 Aug 2022 12:05:41 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id D11636094A; Wed, 17 Aug 2022 14:05:38 +0200 (CEST)
Date:   Wed, 17 Aug 2022 14:05:38 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>
Subject: Re: [RFC PATCH net-next 1/7] net: ethtool: netlink: introduce
 ethnl_update_bool()
Message-ID: <20220817120538.cju7rxvcjxaeb7j5@lion.mk-sys.cz>
References: <20220816222920.1952936-1-vladimir.oltean@nxp.com>
 <20220816222920.1952936-2-vladimir.oltean@nxp.com>
 <20220817112729.4aniwysblnarakwx@lion.mk-sys.cz>
 <20220817115256.4zzcj3bg3mrlwejk@skbuf>
 <20220817120036.zccibit4dj6gqjyw@skbuf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4rkfe3rn43ilwzhe"
Content-Disposition: inline
In-Reply-To: <20220817120036.zccibit4dj6gqjyw@skbuf>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_SOFTFAIL,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--4rkfe3rn43ilwzhe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 17, 2022 at 12:00:37PM +0000, Vladimir Oltean wrote:
> On Wed, Aug 17, 2022 at 02:52:56PM +0300, Vladimir Oltean wrote:
> > On Wed, Aug 17, 2022 at 01:27:29PM +0200, Michal Kubecek wrote:
> > > On Wed, Aug 17, 2022 at 01:29:14AM +0300, Vladimir Oltean wrote:
> > > > For a reason I can't really understand, ethnl_update_bool32() exist=
s,
> > > > but the plain function that operates on a boolean value kept in an
> > > > actual u8 netlink attribute doesn't.
> > >=20
> > > I can explain that: at the moment these helpers were introduced, only
> > > members of traditional structures shared with ioctl interface were
> > > updated and all attributes which were booleans logically were
> > > represented as u32 in them so that no other helper was needed back th=
en.
> >=20
> > Thanks, but the internal data structures of the kernel did not
> > necessitate boolean netlink attributes to be promoted to u32 just
> > because the ioctl interface did it that way; or did they?
> >=20
> > Or otherwise said, is there a technical requirement that if a boolean is
> > passed to the kernel as u32 via ioctl, it should be passed as u32 via
> > netlink too?
>=20
> Ah, don't mind me... By the time I wrote this email, I forgot that
> ethnl_update_bool32() also calls nla_get_u8(). All clear now.

Yes, it expects a NLA_U8 attribute. But it does not really matter that
much as even NLA_U8 still occupies 4 bytes in the message because of the
padding. (Which is why I generally prefer using NLA_U32 attributes
unless the value is naturally 8- or 16-bit and we are absolutely sure we
will never need more.)

Michal

--4rkfe3rn43ilwzhe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmL82YwACgkQ538sG/LR
dpWhjAf/ZGQIbv1tOY6+QKFeZK1fMWxC7tIM+rGBpbEbWoad3PEJqQ7Ip+2zwyvU
VdfHYunfDnxcXpKWqqDk2xskZtVp+nTX4mwRvznyM05cd/kl8R3bNNqxt85nBE0J
y7V4Io2oph0/reCXl0VHUqeznq0hM9wQGQSGc6E+xYkfR9NKolbgbOq0cv3168mm
iBhv4Vs0p7M1OFs9AlrjviFlZSbWP1DwBxA6511Z//3H4H+b9qD0mht0l6TCsGq6
30ykMYhcmTqQGSSEHvo2PGLUgaTQZce4p+X5/FHqD4DyVgR6hknDlOUZRQ4oqj6L
8ydje8xMjcmkX4KL1aAJeAx3R+Nk/A==
=hoXZ
-----END PGP SIGNATURE-----

--4rkfe3rn43ilwzhe--
