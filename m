Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3885FC66
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 19:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbfGDRVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 13:21:17 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:37777 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbfGDRVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 13:21:17 -0400
Received: by mail-lj1-f193.google.com with SMTP id 131so6820907ljf.4
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 10:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dev-mellanox-co-il.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GyJqn0odoy4KxK9kDIUV4CGw/44cSup/XVwMYoO7VIU=;
        b=Vl0BKeMiNBBsH1BrmNnKuWcjHHkcxM2s2wHrImfDu8uC80477KAUZfD6waji45Pra3
         0meFUwyO7+lK+wwWTtKuSyORqoz95O03VMCjGrBqAM30aijq2T/Rrm5bjC9dMxSxDTJ1
         BdiZMMXazh8PGAzPUkFXO90Mj1g5VbEE23G4TO+G1SZmRrzNjI4sPDig5k8/xP6raHnA
         ZYStBy6VWoI1D3xIf8cxpFYyaewpWUDDwKyoV4mKQKVh99cWtyeo2T+QVq2s4a3QKko8
         /A+U9hppv1+vGLOEb1Zg6h8Oebwb1e8U3/Dam7E/oCfK5TOhpXzkWwMVUFCcz02pOPEs
         XQJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GyJqn0odoy4KxK9kDIUV4CGw/44cSup/XVwMYoO7VIU=;
        b=OpmSSQdCsf4jCpgDdFcWQfc7lagw9NVUv3//4iGvYPu2Po7USqNJcfKW7W8cDDYAAl
         poshB9aqdNRB8x+deL42XAnn6oHzwrcpKiJRJDm8wdZX8VC4uJtDh+x4uHKKEQNbfgyC
         0r6aX4zwFint/ozr75n7aK/BPSVIdUVQ0iXwAxDVXhFRwpY7IQXksxQC5a3r3Idb54U3
         jkNkGt7q/3mipcITLr+wwWo+0KV5QmHEBneLSKwu8Up7YeAmyBSqqdSMn0eJG3t/afOR
         cE632arv3h/H4yNNx+RKhlWOj2+TetEhV8NMa9bQ7Ab5qU9xUvLvjHW1UWRpvYG0QR5q
         QcqA==
X-Gm-Message-State: APjAAAWLPjaF8eYbaFkobU1OF3Nm3o1G2c+L9erF8lQ8yHA4xUY1D31o
        ky/ISskdOyXueQjXLrZcBLxDOdaVuXXI/pZx0ipNqcQe
X-Google-Smtp-Source: APXvYqxG8EGJ3TE/BC+N8U4oMR5cLRohyhv+yxO1wsbI238a1eV6ROg/8xQVF8oQw/4QnpW5lPA3qNGFeDZU7hEYBO8=
X-Received: by 2002:a2e:5d5a:: with SMTP id r87mr25319924ljb.196.1562260875337;
 Thu, 04 Jul 2019 10:21:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190703073909.14965-1-saeedm@mellanox.com> <20190703073909.14965-5-saeedm@mellanox.com>
 <20190703092735.GZ4727@mtr-leonro.mtl.com> <CALzJLG-em1w+Lgf2UutbG2Lzq8bx3zUqoLGx26H2_EXOuuk+jg@mail.gmail.com>
 <20190704171519.GE7212@mtr-leonro.mtl.com>
In-Reply-To: <20190704171519.GE7212@mtr-leonro.mtl.com>
From:   Saeed Mahameed <saeedm@dev.mellanox.co.il>
Date:   Thu, 4 Jul 2019 13:21:04 -0400
Message-ID: <CALzJLG--k3z2HuV09tivJuOtU-BFAyCEV1vJbPqYX+OyskggmQ@mail.gmail.com>
Subject: Re: [PATCH mlx5-next 4/5] net/mlx5: Introduce TLS TX offload hardware
 bits and structures
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 4, 2019 at 1:15 PM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Thu, Jul 04, 2019 at 01:06:58PM -0400, Saeed Mahameed wrote:
> > On Wed, Jul 3, 2019 at 5:27 AM <leon@kernel.org> wrote:
> > >
> > > On Wed, Jul 03, 2019 at 07:39:32AM +0000, Saeed Mahameed wrote:
> > > > From: Eran Ben Elisha <eranbe@mellanox.com>
> > > >
> > > > Add TLS offload related IFC structs, layouts and enumerations.
> > > >
> > > > Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
> > > > Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
> > > > Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> > > > ---
> > > >  include/linux/mlx5/device.h   |  14 +++++
> > > >  include/linux/mlx5/mlx5_ifc.h | 104 ++++++++++++++++++++++++++++++++--
> > > >  2 files changed, 114 insertions(+), 4 deletions(-)
> > >
> > > <...>
> > >
> > > > @@ -2725,7 +2739,8 @@ struct mlx5_ifc_traffic_counter_bits {
> > > >
> > > >  struct mlx5_ifc_tisc_bits {
> > > >       u8         strict_lag_tx_port_affinity[0x1];
> > > > -     u8         reserved_at_1[0x3];
> > > > +     u8         tls_en[0x1];
> > > > +     u8         reserved_at_1[0x2];
> > >
> > > It should be reserved_at_2.
> > >
> >
> > it should be at_1.
>
> Why? See mlx5_ifc_flow_table_prop_layout_bits, mlx5_ifc_roce_cap_bits, e.t.c.
>

they are all at_1 .. so i don't really understand what you want from me,
Leon the code is good, please double check you comments..

> Thanks
>
> >
> > > Thanks
