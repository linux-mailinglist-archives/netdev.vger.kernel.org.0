Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98861307B24
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 17:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbhA1QjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 11:39:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:42832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232363AbhA1QjL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 11:39:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E474D64E07;
        Thu, 28 Jan 2021 16:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611851910;
        bh=djCbsafxvhaayAmru54h+FonrzJfh7LYVFLUwWYVRq8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KnCywIwkvaLyCiZqcucW2rAB/VRzAAOPuGbGpWZPjbfTC08oiY+8j5zBIpXIDsJU2
         4QPXJjEkVMdN+bnmwi45NPeeHirN9raydoFR3W0OBrviqDq/EvXYdLo/4PXvtOe5mh
         UErXTiC/g30aYGKb+RLx1W+IvIpExNmjHo6byzsv8gJuEa1edq7Ir+FE7tLRxuoVeS
         s6B0ysc3LPwyz3lE8NxvTaBLyuIKki//Bwt3l2Mjx9oGWnMPbYoPgWIF4NtqhpyV4t
         z8Rv5+WLTSdew1NrQaHjlouUls2NQMxPvPgUwcDUbtiBmNvWbbP/oxAhATaNfCa4c2
         jr64RPlKBDMig==
Date:   Thu, 28 Jan 2021 08:38:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Aya Levin <ayal@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [net-next 01/14] devlink: Add DMAC filter generic packet trap
Message-ID: <20210128083828.6cb1d25f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <00a20e1146cf7c0e2a5a114781d1b1b6d369cdde.camel@kernel.org>
References: <20210126232419.175836-1-saeedm@nvidia.com>
        <20210126232419.175836-2-saeedm@nvidia.com>
        <20210127195408.3c3a5788@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <00a20e1146cf7c0e2a5a114781d1b1b6d369cdde.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jan 2021 00:19:48 -0800 Saeed Mahameed wrote:
> On Wed, 2021-01-27 at 19:54 -0800, Jakub Kicinski wrote:
> > On Tue, 26 Jan 2021 15:24:06 -0800 Saeed Mahameed wrote: =20
> > > From: Aya Levin <ayal@nvidia.com>
> > >=20
> > > Add packet trap that can report packets that were dropped due to
> > > destination MAC filtering.
> > >=20
> > > Signed-off-by: Aya Levin <ayal@nvidia.com>
> > > Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> > > Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> > > Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> > > Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> > > Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> >=20
> > s/in case/because/
> >  =20
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 the destination MAC is not conf=
igured in the MAC table =20
> >=20
> > ... and the interface is not in promiscuous mode
> >  =20
>=20
> Makes sense !=20
>=20
> > > + =20
> >=20
> > Double new line
> >  =20
> > > =C2=A0Driver-specific Packet Traps
> > > =C2=A0=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D =20
> >=20
> > Fix that up and applied from the list. =20
>=20
> Thanks,
> I can stop sending pull requests and siwtch to normal patchsets=C2=A0
> if this will be more convenient to you/
>=20
> to me is just converting the cover letter :)..=20

No preference on my side, as long as the patches are on the ML it's just
the matter of remembering which parameters to pass to my scripts :)
