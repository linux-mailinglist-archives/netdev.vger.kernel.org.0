Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51B54408201
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 00:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236557AbhILWG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 18:06:59 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:58854 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235898AbhILWG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 18:06:58 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 443F31FF8F;
        Sun, 12 Sep 2021 22:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1631484343; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0wHVJRATVW48mPcTNFEXMfJBLP9vL5NKwoaQFrLG9zA=;
        b=Nb0mWXS+K2q7YDuHiP7TUC8+UuTTCjTRglZzrm/SpDF6zk54WwwrtK5WrpyuBCao7+2tX3
        nan2QKql6vA45jWnSU6J4h0oW9Vgf/l0xOVnKe5BH1NDkC3LbmBhONCgb0t2lRSszIqYkG
        Y0JImPJeye2tjgNKuPetphN69j3OwiA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1631484343;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0wHVJRATVW48mPcTNFEXMfJBLP9vL5NKwoaQFrLG9zA=;
        b=lNxcV4U/xdAxs5dncK6xP4I2X1gE1mNGrtyk6LQqrMLT6FMeXROVKEonVg0O1bIH7JPBL2
        CCHLXyQZ+sPh00AA==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id D2A43A3B81;
        Sun, 12 Sep 2021 22:05:42 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 8B3676085C; Mon, 13 Sep 2021 00:05:42 +0200 (CEST)
Date:   Mon, 13 Sep 2021 00:05:42 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Yufeng Mo <moyufeng@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, amitc@mellanox.com,
        idosch@idosch.org, andrew@lunn.ch, o.rempel@pengutronix.de,
        f.fainelli@gmail.com, jacob.e.keller@intel.com, mlxsw@mellanox.com,
        netdev@vger.kernel.org, lipeng321@huawei.com, linuxarm@huawei.com,
        linuxarm@openeuler.org
Subject: Re: [PATCH V2 ethtool-next] netlink: settings: add netlink support
 for coalesce cqe mode parameter
Message-ID: <20210912220542.idyv7uzsustqmkax@lion.mk-sys.cz>
References: <1630290953-52439-1-git-send-email-moyufeng@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ty4dawc33vunw42r"
Content-Disposition: inline
In-Reply-To: <1630290953-52439-1-git-send-email-moyufeng@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ty4dawc33vunw42r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 30, 2021 at 10:35:53AM +0800, Yufeng Mo wrote:
> Add support for "ethtool -C <dev> cqe-mode-rx/cqe-mode-tx on/off"
> for setting coalesce cqe mode.
>=20
> Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
> ---

Applied, thank you.

For the record, I added information that "ethtool -c" output is also
updated to the commit message.

Michal

--ty4dawc33vunw42r
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmE+ebAACgkQ538sG/LR
dpXR5QgAjq5PE5DExQLu0Q8PbnK4EWH2XTbAQB2ewat2d3gEiZ4Qd6S2OqM7gtos
ZPf1IlksAtYeJpclw4tz8ygcmalXmfP+lCvx+WbVx/7dMEwA/nFJaSRcOFaIVUq2
m6bh6On5tzaGuSoij0JQgZRaVHZibX01dTYdKwKftmRy0DyvRjNF7zfl9PFD1dkG
6T50OkztNjS9X2b267qoeX+uJ1DXi3TFb1ySADbxlitEuNWz2n6kIlqRe3/R90We
mBbV6mXgaDrB0ECnqRJV6ALhZUGlP92W5hqU+2DMhFq1yW/h+aNpFuaypN+xIUBG
YVleabL0ujYSIU+gI83hIDuhZdipXQ==
=uWC9
-----END PGP SIGNATURE-----

--ty4dawc33vunw42r--
