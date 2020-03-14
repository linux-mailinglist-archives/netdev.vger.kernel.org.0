Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD3B1859AC
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 04:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbgCODa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 23:30:58 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:35723 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbgCODa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Mar 2020 23:30:58 -0400
Received: by mail-ed1-f66.google.com with SMTP id a20so17520343edj.2
        for <netdev@vger.kernel.org>; Sat, 14 Mar 2020 20:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0GJ6VQfIcxSqmC0VsWA9DUzS28HpWl+CRKDXx7us1aY=;
        b=J6xPdMw86fdXVo5tyJJ6sEdEFGCLTbXK12aV2erggYdOAxiGvoFTMN7mimOTPt2dse
         llfyDFLoam74vzimGK0cbX3hB1as9Tzd+5MsbJ/TsyTKG/FF5gr5QPCOQ6hxWO57Q+Le
         uq6tV2hg/uBy9keiYfvEYi5ZnLc4Rzu55tHVwQACjwze3wxSnoPuYM8fKJf3uphc/0Vx
         ydEI+tBl81c0AqEHcJ/wXQJ8mgN1nVyp8D3VRiJ/Q5/QrWelMTpMo1EdmwS8CFySM/8P
         gLuRxSm4UPnsWtviMkyXJWeRiEGWUdtCP7icbg/dD5yRheHuYZIzJxR4FTw8jOcRcN7n
         /akw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0GJ6VQfIcxSqmC0VsWA9DUzS28HpWl+CRKDXx7us1aY=;
        b=rZ4w1NrolO0FaGMOSyAz2WhABWooEI+USqIttzv6iiNbei+VVuXQwR915RByirc5Um
         aR2SETyVQkhq++X8xTenUsS5IZQ74fmj1X1GNlmyFY5TOo12LGEp16Jc49LWAbATIfaM
         4637LCsg6vkj9MD+l68CtklftTwgPr1C9MNykJtEiGV8ItjvtGssvMW6Yx0ObgnsBO1a
         1gpZT/qOZM8W249vFVRjv50CXsOffG87v2LcNEHQJn9vm2dMRO/rDIwzjTU0IEsXcCHU
         LbIopIxpdjbaE2AB8BSHk1qT3bJoxGj+Dh9xowat/0gNaWD1AcXd/+7hgn0AnL4do/u0
         +nFg==
X-Gm-Message-State: ANhLgQ2WN3garYt5Vtr6qDnrvxZfcqOAmOjlYgMzQaayhGhJQjnP1niO
        AFJCEvZWs0WhwVxmoWct0AL4wVqwGNz8kzuyBE2PS31p
X-Google-Smtp-Source: ADFU+vsmzE1mpFxMZfj8suwxIsIPvrFLelItLQYl47HXj5mInaN+NgOhOA93wC1sOQjbpvlMmyNzCgIRe23ZUMP9/L4=
X-Received: by 2002:adf:90e1:: with SMTP id i88mr25277941wri.95.1584200537249;
 Sat, 14 Mar 2020 08:42:17 -0700 (PDT)
MIME-Version: 1.0
References: <1584092566-4793-1-git-send-email-sunil.kovvuri@gmail.com>
 <1584092566-4793-5-git-send-email-sunil.kovvuri@gmail.com> <20200313175625.GB67638@unreal>
In-Reply-To: <20200313175625.GB67638@unreal>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Sat, 14 Mar 2020 21:12:05 +0530
Message-ID: <CA+sq2CcuDbwN1zFbgthysN87ZF43FSP4VEoQU4qerOR1i72_Qg@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 4/7] octeontx2-vf: Ethtool support
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tomasz Duszynski <tduszynski@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 11:26 PM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Fri, Mar 13, 2020 at 03:12:43PM +0530, sunil.kovvuri@gmail.com wrote:
> > From: Tomasz Duszynski <tduszynski@marvell.com>
> >
> > Added ethtool support for VF devices for
> >  - Driver stats, Tx/Rx perqueue stats
> >  - Set/show Rx/Tx queue count
> >  - Set/show Rx/Tx ring sizes
> >  - Set/show IRQ coalescing parameters
> >  - RSS configuration etc
> >
> > It's the PF which owns the interface, hence VF
> > cannot display underlying CGX interface stats.
> > Except for this rest ethtool support reuses PF's
> > APIs.
> >
> > Signed-off-by: Tomasz Duszynski <tduszynski@marvell.com>
> > Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> > ---
> >  .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   1 +
> >  .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  | 133 ++++++++++++++++++++-
> >  .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |   4 +
> >  3 files changed, 136 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> > index ca757b2..95b8f1e 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> > @@ -631,6 +631,7 @@ void otx2_update_lmac_stats(struct otx2_nic *pfvf);
> >  int otx2_update_rq_stats(struct otx2_nic *pfvf, int qidx);
> >  int otx2_update_sq_stats(struct otx2_nic *pfvf, int qidx);
> >  void otx2_set_ethtool_ops(struct net_device *netdev);
> > +void otx2vf_set_ethtool_ops(struct net_device *netdev);
> >
> >  int otx2_open(struct net_device *netdev);
> >  int otx2_stop(struct net_device *netdev);
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> > index f450111..1751e2d 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> > @@ -17,6 +17,7 @@
> >  #include "otx2_common.h"
> >
> >  #define DRV_NAME     "octeontx2-nicpf"
> > +#define DRV_VF_NAME  "octeontx2-nicvf"
> >
> >  struct otx2_stat {
> >       char name[ETH_GSTRING_LEN];
> > @@ -63,14 +64,34 @@ static const unsigned int otx2_n_dev_stats = ARRAY_SIZE(otx2_dev_stats);
> >  static const unsigned int otx2_n_drv_stats = ARRAY_SIZE(otx2_drv_stats);
> >  static const unsigned int otx2_n_queue_stats = ARRAY_SIZE(otx2_queue_stats);
> >
> > +int __weak otx2vf_open(struct net_device *netdev)
> > +{
> > +     return 0;
> > +}
> > +
> > +int __weak otx2vf_stop(struct net_device *netdev)
> > +{
> > +     return 0;
> > +}
>
> We tried very politely to explain that drivers shouldn't have "__weak"
> in their code, sorry if it wasn't clear enough.
>
> Thanks

Hmm.. I will try to remove.

Thanks,
Sunil.
