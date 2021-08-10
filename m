Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 220593E5B9E
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 15:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbhHJNaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 09:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbhHJNaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 09:30:10 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0BF8C0613D3
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 06:29:48 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id u7so438422ilk.7
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 06:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OwFDk7GN/WvHjIQfExElRPlnWlbCzEVVeMa3dwRYSGg=;
        b=eigR4KsX8ShfnDfG2ef2VVtjYBv4SQ0mqhCpkJkH/PjQ4Ro74WbS52pH8F/R8I5b7x
         GCnmj7kdF8Dl2LVY4fljQrvXpc7X4U17SBSJ/xP/7pJgkV0ecAhRUukXuDgEvF2CVwn/
         dDCP1rZ9DFeCxcU6e4+Z1CSGKIRVCxpvABPnGs1N6GoVqUBT3OO06LGQvnqOxDW3rxK5
         Y1IxpYehQQ8fCSOOoReDimIgaeNkXlchS4CXhTPqmp0b6SjtzSS5LlQJTovcxvg/9y2f
         GWvbniMcJXGLzdpk8ahCigLE4wSEps976FtVfxe4rJiCfKo3vx3BdK9MlQArjg0uzn1U
         iLaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OwFDk7GN/WvHjIQfExElRPlnWlbCzEVVeMa3dwRYSGg=;
        b=GZRFF3qs2nhN5WsoVpn04eCRiUK9AueeIbO/HDTr20SZ5gNUY1IYi+RYZd5iREbgAa
         5TykqpboxIivv1SDubKlXWbK1IlT4zDNAUy8VwdGRZNTw0nkhdyhaCxCzYP0vm1TG3Od
         ATvh/v0ILsKMclhKE3V629Xd4kv8bgwHZn+5m/7EJnx8PHswlxGbZA0V0NK48H7w/yvS
         Z8c5+QastMm49Np5MRkLN8VqyBBnak4Q8tnDYXXc+tUnNa+2mf7IQsGVcR9vB5xSpWIJ
         oKCAVx+qrFTXBgi4wf3SNgoLW6qmHdPdbTAzuQbsdHkk30hCiYcRNsFGrlpd0ZebQqXF
         BHQw==
X-Gm-Message-State: AOAM533dpJWjfJretstenU+vqDnlNqTn62107Lkd0L4OvGvrILkyaPQX
        tYB9xXYAyK2ryltj2YMAEtkd8jiHjCZTzW56XZ1co/hZu9s=
X-Google-Smtp-Source: ABdhPJzEDxQLAhdTU09T2kFlxcCFhEHGWs95QHE1D9caZvuDO90Lh3oRtD4hCl1jeDvEAZmQvbvfns9H/7aSw+TnaXg=
X-Received: by 2002:a05:6e02:528:: with SMTP id h8mr1376379ils.223.1628602188151;
 Tue, 10 Aug 2021 06:29:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210722110325.371-1-borisp@nvidia.com> <20210722110325.371-3-borisp@nvidia.com>
 <YPlzHTnoxDinpOsP@infradead.org> <6f7f96dc-f1e6-99d9-6ab4-920126615302@gmail.com>
 <20210723050302.GA30841@lst.de> <YPpRziMHmeatfAw2@zeniv-ca.linux.org.uk> <CAJ3xEMid0sWkCf4CPK5Aotu=+U4=vtDrdJANqn+CnWd7HTb-vg@mail.gmail.com>
In-Reply-To: <CAJ3xEMid0sWkCf4CPK5Aotu=+U4=vtDrdJANqn+CnWd7HTb-vg@mail.gmail.com>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Tue, 10 Aug 2021 16:29:36 +0300
Message-ID: <CAJ3xEMiNU5_+hcbzgXP6n-muE2790iT19BO6R7A2c0CeMu4Uuw@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 02/36] iov_iter: DDP copy to iter/pages
To:     Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>
Cc:     Boris Pismenny <borispismenny@gmail.com>,
        Boris Pismenny <borisp@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>, axboe@fb.com,
        Keith Busch <kbusch@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Shai Malin <smalin@marvell.com>, boris.pismenny@gmail.com,
        linux-nvme@lists.infradead.org,
        Linux Netdev List <netdev@vger.kernel.org>,
        benishay@nvidia.com, Or Gerlitz <ogerlitz@nvidia.com>,
        Yoray Zack <yorayz@nvidia.com>,
        Ben Ben-Ishay <benishay@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 4, 2021 at 5:13 PM Or Gerlitz <gerlitz.or@gmail.com> wrote:
> On Fri, Jul 23, 2021 at 8:30 AM Al Viro <viro@zeniv.linux.org.uk> wrote:
> > On Fri, Jul 23, 2021 at 07:03:02AM +0200, Christoph Hellwig wrote:
> > > On Thu, Jul 22, 2021 at 11:23:38PM +0300, Boris Pismenny wrote:
>
> >>> This routine, like other changes in this file, replicates the logic in
> >>> memcpy_to_page. The only difference is that "ddp" avoids copies when the
> >>> copy source and destinations buffers are one and the same.
>
> >> Now why can't we just make that change to the generic routine?
>
> > Doable... replace memcpy(base, addr + off, len) with
> >         base != addr + off && memcpy(base, addr + off, len)
> > in _copy_to_iter() and be done with that...
>
> Guys,
>
> AFAIR we did the adding ddp_ prefix exercise to the copy functions call chain
>
> ddp_hash_and_copy_to_iter
> -> ddp_copy_to_iter
> -> _ddp_copy_to_iter
> -> ddp_memcpy_to_page
>
> to address feedback given on earlier versions of the series. So let's
> decide please.. are we all set to remove the ddp_ prefixed calls and just
> plant the new check (plus a nice comment!) as Al suggested?

So we are okay going for the minimal approach / direction suggested by
Al of adding a (base != addr + offset) check before the memcpy call.

This will also simplify the changes to the nvme-tcp driver.  Please
speak if you want the ddp_ prefix approach to remain.

Or.

> re the comments given on ddp_memcpy_to_page, upstream move
> to just call memcpy, so we need not have it anyway, will be fixed in v6
> if we remain with ddp_ call chain or becomes irrelevant if we drop it.
