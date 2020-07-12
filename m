Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E73E21C7CE
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 09:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728264AbgGLHFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 03:05:23 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:56393 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727777AbgGLHFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 03:05:16 -0400
X-IronPort-AV: E=Sophos;i="5.75,342,1589234400"; 
   d="scan'208";a="459480431"
Received: from abo-173-121-68.mrs.modulonet.fr (HELO hadrien) ([85.68.121.173])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Jul 2020 09:05:13 +0200
Date:   Sun, 12 Jul 2020 09:05:13 +0200 (CEST)
From:   Julia Lawall <julia.lawall@inria.fr>
X-X-Sender: jll@hadrien
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
cc:     Joe Perches <joe@perches.com>, mlindner@marvell.com,
        stephen@networkplumber.org, davem@davemloft.net, kuba@kernel.org,
        hch@infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net: sky2: switch from 'pci_' to 'dma_' API
In-Reply-To: <a0d0ad2b-8b21-3842-cf2b-1d46274bbe7a@wanadoo.fr>
Message-ID: <alpine.DEB.2.22.394.2007120902170.2424@hadrien>
References: <20200711204944.259152-1-christophe.jaillet@wanadoo.fr> <2181026e68d2948c396cc7a7b6bfb7146c1cd5f6.camel@perches.com> <8a3e5514-9cc9-18f3-9a98-81007419a20a@wanadoo.fr> <866325009f9ae73b3a563dd745f901260a372242.camel@perches.com>
 <a0d0ad2b-8b21-3842-cf2b-1d46274bbe7a@wanadoo.fr>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-794464576-1594537513=:2424"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-794464576-1594537513=:2424
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT



On Sun, 12 Jul 2020, Christophe JAILLET wrote:

> Le 12/07/2020 à 08:32, Joe Perches a écrit :
> > On Sun, 2020-07-12 at 08:29 +0200, Christophe JAILLET wrote:
> > > Le 11/07/2020 à 23:20, Joe Perches a écrit :
> > > > On Sat, 2020-07-11 at 22:49 +0200, Christophe JAILLET wrote:
> > > > > The wrappers in include/linux/pci-dma-compat.h should go away.
> > > > why?
> > > >
> > > >
> > >   From Christoph Hellwig
> > > https://marc.info/?l=kernel-janitors&m=158745678307186&w=4
> > There's no why there.
> > There's just an assertion a wrapper should "go away".
> >
> > "the wrappers in include/linux/pci-dma-compat.h should go away"
> >
> > wrappers aren't all bad.
> >
> >
> Adding Christoph Hellwig to shed some light.

Neither the wrapped name nor the unwrapped name is higher or lower level.
Nothing much happens to the arguments.  The wrappers and the wrapped
functions are not used entirely consistently, eg some files, and perhaps
even some functions, use a mixture of the two.  There a set of confusingly
named constants associated with the two sets of functions, and these
constants are also not always used consistently.

julia
--8323329-794464576-1594537513=:2424--
