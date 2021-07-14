Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 631433C817E
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 11:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238743AbhGNJ0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 05:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238362AbhGNJ0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 05:26:36 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F157C06175F;
        Wed, 14 Jul 2021 02:23:44 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id h24-20020a9d64180000b029036edcf8f9a6so1824846otl.3;
        Wed, 14 Jul 2021 02:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2HLBTGCXMRPNUfTiU5lR2jNmDZ2oT1qUww79aTko9iA=;
        b=h8YTZwwBi/ylgZqYNlDCVPtcDgPZH8XGll8JztorriX6JaU1S/h+5S/8e1YFI5Subd
         xK9G6QGeTUp5i6y+kW0FUnrpY+F1+/M0KUNRXhnIf1DU89Rwpi3i3U1rTOoCHZHxqIVT
         qapPjyqiwt5tXGvjdkCZBjrV3Gs1EzBAx6UumLHYXowZmOJjjsqTWjb21ajGpjuwV/Er
         ZwPm3klGKi1+p3CyYZhY1xrop/qygQritHnOaUisT/4g92W8uZpxK4psT0tVPd241+k/
         IOSdqCHhVBHVGmcFcn4zWZnVjwwjQiun3ueZPMwM6IzVV3Dpp7z5ta62qcfXzCVDEWtg
         ov1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2HLBTGCXMRPNUfTiU5lR2jNmDZ2oT1qUww79aTko9iA=;
        b=R6TI69C3MiYgpeWXqEhNmu0GSimDpWVDPDvBRRZHoLWxsQZftPe1Ym5jvkr45YhbXd
         gBtCSeOTEv2GvAxxlycNbuVxJmWNvfGuV6MNv4Sp/cmjZGnoaGrBW334nlORrqyFYekr
         O94fNimG9pIqBreBJuHjtpFrg/kysh68uUh8i95ys0UrT481G2dc3MG2/IhdHdnBcfri
         S0A9lbqSr7tgcF02MeaH0hrkFnbttp7zsihS5H6woFctTCZ6U3q8Cmi6hxIn7IyLIOD6
         Knmkgr9fszdPy9lvJDHFEu72jqPyUFyygmj0jiMLbrONLP6KPBuH/ehpsUdbqOl9rcTF
         XMsA==
X-Gm-Message-State: AOAM530hWqdTu6JkM+oep4iBSAjp6ycW4FB6K+WkejxZs0sVhHHYZBpK
        pLCBzKQzMEwNbuvMd9T9ZmI9kQCPuWpox+IoZsQ=
X-Google-Smtp-Source: ABdhPJyVp1m5PjSCw4097gJW1Oi5cE3HaKM/xpb26FHyJmPk75vekL+NDng+/Lh6mU339jOEsHxddK3HqVczaxn+a+o=
X-Received: by 2002:a05:6830:34a2:: with SMTP id c34mr7365005otu.59.1626254624059;
 Wed, 14 Jul 2021 02:23:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210714031130.1511109-1-yanjun.zhu@linux.dev>
 <20210714031130.1511109-2-yanjun.zhu@linux.dev> <YO6rEkoHgsYh+w37@unreal>
In-Reply-To: <YO6rEkoHgsYh+w37@unreal>
From:   Zhu Yanjun <zyjzyj2000@gmail.com>
Date:   Wed, 14 Jul 2021 17:23:33 +0800
Message-ID: <CAD=hENfFQD3XnSekpeapr1-vb+xuaJh+qXYGHa2MLAhqWwdcKg@mail.gmail.com>
Subject: Re: [PATCH 1/3] RDMA/irdma: change the returned type of
 irdma_sc_repost_aeq_entries to void
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Shiraz Saleem <shiraz.saleem@intel.com>,
        Zhu Yanjun <yanjun.zhu@intel.com>, mustafa.ismail@intel.com,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        yanjun.zhu@linux.dev, Jakub Kicinski <kuba@kernel.org>,
        linux-netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 14, 2021 at 5:15 PM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Tue, Jul 13, 2021 at 11:11:28PM -0400, yanjun.zhu@linux.dev wrote:
> > From: Zhu Yanjun <yanjun.zhu@linux.dev>
> >
> > The function irdma_sc_repost_aeq_entries always returns zero. So
> > the returned type is changed to void.
> >
> > Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
> > ---
> >  drivers/infiniband/hw/irdma/ctrl.c | 4 +---
> >  drivers/infiniband/hw/irdma/type.h | 3 +--
> >  2 files changed, 2 insertions(+), 5 deletions(-)
>
> <...>
>
> > -enum irdma_status_code irdma_sc_repost_aeq_entries(struct irdma_sc_dev *dev,
> > -                                                u32 count);
>
> I clearly remember that Jakub asked for more than once to remo remove
> custom ice/irdma error codes. Did it happen? Can we get rid from them
> in RDMA too?

No. This is not related with custom ice/irdma error codes.

This is related with the returned type of the function.
If a function always returns 0, change the function returned type to void.
And remove the related returned value check.

Zhu Yanjun

>
> Thanks
