Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD1442744EE
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 17:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgIVPE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 11:04:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:45700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726641AbgIVPE2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Sep 2020 11:04:28 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B93582395C;
        Tue, 22 Sep 2020 15:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600787068;
        bh=AXw2tfK29u5pN8a/sQAZ5oYaSay0GrxXyeLbzU7BfV4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xCIbHC4uF6h2VAaoSR+FDu3Loy7x7tSEZ6k4dfg6SGY6vl0x42IPebwqwZY/fYS0K
         eEuWBwxI2yNs+BIuwGxzxtha07zs+dNUdahLQYI5MhLsZoHXCzkIosuOE7swsRPjsj
         pEsz/Tb0vzr0WNL1dnNn4PK45JGnoNUyMVT2ov8I=
Date:   Tue, 22 Sep 2020 08:04:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Qinglang Miao <miaoqinglang@huawei.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] net/mlx5: simplify the return expression of
 mlx5_ec_init()
Message-ID: <20200922080426.164e5af1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <ae06288c3c4d5d8ad59202ff7967d479af1152a5.camel@kernel.org>
References: <20200921131044.92430-1-miaoqinglang@huawei.com>
        <ae06288c3c4d5d8ad59202ff7967d479af1152a5.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Sep 2020 22:52:30 -0700 Saeed Mahameed wrote:
> On Mon, 2020-09-21 at 21:10 +0800, Qinglang Miao wrote:
> > Simplify the return expression.
> >=20
> > Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
> > ---
> >  drivers/net/ethernet/mellanox/mlx5/core/ecpf.c | 6 +-----
> >  1 file changed, 1 insertion(+), 5 deletions(-)
> >=20
> >  =20
>=20
> Applied to net-next-mlx5.

Beware:

drivers/net/ethernet/mellanox/mlx5/core/ecpf.c: In function =E2=80=98mlx5_e=
c_init=E2=80=99:
drivers/net/ethernet/mellanox/mlx5/core/ecpf.c:46:6: warning: unused variab=
le =E2=80=98err=E2=80=99 [-Wunused-variable]
  46 |  int err =3D 0;
     |      ^~~
