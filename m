Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDE08484F81
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 09:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238576AbiAEIpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 03:45:21 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:36608 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233151AbiAEIpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 03:45:21 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 5678021114;
        Wed,  5 Jan 2022 08:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1641372320; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HhJonGj2C1TEP6hcx6JEjdu7NyJveagwhgxsiZB/FEI=;
        b=UYdz52w/YjthFkYnmpMxSgYo8vIIOsR/OvrR2Zwq9D80TF7u8XBnyGgQvzIEqOfvwcXSks
        saw2ZnZBGLcm5mJUo+wwVef0w8uX+FZdnT+rqvamouw0WNkOT41nh5X3ZnGdL9nZNCYVf9
        a2MVODWnCfIcR+f2HC5x8WNPTvbsR0Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1641372320;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HhJonGj2C1TEP6hcx6JEjdu7NyJveagwhgxsiZB/FEI=;
        b=IIHRr7tRwR4oI+0T/JKA6NuGawD0MMazRED9DLKL+3LlHQjekuLKLI9pxEtNuVI/bhbVUk
        XQavB+0Obdy0GgBw==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id EF2DEA3B84;
        Wed,  5 Jan 2022 08:45:19 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 9ECF8607DC; Wed,  5 Jan 2022 09:45:16 +0100 (CET)
Date:   Wed, 5 Jan 2022 09:45:16 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        lipeng321@huawei.com, chenhao288@hisilicon.com
Subject: Re: [PATCH ethtool-next 0/2] add some supports for netlink
Message-ID: <20220105084516.yg726rg27aqlkgj5@lion.mk-sys.cz>
References: <20211220083155.39882-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6cw6rxsmkk662ivs"
Content-Disposition: inline
In-Reply-To: <20211220083155.39882-1-huangguangbin2@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--6cw6rxsmkk662ivs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 20, 2021 at 04:31:53PM +0800, Guangbin Huang wrote:
> Add support for "ethtool -G/g <dev>" to set/get rx buf len
> and support for "ethtool --set/get-tunable <dev>" to
> set/get tx copybreak buf size.

Applied both patches to next branch (with minor subject adjustment so
that the bot may not recognize). Next time, please do not forget to
update also the man page (ethtool.8.in file).

Michal

>=20
> Hao Chen (2):
>   ethtool: netlink: add support to set/get rx buf len
>   ethtool: netlink: add support to get/set tx copybreak buf size
>=20
>  ethtool.c       | 9 +++++++++
>  netlink/rings.c | 7 +++++++
>  2 files changed, 16 insertions(+)
>=20
> --=20
> 2.33.0
>=20

--6cw6rxsmkk662ivs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmHVWpYACgkQ538sG/LR
dpW/BQf/bpeI++pq4LDMdfBbK1e0zNYfJrwb4vE1PyGREU/VzM7kEmji6NuW385Y
tNTqzMf8OjwSwUb4jJyqOvpa65aUvd7+5Sg7p/kgzbdsOR0yiXEY376V31ec5C0+
0+U34XupjdDbra/WOH+u8/85wAwO8/JhqbGGkxgpgIC8S4r9em6w7fPn4NZtrqtV
PWaGOWah/1HQxGu8Yj15EFSJDlFq/3tYvouLKEho/U7t8+IYR4I8CAJ/0vf6+1tm
PvflYIXhKMFCiHpDvw3N9qiJmFgBdArIJitVMJw7DKlnNnucUJpvWRkX4sOwk/Sw
lin0RZWPL94fzzZooRb5GvYyZ3QOAw==
=ej01
-----END PGP SIGNATURE-----

--6cw6rxsmkk662ivs--
