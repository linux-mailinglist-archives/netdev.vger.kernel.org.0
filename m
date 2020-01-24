Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 663731481A2
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 12:21:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390820AbgAXLVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 06:21:33 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35750 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391081AbgAXLVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 06:21:32 -0500
Received: by mail-wr1-f67.google.com with SMTP id g17so1530975wro.2
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 03:21:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7IwH31jkEz1bOLva9KUCFYaHyXaTO5IHNMEwcH3vJeI=;
        b=FYt5cxkXN81+GuXiWqKvfg0gdTbjUYa98uTVRJwn0LG7rhMPTJA/iUPc5zwFqzYAGH
         U8cp5j1SZPvl2BuDQnnBI0DeD1kwXu1lqX77pfTjYYl0uBS02JLr1vu5QZCs65qJp+LC
         SlzNeb1GufwHBClw81ZOemp5LjiaOIgjTpEgZooA5+/Lnx8hiPtnD17T0J4d2iD82zKN
         FnOoCZ7mo7QhKZSu9vglPUePWbxgKeib/WAVOINK4BTu+vCd0K/trMomlFnVY1p4/5Po
         OmL2bAVjxDzXUeYaH+1wFJlEmWeR6VZvnTVKngxAyrXPWd71JN3ujOG44Hr/1WODXY1b
         JwOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7IwH31jkEz1bOLva9KUCFYaHyXaTO5IHNMEwcH3vJeI=;
        b=JF/MDBSTQavjhgUcl0Y1m54xaVYkk3or4MOnItC/BUGI00lRoELAA2hOsWNId3Pnpb
         p4imooTiVImfOIH4++93Yd16bKMsqB+JX3fvUJuVtEg69T5VPL1xQ8LZ27IPUaMRJiAE
         XoHBu/e6850BZ/2Nb6YlFopAdDnenSexDW1j432Izyf+SFf4w/TZZheMe9wQOMwpPPKI
         efJsxBoHncNXDr/eYE86a9Pm10s/g3PQHxUJMtdM+Atfntxl1uct+1mcUjD9aik35Laq
         3Rb7DSe/1AnYpVMO0F6pCgyAoHxsaXqs2kJ6MiXZIXcO9sYBZD3VvrcsbWBmdwDd69vD
         iDmA==
X-Gm-Message-State: APjAAAVpDQu4Nu8YY+m0GlKRNPJ2SZxWh5Wn7vajszUHgl5yW4Fg6vHG
        G9qz7duHplQ+TPhY4l1m9KtFVDRNBx7YBUpToXY=
X-Google-Smtp-Source: APXvYqx4Bt9TxfzjsjlxhGOuluVz8f6CZLpCKUDd5avqLMW5k60nz3DdmIxEU/8MH0XNuwUy6jVZ9doK2o+qy0TYojU=
X-Received: by 2002:a5d:4984:: with SMTP id r4mr3679551wrq.137.1579864889756;
 Fri, 24 Jan 2020 03:21:29 -0800 (PST)
MIME-Version: 1.0
References: <1579612911-24497-1-git-send-email-sunil.kovvuri@gmail.com>
 <1579612911-24497-5-git-send-email-sunil.kovvuri@gmail.com>
 <20200121080058.42b0c473@cakuba> <CA+sq2CenEgQ31St1kGgvWfxgyjv2fhT=Xmpt+QZZrtN3faPAqw@mail.gmail.com>
 <20200123062017.3cbefe70@cakuba>
In-Reply-To: <20200123062017.3cbefe70@cakuba>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Fri, 24 Jan 2020 16:51:18 +0530
Message-ID: <CA+sq2Cfq_Km3HdPEn97q4jBEg7GFnDvDM0ZjP9E8fpK6O7=bmA@mail.gmail.com>
Subject: Re: [PATCH v4 04/17] octeontx2-pf: Initialize and config queues
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 23, 2020 at 7:50 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 23 Jan 2020 00:59:54 +0530, Sunil Kovvuri wrote:
> > On Tue, Jan 21, 2020 at 9:31 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Tue, 21 Jan 2020 18:51:38 +0530, sunil.kovvuri@gmail.com wrote:
> > > > +dma_addr_t otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool,
> > > > +                        gfp_t gfp)
> > > > +{
> > > > +     dma_addr_t iova;
> > > > +
> > > > +     /* Check if request can be accommodated in previous allocated page */
> > > > +     if (pool->page &&
> > > > +         ((pool->page_offset + pool->rbsize) <= PAGE_SIZE)) {
>
> You use straight PAGE_SIZE here
>
> > > > +             pool->pageref++;
> > > > +             goto ret;
> > > > +     }
> > > > +
> > > > +     otx2_get_page(pool);
> > > > +
> > > > +     /* Allocate a new page */
> > > > +     pool->page = alloc_pages(gfp | __GFP_COMP | __GFP_NOWARN,
> > > > +                              pool->rbpage_order);
>
> but allocate with order
>

For 4K pages and with MTU > 4K, we cannot allocate morethan 1buffer
from a compound page.
For 64K pages the order will never go beyond '0'.
So comparing with PAGE_SIZE or with (PAGE_SIZE * (pool->rbpage_order +
1)) will not make a difference.

But anyway i will change this to make things clear.
Thanks for pointing.

Sunil.
