Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B72C5FC51
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 19:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727439AbfGDRPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 13:15:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:56730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726012AbfGDRPa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 13:15:30 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C559218A0;
        Thu,  4 Jul 2019 17:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562260529;
        bh=v+gDll06S8vYhl/cZjHcsE0k3uW07xbsKYuKXX0Esg4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c8gXNGAwIsocNqAMCKi3QiNdsDGSvpqNJGZv9+yiVhb7RwwGQ+BC1fLAXVP4qwgWr
         s2MNG3dZg5hosczAQzeWPBkx4obosWG7NuGe6+bWcFGZU94b5PPTteActrg7BpVs2z
         wEJtRL6p+VFHHUO+0taf0wKEU1mdPN6PIN91pouA=
Date:   Thu, 4 Jul 2019 20:15:19 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Saeed Mahameed <saeedm@dev.mellanox.co.il>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [PATCH mlx5-next 4/5] net/mlx5: Introduce TLS TX offload
 hardware bits and structures
Message-ID: <20190704171519.GE7212@mtr-leonro.mtl.com>
References: <20190703073909.14965-1-saeedm@mellanox.com>
 <20190703073909.14965-5-saeedm@mellanox.com>
 <20190703092735.GZ4727@mtr-leonro.mtl.com>
 <CALzJLG-em1w+Lgf2UutbG2Lzq8bx3zUqoLGx26H2_EXOuuk+jg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzJLG-em1w+Lgf2UutbG2Lzq8bx3zUqoLGx26H2_EXOuuk+jg@mail.gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 04, 2019 at 01:06:58PM -0400, Saeed Mahameed wrote:
> On Wed, Jul 3, 2019 at 5:27 AM <leon@kernel.org> wrote:
> >
> > On Wed, Jul 03, 2019 at 07:39:32AM +0000, Saeed Mahameed wrote:
> > > From: Eran Ben Elisha <eranbe@mellanox.com>
> > >
> > > Add TLS offload related IFC structs, layouts and enumerations.
> > >
> > > Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
> > > Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
> > > Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> > > ---
> > >  include/linux/mlx5/device.h   |  14 +++++
> > >  include/linux/mlx5/mlx5_ifc.h | 104 ++++++++++++++++++++++++++++++++--
> > >  2 files changed, 114 insertions(+), 4 deletions(-)
> >
> > <...>
> >
> > > @@ -2725,7 +2739,8 @@ struct mlx5_ifc_traffic_counter_bits {
> > >
> > >  struct mlx5_ifc_tisc_bits {
> > >       u8         strict_lag_tx_port_affinity[0x1];
> > > -     u8         reserved_at_1[0x3];
> > > +     u8         tls_en[0x1];
> > > +     u8         reserved_at_1[0x2];
> >
> > It should be reserved_at_2.
> >
>
> it should be at_1.

Why? See mlx5_ifc_flow_table_prop_layout_bits, mlx5_ifc_roce_cap_bits, e.t.c.

Thanks

>
> > Thanks
