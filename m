Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA23F5FC3C
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 19:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbfGDRHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 13:07:11 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:46282 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbfGDRHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 13:07:11 -0400
Received: by mail-lj1-f194.google.com with SMTP id v24so6759444ljg.13
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 10:07:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dev-mellanox-co-il.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rwlsawBHLhO/lSrvWfCS3hDj6UzmtEvVKJ6+9BqzQD4=;
        b=ornLwSqjOwu359EGsEEWvC6DrdBXTPWnS62YSpws7rNtbKdlUtoLjRQ5WpwvIQRZJY
         0cvBEhqOwpWkhVd7YPAwrqqRYnaipK7npk4mXHpiJ/jEczmHrjKvlvoHLr/xMGnlLmSO
         zkz/bQPI56vUAlcB/pnOFZq7JJXf5BcH31Aj4jpd58/GIgUnslPX2ooiiJ4iyUCJtDlZ
         YPoZsR2ekw+ePwKRfcN2LMoH0RlutfRfPXZeFdjdm/oLXUt+8KuIS82Iot1/J4piQB2o
         d7WwFADRjccd9uJtvDcBwLT/SaxyO0AJK4aNR8zKPJrpDaagbvSGQtZdQ8YA+PQI4F49
         HcAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rwlsawBHLhO/lSrvWfCS3hDj6UzmtEvVKJ6+9BqzQD4=;
        b=NaOYFqMsGpArmMEmlnmD0teO4nyeqxoiIw0/Sm34N6yK7cINASTJfvD2Zn9w6ird87
         64f3ELKdEhoU2BZwuCZNmCyaaBQ65cXA5SoXJnYqKoII3Lgc9+Izc/D4rh4n249HVoes
         5anWF9KdGN3aT/vlH5t68Uwgbs45fbtqOHGq5w5IDVTSMvRfCoXrYf82v/NhMaj5BQoW
         exlObzGan48yRMBs3o3Ht8qqWUcxqLDNnmdBJBueSNHFfK8vKTJ0FWvL+wJApmzycNoo
         r3MYGN3it8VpqnllUvXeZMxdtuLFTYssN98wGR2SJYznDqes0+8w4l/EIYPi2FT719g8
         e+zA==
X-Gm-Message-State: APjAAAX9J967cLsYc5aS+zPdHSfasbEccpiQAimUH1ktrPAlqFv5JstJ
        PsCk33pBtmy7cAchqxnBLTl9gruFryhd0A7liHYSCQ==
X-Google-Smtp-Source: APXvYqxz3IdnYqLxGB1i3BZb0JjRA5+VfZj4Yx5GDXEmAPqu5MmboscK6jWq9SmP/GdXVE4Gpc/GhUaDIlFJJu6H/AY=
X-Received: by 2002:a2e:2993:: with SMTP id p19mr24500471ljp.202.1562260029660;
 Thu, 04 Jul 2019 10:07:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190703073909.14965-1-saeedm@mellanox.com> <20190703073909.14965-5-saeedm@mellanox.com>
 <20190703092735.GZ4727@mtr-leonro.mtl.com>
In-Reply-To: <20190703092735.GZ4727@mtr-leonro.mtl.com>
From:   Saeed Mahameed <saeedm@dev.mellanox.co.il>
Date:   Thu, 4 Jul 2019 13:06:58 -0400
Message-ID: <CALzJLG-em1w+Lgf2UutbG2Lzq8bx3zUqoLGx26H2_EXOuuk+jg@mail.gmail.com>
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

On Wed, Jul 3, 2019 at 5:27 AM <leon@kernel.org> wrote:
>
> On Wed, Jul 03, 2019 at 07:39:32AM +0000, Saeed Mahameed wrote:
> > From: Eran Ben Elisha <eranbe@mellanox.com>
> >
> > Add TLS offload related IFC structs, layouts and enumerations.
> >
> > Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
> > Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
> > Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> > ---
> >  include/linux/mlx5/device.h   |  14 +++++
> >  include/linux/mlx5/mlx5_ifc.h | 104 ++++++++++++++++++++++++++++++++--
> >  2 files changed, 114 insertions(+), 4 deletions(-)
>
> <...>
>
> > @@ -2725,7 +2739,8 @@ struct mlx5_ifc_traffic_counter_bits {
> >
> >  struct mlx5_ifc_tisc_bits {
> >       u8         strict_lag_tx_port_affinity[0x1];
> > -     u8         reserved_at_1[0x3];
> > +     u8         tls_en[0x1];
> > +     u8         reserved_at_1[0x2];
>
> It should be reserved_at_2.
>

it should be at_1.

> Thanks
