Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3991897BE5
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 16:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728964AbfHUOCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 10:02:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:43436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727696AbfHUOCG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 10:02:06 -0400
Received: from localhost (unknown [12.235.16.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BC0D206BA;
        Wed, 21 Aug 2019 14:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566396125;
        bh=jhrSMXsQBEis4nTZAuo/KQ6+8xUmeHCVXWMkQ0P7oR4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ulwk6+ldtBuMPNH2+gSD14tm0Xc0PNIAOH2cv3Ktg97d5wPsOf5AuASo0Sznr2XYQ
         uRmjF/9vGm/23bT6btAL2+PTYAFZzasd8FL1eBoQQKKadUX6xNdIpqfbxZW38YNtG/
         bZ2GhEwMSTlkQwMKHdXyIAKVKSn7W2cn/sn140aM=
Date:   Wed, 21 Aug 2019 17:02:04 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Mark Bloch <markb@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next 0/3] RDMA RX RoCE Steering Support
Message-ID: <20190821140204.GG4459@mtr-leonro.mtl.com>
References: <20190819113626.20284-1-leon@kernel.org>
 <6e099d052f1803e74b5731fe3da2d9109533734d.camel@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
In-Reply-To: <6e099d052f1803e74b5731fe3da2d9109533734d.camel@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 20, 2019 at 01:54:59PM -0400, Doug Ledford wrote:
> On Mon, 2019-08-19 at 14:36 +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Hi,
> >
> > This series from Mark extends mlx5 with RDMA_RX RoCE flow steering
> > support
> > for DEVX and QP objects.
> >
> > Thanks
> >
> > Mark Zhang (3):
> >   net/mlx5: Add per-namespace flow table default miss action support
> >   net/mlx5: Create bypass and loopback flow steering namespaces for
> > RDMA
> >     RX
> >   RDMA/mlx5: RDMA_RX flow type support for user applications
>
> I have no objection to this series.

Thanks, first two patches were applied to mlx5-next

e6806e9a63a7 net/mlx5: Create bypass and loopback flow steering namespaces for RDMA RX
f66ad830b114 net/mlx5: Add per-namespace flow table default miss action support

>
> --
> Doug Ledford <dledford@redhat.com>
>     GPG KeyID: B826A3330E572FDD
>     Fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD



--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQT1m3YD37UfMCUQBNwp8NhrnBAZsQUCXV1O2AAKCRAp8NhrnBAZ
semXAQCjPCerTL0Htno0tUV9YDKVYjNt/CkdikSSFECt0WeRFAEAwKqJhucCIQ40
+h7STCq++15bVE5gfCsxZitqSZgyHAc=
=PmSZ
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
