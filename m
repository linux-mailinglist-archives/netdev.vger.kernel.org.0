Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B24E9986C
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 17:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732967AbfHVPpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 11:45:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732460AbfHVPpG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 11:45:06 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 178EF23400;
        Thu, 22 Aug 2019 15:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566488705;
        bh=0lsRsK+iB9uzsfVYAueEgtqb2iXaNyfPtL5bw0ygs40=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jmmQ9bcX0eF5kRcWdcR0w17hzS1aGLtTqiFDJSzScNVoOPqPn+XgV4IhOAChAZ6aW
         orJUyc9Gwd72N+oBqtCUfkSYgSkZDHPHGhWOdprTfS+tpfGPTxCWkouPisqwRj2VSH
         AcWCwxDe6i27f0d76s82ZR4G90HHsR3IxPc1Emj8=
Date:   Thu, 22 Aug 2019 18:45:04 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Mark Bloch <markb@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next 0/3] RDMA RX RoCE Steering Support
Message-ID: <20190822154504.GF29433@mtr-leonro.mtl.com>
References: <20190819113626.20284-1-leon@kernel.org>
 <6e099d052f1803e74b5731fe3da2d9109533734d.camel@redhat.com>
 <20190821140204.GG4459@mtr-leonro.mtl.com>
 <c7caa8eece02f3d15a0928663e9f64f99572f3ab.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c7caa8eece02f3d15a0928663e9f64f99572f3ab.camel@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 22, 2019 at 11:29:02AM -0400, Doug Ledford wrote:
> On Wed, 2019-08-21 at 17:02 +0300, Leon Romanovsky wrote:
> > On Tue, Aug 20, 2019 at 01:54:59PM -0400, Doug Ledford wrote:
> > > On Mon, 2019-08-19 at 14:36 +0300, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro@mellanox.com>
> > > >
> > > > Hi,
> > > >
> > > > This series from Mark extends mlx5 with RDMA_RX RoCE flow steering
> > > > support
> > > > for DEVX and QP objects.
> > > >
> > > > Thanks
> > > >
> > > > Mark Zhang (3):
> > > >   net/mlx5: Add per-namespace flow table default miss action
> > > > support
> > > >   net/mlx5: Create bypass and loopback flow steering namespaces
> > > > for
> > > > RDMA
> > > >     RX
> > > >   RDMA/mlx5: RDMA_RX flow type support for user applications
> > >
> > > I have no objection to this series.
> >
> > Thanks, first two patches were applied to mlx5-next
> >
> > e6806e9a63a7 net/mlx5: Create bypass and loopback flow steering
> > namespaces for RDMA RX
> > f66ad830b114 net/mlx5: Add per-namespace flow table default miss
> > action support
>
> mlx5-next merged into for-next, final patch applied, thanks.

Thanks
>
> --
> Doug Ledford <dledford@redhat.com>
>     GPG KeyID: B826A3330E572FDD
>     Fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD


