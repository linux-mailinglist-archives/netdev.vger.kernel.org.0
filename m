Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4D03CC84D
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 11:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbhGRJaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 05:30:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:44496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229578AbhGRJaQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Jul 2021 05:30:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC10A60C3F;
        Sun, 18 Jul 2021 09:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626600438;
        bh=BUPAsZFr72/ZfDtgeCNzvRJEjiac1TFASEE8igMSwSk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rrT8fDr/c4AP8C94pJ4zgcND1dZUX6KT60Ye7DApAdDNST00MnnB7TXCVSKEv+uC5
         XpZctqiUJHJ++xEm9yCP7fJ6UXF/nasuxuDRlNoAIRNgHvKXQu/ryY+qJc+PND2v/3
         AVNVY+xzK8V1UmTaVbTj2mDFXB1HnIwtyNYvFxcjH/MYkH4Y8t0kV834chhioMPnnv
         KaUPviC7LMpUUju8ZMOuz9obijr9FNpU008XG8r+3oQVDJK+tqikNy1zeSmfxzrARY
         qFDPAOICTSgL6C1OfkcoTGucXRB9abZ2Et6bzU6TQQK0nh0hDlQxg1zEfhWrMTyL8J
         tlIu8DB4w3VDw==
Date:   Sun, 18 Jul 2021 12:27:14 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Zhu Yanjun <zyjzyj2000@gmail.com>
Cc:     Shiraz Saleem <shiraz.saleem@intel.com>,
        Zhu Yanjun <yanjun.zhu@intel.com>, mustafa.ismail@intel.com,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        yanjun.zhu@linux.dev, Jakub Kicinski <kuba@kernel.org>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/3] RDMA/irdma: change the returned type of
 irdma_sc_repost_aeq_entries to void
Message-ID: <YPPz8klLCiIbEsCp@unreal>
References: <20210714031130.1511109-1-yanjun.zhu@linux.dev>
 <20210714031130.1511109-2-yanjun.zhu@linux.dev>
 <YO6rEkoHgsYh+w37@unreal>
 <CAD=hENfFQD3XnSekpeapr1-vb+xuaJh+qXYGHa2MLAhqWwdcKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=hENfFQD3XnSekpeapr1-vb+xuaJh+qXYGHa2MLAhqWwdcKg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 14, 2021 at 05:23:33PM +0800, Zhu Yanjun wrote:
> On Wed, Jul 14, 2021 at 5:15 PM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Tue, Jul 13, 2021 at 11:11:28PM -0400, yanjun.zhu@linux.dev wrote:
> > > From: Zhu Yanjun <yanjun.zhu@linux.dev>
> > >
> > > The function irdma_sc_repost_aeq_entries always returns zero. So
> > > the returned type is changed to void.
> > >
> > > Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
> > > ---
> > >  drivers/infiniband/hw/irdma/ctrl.c | 4 +---
> > >  drivers/infiniband/hw/irdma/type.h | 3 +--
> > >  2 files changed, 2 insertions(+), 5 deletions(-)
> >
> > <...>
> >
> > > -enum irdma_status_code irdma_sc_repost_aeq_entries(struct irdma_sc_dev *dev,
> > > -                                                u32 count);
> >
> > I clearly remember that Jakub asked for more than once to remo remove
> > custom ice/irdma error codes. Did it happen? Can we get rid from them
> > in RDMA too?
> 
> No. This is not related with custom ice/irdma error codes.

I'm not talking about your specific change, but pointed to the fact that
custom error codes are not cleaned despite multiple requests.

Thanks
