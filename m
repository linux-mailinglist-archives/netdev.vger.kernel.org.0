Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 677B843D2B6
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 22:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239011AbhJ0UT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 16:19:58 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:49396 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237028AbhJ0UT5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 16:19:57 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 661AC1FD3D;
        Wed, 27 Oct 2021 20:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1635365851; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JVuPepx2wkzlf8agl6EkDv3jU7kF0zWRRmvTeQCy8os=;
        b=XJve/VdYQq57ERo1CEJRq4/cPdx/yntQ97YE8SKa+7K7vWLXmjKZebFnkTK7kDobOfFMCC
        o1Nfkj7fz4U0zbwSsb/ZtOxEwOTRhH+08rsB6eX9RG4QEs89VrvNyP8ZTsMfxVZbtYdQ0U
        aJ+ORqfFPcOL9v3You4dXiVVlVt9sWc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1635365851;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JVuPepx2wkzlf8agl6EkDv3jU7kF0zWRRmvTeQCy8os=;
        b=eqbaBdpMOxaNLoOt6z2L+CMnSOziFHQim0Kl3LxdNfaKcYnEhaXMY5UfKd2Ued5k6CwXpe
        IgqmNaPSEk59r0DA==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 5E4C8A3B81;
        Wed, 27 Oct 2021 20:17:31 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 403C5607F2; Wed, 27 Oct 2021 22:17:31 +0200 (CEST)
Date:   Wed, 27 Oct 2021 22:17:31 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     bage@linutronix.de
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool 2/2] netlink: settings: Drop port filter for MDI-X
Message-ID: <20211027201731.ylor6jkgdyyzoamx@lion.mk-sys.cz>
References: <20211027181140.46971-1-bage@linutronix.de>
 <20211027181140.46971-3-bage@linutronix.de>
 <20211027195923.3vhfr4diwuelw3gg@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zwb4wluckbdwrmtq"
Content-Disposition: inline
In-Reply-To: <20211027195923.3vhfr4diwuelw3gg@lion.mk-sys.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--zwb4wluckbdwrmtq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 27, 2021 at 09:59:23PM +0200, Michal Kubecek wrote:
> How about replacing "port =3D=3D PORT_TP" with
>=20
>   (port =3D=3D TP || mdix !=3D ETH_TP_MDI_INVALID || mdix_ctrl !=3D ETH_T=
P_MDI_INVALID)
>=20
> in both code path and probably moving the check into dump_mdix()?

Looking at the code again, we cannot move the check into dump_mdix()
easily as decision if print_banner(nlctx) should be called depends on
its result.

Michal

--zwb4wluckbdwrmtq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmF5s9UACgkQ538sG/LR
dpWtMAf7BaF4h1kDYAe4LoRKYmEXmPq6MwqZ8k3jqzXxMz3eCD2C4fHK9vIvG/zI
a1Xuz5lxKdkkKizQTffTtcOD1wnBwZTvvajcGGynxANVNBjs922MpC+pZkvBkiL6
cCFX+1ZElgXKBH7r+x6EytPGQeAYAVjukMoklg3X+vfDewSAnMktgaz/ObzLfTcS
B3t52BhPOX3MZlryXV9iNi+sOR8vQLFcgJ2j0YRIsT0sNRwsQeS0FLGMrz4I9o+Z
eJ/yTA1iM2vXOfjDP+fsCOag7Br3LtUVwFzBEWma2CoSM0+fclkMfMcd68r61saT
O4pYVxe7bbZnh5CYfxTi569OmjnDlA==
=pPKG
-----END PGP SIGNATURE-----

--zwb4wluckbdwrmtq--
